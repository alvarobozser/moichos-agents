# bootstrap.ps1 — Descarga e instala el sistema multi-agente desde GitHub
#
# Uso (una sola línea, desde cualquier PC):
#   irm https://raw.githubusercontent.com/alvarobozser/moichos-agents/main/bootstrap.ps1 | iex
#
# Con parámetros (guardar el script primero):
#   .\bootstrap.ps1 -Target C:\ruta\al\proyecto -Force

param(
    [string]$Target = (Get-Location).Path,
    [switch]$Force,
    [switch]$Help
)

# ── Configuración — actualiza esta URL tras el primer push a GitHub
$RepoUrl = "https://github.com/alvarobozser/moichos-agents"
$Branch  = "main"

if ($Help) { Write-Host "Uso: .\bootstrap.ps1 [-Target C:\ruta] [-Force]"; exit 0 }

Write-Host "Sistema Multi-Agente - Bootstrap" -ForegroundColor Blue
Write-Host "Repo   : $RepoUrl"
Write-Host "Destino: $Target"
Write-Host ""

if ($RepoUrl -like "*TU_USUARIO*") {
    Write-Host "x El script no esta configurado aun." -ForegroundColor Red
    Write-Host "  Edita bootstrap.ps1 y reemplaza alvarobozser/moichos-agents con tu repositorio GitHub."
    exit 1
}

$TmpDir = Join-Path $env:TEMP "agents-bootstrap-$(Get-Random)"
New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null

try {
    Write-Host "Descargando sistema de agentes..."
    $gitAvailable = $null -ne (Get-Command git -ErrorAction SilentlyContinue)

    if ($gitAvailable) {
        git clone --depth 1 --branch $Branch "$RepoUrl.git" "$TmpDir\repo" --quiet 2>$null
        Write-Host "  + Clonado via git" -ForegroundColor Green
    } else {
        $zipUrl  = "$RepoUrl/archive/refs/heads/$Branch.zip"
        $zipPath = "$TmpDir\repo.zip"
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
        Expand-Archive -Path $zipPath -DestinationPath $TmpDir
        $extracted = Get-ChildItem $TmpDir -Directory | Where-Object { $_.Name -ne "repo" } | Select-Object -First 1
        Rename-Item $extracted.FullName "$TmpDir\repo"
        Write-Host "  + Descargado via web" -ForegroundColor Green
    }

    Write-Host ""
    if ($Force) {
        & "$TmpDir\repo\install.ps1" -Target $Target -Force
    } else {
        & "$TmpDir\repo\install.ps1" -Target $Target
    }
} finally {
    Remove-Item $TmpDir -Recurse -Force -ErrorAction SilentlyContinue
}
