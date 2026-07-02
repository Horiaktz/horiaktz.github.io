Clear-Host

Write-Host "==============================" -ForegroundColor Cyan
Write-Host "       HORIA UTILITY"
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Deschide site-ul"
Write-Host "2. Deschide Notepad"
Write-Host "3. Informații sistem"
Write-Host "0. Ieșire"
Write-Host ""

$opt = Read-Host "Alege o opțiune"

switch ($opt)
{
    "1" { Start-Process "https://asistentapsihologica.rf.gd" }
    "2" { Start-Process notepad }
    "3" { Get-ComputerInfo | Out-Host }
    "0" { exit }
    default { Write-Host "Opțiune invalidă." -ForegroundColor Red }
}
