import 'package:meta/meta.dart';

import 'util/convert.dart';
import 'util/errors.dart';

/// `Option` is a type that represents either having a value ([Some]) or not
/// having a value ([None]).
@sealed
abstract class Option<T> {
  const Option();

  Some<T> get _asSome => this as Some<T>;

  T get _someValue => _asSome._value;

  /// Returns `true` if the option is [Some].
  bool get isSome => this is Some;

  /// Returns `true` if the option is [None].
  bool get isNone => !isSome;

  /// Returns the contained [Some] value, consuming the `this` value.
  ///
  /// Because this function may throw an error, its use is generally
  /// discouraged.
  /// Instead, prefer to handle the [None] case explicitly,
  /// or call [unwrapOr] or [unwrapOrElse].
  T unwrap() => isSome
      ? _someValue
      : throw UnwrapError('called `Option#unwrap` on an `None` value');

  /// Returns the contained [Some] value or a provided default.
  ///
  /// Arguments passed to `unwrapOr` are eagerly evaluated; if you are passing
  /// the option of a function call, it is recommended to use
  /// [unwrapOrElse], which is lazily evaluated.
  T unwrapOr(T defaultValue) => isSome ? _someValue : defaultValue;

  /// Returns the contained [Some] value or computes it from a closure.
  T unwrapOrElse(T Function() op) => isSome ? _someValue : op();

  /// Maps an `Option<T>` to `Option<U>` by applying a function to a contained
  /// value.
  Option<U> map<U>(U Function(T value) op) =>
      isSome ? Some(op(_someValue)) : None<U>();

  /// Returns the provided default (if [None]), or
  /// applies a function to the contained value (if [Some]),
  ///
  /// Arguments passed to `mapOr` are eagerly evaluated; if you are passing
  /// the option of a function call, it is recommended to use [mapOrElse],
  /// which is lazily evaluated.
  U mapOr<U>(U defaultValue, U Function(T value) f) =>
      isSome ? f(_someValue) : defaultValue;

  /// Computes a default function result (if [None]), or
  /// applies a different function to the contained value (if [Some]).
  U mapOrElse<U>(U Function() defaultF, U Function(T value) f) =>
      isSome ? f(_someValue) : defaultF();

  /// Maps an `Option<T>` to `Option<U>` by applying a function to a contained
  /// value.
  Option<U> flatMap<U>(Option<U> Function(T value) op) =>
      isSome ? op(_someValue) : None<U>();
}

extension OptionFlattener<T> on Option<Option<T>> {
  /// Converts from `Option<Option<T>>` to `Option<T>`
  Option<T> flatten() => flatMap(identity);
}

/// `Some` is a type that represents having a value and contains a `T` type
/// value.
@sealed
class Some<T> extends Option<T> {
  const Some(this._value);

  final T _value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Some<T> && other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Some(${_value.toString()})';
}

/// `None` is a type that represents not having a value.
@sealed
class None<T> extends Option<T> {
  const None();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is None<T>;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() => 'None';
}
