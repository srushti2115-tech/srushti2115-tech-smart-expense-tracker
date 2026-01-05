import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // =========================
  // 🔐 EMAIL LOGIN
  // =========================
  Future<User?> login(String email, String password) async {
    final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // =========================
  // 🆕 EMAIL SIGNUP
  // =========================
  Future<User?> signup(String email, String password) async {
    final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // =========================
  // 🔁 FORGOT PASSWORD
  // =========================
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw Exception("Please enter your email");
    }
    await _auth.sendPasswordResetEmail(email: email);
  }

  // =========================
  // 🔵 GOOGLE SIGN-IN
  // =========================
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await _googleSignIn.signIn();

    if (googleUser == null) return null; // user cancelled

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential =
        GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    return userCredential.user;
  }

  // =========================
  // 🚪 LOGOUT
  // =========================
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
  

}
