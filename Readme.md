Urutan melakukannya clone
terus buat project nya di ctrl shift p

kalo belum install bisa npm install -g firebase-tools
terus jangan lupa firebase login dan jangan lupa logout

masuk ke dalam project dimana bagian ini aan adimna 
dart pub global activate flutterfire_cli
flutterfire configure
android web
flutter pub add firebase_core
flutter pub add firebase_database

tampilan bagian main dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

jangan lupa untuk bagian di firebase buat project dimana untuk dimna membuat firebase, terus cari halkaman database and storage, masuk ek bagian realtime database buat buat di situ