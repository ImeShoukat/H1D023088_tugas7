# Tugas 7
```
Nama        : Imedia Sholem Shoukat
Nim         : H1D023088
Shift Baru  : D
Shift KRS   : C
```

## 🧩 Penjelasan Struktur Kode

Berikut adalah detail teknis mengenai fungsi setiap file dalam aplikasi ini:

### 1. `main.dart` 
File ini adalah titik awal aplikasi (`entry point`).
- **Global Theme:** Mengatur tema aplikasi menjadi **Dark Mode** (Spotify Style) menggunakan `ThemeData.dark()`.
- **Initialization:** Memanggil `WidgetsFlutterBinding.ensureInitialized()` untuk memastikan plugin (seperti Audio & Storage) siap sebelum aplikasi dijalankan.

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const MyApp());
}

theme: ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF121212), 
  primaryColor: const Color(0xFF1DB954), 
),
```

### 2. `login_page.dart` (Autentikasi & Logic)
Menangani input username dan password user.
- **Validasi:** Mengecek apakah input adalah `admin`.
- **Jumpscare Logic:** Jika password salah, fungsi `_showJumpscare()` dipanggil untuk menampilkan `AlertDialog` dengan gambar hantu.
- **Session Save:** Jika benar, fungsi `_saveUsername()` menyimpan data ke `SharedPreferences` agar user tetap login nanti.

```dart
if (_usernameController.text == 'admin' && _passwordController.text == 'admin') {
  _saveUsername(); 
  Navigator.pushReplacement(...); 
} else {
  _showJumpscare(); 
}
```

### 3. `home_page.dart` (Dashboard UI)
Halaman utama setelah login berhasil.
- **Gradient Background:** Menggunakan `BoxDecoration` dengan `LinearGradient` untuk efek warna gradasi.
- **Load Session:** Mengambil nama user yang tersimpan di memori menggunakan `prefs.getString('username')` dan menampilkannya di layar.

```dart
void _loadUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    namauser = prefs.getString('username') ?? 'User';
  });
}
```

### 4. `sidemenu.dart` (Navigasi)
Menu samping (Drawer) untuk berpindah halaman.
- **UserHeader:** Menampilkan profil admin dengan gaya `UserAccountsDrawerHeader`.
- **PushReplacement:** Menggunakan `Navigator.pushReplacement` saat pindah halaman. Ini **sangat penting** agar halaman lama (terutama Music Player) benar-benar ditutup dan lagunya berhenti saat pindah menu.
- **Logout:** Menghapus sesi (`prefs.remove('username')`) dan mengembalikan user ke halaman Login secara permanen.

```dart
Widget _buildMenuItem(...) {
  return ListTile(
    onTap: () {
      Navigator.pop(context); 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    },
  );
}
```

### 5. `music_page.dart` (Audio Logic)
Halaman pemutar musik interaktif.
- **Library:** Menggunakan `audioplayers`.
- **Event Listeners:**
  - `onPlayerStateChanged`: Mengubah ikon Play/Pause.
  - `onDurationChanged`: Mendapatkan total durasi lagu untuk Slider.
  - `onPositionChanged`: Menggerakkan Slider sesuai detik lagu yang berjalan.
- **Lifecycle:** Menggunakan `dispose()` untuk mematikan lagu (`player.stop()`) secara otomatis saat user meninggalkan halaman ini.

```dart
@override
void initState() {
  // Listener untuk update slider durasi secara real-time
  player.onPositionChanged.listen((newPosition) {
    setState(() => position = newPosition);
  });
  _playMusic();
}

@override
void dispose() {
  player.stop(); // Paksa stop lagu saat ganti page
  player.dispose(); // Hancurkan object player
  super.dispose();
}
```

### 6. `me_page.dart` (CRUD Notes)
Fitur catatan sederhana dengan penyimpanan lokal.
- **Data Structure:** Menyimpan catatan dalam bentuk `List<String>`.
- **Persistence:** Menggunakan `prefs.setStringList` untuk menyimpan daftar catatan dan `prefs.getStringList` untuk memuatnya kembali saat aplikasi dibuka.
- **State Management:** Setiap kali menambah atau menghapus catatan, `setState()` dipanggil untuk memperbarui tampilan list secara langsung.

```dart
// Menambah Catatan
void _addNote(String note) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _notes.add(note);
  // Simpan List String ke Local Storage
  await prefs.setStringList('notes_list', _notes); 
}

// Memuat Catatan
void _loadNotes() async {
  // Ambil data, jika null (kosong), kembalikan list kosong []
  _notes = prefs.getStringList('notes_list') ?? []; 
}
```