import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nextrade/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '542044117550-264qu9k99kl92eairg486dupc19ear47.apps.googleusercontent.com',
  );

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userModel = UserModel(
      uid: result.user!.uid,
      email: email,
      fullName: fullName,
      createdAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(result.user!.uid).set(userModel.toMap());
    return userModel;
  }

  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _ensureUserDoc(result.user!.uid);
    await _firestore.collection('users').doc(result.user!.uid).set({
      'lastLoginAt': Timestamp.now(),
    }, SetOptions(merge: true));
    return await _getOrCreateUser(result.user!.uid);
  }

  Future<UserModel?> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null;
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    final user = result.user!;
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        fullName: user.displayName ?? 'User',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      return userModel;
    }
    await _firestore.collection('users').doc(user.uid).set({
      'lastLoginAt': Timestamp.now(),
    }, SetOptions(merge: true));
    return UserModel.fromMap(userDoc.data()!);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(_mapTimestamps(doc.data()!));
  }

  Future<void> updateUserData(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(
      user.toMap(),
      SetOptions(merge: true),
    );
  }

  Future<UserModel?> _getOrCreateUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(_mapTimestamps(doc.data()!));
    }
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    final newUser = UserModel(
      uid: uid,
      email: firebaseUser.email ?? '',
      fullName: firebaseUser.displayName ?? 'Trader',
      createdAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(uid).set(newUser.toMap());
    return newUser;
  }

  Future<void> _ensureUserDoc(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      final firebaseUser = _auth.currentUser;
      final newUser = UserModel(
        uid: uid,
        email: firebaseUser?.email ?? '',
        fullName: firebaseUser?.displayName ?? 'Trader',
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(uid).set(newUser.toMap());
    }
  }

  Map<String, dynamic> _mapTimestamps(Map<String, dynamic> data) {
    final mapped = <String, dynamic>{};
    data.forEach((key, value) {
      if (value is Timestamp) {
        mapped[key] = value.toDate();
      } else {
        mapped[key] = value;
      }
    });
    return mapped;
  }
}
