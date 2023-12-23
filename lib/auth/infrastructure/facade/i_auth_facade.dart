import 'package:dartz/dartz.dart';
import 'package:proxyapp/auth/domain/email_adress.dart';
import 'package:proxyapp/auth/domain/failure/auth_failure.dart';
import 'package:proxyapp/auth/domain/password.dart';

abstract class IAuthFacade {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAdress emailAdress,
    required Password password,
    required String pin,
  });
  Future<Either<AuthFailure, Unit>> signInEmailAndPassword({
    required EmailAdress emailAdress,
    required Password password,
  });
}
