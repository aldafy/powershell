clear-host
if ((Test-Path 'log_remove_files_and_services.txt') -eq 'True') {
    clear-content 'log_remove_files_and_services.txt'
    }
$result = 'True'
$presentpath = @()
$presentservices = @()
$arch = [IntPtr]::Size
if ($arch -eq 8) {
    $file = 'for_x64_not_XP.txt'
    }
elseif ($arch -eq 4) {
    $file = 'for_x86_not_XP.txt'
    }
foreach ($path in get-content $file) {
    if ((Test-Path $path) -eq 'True') {
        $presentpath += $path
        $result = 'False'
        }
}
foreach ($line in get-content 'services.txt') {
    try {
        Get-Service $line -EA stop
        $result = 'False'
        $emptyservices += $line
        }
    catch {
        }
    }
If ($result -eq 'True') {
    write-host '�������� ������ � ����� ������ �������'
    }
else {
    write-host '�������� ������ � ����� ����������� �� ���������. ����������� � log_remove_files_and_services.txt'
    If ($presentpath -ne 0) {
        '������� ��������� �����:' >> log_remove_files_and_services.txt
        foreach ($line in $presentpath) {
            $line >> log_remove_files_and_services.txt
            }
        }
    If ($presentservices -ne 0) {
        '������� ��������� ������:' >> log_remove_files_and_services.txt
        foreach ($line in $presentservices) {
            $line >> log_remove_files_and_services.txt
            }
        }
    }
Write-Host "��� ������ ������� ����� �������"
cmd /c pause | out-null