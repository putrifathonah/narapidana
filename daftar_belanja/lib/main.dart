import 'package:daftar_belanja/firebase_options.dart'; // Import file konfigurasi Firebase
import 'package:flutter/material.dart'; // Import package Flutter Material Design
import 'package:firebase_core/firebase_core.dart'; // Import package inti Firebase
import 'screens/shopping_list_screens.dart'; // Import halaman daftar belanja

// Fungsi utama yang pertama kali dijalankan saat aplikasi dibuka
void main() async {
  // Memastikan Flutter sudah siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();

  // Menginisialisasi Firebase agar bisa digunakan di aplikasi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Konfigurasi Firebase sesuai platform
  );

  // Menjalankan aplikasi dengan widget utama MyApp
  runApp(const MyApp());
}

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Belanja', // Judul aplikasi
      home: const ShoppingListScreen(), // Halaman pertama yang dibuka
    );
  }
}

// Widget ini adalah contoh bawaan Flutter
// Sebenarnya pada aplikasi ini tidak dipakai karena home sudah diarahkan ke ShoppingListScreen
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title; // Variabel untuk menyimpan judul halaman

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State untuk MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // Variabel untuk menyimpan nilai counter

  // Fungsi untuk menambah nilai counter
  void _incrementCounter() {
    setState(() {
      _counter++; // Menambah counter 1
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bagian AppBar
      appBar: AppBar(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.inversePrimary, // Warna AppBar dari tema
        title: Text(widget.title), // Menampilkan judul dari widget
      ),

      // Isi halaman
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Posisi isi di tengah secara vertikal
          children: [
            const Text(
              'You have pushed the button this many times:',
            ), // Teks penjelasan
            Text(
              '$_counter', // Menampilkan nilai counter
              style: Theme.of(context).textTheme.headlineMedium, // Style teks
            ),
          ],
        ),
      ),

      // Tombol tambah di kanan bawah
      floatingActionButton: FloatingActionButton(
        onPressed:
            _incrementCounter, // Saat ditekan akan memanggil fungsi tambah counter
        tooltip: 'Increment', // Tooltip tombol
        child: const Icon(Icons.add), // Icon tombol
      ),
    );
  }
}
