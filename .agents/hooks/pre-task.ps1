# pre-task.ps1 — Validaciones antes de ejecutar una tarea de escritura (Windows)
# Invocado por el hook PreToolUse de Claude Code

param([string]$Tool = "unknown")

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "[$Timestamp] pre-task: $Tool"

# Verificar que estamos dentro de un repo git
$gitCheck = git rev-parse --git-dir 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  AVISO: No estás en un repositorio git. Los cambios no podrán versionarse."
}

# Advertir si hay cambios sin commitear
$uncommitted = (git status --porcelain 2>$null | Measure-Object -Line).Lines
if ($uncommitted -gt 5) {
    Write-Host "⚠️  AVISO: Hay $uncommitted ficheros con cambios sin commitear."
}

# Verificar que no hay .env en el working tree
$envFiles = git status --porcelain 2>$null | Where-Object { $_ -match "\.env$" }
if ($envFiles) {
    Write-Host "⚠️  AVISO: Hay un fichero .env en el working tree. No lo incluyas en el commit."
}

exit 0
