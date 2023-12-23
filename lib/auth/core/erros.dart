// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:proxyapp/auth/domain/failure/failures.dart';

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() => Error.safeToString(
      'UnexpectedValueError at an unrecoverable point. (valueFailure: $valueFailure)');
}
