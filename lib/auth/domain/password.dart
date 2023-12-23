// ignore_for_file: unnecessary_null_comparison

import 'package:dartz/dartz.dart';
import 'package:proxyapp/auth/domain/failure/failures.dart';
import 'package:proxyapp/auth/core/value_object.dart';
import 'package:proxyapp/auth/core/value_validator.dart';

class Password extends ValueObject<String> {
  final Either<ValueFailure<String>, String> value;
  factory Password(String input) {
    assert(input != null);
    return Password._(
      validatePassword(input),
    );
  }

  const Password._(this.value);
}
