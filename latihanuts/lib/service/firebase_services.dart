import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://sebelumuts-2be00-default-rtdb.firebaseio.com",
  ).ref().child('narapidana');

  // Ambil data sebagai Stream<Map>
  Stream<Map<String, dynamic>> getNarapidana() {
    return _database.onValue.map((event) {
      final Map<String, dynamic> items = {};
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          items[key] = value;
        });
      }
      return items;
    });
  }

  // Tambah data
  void tambahNarapidana(
    String nama,
    String jenisKelamin,
    int umur,
    String kasus,
  ) {
    _database.push().set({
      'nama': nama,
      'jenisKelamin': jenisKelamin,
      'umur': umur,
      'kasus': kasus,
    });
  }

  // Hapus data
  Future<void> hapusNarapidana(String key) async {
    await _database.child(key).remove();
  }
}
