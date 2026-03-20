import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Retorna null si el registro fue exitoso, o un mensaje de error.
  Future<String?> createUser(String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credentials.user?.sendEmailVerification();
      return null; // éxito
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseError(e.code);
    } catch (e) {
      return "Error inesperado: $e";
    }
  }

  /// Retorna null si el login fue exitoso, o un mensaje de error.
  Future<String?> login(String email, String password) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credentials.user?.emailVerified ?? false) {
        return null; // éxito
      } else {
        return "Debes verificar tu correo antes de iniciar sesión.";
      }
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseError(e.code);
    } catch (e) {
      return "Error inesperado: $e";
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return "Este correo ya está registrado.";
      case 'invalid-email':
        return "El correo no es válido.";
      case 'weak-password':
        return "La contraseña es demasiado débil.";
      case 'user-not-found':
        return "No existe una cuenta con ese correo.";
      case 'wrong-password':
        return "Contraseña incorrecta.";
      case 'too-many-requests':
        return "Demasiados intentos. Intenta más tarde.";
      default:
        return "Error de autenticación ($code).";
    }
  }
}