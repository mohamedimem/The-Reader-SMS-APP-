import 'package:proxyapp/auth/application/auth_notifier.dart';
import 'package:proxyapp/auth/infrastructure/credentials_storage/secure_credentials_storage.dart';
import 'package:proxyapp/auth/infrastructure/firebase_facade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return FlutterSecureStorage();
});

final secureProfileCredentialsProvider = Provider<AuthManager>((ref) {
  return AuthManager(ref.watch(flutterSecureStorageProvider));
});

final firebaseAuthFacadeProvider = Provider((ref) {
  return FirebaseAuthFacade(
    ref.watch(firebaseProvider),
    ref.watch(secureProfileCredentialsProvider),
  );
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(firebaseAuthFacadeProvider));
});
