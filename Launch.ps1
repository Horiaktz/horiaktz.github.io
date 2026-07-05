# 1. Configurăm o cale universală sigură în folderul User-ului
$targetFolder = "$HOME\HoriaktzMarketTerminal"

# 2. Dacă proiectul nu există local, îl descărcăm de pe GitHub
if (-not (Test-Path $targetFolder)) {
    Write-Host "[*] Terminalul nu a fost găsit local. Îl descărcăm de pe GitHub..." -ForegroundColor Yellow
    if (Get-Command git -ErrorAction SilentlyContinue) {
        git clone https://github.com/Horiaktz/HoriaktzMarketTerminal.git $targetFolder
    } else {
        Write-Host "[*] Git nu este instalat. Descărcăm codul sursă direct..." -ForegroundColor Yellow
        $zipPath = "$env:TEMP\terminal.zip"
        Invoke-RestMethod -Uri "https://github.com/Horiaktz/HoriaktzMarketTerminal/archive/refs/heads/main.zip" -OutFile $zipPath
        Expand-Archive -Path $zipPath -DestinationPath "$env:TEMP\terminal_extract" -Force
        Move-Item -Path "$env:TEMP\terminal_extract\HoriaktzMarketTerminal-main" -Destination $targetFolder -Force
    }
}

# Mergem în folderul proiectului
cd $targetFolder

# 3. VERIFICARE REALĂ PYTHON (Trecem de aliasurile false din Windows)
$pythonValid = $false
if (Get-Command python -ErrorAction SilentlyContinue) {
    # Încercăm să rulăm o comandă scurtă. Dacă e aliasul gol din Windows, va da eroare cod 1 sau text specific.
    $checkPython = python --version 2>&1
    if ($checkPython -match "Python 3\.") {
        $pythonValid = $true
    }
}

# 4. Dacă nu avem un Python valid, îl instalăm forțat via Winget
if (-not $pythonValid) {
    Write-Host "[!] Python nu este instalat sau este invalid pe acest PC. Se instalează automat via Winget..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id Python.Python.3.11 --silent --accept-source-agreements --accept-package-agreements
        
        # Reîmprospătăm variabilele de mediu pe loc ca să devină activ
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        # Dacă tot nu îl vede imediat, încercăm drumul standard unde instalează Winget Python 3.11
        if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
            $env:Path += ";$env:LocalAppData\Programs\Python\Python311;$env:LocalAppData\Programs\Python\Python311\Scripts"
        }
    } else {
        Write-Host "[🔴] Winget nu a fost găsit. Te rog instalează Python manual din Microsoft Store sau python.org ca să poți continua!" -ForegroundColor Red
        return
    }
}

# 5. Managementul Mediului Virtual (.venv)
if (-not (Test-Path ".\.venv")) {
    Write-Host "[*] Se creează mediul virtual separat (.venv)..." -ForegroundColor Yellow
    python -m venv .venv
}

# Activăm mediul virtual
.\.venv\Scripts\Activate.ps1

# 6. Instalam dependințele în interiorul mediului izolat
Write-Host "[*] Se instalează/verifică dependințele necesare (yfinance, requests)..." -ForegroundColor Yellow
python -m pip install --upgrade pip --quiet
if (Test-Path "requirements.txt") {
    pip install -r requirements.txt --quiet
} else {
    pip install yfinance requests pandas bs4 matplotlib --quiet
}

# 7. Lansăm Terminalul stabil Horiaktz!
python market.py
