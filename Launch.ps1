$exePath = "$env:TEMP\HoriaktzMarket.exe"
Write-Host "[*] Se lanseaza Horiaktz Market Terminal..." -ForegroundColor Cyan

# Daca nu il are deja in calculator, il descarca din Release-ul de pe GitHub
if (-not (Test-Path $exePath)) {
    Invoke-RestMethod -Uri "https://github.com/Horiaktz/horiaktz.github.io/releases/latest/download/market.exe" -OutFile $exePath
}

# Il porneste instant
Start-Process -FilePath $exePath -Wait
