import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_tracker/data/repositories/storage.dart';
import 'package:health_tracker/data/repositories/user_repository.dart';
import 'package:health_tracker/data/models/user_model.dart' as model;
import 'package:health_tracker/shared/constants/consts_variables.dart';

class FirebaseAuthRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches the current user's details from Firestore.
  @override
  Future<model.User> getUserDetails() async {
    try {
      final User currentUser = _firebaseAuth.currentUser!;
      final DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!documentSnapshot.exists) {
        throw 'User not found in Firestore.';
      }

      return model.User.fromSnap(documentSnapshot);
    } catch (e) {
      throw 'Failed to fetch user details: ${e.toString()}';
    }
  }

  /// Logs in a user with email and password.
  @override
  Future<void> login({required String email, required String password}) async {
    try {
      // Bypass condition for testing
      if (email == 'admin' && password == 'admin') {
        // Simulate a successful login without Firebase authentication
        print('Bypass login successful for admin.');
        return;
      }

      // Normal Firebase authentication
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email.';
        case 'wrong-password':
          throw 'Wrong password provided for that user.';
        default:
          throw 'Login failed: ${e.message}';
      }
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  /// Registers a new user with email, password, and additional details.
  @override
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required Sex sex,
    Uint8List? file,
  }) async {
    try {
      // Create user with email and password
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user's display name
      await userCredential.user!.updateDisplayName(username);

      // Upload profile picture (if provided)
      final String photoUrl = file != null
          ? await FireStorage().uploadImageToStorage('profilePics', file, false)
          : 'https://i.stack.imgur.com/l60Hf.png'; // Default profile picture

      // Create a user model
      final model.User user = model.User(
        username: username,
        uid: userCredential.user!.uid,
        sex: sex,
        photoUrl: photoUrl,
        email: email,
        bio: '',
        bookmarkedRecipes: [],
        followers: [],
        following: [],
        isDarkMode: true,
      );

      // Save user details to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toJson());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw 'The password provided is too weak.';
        case 'email-already-in-use':
          throw 'The account already exists for that email.';
        default:
          throw 'Registration failed: ${e.message}';
      }
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  /// Signs in a user using Google authentication.
  Future<void> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw 'Google sign-in was canceled.';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw 'Google sign-in failed: ${e.toString()}';
    }
  }

  /// Logs out the current user.
  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw 'Logout failed: ${e.toString()}';
    }
  }

  /// Signs in a user anonymously.
  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw 'Anonymous sign-in failed: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }
}