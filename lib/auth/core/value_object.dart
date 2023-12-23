// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_null_comparison
import 'package:dartz/dartz.dart';
import 'package:proxyapp/auth/core/erros.dart';
import 'package:proxyapp/auth/domain/failure/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

//id is identical thing like r=> r
  T getOrCrash() {
    return value.fold((l) => throw UnexpectedValueError(l), id);
  }

  @override
  bool operator ==(covariant ValueObject<T> other) {
    if (identical(this, other)) return true;
    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '(value: $value)';
}
