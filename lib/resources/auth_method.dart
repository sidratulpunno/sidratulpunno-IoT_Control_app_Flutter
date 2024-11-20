import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iot/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();

  User? get user => _auth.currentUser;

  // Google Sign-In method
  Future<bool> signInWithGoogle(BuildContext context) async {
    bool result = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      if (googleAuth == null) return false;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await _firestore.collection('users').doc(user.uid).set({
            'username': user.displayName,
            'uid': user.uid,
            'profilePhoto': user.photoURL,
          });
        }
        result = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context,  "Authentication error occurred.");
    }
    return result;
  }

  // Sign up with Email and Password
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    bool result = false;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification(); // Send OTP for verification
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'uid': user.uid,
          'profilePhoto': null,
        });
        result = true;
        showSnackBar(context, "Verification email sent! Please verify to continue.");
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context,  "Sign-up error occurred.");
    }
    return result;
  }

  // Sign in with Email and Password
  Future<bool> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    bool result = false;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null && userCredential.user!.emailVerified) {
        result = true;
      } else {
        showSnackBar(context, "Please verify your email before signing in.");
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "Username or password is wrong. Please give correct info");
    }
    return result;
  }

  // Sign-out method
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Sign-out failed: $e");
      showSnackBar(context, "Error signing out. Please try again.");
    }
  }
}
