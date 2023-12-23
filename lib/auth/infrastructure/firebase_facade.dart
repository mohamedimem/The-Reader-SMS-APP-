import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proxyapp/auth/domain/email_adress.dart';
import 'package:proxyapp/auth/infrastructure/credentials_storage/secure_credentials_storage.dart';
import 'package:proxyapp/auth/infrastructure/facade/i_auth_facade.dart';
import 'package:proxyapp/auth/domain/failure/auth_failure.dart';
import 'package:proxyapp/auth/domain/password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class FirebaseAuthFacade implements IAuthFacade {
  final FirebaseAuth _firebaseAuth;
  final AuthManager authManager;

  FirebaseAuthFacade(this._firebaseAuth, this.authManager);
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> findDocumentIdByEmail(String email) async {
    String docId = "";
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    querySnapshot.docs.forEach((doc) {
      // Access the document ID
      docId = doc.id;
      // Access other fields if needed: doc.data()
    });
    return docId;
  }

  Future<String> findDocumentIdByPin(String pin) async {
    String docId = "";
    QuerySnapshot querySnapshot =
        await _firestore.collection('users').where('pin', isEqualTo: pin).get();

    querySnapshot.docs.forEach((doc) {
      // Access the document ID
      print('###########Find pin doc id ###################');

      docId = doc.id;
      print(docId);
      print('###########Find pin doc id ###################');
      // Access other fields if needed: doc.data()
    });
    return docId;
  }

  Future<void> saveUid(String uid) async {
    await secureStorage.write(key: 'uid', value: uid);
    String? value = await secureStorage.read(key: 'uid');
    print("print value saved+ $value");
  }

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword(
      {required EmailAdress emailAdress,
      required Password password,
      required String pin}) async {
    final emailToString = emailAdress.getOrCrash();
    final passwordToString = password.getOrCrash();
    try {
      var firebaseVar = await _firebaseAuth;
      await firebaseVar.createUserWithEmailAndPassword(
          email: emailToString, password: passwordToString);
      await addUser(pin, emailToString);

      return right(unit);
    } on PlatformException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left(AuthFailure.emailAlreadyInUse());
      } else if (e.code == 'invalid-email') {
        return left(AuthFailure.invalidEmailAndPasswordCombination());
      } else if (e.code == 'weak-password') {
        return left(AuthFailure.weekPassword());
      } else {
        return left(AuthFailure.serverError());
      }
    }
  }

  Future<Either<AuthFailure, Unit>> signInWithPin(String pin) async {
    Future<bool> doesPinExist(String pin) async {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('pin', isEqualTo: pin)
              .get();

      return querySnapshot.docs.isNotEmpty;
    }

    bool pinExists = await doesPinExist(pin);
    if (pinExists) {
      authManager.signIn();
      var x = await findDocumentIdByPin(pin);
      await saveUid(x);

      return right(unit);
    } else {
      return left(AuthFailure.serverError());
    }
  }

  Future addUser(String pin, String email) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .add({'email': email, 'pin': pin});
    } catch (e) {
      print('some error occured');
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInEmailAndPassword(
      {required EmailAdress emailAdress, required Password password}) async {
    final emailToString = emailAdress.getOrCrash();
    final passwordToString = password.getOrCrash();
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: emailToString, password: passwordToString);
      authManager.signIn();

      await saveUid(await findDocumentIdByEmail(emailToString));

      return right(unit);
    } on PlatformException catch (e) {
      if (e.code == 'invalid-email' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        return left(AuthFailure.invalidEmailAndPasswordCombination());
      } else {
        return left(AuthFailure.serverError());
      }
    }
  }

  Future<bool> isSignedIn() => authManager.isSignedIn();

  Future<Either<AuthFailure, Unit>> signOut() async {
    await authManager.signOut();
    return right(unit);
  }
}
