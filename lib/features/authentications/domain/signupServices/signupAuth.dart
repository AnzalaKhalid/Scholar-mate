import 'package:firebase_auth/firebase_auth.dart';

class LoginAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> sendVerificationEmail(User? user) async {
    await user?.sendEmailVerification();
  }

  bool validateEmail(String email) {
    final String domain = email.split('@').last;
    return domain == 'stud.uot.edu.pk';
  }
}
