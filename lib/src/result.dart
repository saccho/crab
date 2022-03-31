import 'package:meta/meta.dart';

import 'option.dart';
import 'util/convert.dart';
import 'errors.dart';

/// `Result` is a type that represents either success ([Ok]) or failure
/// ([Err]).
@sealed
abstract class Result<T, E> {
  const Result();

  Ok<T, E> get _asOk => this as Ok<T, E>;

  Err<T, E> get _asErr => this as Err<T, E>;

  T get _okValue => _asOk._value;

  E get _errValue => _asErr._value;

  /// Returns `true` if the result is [Ok].
  bool get isOk => this is Ok;

  /// Returns `true` if the result is [Err].
  bool get isErr => !isOk;

  /// Converts from `Result<T, E>` to `T?`.
  ///
  /// Converts `this` into a nullable value, consuming `this`,
  /// and discarding the error, if any.
  T? ok() => isOk ? _okValue : null;

  /// Converts from `Result<T, E>` to `Option<T>`.
  ///
  /// Converts `this` into an [Option], consuming `this`,
  /// and discarding the error, if any.
  Option<T> okOpt() => isOk ? Some(_okValue) : None<T>();

  /// Converts from `Result<T, E>` to `E?`.
  ///
  /// Converts `this` into a nullable value, consuming `this`,
  /// and discarding the success value, if any.
  E? err() => isOk ? null : _errValue;

  /// Converts from `Result<T, E>` to `Option<E>`.
  ///
  /// Converts `this` into an [Option], consuming `this`,
  /// and discarding the success value, if any.
  Option<E> errOpt() => isOk ? None<E>() : Some(_errValue);

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
  U mapOr<U>(U defaultValue, U Function(T value) f) =>
      isOk ? f(_okValue) : defaultValue;

  /// Maps a `Result<T, E>` to `U` by applying fallback function `defaultF` to
  /// a contained [Err] value, or function `f` to a contained [Ok] value.
  ///
  /// This function can be used to unpack a successful result
  /// while handling an error.
  U mapOrElse<U>(U Function(E err) defaultF, U Function(T value) f) =>
      isOk ? f(_okValue) : defaultF(_errValue);

  /// Returns an iterable over the possibly contained value.
  ///
  /// The iterable yields one value if the result is [Ok], otherwise none.
  Iterable<T> iter() => isOk ? [_okValue] : const [];

  /// Returns the contained [Ok] value, consuming the `this` value.
  ///
  /// Throw an error if the value is an [Err], with an error message including
  /// the passed message, and the content of the [Err].
  T expect(String msg) =>
      isOk ? _okValue : throw UnwrapError(msg, obj: _errValue);

  /// Returns the contained [Ok] value, consuming the `this` value.
  ///
  /// Because this function may throw an error, its use is generally
  /// discouraged.
  /// Instead, prefer to handle the [Err] case explicitly,
  /// or call [unwrapOr] or [unwrapOrElse].
  T unwrap() => isOk
      ? _okValue
      : throw UnwrapError(
          'called `Result#unwrap` on an `Err` value',
          obj: _errValue,
        );

  /// Returns the contained [Err] value, consuming the `this` value.
  ///
  /// Throw an error if the value is an [Ok], with an error message including
  /// the passed message, and the content of the [Ok].
  E expectErr(String msg) =>
      isOk ? throw UnwrapError(msg, obj: _okValue) : _errValue;

  /// Returns the contained [Err] value, consuming the `this` value.
  ///
  /// Exceptions if the value is an [Ok], with a custom error message provided
  /// by the [Ok]'s value.
  E unwrapErr() => isOk
      ? throw UnwrapError(
          'called `Result#unwrapErr` on an `Ok` value',
          obj: _okValue,
        )
      : _errValue;

  /// Returns `res` if the result is [Ok], otherwise returns the [Err] value of
  /// `this`.
  Result<U, E> and<U>(Result<U, E> res) => isOk ? res : Err(_errValue);

  /// Calls `op` if the result is [Ok], otherwise returns the [Err] value of
  /// `this`.
  ///
  /// This function can be used for control flow based on `Result` values.
  Result<U, E> andThen<U>(Result<U, E> Function(T value) op) =>
      isOk ? op(_okValue) : Err(_errValue);

  /// Returns `res` if the result is [Err], otherwise returns the [Ok] value of
  /// `this`.
  ///
  /// Arguments passed to `or` are eagerly evaluated; if you are passing the
  /// result of a function call, it is recommended to use [orElse], which is
  /// lazily evaluated.
  Result<T, F> or<F>(Result<T, F> res) => isOk ? Ok(_okValue) : res;

  /// Calls `op` if the result is [Err], otherwise returns the [Ok] value of
  /// `this`.
  ///
  /// This function can be used for control flow based on result values.
  Result<T, F> orElse<F>(Result<T, F> Function(E err) op) =>
      isOk ? Ok(_okValue) : op(_errValue);

  /// Returns the contained [Ok] value or a provided default.
  ///
  /// Arguments passed to `unwrapOr` are eagerly evaluated; if you are passing
  /// the result of a function call, it is recommended to use
  /// [unwrapOrElse], which is lazily evaluated.
  T unwrapOr(T defaultValue) => isOk ? _okValue : defaultValue;

  /// Returns the contained [Ok] value or computes it from a closure.
  T unwrapOrElse(T Function(E err) op) => isOk ? _okValue : op(_errValue);
}

extension ResultFlattener<T, E> on Result<Result<T, E>, E> {
  /// Converts from `Result<Result<T, E>, E>` to `Result<T, E>`
  Result<T, E> flatten() => andThen(identity);
}

extension ResultTransposer<T, E> on Result<T?, E> {
  /// Transposes a `Result` with a nullable value into a nullable `Result`.
  ///
  /// `Ok(null)` will be mapped to `null`.
  /// `Ok(v)` and `Err(e)` (if `v` and `e` are not null) will be returned as is.
  Result<T, E>? transpose() {
    if (isOk) {
      final x = unwrap();
      return x != null ? Ok(x) : null;
    } else {
      return Err(unwrapErr());
    }
  }
}

extension ResultOptionTransposer<T, E> on Result<Option<T>, E> {
  /// Transposes a `Result` of an `Option` into an `Option` of a `Result`.
  ///
  /// `Ok(None)` will be mapped to `None`.
  /// `Ok(Some(_))` and `Err(_)` will be mapped to `Some(Ok(_))` and
  /// `Some(Err(_))`.
  Option<Result<T, E>> transposeOpt() {
    if (isOk) {
      return unwrap().map((value) => Ok(value));
    } else {
      return Some(Err(unwrapErr()));
    }
  }
}

/// `Ok` is a type that represents success and contains a `T` type success
/// value.
@sealed
class Ok<T, E> extends Result<T, E> {
  const Ok(this._value);

  final T _value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Ok<T, E> && other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Ok(${_value.toString()})';
}

/// `Err` is a type that represents failure and contains a `E` type error value.
@sealed
class Err<T, E> extends Result<T, E> {
  const Err(this._value);

  final E _value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Err<T, E> && other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Err(${_value.toString()})';
}
