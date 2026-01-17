# Script untuk cek siapa saja yang sudah contribute
# Jalankan di repository Favianyumna atau fork

Write-Host "=== Cek Kontributor Repository ===" -ForegroundColor Cyan
Write-Host ""

# Cek remote upstream
$upstream = git remote get-url upstream 2>$null
if (-not $upstream) {
    Write-Host "⚠️  Remote upstream tidak ditemukan!" -ForegroundColor Red
    Write-Host "   Setup: git remote add upstream https://github.com/Favianyumna/Insight_minds.git" -ForegroundColor Yellow
    exit 1
}

Write-Host "Repository: $upstream" -ForegroundColor Green
Write-Host ""

# Fetch update
Write-Host "Mengambil update dari repository teman..." -ForegroundColor Yellow
git fetch upstream 2>&1 | Out-Null

# Cek contributors dari log
Write-Host ""
Write-Host "=== Contributors (dari commit history) ===" -ForegroundColor Cyan
$contributors = git log upstream/main --pretty=format:"%an <%ae>" | Sort-Object -Unique

$count = 1
foreach ($contributor in $contributors) {
    Write-Host "$count. $contributor" -ForegroundColor White
    $count++
}

Write-Host ""
Write-Host "Total Contributors: $($contributors.Count)" -ForegroundColor Green
Write-Host ""

# Info untuk melihat di GitHub
Write-Host "=== Lihat di GitHub ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Contributors:" -ForegroundColor Yellow
Write-Host "   https://github.com/Favianyumna/Insight_minds/graphs/contributors" -ForegroundColor White
Write-Host ""
Write-Host "2. Pull Requests:" -ForegroundColor Yellow
Write-Host "   https://github.com/Favianyumna/Insight_minds/pulls" -ForegroundColor White
Write-Host ""
Write-Host "3. Commits:" -ForegroundColor Yellow
Write-Host "   https://github.com/Favianyumna/Insight_minds/commits/main" -ForegroundColor White
Write-Host ""
Write-Host "4. Network Graph:" -ForegroundColor Yellow
Write-Host "   https://github.com/Favianyumna/Insight_minds/network" -ForegroundColor White
Write-Host ""
