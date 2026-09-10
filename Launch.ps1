$exePath = "$env:TEMP\HoriaktzMarket.exe"
# Link direct catre noul release v2.6 sau latest
$releaseUrl = "https://github.com/Horiaktz/HoriaktzMarketTerminal/releases/download/v2.6/HoriaktzMarket.exe"

Write-Host "[*] Se lanseaza Horiaktz Market Terminal v2.6..." -ForegroundColor Cyan

# Stergem executabilul vechi din cache daca exista
if (Test-Path $exePath) {
    Remove-Item $exePath -Force -ErrorAction SilentlyContinue
}

Write-Host "[*] Descarcam noua versiune de pe GitHub..." -ForegroundColor Yellow
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $releaseUrl -OutFile $exePath -UseBasicParsing
} catch {
    # Daca linkul cu v2.6 nu raspunde, incercam fallback pe latest
    try {
        $fallbackUrl = "https://github.com/Horiaktz/HoriaktzMarketTerminal/releases/latest/download/HoriaktzMarket.exe"
        Invoke-WebRequest -Uri $fallbackUrl -OutFile $exePath -UseBasicParsing
    } catch {
        Write-Host "[X] Eroare la descarcare: $_" -ForegroundColor Red
        exit
    }
}

if (Test-Path $exePath) {
    Start-Process -FilePath $exePath -Wait
} else {
    Write-Host "[X] Executabilul nu a putut fi gasit." -ForegroundColor Red
}
