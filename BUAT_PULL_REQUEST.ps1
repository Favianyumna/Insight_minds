# Script untuk membuat Pull Request ke repository Favianyumna
# Jalankan script ini setelah commit dan push

Write-Host "=== Membuat Pull Request ke Favianyumna/Insight_minds ===" -ForegroundColor Cyan
Write-Host ""

# Cek remote
Write-Host "1. Cek remote repository..." -ForegroundColor Yellow
$origin = git remote get-url origin
$upstream = git remote get-url upstream 2>$null

Write-Host "   Origin: $origin" -ForegroundColor Gray
Write-Host "   Upstream: $upstream" -ForegroundColor Gray
Write-Host ""

# Cek apakah sudah push
Write-Host "2. Cek status commit..." -ForegroundColor Yellow
$status = git status --short
if ($status) {
    Write-Host "   ⚠️  Ada perubahan yang belum di-commit!" -ForegroundColor Red
    Write-Host "   Jalankan: git add . && git commit -m 'feat: deskripsi'" -ForegroundColor Yellow
    exit 1
}

# Cek branch
$currentBranch = git branch --show-current
Write-Host "   Branch: $currentBranch" -ForegroundColor Gray
Write-Host ""

# Cek apakah sudah push
Write-Host "3. Cek apakah sudah push..." -ForegroundColor Yellow
$localCommit = git rev-parse HEAD
$remoteCommit = git rev-parse origin/$currentBranch 2>$null

if ($localCommit -ne $remoteCommit) {
    Write-Host "   ⚠️  Belum di-push ke GitHub!" -ForegroundColor Red
    Write-Host "   Jalankan: git push origin $currentBranch" -ForegroundColor Yellow
    exit 1
}

Write-Host "   ✅ Sudah di-push" -ForegroundColor Green
Write-Host ""

# Extract username dari origin URL
if ($origin -match "github\.com/([^/]+)/") {
    $username = $matches[1]
    Write-Host "4. Username terdeteksi: $username" -ForegroundColor Green
    Write-Host ""
    
    # Generate PR URL
    $prUrl = "https://github.com/Favianyumna/Insight_minds/compare/main...$username`:Insight_minds:main"
    
    Write-Host "=== Langkah Selanjutnya ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Buka URL berikut di browser:" -ForegroundColor Yellow
    Write-Host "   $prUrl" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Atau buka manual:" -ForegroundColor Yellow
    Write-Host "   https://github.com/$username/Insight_minds" -ForegroundColor White
    Write-Host "   Klik 'Contribute' → 'Open Pull Request'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Isi deskripsi PR:" -ForegroundColor Yellow
    Write-Host "   Judul: feat: [nama fitur yang ditambahkan]" -ForegroundColor Gray
    Write-Host "   Deskripsi: List perubahan yang dibuat" -ForegroundColor Gray
    Write-Host "   Mention: @Favianyumna" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. Klik 'Create Pull Request'" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "✅ Setelah PR dibuat, Favianyumna akan mendapat notifikasi" -ForegroundColor Green
    Write-Host "✅ Dosen bisa lihat di: https://github.com/Favianyumna/Insight_minds/pulls" -ForegroundColor Green
    Write-Host "✅ Contributors terlihat di: https://github.com/Favianyumna/Insight_minds/graphs/contributors" -ForegroundColor Green
    Write-Host ""
    
    # Buka browser otomatis (opsional)
    $openBrowser = Read-Host "Buka URL PR di browser? (y/n)"
    if ($openBrowser -eq "y" -or $openBrowser -eq "Y") {
        Start-Process $prUrl
    }
} else {
    Write-Host "   ⚠️  Tidak bisa detect username dari remote" -ForegroundColor Red
    Write-Host "   Buka manual: https://github.com/YOUR-USERNAME/Insight_minds" -ForegroundColor Yellow
}
