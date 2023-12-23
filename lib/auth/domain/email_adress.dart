import 'package:dartz/dartz.dart';
import 'package:proxyapp/auth/domain/failure/failures.dart';
import 'package:proxyapp/auth/core/value_object.dart';
import 'package:proxyapp/auth/core/value_validator.dart';

class EmailAdress extends ValueObject<String> {
  final Either<ValueFailure<String>, String> value;
  factory EmailAdress(String input) {
    // ignore: unnecessary_null_comparison
    input = input.trim();
    assert(input != null);
    return EmailAdress._(
      validateEmailAddress(input),
    );
  }

  const EmailAdress._(this.value);
}
