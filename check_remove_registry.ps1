clear-host
function ConvertFrom-Json20([object] $item) {
    add-type -assembly system.web.extensions
    $ps_js = new-object system.web.script.serialization.javascriptSerializer
    return ,$ps_js.DeserializeObject($item)
    }
    
if ((Test-Path 'log_remove_registry.txt') -eq 'True') {
    clear-content 'log_remove_registry.txt'
    }
$failcheck = 'Passed'
$jsons = @('')
$count = 0
foreach ($file in $jsons) {
    $json = Get-Content -Path $file 
    $hash = ConvertFrom-Json20($json)
    foreach ($block in $hash) {
        foreach ($key in $block.Keys){
            foreach ($val in $block.$key) {
                foreach ($inval in $val.Keys) {
                    if ((Get-ItemProperty -Path (echo $key) -ErrorAction SilentlyContinue).($inval)) {
                           'Оставшийся ключ: ' + $key + ', Оставшееся значение: ' + $inval >> log_remove_registry.txt
                           $failcheck = 'Failed'
                        }
                    $count += 1
                    clear-host
                    write-host 'Проверено ключей:' $count
                    }
                }
            }
        }
    }
if ($failcheck -eq 'Passed') {
    write-host 'Удаление завершено удачно.'
    }
else {
    write-host 'Удаление произведено не полностью. Подробности в log_remove_registry.txt'
    }
Write-Host "Для выхода нажмите любую клавишу"
cmd /c pause | out-null
