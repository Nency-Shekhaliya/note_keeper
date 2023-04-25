import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper/views/screens/home_page.dart';
import 'package:note_keeper/views/screens/login_page.dart';
import 'package:note_keeper/views/screens/signin_page.dart';
import 'package:note_keeper/views/screens/splash_screen.dart';
import 'package:note_keeper/views/screens/welcom_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Myapp(),
    theme: ThemeData(useMaterial3: true),
    routes: {
      // '/': (context) => Splash_screen(),
      'Signin_page': (context) => const Signin_page(),
      'login_page': (context) => const Login_page(),
      'Home_Page': (context) => const Home_Page(),
      'Welcome_page': (context) => const Welcome_page(),
    },
  ));
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return const Splash_screen();
  }
}
