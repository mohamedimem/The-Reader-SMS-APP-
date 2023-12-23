import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:proxyapp/auth/domain/email_adress.dart';
import 'package:proxyapp/auth/domain/password.dart';
import 'package:proxyapp/auth/infrastructure/firebase_facade.dart';

part 'auth_notifier.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();
  const factory AuthState.initial() = _Initial;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.failure() = _Failure;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuthFacade _firebaseAuthFacade;
  AuthNotifier(this._firebaseAuthFacade) : super(AuthState.initial());

  Future<void> checkAndUpdateAuthStatus() async {
    if (await _firebaseAuthFacade.isSignedIn()) {
      state = AuthState.authenticated();
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<AuthState> signInWithPin(String pin) async {
    final failureOrSuccess = await _firebaseAuthFacade.signInWithPin(pin);
    return state = failureOrSuccess.fold((l) {
      print("AuthState.failure()");
      return AuthState.failure();
    }, (r) {
      print("AuthState.authenticated()");
      return AuthState.authenticated();
    });
  }

  Future<AuthState> createUserWithEmailAndPassword(
      EmailAdress e, Password p, String pinVar) async {
    final failureOrSuccess = await _firebaseAuthFacade
        .registerWithEmailAndPassword(emailAdress: e, password: p, pin: pinVar);

    return state = failureOrSuccess.fold((l) {
      return AuthState.failure();
    }, (r) {
      print("register success");
      return AuthState.unauthenticated();
    });
  }

  Future<AuthState> signInWithEmailAndPassword(
      EmailAdress e, Password p) async {
    final failureOrSuccess = await _firebaseAuthFacade.signInEmailAndPassword(
        emailAdress: e, password: p);
    return state = failureOrSuccess.fold((l) {
      return AuthState.failure();
    }, (r) {
      return AuthState.authenticated();
    });
  }

  Future<void> signOut() async {
    final failureOrSuccess = await _firebaseAuthFacade.signOut();
    state = failureOrSuccess.fold((l) {
      return AuthState.failure();
    }, (r) {
      return AuthState.unauthenticated();
    });
    print('---------------state------------');
  }
}
