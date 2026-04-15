import 'package:flutter/material.dart'; // import library flutter
import '../service/firebase_services.dart'; // import file service untuk mengatur data narapidana
import 'tambah_screen.dart'; // import halaman tambah data narapidana

// Membuat class HomeScreen sebagai halaman utama
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Constructor HomeScreen

  @override
  Widget build(BuildContext context) {
    final FirebaseService service = FirebaseService();  // Membuat objek service untuk mengakses Firebase

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Narapidana', // Judul pada AppBar
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo, // Warna latar AppBar
        centerTitle: true, // Posisi judul di tengah
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: service.getNarapidana(), // Mengambil data narapidana secara realtime dari Firebase
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Menampilkan loading saat data belum selesai dimuat
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Menampilkan pesan error jika terjadi kesalahan
          }

          final Map<String, dynamic> data = snapshot.data ?? {}; // Menyimpan data dari snapshot, jika null maka jadi map kosong

          if (data.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data narapidana.\nTekan tombol + untuk menambahkan.', // Pesan jika data kosong
                textAlign: TextAlign.center, // Posisi teks di tengah
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12), // Jarak isi list dari tepi layar
            itemCount: data.length, // Jumlah item sesuai banyaknya data
            itemBuilder: (context, index) {
              final key = data.keys.elementAt(index);  // Mengambil key data berdasarkan index
              final item = data[key]; // Mengambil isi data berdasarkan key

              final String nama =item['nama'] ??''; // Mengambil nama, jika null maka string kosong
              final String jenisKelamin = item['jenisKelamin'] ?? ''; // Mengambil jenis kelamin
              final int umur =item['umur'] ?? 0; // Mengambil umur, jika null maka 0
              final String kasus = item['kasus'] ?? ''; // Mengambil kasus

              return Card(
                elevation: 3, // Memberi efek bayangan pada card
                margin: const EdgeInsets.symmetric( vertical: 6,), // Jarak antar card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12,), // Membuat sudut card melengkung
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: jenisKelamin == 'Laki-laki'
                        ? Colors.indigo // laki laki
                        : Colors.pink, // perempuan
                    child: Icon(
                      jenisKelamin == 'Laki-laki' ? Icons.male : Icons.female,
                      color: Colors.white, // warna ikon
                    ),
                  ),
                  title: Text(
                    nama, // menampilkan nama narapidana
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jenis Kelamin : $jenisKelamin'),
                      Text('Umur          : $umur tahun'),
                      Text('Kasus         : $kasus'),
                    ],
                  ),
                  isThreeLine: true, // menandakan subtitle terdiri dari beberapa baris
                  // Tombol hapus
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Data'), // judul dialog
                          content: Text('Yakin ingin menghapus data $nama?'), //Isi dialog konfirmasi
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context), // Menutup dialog jika batal
                              child: const Text('Batal'), // Tombol batal
                            ),
                            TextButton(
                              onPressed: () {
                                service.hapusNarapidana(key); // Menghapus data berdasarkan key
                                Navigator.pop(context); // Menutup dialog setelah hapus
                              },
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
