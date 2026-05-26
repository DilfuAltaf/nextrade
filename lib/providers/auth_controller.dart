import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nextrade/models/user_model.dart';
import 'package:nextrade/services/auth_service.dart';
import 'package:nextrade/app/routes/route_names.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final user = Rx<UserModel?>(null);
  final isLoading = false.obs;
  final isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        loadUserData(firebaseUser.uid);
      } else {
        user.value = null;
        isAuthenticated.value = false;
      }
    });
  }

  Future<void> loadUserData(String uid) async {
    try {
      final userData = await _authService.getUserData(uid);
      if (userData != null) {
        user.value = userData;
        isAuthenticated.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data pengguna');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      isLoading.value = true;
      final userData = await _authService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );
      if (userData != null) {
        user.value = userData;
        isAuthenticated.value = true;
        Get.offNamed(RouteNames.home);
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final userData = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      if (userData != null) {
        user.value = userData;
        isAuthenticated.value = true;
        Get.offNamed(RouteNames.home);
      } else {
        Get.snackbar('Login Gagal', 'Data pengguna tidak ditemukan. Silakan daftar terlebih dahulu.');
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      Get.snackbar('Login Gagal', 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final userData = await _authService.signInWithGoogle();
      if (userData != null) {
        user.value = userData;
        isAuthenticated.value = true;
        Get.offNamed(RouteNames.home);
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      Get.snackbar('Login Gagal', 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      await _authService.sendPasswordResetEmail(email);
      Get.snackbar('Terikirim', 'Link reset password telah dikirim ke email Anda');
      Get.back();
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

    Future<void> logout() async {
    await _authService.signOut();
    user.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed(RouteNames.login);
  }

  void _handleAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'Email tidak terdaftar';
        break;
      case 'wrong-password':
        message = 'Password salah';
        break;
      case 'email-already-in-use':
        message = 'Email sudah digunakan';
        break;
      case 'weak-password':
        message = 'Password terlalu lemah';
        break;
      case 'invalid-email':
        message = 'Format email tidak valid';
        break;
      case 'too-many-requests':
        message = 'Terlalu banyak percobaan. Coba lagi nanti';
        break;
      default:
        message = e.message ?? 'Terjadi kesalahan';
    }
    Get.snackbar('Gagal', message);
  }
}
