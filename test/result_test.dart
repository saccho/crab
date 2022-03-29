import 'package:crab/src/result.dart';
import 'package:test/test.dart';

void main() {
  group('isOk', () {
    test('should return true when `Ok` value', () {
      final Result<String, String> res = Ok('ok');
      expect(res.isOk, true);
    });

    test('should throw false when `Err` value', () {
      final Result<String, String> res = Err('err');
      expect(res.isOk, false);
    });
  });

  group('isErr', () {
    test('should return false when `Ok` value', () {
      final Result<String, String> res = Ok('ok');
      expect(res.isErr, false);
    });

    test('should throw true when `Err` value', () {
      final Result<String, String> res = Err('err');
      expect(res.isErr, true);
    });
  });

  group('unwrap', () {
    test('should return value when `Ok` value', () {
      final Result<String, String> res = Ok('ok');
      expect(res.unwrap(), 'ok');
    });

    test('should throw error when `Err` value', () {
      final Result<String, String> res = Err('err');
      expect(res.unwrap, throwsA(const TypeMatcher<UnwrapError<String>>()));
    });
  });

  group('unwrapErr', () {
    test('should throw error when `Ok` value', () {
      final Result<String, String> res = Ok('ok');
      expect(res.unwrapErr, throwsA(const TypeMatcher<UnwrapError<String>>()));
    });

    test('should return value when `Err` value', () {
      final Result<String, String> res = Err('err');
      expect(res.unwrapErr(), 'err');
    });
  });

  group('unwrapOr', () {
    test('should return value when `Ok` value', () {
      final Result<String, String> res = Ok('ok');
      expect(res.unwrapOr('default'), 'ok');
    });

    test('should return default value when `Err` value', () {
      final Result<String, String> res = Err('err');
      expect(res.unwrapOr('default'), 'default');
    });
  });

  group('unwrapOrElse', () {
    test('should return value when `Ok` value', () {
      final Result<String, String> res = Ok('ok');
      expect(res.unwrapOrElse((err) => err), 'ok');
    });

    test('should return error when `Err` value', () {
      final Result<String, String> res = Err('err');
      expect(res.unwrapOrElse((err) => err), 'err');
    });
  });

  group('map', () {
    test('should apply a function when `Ok` value', () {
      final Result<String, String> res = Ok('ok');
      expect(res.map((value) => value.length), Ok<int, String>(2));
    });

    test('should not apply a function when `Err` value', () {
      final Result<String, String> res = Err('err');
      expect(res.map((value) => value.length), Err<int, String>('err'));
    });
  });

  group('mapErr', () {
    test('should not apply a function when `Ok` value', () {
      final Result<String, String> res = Ok('ok');
      expect(res.mapErr((err) => err.length), Ok<String, int>('ok'));
    });

    test('should apply a function when `Err` value', () {
      final Result<String, String> res = Err('err');
      expect(res.mapErr((err) => err.length), Err<String, int>(3));
    });
  });

  group('mapOr', () {
    test('should apply a function when `Ok` value', () {
      final Result<String, String> res = Ok('ok');
      expect(res.mapOr(1, (value) => value.length), 2);
    });

    test('should return default value when `Err` value', () {
      final Result<String, String> res = Err('err');
      expect(res.mapOr(1, (value) => value.length), 1);
    });
  });

  group('mapOrElse', () {
    test('should apply a function when `Ok` value', () {
      final Result<String, String> res = Ok('ok');
      expect(res.mapOrElse((err) => err.length, (value) => value.length), 2);
    });

    test('should apply a default function when `Err` value', () {
      final Result<String, String> res = Err('err');
      expect(res.mapOrElse((err) => err.length, (value) => value.length), 3);
    });
  });

  group('flatMap', () {
    test('should apply a function when `Ok` value', () {
      final Result<String, String> res = Ok('ok');
      expect(res.flatMap((value) => Ok(value.length)), Ok<int, String>(2));
    });

    test('should not apply a function when `Err` value', () {
      final Result<String, String> res = Err('err');
      expect(res.flatMap((value) => Ok(value.length)), Err<int, String>('err'));
    });
  });

  group('flatten', () {
    test('should return Ok<T, E> when received Ok<Ok<T, E>, E> value', () {
      final Result<Result<String, String>, String> res = Ok(Ok('ok-ok'));
      expect(res.flatten(), Ok<String, String>('ok-ok'));
    });

    test('should return Err<T, E> when received Ok<Err<T, E>, E> value', () {
      final Result<Result<String, String>, String> res = Ok(Err('ok-err'));
      expect(res.flatten(), Err<String, String>('ok-err'));
    });

    test('should return Err<T, E> when received Err<Result<T, E>, E> value',
        () {
      final Result<Result<String, String>, String> res = Err('err');
      expect(res.flatten(), Err<String, String>('err'));
    });
  });
}
