import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scholar_mate/features/authentications/presentation/pages/login_screen.dart';
import 'package:scholar_mate/features/authentications/presentation/pages/otp_page.dart';
import 'package:scholar_mate/firebase_options.dart';
import 'package:scholar_mate/mainPage/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MaterialApp(
    title: "Scholar Mate",
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
    return const AuthCheck();
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Check if the email is verified
      if (user.emailVerified) {
        return const Navigation(); // Navigate to main screen if verified
      } else {
        return OtpVerificationScreen(email: user.email!, fromLoginPage: true); // Navigate to verification if not verified
      }
    } else {
      return const LoginPage(); // Navigate to login page if no user is logged in
    }
  }
}
