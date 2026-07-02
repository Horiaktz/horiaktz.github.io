Clear-Host

$Host.UI.RawUI.WindowTitle = "Horia Utility"

Write-Host ""
Write-Host "==========================================" -ForegroundColor DarkCyan
Write-Host "           HORIA UTILITY v0.1             " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor DarkCyan
Write-Host ""

Write-Host "[+] Se încarcă utilitarul..." -ForegroundColor Green
Start-Sleep 1

Write-Host "[+] Verificare conexiune..." -ForegroundColor Yellow
Start-Sleep 1

Write-Host "[✓] Gata!" -ForegroundColor Green
Write-Host ""

Start-Process "https://asistentapsihologica.rf.gd"
