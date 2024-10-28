import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scholar_mate/features/authentications/presentation/pages/login_screen.dart';
// import 'package:scholar_mate/features/login/presentation/pages/signup.dart';
import 'package:scholar_mate/firebase_options.dart';
import 'package:scholar_mate/mainPage/navigation.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}
class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return  AuthCheck();
  }
}


// AuthCheck widget to determine if user is signed in
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // If user is signed in, go to ProfileScreen; else, go to LoginPage
    if (user != null) {
      return const Navigation();
    } else {
      return LoginPage();
    }
  }
}
