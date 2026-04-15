import 'package:firebase_database/firebase_database.dart'; // Import package Firebase Realtime Database
import 'package:firebase_core/firebase_core.dart'; // Import package inti Firebase

// Membuat class ShoppingService
// Class ini berfungsi untuk mengatur semua proses yang berhubungan dengan data belanja di Firebase
class ShoppingService {
  // Membuat koneksi ke Firebase Realtime Database
  // FirebaseDatabase.instanceFor digunakan untuk mengambil database dari app Firebase yang aktif
  final DatabaseReference _database =
      FirebaseDatabase.instanceFor(
        app: Firebase.app(), // Mengambil Firebase app yang sudah diinisialisasi
        databaseURL:
            "https://sebelumuts-2be00-default-rtdb.firebaseio.com", // URL database Firebase
      ).ref().child(
        'shopping_list',
      ); // Mengarah ke child / tabel / node bernama shopping_list

  // Method untuk mengambil daftar belanja secara realtime
  // Return type-nya Stream<Map<String, String>>
  // Artinya method ini mengirim data terus-menerus saat ada perubahan di database
  Stream<Map<String, String>> getShoppingList() {
    return _database.onValue.map((event) {
      // Membuat map kosong untuk menampung hasil data
      final Map<String, String> items = {};

      // Mengambil snapshot data dari event Firebase
      DataSnapshot snapshot = event.snapshot;

      // Mengecek apakah snapshot memiliki nilai
      if (snapshot.value != null) {
        // Mengubah snapshot.value menjadi Map agar bisa dibaca per key dan value
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

        // Melakukan perulangan untuk setiap data di Firebase
        values.forEach((key, value) {
          // Memasukkan data ke map items
          // key = id unik Firebase
          // value['name'] = nama barang
          items[key] = value['name'] as String;
        });
      }

      // Mengembalikan map items
      return items;
    });
  }

  // Method untuk menambahkan item belanja baru ke Firebase
  void addShoppingItem(String itemName) {
    // push() digunakan untuk membuat key unik otomatis
    // set({'name': itemName}) digunakan untuk menyimpan data ke Firebase
    _database.push().set({'name': itemName});
  }

  // Method untuk menghapus item belanja berdasarkan key
  Future<void> removeShoppingItem(String key) async {
    // Mengarah ke child berdasarkan key lalu menghapus data tersebut
    await _database.child(key).remove();
  }
}
