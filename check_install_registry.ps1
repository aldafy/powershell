clear-host
function ConvertFrom-Json20([object] $item) {
    add-type -assembly system.web.extensions
    $ps_js = new-object system.web.script.serialization.javascriptSerializer
    return ,$ps_js.DeserializeObject($item)
    }

if ((Test-Path 'log_install_registry.txt') -eq 'True') {
    clear-content 'log_install_registry.txt'
    }
$failcheck = 'Passed'
$jsons = @('')
$count = 0
foreach ($file in $jsons) {
    $json = Get-Content -Path $file
    $hash = ConvertFrom-Json20($json)
    foreach ($block in $hash) {
        foreach ($key in $block.Keys){
            if (-not (Get-ItemProperty -Path (echo $key) -ErrorAction SilentlyContinue)) {
                        'Ветка ' + $key + ' не найдена' >> log_install_registry.txt
                        }
            foreach ($val in $block.$key) {
                foreach ($inval in $val.Keys) {
                    if (((Get-ItemProperty -Path (echo $key) -ErrorAction SilentlyContinue).(echo $inval)) -ne ($block.$key.$inval) -And ((Get-ItemProperty -Path (echo $key) -ErrorAction SilentlyContinue).(echo $inval)) -And ($block.$key.$inval)) {
                        $key+ ', Ключ: '+$inval+'. Должно быть: '+$block.$key.$inval+'    В реестре: '+(Get-ItemProperty -Path (echo $key)).(echo $inval) >> log_install_registry.txt
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
    write-host 'Установка завершена удачно.'
    }
else {
    write-host 'Установка завершилась неудачно. Подробности в log_install_registry.txt'
    }
Write-Host "Для выхода нажмите любую клавишу"
cmd /c pause | out-null
