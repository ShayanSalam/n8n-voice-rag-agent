# Run from inside the n8n-rag-agent folder in PowerShell:  .\push.ps1
# Prerequisites: git installed, empty repo "n8n-rag-agent" already created on GitHub.

$ErrorActionPreference = "Stop"

if (-not (Test-Path "workflows/RAG_System.json")) {
    Write-Error "Put your exported RAG_System.json in the workflows folder first."
}

# Safety check: refuse to continue if anything secret-looking is staged.
git init
git add .
$staged = git diff --cached --name-only
$bad = $staged | Where-Object { $_ -match "(?i)key|token|secret|\.env|\.txt$" }
if ($bad) {
    Write-Host "STOP - these look like secrets:" -ForegroundColor Red
    $bad
    git reset
    exit 1
}

Write-Host "Files to be committed:" -ForegroundColor Cyan
$staged

git commit -m "Add n8n RAG agent workflow, docs and README"
git branch -M main
git remote add origin https://github.com/ShayanSalam/n8n-voice-rag-agent.git
git push -u origin main
