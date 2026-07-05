# 1. Configurăm o cale universală sigură în folderul User-ului (funcționează pe orice PC)
$targetFolder = "$HOME\HoriaktzMarketTerminal"

# 2. Dacă proiectul nu există pe acest PC, îl descărcăm automat de pe GitHub-ul tău
if (-not (Test-Path $targetFolder)) {
    Write-Host "[*] Terminalul nu a fost găsit local. Îl descărcăm de pe GitHub..." -ForegroundColor Yellow
    # Verificăm dacă există Git instalat, altfel descărcăm direct arhiva ZIP a codului ta
    if (Get-Command git -ErrorAction SilentlyContinue) {
        git clone https://github.com/Horiaktz/HoriaktzMarketTerminal.git $targetFolder
    } else {
        Write-Host "[*] Git nu este instalat. Descărcăm codul sursă direct..." -ForegroundColor Direct
        $zipPath = "$env:TEMP\terminal.zip"
        Invoke-RestMethod -Uri "https://github.com/Horiaktz/HoriaktzMarketTerminal/archive/refs/heads/main.zip" -OutFile $zipPath
        Expand-Archive -Path $zipPath -DestinationPath "$env:TEMP\terminal_extract" -Force
        Move-Item -Path "$env:TEMP\terminal_extract\HoriaktzMarketTerminal-main" -Destination $targetFolder -Force
    }
}

# 3. Mergem în folderul proiectului
cd $targetFolder

# 4. Verificăm dacă Python este instalat pe acest calculator
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Python nu este instalat pe acest PC. Se instalează automat în fundal (silențios)..." -ForegroundColor Cyan
    $wingetCheck = Get-Command winget -ErrorAction SilentlyContinue
    if ($wingetCheck) {
        winget install --id Python.Python.3.11 --silent --accept-source-agreements --accept-package-agreements
        # Reîmprospătăm variabilele de mediu ca PowerShell să vadă Python-ul nou instalat
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } else {
        Write-Host "[🔴] Acest PC nu are WinGet sau Python. Te rog instalează Python din Microsoft Store pentru a rula terminalul." -ForegroundColor Red
        return
    }
}

# 5. Managementul Mediului Virtual (.venv) - îl creăm dacă nu există
if (-not (Test-Path ".\.venv")) {
    Write-Host "[*] Se creează mediul virtual separat pentru izolare biblioteci..." -ForegroundColor Yellow
    python -m venv .venv
    .\.venv\Scripts\Activate.ps1
    Write-Host "[*] Se instalează dependințele necesare (yfinance, requests etc.)..." -ForegroundColor Yellow
    python -m pip install --upgrade pip
    if (Test-Path "requirements.txt") {
        pip install -r requirements.txt
    } else {
        pip install yfinance requests pandas bs4 matplotlib  # Fallback dacă lipsește requirements.txt
    }
} else {
    # Dacă există deja mediul virtual, doar îl activăm
    .\.venv\Scripts\Activate.ps1
}

# 6. Lansăm Terminalul tău stabil!
python market.py
