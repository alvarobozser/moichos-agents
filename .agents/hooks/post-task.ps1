# post-task.ps1 — Acciones y auditoría tras completar una tarea (Windows)
# Invocado por el hook Stop de Claude Code

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Changed = (git status --porcelain 2>$null | Measure-Object -Line).Lines

Write-Host "[$Timestamp] post-task: tarea completada"

# ── 1. Escanear ficheros modificados en busca de secrets ──────────────────────
$SecretPattern = '(ghp_[a-zA-Z0-9]{36}|sk-ant-api[0-9]+-[a-zA-Z0-9_-]{90,}|sk-[a-zA-Z0-9]{48}|xoxb-[0-9]+-[a-zA-Z0-9-]+|AIza[0-9A-Za-z_-]{35}|AKIA[0-9A-Z]{16}|[Pp]assword\s*[:=]\s*[''"][^''"]{6,}|api[_-]?key\s*[:=]\s*[''"][^''"]{8,}|[Bb]earer\s+[a-zA-Z0-9\-_\.]{20,}|[Ss]ecret\s*[:=]\s*[''"][^''"]{8,})'

$ModifiedFiles = @()
$ModifiedFiles += git diff --name-only HEAD 2>$null
$ModifiedFiles += git ls-files --others --exclude-standard 2>$null
$ModifiedFiles = $ModifiedFiles | Where-Object { $_ -and (Test-Path $_) }

$Hits = @()
foreach ($File in $ModifiedFiles) {
    $Matches = Select-String -Path $File -Pattern $SecretPattern -ErrorAction SilentlyContinue
    if ($Matches) { $Hits += $Matches }
}

if ($Hits.Count -gt 0) {
    Write-Host ""
    Write-Host "🚨 ALERTA DE SEGURIDAD: Posibles secrets detectados en ficheros modificados:" -ForegroundColor Red
    $Hits | Select-Object -First 20 | ForEach-Object { Write-Host "   $_" -ForegroundColor Red }
    Write-Host ""
    Write-Host "   Revisa estos ficheros ANTES de hacer commit o push." -ForegroundColor Yellow
    Write-Host "   Usa 'git diff' para confirmar qué se va a subir." -ForegroundColor Yellow
}

# ── 2. Resumen de cambios ─────────────────────────────────────────────────────
if ($Changed -gt 0) {
    Write-Host ""
    Write-Host "📝 Ficheros modificados ($Changed):"
    git status --short 2>$null
    Write-Host ""
    Write-Host "💡 Sugerencia: cuando quieras commitear, usa Conventional Commits:"
    Write-Host "   feat(scope): descripción"
    Write-Host "   fix(scope): descripción"
}

exit 0
