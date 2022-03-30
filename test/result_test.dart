import 'package:crab/crab.dart';
import 'package:test/test.dart';

void main() {
  group('isOk', () {
    test('should return true when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.isOk, true);
    });

    test('should throw false when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.isOk, false);
    });
  });

  group('isErr', () {
    test('should return false when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.isErr, false);
    });

    test('should throw true when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.isErr, true);
    });
  });

  group('ok', () {
    test('should return value when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.ok(), 'ok');
    });

    test('should return null when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.ok(), null);
    });
  });

  group('err', () {
    test('should return null when `Err`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.err(), null);
    });

    test('should return value when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.err(), 'err');
    });
  });

  group('okOpt', () {
    test('should return `Some` when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.okOpt(), const Some('ok'));
    });

    test('should return `None  when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.okOpt(), const None<String>());
    });
  });

  group('errOpt', () {
    test('should return `None` when `Err`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.errOpt(), const None<String>());
    });

    test('should return `Some` when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.errOpt(), const Some('err'));
    });
  });

  group('map', () {
    test('should apply a function when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.map((value) => value.length), const Ok<int, String>(2));
    });

    test('should not apply a function when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.map((value) => value.length), const Err<int, String>('err'));
    });
  });

  group('mapErr', () {
    test('should not apply a function when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.mapErr((err) => err.length), const Ok<String, int>('ok'));
    });

    test('should apply a function when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.mapErr((err) => err.length), const Err<String, int>(3));
    });
  });

  group('mapOr', () {
    test('should apply a function when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.mapOr(1, (value) => value.length), 2);
    });

    test('should return default value when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.mapOr(1, (value) => value.length), 1);
    });
  });

  group('mapOrElse', () {
    test('should apply a function when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.mapOrElse((err) => err.length, (value) => value.length), 2);
    });

    test('should apply a default function when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.mapOrElse((err) => err.length, (value) => value.length), 3);
    });
  });

  group('iter', () {
    test('should return `Iterable` with value when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.iter(), ['ok']);
    });

    test('should return empty `Iterable` when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.iter(), const <String>[]);
    });
  });

  group('expect', () {
    test('should return value when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.expect('error message'), 'ok');
    });

    test('should throw error with passed message when `Err`', () {
      const Result<String, String> res = Err('err');
      late final String message;
      try {
        res.expect('error message');
        // ignore: avoid_catching_errors
      } on UnwrapError catch (e) {
        message = e.toString();
      }
      expect(message, 'error message: err');
    });
  });

  group('unwrap', () {
    test('should return value when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.unwrap(), 'ok');
    });

    test('should throw error when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.unwrap, throwsA(const TypeMatcher<UnwrapError>()));
    });
  });

  group('expectErr', () {
    test('should throw error with passed message when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      late final String message;
      try {
        res.expectErr('error message');
        // ignore: avoid_catching_errors
      } on UnwrapError catch (e) {
        message = e.toString();
      }
      expect(message, 'error message: ok');
    });

    test('should return value when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.expectErr('error message'), 'err');
    });
  });

  group('unwrapErr', () {
    test('should throw error when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.unwrapErr, throwsA(const TypeMatcher<UnwrapError>()));
    });

    test('should return value when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.unwrapErr(), 'err');
    });
  });

  group('and', () {
    test('should return passed `Ok` when `Ok`', () {
      const Result<int, String> res = Ok(2);
      const Result<String, String> res2 = Ok('ok');
      expect(res.and(res2), const Ok<String, String>('ok'));
    });

    test('should return passed `Err` when `Ok`', () {
      const Result<int, String> res = Ok(2);
      const Result<String, String> res2 = Err('err');
      expect(res.and(res2), const Err<String, String>('err'));
    });

    test('should return self `Err` when `Err` (passed `Ok`)', () {
      const Result<int, String> res = Err('err');
      const Result<String, String> res2 = Ok('ok');
      expect(res.and(res2), const Err<String, String>('err'));
    });

    test('should return self `Err` when `Err` (passed `Err`)', () {
      const Result<int, String> res = Err('err');
      const Result<String, String> res2 = Err('err2');
      expect(res.and(res2), const Err<String, String>('err'));
    });
  });

  group('andThen', () {
    test('should apply a function when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(
        res.andThen((value) => Ok(value.length)),
        const Ok<int, String>(2),
      );
    });

    test('should not apply a function when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(
        res.andThen((value) => Ok(value.length)),
        const Err<int, String>('err'),
      );
    });
  });

  group('or', () {
    test('should return self `Ok` when `Ok (passed `Ok`)`', () {
      const Result<int, String> res = Ok(2);
      const Result<int, String> res2 = Ok(100);
      expect(res.or(res2), const Ok<int, String>(2));
    });

    test('should return self `Err` when `Ok` (passed `Err`)', () {
      const Result<int, String> res = Ok(2);
      const Result<int, String> res2 = Err('err');
      expect(res.or(res2), const Ok<int, String>(2));
    });

    test('should return passed `Ok` when `Err`', () {
      const Result<int, String> res = Err('err');
      const Result<int, String> res2 = Ok(2);
      expect(res.or(res2), const Ok<int, String>(2));
    });

    test('should return passed `Err` when `Err`', () {
      const Result<int, String> res = Err('err');
      const Result<int, String> res2 = Err('err2');
      expect(res.or(res2), const Err<int, String>('err2'));
    });
  });

  group('orElse', () {
    test('should not apply a function when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(
        res.orElse((err) => Err(err.length)),
        const Ok<String, int>('ok'),
      );
    });

    test('should apply a function when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(
        res.orElse((err) => Err(err.length)),
        const Err<String, int>(3),
      );
    });
  });

  group('unwrapOr', () {
    test('should return value when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.unwrapOr('default'), 'ok');
    });

    test('should return default value when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.unwrapOr('default'), 'default');
    });
  });

  group('unwrapOrElse', () {
    test('should return value when `Ok`', () {
      const Result<String, String> res = Ok('ok');
      expect(res.unwrapOrElse((err) => err), 'ok');
    });

    test('should return error when `Err`', () {
      const Result<String, String> res = Err('err');
      expect(res.unwrapOrElse((err) => err), 'err');
    });
  });

  group('flatten', () {
    test('should return Ok<T, E> when received Ok<Ok<T, E>, E>', () {
      const Result<Result<String, String>, String> res = Ok(Ok('ok-ok'));
      expect(res.flatten(), const Ok<String, String>('ok-ok'));
    });

    test('should return Err<T, E> when received Ok<Err<T, E>, E>', () {
      const Result<Result<String, String>, String> res = Ok(Err('ok-err'));
      expect(res.flatten(), const Err<String, String>('ok-err'));
    });

    test('should return Err<T, E> when received Err<Result<T, E>, E>', () {
      const Result<Result<String, String>, String> res = Err('err');
      expect(res.flatten(), const Err<String, String>('err'));
    });
  });

  group('transpose', () {
    test('should return null when `Ok(null)`', () {
      const Result<String?, String> res = Ok(null);
      expect(res.transpose(), null);
    });

    test('should return `Ok(_)` when `Ok(_)`', () {
      const Result<String?, String> res = Ok('ok');
      expect(res.transpose(), const Ok<String, String>('ok'));
    });

    test('should return `Err(_)` when `Err(_)`', () {
      const Result<String?, String> res = Err('err');
      expect(res.transpose(), const Err<String, String>('err'));
    });
  });

  group('transposeOpt', () {
    test('should return None when `Ok(None)`', () {
      const Result<Option<String>, String> res = Ok(None());
      const Option<Result<String, String>> expected = None();
      expect(res.transposeOpt(), expected);
    });

    test('should return `Some(Ok(_))` when `Ok(Some(_))`', () {
      const Result<Option<String>, String> res = Ok(Some('ok-some'));
      const Option<Result<String, String>> expected = Some(Ok('ok-some'));
      expect(res.transposeOpt(), expected);
    });

    test('should return `Some(Err(_))` when `Err(_)`', () {
      const Result<Option<String>, String> res = Err('err');
      const Option<Result<String, String>> expected = Some(Err('err'));
      expect(res.transposeOpt(), expected);
    });
  });
}
