import 'package:meta/meta.dart';

/// Error thrown by the runtime system when [Result.unwrap] or
/// [Result.unwrapErr] fails.
class UnwrapError<T> extends Error {
  UnwrapError(this.message, this.obj);

  final String message;
  final T obj;

  @override
  String toString() => '$message: $obj';
}

/// `Result` is a type that represents either success ([Ok]) or failure
///  ([Err]).
@sealed
abstract class Result<T, E> {
  Ok<T, E> get _asOk => this as Ok<T, E>;

  Err<T, E> get _asErr => this as Err<T, E>;

  T get _okValue => _asOk.value;

  E get _errValue => _asErr.err;

  /// Returns `true` if the result is [Ok].
  bool get isOk => this is Ok;

  /// Returns `true` if the result is [Err].
  bool get isErr => !isOk;

  /// Returns the contained [Ok] value, consuming the `this` value.
  ///
  /// Because this function may throw error, its use is generally discouraged.
  /// Instead, prefer to handle the [Err] case explicitly,
  /// or call [unwrapOr] or [unwrapOrElse].
  T unwrap() => isOk
      ? _okValue
      : throw UnwrapError(
          'called `Result#unwrap` on an `Err` value',
          _errValue,
        );

  /// Returns the contained [Err] value, consuming the `this` value.
  ///
  /// Exceptions if the value is an [Ok], with a custom error message provided
  /// by the [Ok]'s value.
  E unwrapErr() => isOk
      ? throw UnwrapError(
          'called `Result#unwrapErr` on an `Ok` value',
          _okValue,
        )
      : _errValue;

  /// Returns the contained [Ok] value or a provided default.
  ///
  /// Arguments passed to `unwrapOr` are eagerly evaluated; if you are passing
  /// the result of a function call, it is recommended to use
  /// [unwrapOrElse], which is lazily evaluated.
  T unwrapOr(T defaultValue) => isOk ? _okValue : defaultValue;

  /// Returns the contained [Ok] value or computes it from a closure.
  T unwrapOrElse(T Function(E err) op) => isOk ? _okValue : op(_errValue);

  /// Maps a `Result<T, E>` to `Result<U, E>` by applying a function to a
  /// contained [Ok] value, leaving an [Err] value untouched.
  ///
  /// This function can be used to compose the results of two functions.
  Result<U, E> map<U>(U Function(T value) op) =>
      isOk ? Ok(op(_okValue)) : Err(_errValue);

  /// Maps a `Result<T, E>` to `Result<T, F>` by applying a function to a
  /// contained [Err] value, leaving an [Ok] value untouched.
  ///
  /// This function can be used to pass through a successful result while
  /// handling an error.
  Result<T, F> mapErr<F>(F Function(E err) op) =>
      isOk ? Ok(_okValue) : Err(op(_errValue));

  /// Returns the provided default (if [Err]), or
  /// applies a function to the contained value (if [Ok]),
  ///
  /// Arguments passed to `mapOr` are eagerly evaluated; if you are passing
  /// the result of a function call, it is recommended to use [mapOrElse],
  /// which is lazily evaluated.
  U mapOr<U>(U defaultValue, U Function(T value) op) =>
      isOk ? op(_okValue) : defaultValue;

  /// Maps a `Result<T, E>` to `U` by applying fallback function `default` to
  /// a contained [Err] value, or function `f` to a contained [Ok] value.
  ///
  /// This function can be used to unpack a successful result
  /// while handling an error.
  U mapOrElse<U>(U Function(E err) defaultOp, U Function(T value) op) =>
      isOk ? op(_okValue) : defaultOp(_errValue);

  /// Maps a `Result<T, E>` to `Result<U, E>` by applying a function to a
  /// contained [Ok] value, leaving an [Err] value untouched.
  Result<U, E> flatMap<U>(Result<U, E> Function(T value) op) =>
      isOk ? op(_okValue) : Err(_errValue);
}

extension Flatten<T, E> on Result<Result<T, E>, E> {
  /// Converts from `Result<Result<T, E>, E>` to `Result<T, E>`
  Result<T, E> flatten() => flatMap(_identity);
}

/// `Ok` is a type that represents success and contains a `T` type success
/// value.
@sealed
class Ok<T, E> extends Result<T, E> {
  Ok(this.value);

  final T value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Ok<T, E> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// `Err` is a type that represents failure and contains a `E` type error value.
@sealed
class Err<T, E> extends Result<T, E> {
  Err(this.err);

  final E err;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Err<T, E> && other.err == err;
  }

  @override
  int get hashCode => err.hashCode;
}

T _identity<T>(T x) => x;
