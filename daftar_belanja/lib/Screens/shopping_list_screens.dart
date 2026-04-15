import 'package:daftar_belanja/services/shopping_service.dart'; // Import file service untuk mengatur data belanja
import 'package:flutter/material.dart'; // Import package Flutter Material Design

// Membuat halaman ShoppingListScreen
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState(); // Menghubungkan widget dengan state-nya
}

// Class state untuk ShoppingListScreen
class _ShoppingListScreenState extends State<ShoppingListScreen> {
  // Controller untuk mengambil dan mengatur isi TextField
  final TextEditingController _itemController = TextEditingController();

  // Membuat objek ShoppingService untuk akses tambah, hapus, dan ambil data
  final ShoppingService _shoppingService = ShoppingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar di bagian atas
      appBar: AppBar(
        title: const Text("Daftar Belanja"), // Judul halaman
      ),

      // Isi utama halaman
      body: Column(
        children: [
          // Memberi jarak di sekeliling form input
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                // Expanded agar TextField memenuhi sisa ruang
                Expanded(
                  child: TextField(
                    controller:
                        _itemController, // Menghubungkan TextField dengan controller
                    decoration: const InputDecoration(
                      hintText:
                          'Masukkan nama barang', // Teks petunjuk dalam input
                    ),
                  ),
                ),

                // Tombol tambah item
                IconButton(
                  icon: const Icon(Icons.add), // Icon tambah
                  onPressed: () {
                    // Menambahkan item belanja ke service
                    _shoppingService.addShoppingItem(_itemController.text);

                    // Mengosongkan TextField setelah data ditambahkan
                    _itemController.clear();
                  },
                ),
              ],
            ),
          ),

          // Expanded agar daftar belanja mengisi sisa ruang di bawah form
          Expanded(
            child: StreamBuilder<Map<String, String>>(
              // Mengambil data daftar belanja secara realtime dari service
              stream: _shoppingService.getShoppingList(),

              builder: (context, snapshot) {
                // Jika data berhasil didapat
                if (snapshot.hasData) {
                  final items = snapshot.data!; // Ambil data dari snapshot

                  return ListView.builder(
                    itemCount: items.length, // Jumlah item sesuai panjang data
                    itemBuilder: (context, index) {
                      // Mengambil key berdasarkan index
                      final key = items.keys.elementAt(index);

                      // Mengambil value/item berdasarkan key
                      final item = items[key];

                      return ListTile(
                        title: Text(item!), // Menampilkan nama barang
                        trailing: IconButton(
                          icon: const Icon(Icons.delete), // Tombol hapus
                          onPressed: () {
                            // Menghapus item berdasarkan key
                            _shoppingService.removeShoppingItem(key);
                          },
                        ),
                      );
                    },
                  );
                }
                // Jika terjadi error saat mengambil data
                else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                // Jika data masih loading
                else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
