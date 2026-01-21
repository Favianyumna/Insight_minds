# 🚀 QUICK START - Login/Register Testing

## Status: ✅ FIXED

Masalah login dan register sudah diperbaiki dan siap untuk ditest.

## 📦 Installation

```bash
flutter pub get
```

Semua dependencies sudah di-install termasuk `crypto` package untuk password hashing.

## 🧪 Testing Checklist

### Test 1: Register User Baru
- [ ] Buka aplikasi
- [ ] Klik "Daftar"
- [ ] Isi form dengan:
  - Nama Lengkap: `Test User`
  - Email: `test@example.com`
  - Password: `password123`
  - Konfirmasi: `password123`
- [ ] Klik "Daftar"
- [ ] ✅ Seharusnya otomatis login ke home page

### Test 2: Login
- [ ] Dari home page → Drawer → Logout
- [ ] Klik "Masuk"
- [ ] Isi dengan:
  - Email: `test@example.com`
  - Password: `password123`
- [ ] Klik "Masuk"
- [ ] ✅ Seharusnya masuk ke home page

### Test 3: Wrong Password
- [ ] Klik "Masuk"
- [ ] Email: `test@example.com`
- [ ] Password: `wrongpassword`
- [ ] Klik "Masuk"
- [ ] ✅ Error: "Password salah"

### Test 4: Email Not Found
- [ ] Klik "Masuk"
- [ ] Email: `notexist@example.com`
- [ ] Password: `anything`
- [ ] Klik "Masuk"
- [ ] ✅ Error: "Email tidak ditemukan"

### Test 5: Empty Fields
- [ ] Klik "Masuk"
- [ ] Kosongkan email dan password
- [ ] Klik "Masuk"
- [ ] ✅ Error: "Email dan password wajib diisi"

### Test 6: Short Password (Register)
- [ ] Klik "Daftar"
- [ ] Nama: `Test`
- [ ] Email: `test2@example.com`
- [ ] Password: `123` (kurang dari 6)
- [ ] Klik "Daftar"
- [ ] ✅ Error: "Password minimal 6 karakter"

### Test 7: Duplicate Email
- [ ] Klik "Daftar"
- [ ] Email: `test@example.com` (sudah ada dari Test 1)
- [ ] Klik "Daftar"
- [ ] ✅ Error: "Email sudah terdaftar"

## 🔍 Files Changed

```
lib/core/features/auth/data/repositories/auth_repository.dart
pubspec.yaml
```

## 📚 Documentation

- [FIX_LOGIN_REGISTER_ISSUES.md](FIX_LOGIN_REGISTER_ISSUES.md) - Detailed fix explanation
- [SUMMARY_LOGIN_FIX.md](SUMMARY_LOGIN_FIX.md) - Summary of changes

## ⚠️ Important Notes

### Data Persistence
Data disimpan di Hive local database. Jika ingin reset:
```bash
flutter clean
# atau hapus app dan reinstall
```

### Password Hash
Password menggunakan SHA256 hashing. Passwords yang tersimpan sebelumnya (plain text) tidak akan match dengan new hash system.

**Solution:** 
- Option 1: `flutter clean` untuk reset semua data
- Option 2: Buat user baru dengan password yang baru

### For Production
Saat ini menggunakan local storage. Untuk production:
1. Migrate ke backend API
2. Gunakan bcrypt atau argon2 untuk password hashing
3. Implement HTTPS
4. Add refresh tokens

## 🎯 Expected Results

```
✅ Register → Auto-login → Home page
✅ Login dengan email & password yang benar → Home page
✅ Login dengan password salah → Error message
✅ Register dengan email yang sudah ada → Error message
✅ Input validation untuk empty fields → Error message
✅ Password hashing menggunakan SHA256 → Secure
```

## 🆘 Troubleshooting

### "Users box belum diinisialisasi"
**Cause:** Hive box tidak terbuka di main()  
**Fix:** Pastikan `Hive.openBox('users')` dipanggil di `main()` ✅ (Sudah fixed)

### "Password masih plain text"
**Cause:** Old data dari sebelum fix  
**Fix:** `flutter clean` untuk reset data

### "Import crypto tidak found"
**Fix:** `flutter pub get`

---

**Last Updated:** 2026-01-17  
**Status:** ✅ Ready for Testing
