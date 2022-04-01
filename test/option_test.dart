// ignore_for_file: lines_longer_than_80_chars

import 'package:crab/src/errors.dart';
import 'package:crab/src/option.dart';
import 'package:crab/src/result.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('isSome', () {
    test('should return true when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.isSome, true);
    });

    test('should throw false when `None`', () {
      const Option<String> opt = None();
      expect(opt.isSome, false);
    });
  });

  group('isNone', () {
    test('should return false when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.isNone, false);
    });

    test('should throw true when `None`', () {
      const Option<String> opt = None();
      expect(opt.isNone, true);
    });
  });

  group('some', () {
    test('should return value when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.some(), 'some');
    });

    test('should return null when `None`', () {
      const Option<String> opt = None();
      expect(opt.some(), null);
    });
  });

  group('expect', () {
    test('should return value when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.expect('error message'), 'some');
    });

    test('should throw error with passed message when `None`', () {
      const Option<String> opt = None();
      late final String message;
      try {
        opt.expect('error message');
        // ignore: avoid_catching_errors
      } on UnwrapError catch (e) {
        message = e.toString();
      }
      expect(message, 'error message');
    });
  });

  group('unwrap', () {
    test('should return value when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.unwrap(), 'some');
    });

    test('should throw error when `None`', () {
      const Option<String> opt = None();
      expect(opt.unwrap, throwsA(const TypeMatcher<UnwrapError>()));
    });
  });

  group('unwrapOr', () {
    test('should return value when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.unwrapOr('default'), 'some');
    });

    test('should return default value when `None`', () {
      const Option<String> opt = None();
      expect(opt.unwrapOr('default'), 'default');
    });
  });

  group('unwrapOrElse', () {
    test('should return value when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.unwrapOrElse(() => 'none'), 'some');
    });

    test('should return error when `None`', () {
      const Option<String> opt = None();
      expect(opt.unwrapOrElse(() => 'none'), 'none');
    });
  });

  group('map', () {
    test('should apply a function when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.map((value) => value.length), const Some<int>(4));
    });

    test('should not apply a function when `None`', () {
      const Option<String> opt = None();
      expect(opt.map((value) => value.length), const None<int>());
    });
  });

  group('mapOr', () {
    test('should apply a function when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.mapOr(1, (value) => value.length), 4);
    });

    test('should return default value when `None`', () {
      const Option<String> opt = None();
      expect(opt.mapOr(1, (value) => value.length), 1);
    });
  });

  group('mapOrElse', () {
    const k = 21;
    test('should apply a function when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.mapOrElse(() => 2 * k, (value) => value.length), 4);
    });

    test('should apply a default function when `None`', () {
      const Option<String> opt = None();
      expect(opt.mapOrElse(() => 2 * k, (value) => value.length), 42);
    });
  });

  group('okOr', () {
    test('should return `Ok(v)` when `Some(v)`', () {
      const Option<String> opt = Some('some');
      expect(opt.okOr(0), const Ok<String, int>('some'));
    });

    test('should return `Err` with passed value when `None`', () {
      const Option<String> opt = None();
      expect(opt.okOr(0), const Err<String, int>(0));
    });
  });

  group('okOrElse', () {
    test('should return `Ok(v)` when `Some(v)`', () {
      const Option<String> opt = Some('some');
      expect(opt.okOrElse(() => 0), const Ok<String, int>('some'));
    });

    test(
        'should return `Err` with value created from the passed function when `None`',
        () {
      const Option<String> opt = None();
      expect(opt.okOrElse(() => 0), const Err<String, int>(0));
    });
  });

  group('iter', () {
    test('should return `Iterable` with value when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.iter(), const ['some']);
    });

    test('should return empty `Iterable` when `None`', () {
      const Option<String> opt = None();
      expect(opt.iter(), const <String>[]);
    });
  });

  group('and', () {
    test('should return passed `Some` when `Some`', () {
      const Option<String> opt = Some('some');
      const Option<int> opt2 = Some(0);
      expect(opt.and(opt2), const Some(0));
    });

    test('should return passed `None` when `Some`', () {
      const Option<String> opt = Some('some');
      const Option<int> opt2 = None();
      expect(opt.and(opt2), const None<int>());
    });

    test('should return `None` when `None` (passed `Some`)', () {
      const Option<String> opt = None();
      const Option<int> opt2 = Some(0);
      expect(opt.and(opt2), const None<int>());
    });

    test('should return `None` when `None` (passed `None`)', () {
      const Option<String> opt = None();
      const Option<int> opt2 = None();
      expect(opt.and(opt2), const None<int>());
    });
  });

  group('andThen', () {
    test('should apply a function when `Some`', () {
      const Option<String> opt = Some('some');
      expect(
        opt.andThen((value) => Some(value.length)),
        const Some<int>(4),
      );
    });

    test('should not apply a function when `None`', () {
      const Option<String> opt = None();
      expect(
        opt.andThen((value) => Some(value.length)),
        const None<int>(),
      );
    });
  });

  group('filter', () {
    test('should return `Some` when `Some` and `predicate` returns `true`', () {
      const Option<String> opt = Some('some');
      bool predicate(String s) => s.contains('s');
      expect(opt.filter(predicate), const Some('some'));
    });

    test('should return `None` when `Some` and `predicate` returns `false`',
        () {
      const Option<String> opt = Some('some');
      bool predicate(String s) => s.contains('ss');
      expect(opt.filter(predicate), const None<String>());
    });

    test('should return `None` when `None`', () {
      const Option<String> opt = None();
      bool predicate(String s) => s.contains('s');
      expect(opt.filter(predicate), const None<String>());
    });
  });

  group('or', () {
    test('should return `Some` with self value when `Some` (passed `Some`)',
        () {
      const Option<String> opt = Some('some');
      const Option<String> opt2 = Some('some2');
      expect(opt.or(opt2), const Some('some'));
    });

    test('should return `Some` with self value when `Some` (passed `None`)',
        () {
      const Option<String> opt = Some('some');
      const Option<String> opt2 = None();
      expect(opt.or(opt2), const Some('some'));
    });

    test('should return passed `Some` when `None`', () {
      const Option<String> opt = None();
      const Option<String> opt2 = Some('some');
      expect(opt.or(opt2), const Some('some'));
    });

    test('should return passed `None` when `None`', () {
      const Option<String> opt = None();
      const Option<String> opt2 = None();
      expect(opt.or(opt2), const None<String>());
    });
  });

  group('orElse', () {
    test('should return `Some` with self value when `Some`', () {
      const Option<String> opt = Some('some');
      expect(opt.orElse(() => const Some('some2')), const Some('some'));
    });

    test('should return `Option` created from the passed function when `None`',
        () {
      const Option<String> opt = None();
      expect(opt.orElse(() => const Some('some')), const Some('some'));
    });
  });

  group('xor', () {
    test('should return `None` when `Some` (passed `Some`)', () {
      const Option<String> opt = Some('some');
      const Option<String> opt2 = Some('some2');
      expect(opt.xor(opt2), const None<String>());
    });

    test('should return `Some` with self value when `Some` (passed `None`)',
        () {
      const Option<String> opt = Some('some');
      const Option<String> opt2 = None();
      expect(opt.xor(opt2), const Some('some'));
    });

    test('should return passed `Some` when `None`', () {
      const Option<String> opt = None();
      const Option<String> opt2 = Some('some');
      expect(opt.xor(opt2), const Some('some'));
    });

    test('should return `None` when `None`', () {
      const Option<String> opt = None();
      const Option<String> opt2 = None();
      expect(opt.xor(opt2), const None<String>());
    });
  });

  group('zip', () {
    test(
        'should return tuple with the values self `Some` and passed `Some` value when `Some` (passed `Some`)',
        () {
      const Option<String> opt = Some('some');
      const Option<String> opt2 = Some('some2');
      expect(opt.zip(opt2), const Some(Tuple2('some', 'some2')));
    });

    test('should return `None` when `Some` (passed `None`)', () {
      const Option<String> opt = Some('some');
      const Option<String> opt2 = None();
      expect(opt.zip(opt2), const None<Tuple2<String, String>>());
    });

    test('should return `None` when `None` (passed `Some`)', () {
      const Option<String> opt = None();
      const Option<String> opt2 = Some('some');
      expect(opt.zip(opt2), const None<Tuple2<String, String>>());
    });

    test('should return `None` when `None` (passed `None`)', () {
      const Option<String> opt = None();
      const Option<String> opt2 = None();
      expect(opt.zip(opt2), const None<Tuple2<String, String>>());
    });
  });

  group('flatten', () {
    test('should return Some<T> when received Some<Some<T>>', () {
      const Option<Option<String>> opt = Some(Some('some-some'));
      expect(opt.flatten(), const Some<String>('some-some'));
    });

    test('should return None<T> when received Some<None<T>>', () {
      const Option<Option<String>> opt = Some(None());
      expect(opt.flatten(), const None<String>());
    });

    test('should return None<T> when received None<Option<T>>', () {
      const Option<Option<String>> opt = None();
      expect(opt.flatten(), const None<String>());
    });
  });

  group('transposeRes', () {
    test('should return `Ok(None)` when `None`', () {
      const Option<Result<String, String>> opt = None();
      const Result<Option<String>, String> expected = Ok(None());
      expect(opt.transposeRes(), expected);
    });

    test('should return `Ok(Some(v))` when `Some(Ok(v))`', () {
      const Option<Result<String, String>> opt = Some(Ok('some-ok'));
      const Result<Option<String>, String> expected = Ok(Some('some-ok'));
      expect(opt.transposeRes(), expected);
    });

    test('should return `Err(v)` when `Some(Err(v))`', () {
      const Option<Result<String, String>> opt = Some(Err('some-err'));
      const Result<Option<String>, String> expected = Err('some-err');
      expect(opt.transposeRes(), expected);
    });
  });
}
