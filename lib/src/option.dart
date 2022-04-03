import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

import 'errors.dart';
import 'result.dart';
import 'util/convert.dart';

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

  /// Converts from `Option<T>` to `T?`.
  ///
  /// Converts `this` into a nullable value, consuming `this`,
  /// and discarding the none, if any.
  T? some() => isSome ? _someValue : null;

  /// Returns the contained [Some] value, consuming the `this` value.
  ///
  /// Throw an error if the value is a [None] with a custom error message
  /// provided by `msg`.
  T expect(String msg) => isSome ? _someValue : throw UnwrapError(msg);

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

  /// Transforms the [Option] into a [Result], mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err)`.
  ///
  /// Arguments passed to `okOr` are eagerly evaluated; if you are passing the
  /// result of a function call, it is recommended to use [okOrElse], which is
  /// lazily evaluated.
  Result<T, E> okOr<E>(E err) => isSome ? Ok(_someValue) : Err(err);

  /// Transforms the [Option] into a [Result], mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err())`.
  Result<T, E> okOrElse<E>(E Function() err) =>
      isSome ? Ok(_someValue) : Err(err());

  /// Returns an iterable over the possibly contained value.
  Iterable<T> iter() => isSome ? [_someValue] : const [];

  /// Returns [None] if the option is [None], otherwise returns `optb`.
  Option<U> and<U>(Option<U> optb) => isSome ? optb : None<U>();

  /// Returns [None] if the option is [None], otherwise calls `f` with the
  /// wrapped value and returns the result.
  ///
  /// Some languages call this operation flatmap.
  Option<U> andThen<U>(Option<U> Function(T value) f) =>
      isSome ? f(_someValue) : None<U>();

  /// Returns [None] if the option is [None], otherwise calls `predicate`
  /// with the wrapped value and returns:
  ///
  /// - `Some(t)` if `predicate` returns `true` (where `t` is the wrapped
  ///   value), and
  /// - `None` if `predicate` returns `false`.
  ///
  /// This function works similar to [Iterable.where]. You can imagine
  /// the `Option<T>` being an iterator over one or zero elements. `filter()`
  /// lets you decide which elements to keep.
  Option<T> filter(bool Function(T value) predicate) =>
      isSome && predicate(_someValue) ? Some(_someValue) : None<T>();

  /// Returns the option if it contains a value, otherwise returns `optb`.
  ///
  /// Arguments passed to `or` are eagerly evaluated; if you are passing the
  /// result of a function call, it is recommended to use [orElse], which is
  /// lazily evaluated.
  Option<T> or(Option<T> optb) => isSome ? Some(_someValue) : optb;

  /// Returns the option if it contains a value, otherwise calls `f` and
  /// returns the result.
  Option<T> orElse(Option<T> Function() f) => isSome ? Some(_someValue) : f();

  /// Returns [Some] if exactly one of `this`, `optb` is [Some], otherwise
  /// returns [None].
  Option<T> xor(Option<T> optb) {
    if (isSome && optb.isNone) {
      return Some(_someValue);
    } else if (isNone && optb.isSome) {
      return Some(optb.unwrap());
    } else {
      return None<T>();
    }
  }

  /// Zips `this` with another `Option`.
  ///
  /// If `this` is `Some(t)` and `other` is `Some(o)`, this method returns
  /// `Some(Tuple2(t, o))`. Otherwise, `None` is returned.
  Option<Tuple2<T, U>> zip<U>(Option<U> other) => isSome && other.isSome
      ? Some(Tuple2(_someValue, other.unwrap()))
      : None<Tuple2<T, U>>();
}

extension OptionFlattener<T> on Option<Option<T>> {
  /// Converts from `Option<Option<T>>` to `Option<T>`
  Option<T> flatten() => andThen(identity);
}

extension OptionResultTransposer<T, E> on Option<Result<T, E>> {
  /// Transposes an `Option` of a [`Result`] into a [`Result`] of an `Option`.
  ///
  /// `None()` will be mapped to `Ok(None())`.
  /// `Some(Ok(_))` and `Some(Err(_))` will be mapped to `Ok(Some(_))` and
  /// `Err(_)`.
  Result<Option<T>, E> transposeRes() {
    if (isSome) {
      return unwrap().map((value) => Some(value));
    } else {
      return Ok(None<T>());
    }
  }
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
