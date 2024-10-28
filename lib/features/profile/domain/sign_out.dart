import 'package:firebase_auth/firebase_auth.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

class Sign_out{
  Future<void> _signOut() async {
    await _auth.signOut();
  }
}
