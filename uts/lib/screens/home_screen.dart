import 'package:flutter/material.dart';
import '../service/firebase_services.dart';
import 'tambah_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService service = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Narapidana',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: service.getNarapidana(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final Map<String, dynamic> data = snapshot.data ?? {};

          if (data.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data narapidana.\nTekan tombol + untuk menambahkan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final key = data.keys.elementAt(index);
              final Map item = data[key] ?? {};

              final String nama = item['nama'] ?? '';
              final String jenisKelamin = item['jenisKelamin'] ?? '';
              final int umur = item['umur'] ?? 0;
              final String kasus = item['kasus'] ?? '';

              return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      jenisKelamin == 'Laki-laki' ? Icons.male : Icons.female,
                      color: jenisKelamin == 'Laki-laki'
                          ? Colors.indigo
                          : Colors.pink,
                    ),
                    title: Text(
                      nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jenis Kelamin : $jenisKelamin'),
                        Text('Umur : $umur tahun'),
                        Text('Kasus : $kasus'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Hapus Data'),
                            content: Text('Yakin ingin menghapus data $nama?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  service.hapusNarapidana(key);
                                  Navigator.pop(context);
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
                  const Divider(),
                ],
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
