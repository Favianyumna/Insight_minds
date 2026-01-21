/// Centralized string constants for the InsightMind app
class AppStrings {
  AppStrings._(); // Private constructor to prevent instantiation

  // App Info
  static const String appName = 'InsightMind';
  static const String appTagline = 'Mental Health Companion';
  static const String appVersion = '1.0.0';

  // Auth
  static const String login = 'Masuk';
  static const String register = 'Daftar';
  static const String logout = 'Keluar';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Konfirmasi Password';
  static const String fullName = 'Nama Lengkap';
  static const String phoneNumber = 'Nomor Telepon';
  static const String age = 'Usia';
  static const String gender = 'Jenis Kelamin';
  static const String bio = 'Bio';

  // Validation Messages
  static const String emailRequired = 'Email tidak boleh kosong';
  static const String emailInvalid = 'Format email tidak valid';
  static const String passwordRequired = 'Password tidak boleh kosong';
  static const String passwordMinLength = 'Password minimal 6 karakter';
  static const String passwordMismatch = 'Password tidak cocok';
  static const String nameRequired = 'Nama tidak boleh kosong';
  static const String nameMinLength = 'Nama minimal 3 karakter';
  static const String phoneInvalid = 'Format nomor telepon tidak valid';
  static const String ageInvalid = 'Usia tidak valid';

  // Error Messages
  static const String errorGeneric = 'Terjadi kesalahan';
  static const String errorNetwork = 'Koneksi internet bermasalah';
  static const String errorNotFound = 'Data tidak ditemukan';
  static const String errorUnauthorized = 'Anda tidak memiliki akses';

  // Success Messages
  static const String successSaved = 'Data berhasil disimpan';
  static const String successDeleted = 'Data berhasil dihapus';
  static const String successUpdated = 'Data berhasil diperbarui';

  // Common
  static const String save = 'Simpan';
  static const String cancel = 'Batal';
  static const String delete = 'Hapus';
  static const String edit = 'Edit';
  static const String close = 'Tutup';
  static const String loading = 'Memuat...';
  static const String noData = 'Tidak ada data';
}
