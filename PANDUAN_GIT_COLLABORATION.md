# 📚 Panduan Git Collaboration - InsightMind Project

## 🎯 Tujuan
Menggunakan repository GitHub teman kelompok agar bisa:
- ✅ Commit dan push perubahan Anda
- ✅ Melihat update dari teman kelompok
- ✅ Pull perubahan dari teman
- ✅ Bekerja bersama tanpa conflict

---

## 📋 Langkah-Langkah Setup

### **Langkah 1: Dapatkan Link Repository GitHub Teman**

Minta teman kelompok Anda untuk memberikan:
- **Link repository GitHub** (contoh: `https://github.com/username/repo-name.git`)
- **Akses collaborator** (teman harus menambahkan Anda sebagai collaborator di GitHub)

---

### **Langkah 2: Setup Remote Repository**

Buka terminal di folder project Anda (`C:\flutter_insightmind_finals`):

#### **A. Cek remote yang sudah ada:**
```bash
git remote -v
```

#### **B. Tambahkan remote repository teman:**
```bash
# Jika belum ada remote
git remote add origin https://github.com/username-teman/repo-name.git

# Atau jika sudah ada remote, ganti dengan:
git remote set-url origin https://github.com/username-teman/repo-name.git

# Atau tambahkan sebagai remote kedua (untuk backup)
git remote add teman https://github.com/username-teman/repo-name.git
```

#### **C. Verifikasi remote sudah benar:**
```bash
git remote -v
```

**Output yang diharapkan:**
```
origin  https://github.com/username-teman/repo-name.git (fetch)
origin  https://github.com/username-teman/repo-name.git (push)
```

---

### **Langkah 3: Pull Perubahan dari Repository Teman**

**⚠️ PENTING: Selalu pull dulu sebelum push!**

```bash
# Fetch perubahan terbaru
git fetch origin

# Lihat perubahan yang ada
git log origin/main --oneline

# Pull perubahan dari teman
git pull origin main

# Atau jika branch-nya berbeda (misal: master)
git pull origin master
```

**Jika ada conflict:**
```bash
# Lihat file yang conflict
git status

# Edit file yang conflict, lalu:
git add .
git commit -m "Resolve conflict"
```

---

### **Langkah 4: Commit Perubahan Anda**

```bash
# 1. Cek status perubahan
git status

# 2. Tambahkan file yang diubah
git add .

# Atau tambahkan file spesifik:
git add lib/core/features/auth/presentation/pages/login_page.dart

# 3. Commit dengan pesan yang jelas
git commit -m "feat: tambah fitur login dan register dengan UI profesional"

# Pesan commit yang baik:
# - feat: untuk fitur baru
# - fix: untuk perbaikan bug
# - refactor: untuk refactoring code
# - docs: untuk dokumentasi
# - style: untuk formatting
```

---

### **Langkah 5: Push ke Repository GitHub**

```bash
# Push ke branch main
git push origin main

# Atau jika pertama kali push:
git push -u origin main

# Jika ada error "non-fast-forward", lakukan:
git pull origin main --rebase
git push origin main
```

---

## 🔄 Workflow Harian

### **Workflow yang Disarankan:**

```bash
# 1. SETIAP KALI MULAI KERJA - Pull dulu!
git pull origin main

# 2. Buat perubahan di code
# ... edit file ...

# 3. Commit perubahan
git add .
git commit -m "deskripsi perubahan"

# 4. Push ke GitHub
git push origin main

# 5. Informasikan teman bahwa sudah update
```

---

## 👀 Melihat Update dari Teman

### **Cara 1: Melihat di GitHub (Web)**
1. Buka repository di browser: `https://github.com/username-teman/repo-name`
2. Klik tab **"Commits"** untuk melihat semua commit
3. Klik **"Insights"** → **"Network"** untuk melihat graph

### **Cara 2: Melihat di Terminal**
```bash
# Lihat semua commit (termasuk dari teman)
git log --oneline --all --graph

# Lihat commit terbaru
git log --oneline -10

# Lihat perubahan dari teman
git log origin/main --oneline --author="nama-teman"

# Lihat detail perubahan
git show <commit-hash>
```

### **Cara 3: Melihat File yang Berubah**
```bash
# Lihat file yang berbeda dengan remote
git diff origin/main

# Lihat file yang diubah teman di commit tertentu
git show <commit-hash> --name-only
```

---

## 🚨 Menghindari Conflict

### **Tips untuk Menghindari Conflict:**

1. **Selalu pull sebelum push:**
   ```bash
   git pull origin main
   # ... buat perubahan ...
   git add .
   git commit -m "perubahan"
   git push origin main
   ```

2. **Komunikasi dengan teman:**
   - Informasikan fitur yang sedang dikerjakan
   - Jangan edit file yang sama bersamaan
   - Gunakan branch terpisah untuk fitur besar

3. **Gunakan branch untuk fitur besar:**
   ```bash
   # Buat branch baru
   git checkout -b fitur-auth
   
   # Kerja di branch ini
   # ... buat perubahan ...
   
   # Commit dan push branch
   git push origin fitur-auth
   
   # Setelah selesai, merge ke main
   git checkout main
   git pull origin main
   git merge fitur-auth
   git push origin main
   ```

---

## 🔧 Troubleshooting

### **Problem 1: "Your branch is behind 'origin/main' by X commits"**

**Solusi:**
```bash
git pull origin main
# Resolve conflict jika ada
git push origin main
```

### **Problem 2: "Failed to push some refs"**

**Solusi:**
```bash
git pull origin main --rebase
git push origin main
```

### **Problem 3: Conflict saat merge**

**Solusi:**
```bash
# 1. Lihat file yang conflict
git status

# 2. Buka file yang conflict, cari tanda:
# <<<<<<< HEAD
# kode Anda
# =======
# kode teman
# >>>>>>> origin/main

# 3. Edit file, pilih kode yang benar atau gabungkan

# 4. Setelah selesai:
git add .
git commit -m "Resolve conflict"
git push origin main
```

### **Problem 4: Ingin reset ke versi sebelumnya**

**Solusi:**
```bash
# Lihat history
git log --oneline

# Reset ke commit tertentu (HATI-HATI!)
git reset --hard <commit-hash>

# Atau reset ke versi remote
git reset --hard origin/main
```

---

## 📝 Best Practices

### **1. Commit Message yang Baik:**
```bash
# ✅ BAIK:
git commit -m "feat: tambah halaman login dengan validasi"
git commit -m "fix: perbaiki error Hive box users"
git commit -m "refactor: extract shared widgets untuk auth"

# ❌ BURUK:
git commit -m "update"
git commit -m "fix"
git commit -m "perubahan"
```

### **2. Commit Sering dengan Pesan Jelas:**
- Jangan tunggu sampai banyak perubahan baru commit
- Commit setiap fitur/perbaikan selesai
- Pesan commit harus jelas dan deskriptif

### **3. Jangan Commit File yang Tidak Perlu:**
Buat file `.gitignore` di root project:
```
# Flutter/Dart
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
*.iml
*.ipr
*.iws
.idea/

# Android
android/.gradle/
android/local.properties

# iOS
ios/Pods/
ios/.symlinks/

# VS Code
.vscode/

# Environment
.env
.env.local

# Logs
*.log
```

---

## 🎯 Checklist Setup Awal

- [ ] Dapatkan link repository GitHub teman
- [ ] Minta akses collaborator dari teman
- [ ] Setup remote repository
- [ ] Pull perubahan terbaru
- [ ] Buat `.gitignore` jika belum ada
- [ ] Test commit dan push
- [ ] Verifikasi perubahan muncul di GitHub

---

## 📞 Command Cheat Sheet

```bash
# Setup
git remote add origin <url>
git remote -v

# Update
git pull origin main
git fetch origin

# Commit
git status
git add .
git commit -m "pesan"
git push origin main

# Lihat History
git log --oneline
git log --oneline --all --graph
git show <commit-hash>

# Branch
git checkout -b nama-branch
git branch
git checkout main
git merge nama-branch

# Troubleshooting
git pull origin main --rebase
git reset --hard origin/main
```

---

## 🎉 Selesai!

Setelah setup ini, Anda bisa:
- ✅ Melihat semua perubahan dari teman di GitHub
- ✅ Commit dan push perubahan Anda
- ✅ Bekerja bersama tanpa kehilangan progress
- ✅ Melihat history semua perubahan

**Selamat berkolaborasi! 🚀**
