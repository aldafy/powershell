clear-host
if ((Test-Path 'log_install_files_and_services.txt') -eq 'True') {
    clear-content 'log_install_files_and_services.txt'
    }
$result = 'True'
$emptypath = @()
$emptyservices = @()
$file_count = 0
$arch = [IntPtr]::Size
$host_os = Get-WmiObject Win32_operatingsystem | Select Caption
if ($host_os.caption.contains('Windows XP')) {
    $file = 'for_XP.txt'
    }
else {
    if ($arch -eq 8) {
        $file = 'for_x64_not_XP.txt'
        }
    elseif ($arch -eq 4) {
        $file = 'for_x86_not_XP.txt'
        }
    }
foreach ($path in get-content $file) {
    Clear-host
    $file_count += 1
    write-host 'Файлов проверено:' $file_count
    if ((Test-Path $path) -ne 'True') {
        $emptypath += $path
        $result = 'False'
        }
}
foreach ($line in get-content 'services.txt') {
    try {
        Get-Service $line -EA stop
        }
    catch {
        $result = 'False'
        $emptyservices += $line
        }
    }
If ($result -eq 'True') {
    write-host 'Установка прошла успешно'
    }
else {
    write-host 'Установка завершилась неудачно. Подробности в log_install_files_and_services.txt'
    If ($emptypath -ne 0) {
        'Не найдены следующие файлы:' >> log_install_files_and_services.txt
        foreach ($line in $emptypath) {
            $line >> log_install_files_and_services.txt
            }
        }
    If ($emptyservices -ne 0) {
        'Не найдены следующие службы:' >> log_install_files_and_services.txt
        foreach ($line in $emptyservices) {
            $line >> log_install_files_and_services.txt
            }
        }
    }
Write-Host "Для выхода нажмите любую клавишу"
cmd /c pause | out-null