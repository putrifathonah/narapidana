import 'package:flutter/material.dart'; // Import package Flutter untuk UI
import '../service/firebase_services.dart'; // Import file service Firebase

class TambahScreen extends StatefulWidget {
  // Membuat halaman TambahScreen
  const TambahScreen({super.key}); // Constructor TambahScreen

  @override
  State<TambahScreen> createState() => _TambahScreenState(); // Menghubungkan widget dengan state
}

class _TambahScreenState extends State<TambahScreen> {
  // State dari TambahScreen
  final _formKey =
      GlobalKey<FormState>(); // Key untuk mengontrol dan validasi form
  final _namaController = TextEditingController(); // Controller input nama
  final _umurController = TextEditingController(); // Controller input umur
  final _kasusController = TextEditingController(); // Controller input kasus

  String _jenisKelamin = 'Laki-laki'; // Nilai awal dropdown jenis kelamin
  bool _isLoading = false; // Penanda proses simpan sedang berjalan atau tidak

  final FirebaseService _service = FirebaseService(); // Objek service Firebase

  @override
  void dispose() {
    // Method untuk membersihkan controller saat widget ditutup
    _namaController.dispose(); // Membersihkan controller nama
    _umurController.dispose(); // Membersihkan controller umur
    _kasusController.dispose(); // Membersihkan controller kasus
    super.dispose(); // Menjalankan dispose bawaan parent class
  }

  Future<void> _simpanData() async {
    // Fungsi untuk menyimpan data ke Firebase
    if (!_formKey.currentState!.validate())
      return; // Jika form tidak valid, proses dihentikan

    setState(() => _isLoading = true); // Mengubah status loading menjadi true

    try {
      // Langsung kirim parameter tanpa class model
      _service.tambahNarapidana(
        _namaController.text
            .trim(), // Mengambil nama dan menghapus spasi di awal/akhir
        _jenisKelamin, // Mengambil jenis kelamin
        int.parse(
          _umurController.text.trim(),
        ), // Mengubah input umur menjadi integer
        _kasusController.text
            .trim(), // Mengambil kasus dan menghapus spasi di awal/akhir
      );

      if (mounted) {
        // Memastikan widget masih aktif di layar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil disimpan!'), // Pesan sukses
            backgroundColor: Colors.green, // Warna snackbar hijau
          ),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      }
    } catch (e) {
      // Menangkap error jika penyimpanan gagal
      if (mounted) {
        // Memastikan widget masih aktif
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'), // Pesan error
            backgroundColor: Colors.red, // Warna snackbar merah
          ),
        );
      }
    } finally {
      if (mounted)
        setState(
          () => _isLoading = false,
        ); // Mengubah loading menjadi false setelah selesai
    }
  }

  @override
  Widget build(BuildContext context) {
    // Method untuk membangun tampilan UI
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Narapidana', // Judul AppBar
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ), // Style teks judul
        ),
        backgroundColor: Colors.indigo, // Warna AppBar
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Warna icon kembali
        centerTitle: true, // Judul berada di tengah
      ),
      body: SingleChildScrollView(
        // Agar tampilan bisa discroll jika layar kecil
        padding: const EdgeInsets.all(20), // Padding seluruh isi body
        child: Form(
          key: _formKey, // Menghubungkan form dengan form key
          child: Column(
            children: [
              // Input Nama
              TextFormField(
                controller:
                    _namaController, // Menghubungkan input nama ke controller
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap', // Label input
                  prefixIcon: const Icon(Icons.person), // Icon di depan input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Border melengkung
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama wajib diisi'
                    : null, // Validasi nama tidak boleh kosong
              ),
              const SizedBox(height: 16), // Jarak antar widget
              // Dropdown Jenis Kelamin
              DropdownButtonFormField<String>(
                value: _jenisKelamin, // Nilai awal dropdown
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin', // Label dropdown
                  prefixIcon: const Icon(Icons.wc), // Icon di depan dropdown
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Border melengkung
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Laki-laki', // Nilai item pertama
                    child: Text('Laki-laki'), // Teks item pertama
                  ),
                  DropdownMenuItem(
                    value: 'Perempuan', // Nilai item kedua
                    child: Text('Perempuan'), // Teks item kedua
                  ),
                ],
                onChanged: (value) {
                  setState(
                    () => _jenisKelamin = value!,
                  ); // Mengubah nilai jenis kelamin saat dipilih
                },
              ),
              const SizedBox(height: 16), // Jarak antar widget
              // Input Umur
              TextFormField(
                controller:
                    _umurController, // Menghubungkan input umur ke controller
                keyboardType: TextInputType.number, // Keyboard hanya angka
                decoration: InputDecoration(
                  labelText: 'Umur', // Label input umur
                  prefixIcon: const Icon(Icons.cake), // Icon di depan input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Border melengkung
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Umur wajib diisi'; // Validasi umur tidak boleh kosong
                  if (int.tryParse(value) == null) {
                    return 'Masukkan angka valid'; // Validasi harus berupa angka
                  }
                  return null; // Jika valid, tidak ada pesan error
                },
              ),
              const SizedBox(height: 16), // Jarak antar widget
              // Input Kasus
              TextFormField(
                controller:
                    _kasusController, // Menghubungkan input kasus ke controller
                maxLines: 3, // Input bisa 3 baris
                decoration: InputDecoration(
                  labelText: 'Kasus', // Label input kasus
                  prefixIcon: const Icon(Icons.gavel), // Icon di depan input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Border melengkung
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Kasus wajib diisi'
                    : null, // Validasi kasus tidak boleh kosong
              ),
              const SizedBox(height: 24), // Jarak sebelum tombol
              // Tombol Simpan
              SizedBox(
                width: double.infinity, // Lebar tombol penuh
                height: 50, // Tinggi tombol
                child: ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : _simpanData, // Jika loading, tombol nonaktif
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo, // Warna tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Sudut tombol melengkung
                    ),
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20, // Lebar loading indicator
                          height: 20, // Tinggi loading indicator
                          child: CircularProgressIndicator(
                            color: Colors.white, // Warna loading indicator
                            strokeWidth: 2, // Ketebalan loading indicator
                          ),
                        )
                      : const Icon(
                          Icons.save,
                          color: Colors.white,
                        ), // Icon simpan jika tidak loading
                  label: Text(
                    _isLoading
                        ? 'Menyimpan...'
                        : 'Simpan Data', // Teks tombol sesuai kondisi
                    style: const TextStyle(
                      fontSize: 16, // Ukuran teks tombol
                      fontWeight: FontWeight.bold, // Teks tebal
                      color: Colors.white, // Warna teks tombol
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
