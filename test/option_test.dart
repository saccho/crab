import 'package:crab/src/option.dart';
import 'package:crab/src/util/errors.dart';
import 'package:test/test.dart';

void main() {
  group('isSome', () {
    test('should return true when `Some` value', () {
      const Option<String> opt = Some('some');
      expect(opt.isSome, true);
    });

    test('should throw false when `None` value', () {
      const Option<String> opt = None();
      expect(opt.isSome, false);
    });
  });

  group('isNone', () {
    test('should return false when `Some` value', () {
      const Option<String> opt = Some('some');
      expect(opt.isNone, false);
    });

    test('should throw true when `None` value', () {
      const Option<String> opt = None();
      expect(opt.isNone, true);
    });
  });

  group('unwrap', () {
    test('should return value when `Some` value', () {
      const Option<String> opt = Some('some');
      expect(opt.unwrap(), 'some');
    });

    test('should throw error when `None` value', () {
      const Option<String> opt = None();
      expect(opt.unwrap, throwsA(const TypeMatcher<UnwrapError<void>>()));
    });
  });

  group('unwrapOr', () {
    test('should return value when `Some` value', () {
      const Option<String> opt = Some('some');
      expect(opt.unwrapOr('default'), 'some');
    });

    test('should return default value when `None` value', () {
      const Option<String> opt = None();
      expect(opt.unwrapOr('default'), 'default');
    });
  });

  group('unwrapOrElse', () {
    test('should return value when `Some` value', () {
      const Option<String> opt = Some('some');
      expect(opt.unwrapOrElse(() => 'none'), 'some');
    });

    test('should return error when `None` value', () {
      const Option<String> opt = None();
      expect(opt.unwrapOrElse(() => 'none'), 'none');
    });
  });

  group('map', () {
    test('should apply a function when `Some` value', () {
      const Option<String> opt = Some('some');
      expect(opt.map((value) => value.length), const Some<int>(4));
    });

    test('should not apply a function when `None` value', () {
      const Option<String> opt = None();
      expect(opt.map((value) => value.length), const None<int>());
    });
  });

  group('mapOr', () {
    test('should apply a function when `Some` value', () {
      const Option<String> opt = Some('some');
      expect(opt.mapOr(1, (value) => value.length), 4);
    });

    test('should return default value when `None` value', () {
      const Option<String> opt = None();
      expect(opt.mapOr(1, (value) => value.length), 1);
    });
  });

  group('mapOrElse', () {
    const k = 21;
    test('should apply a function when `Some` value', () {
      const Option<String> opt = Some('some');
      expect(opt.mapOrElse(() => 2 * k, (value) => value.length), 4);
    });

    test('should apply a default function when `None` value', () {
      const Option<String> opt = None();
      expect(opt.mapOrElse(() => 2 * k, (value) => value.length), 42);
    });
  });

  group('flatMap', () {
    test('should apply a function when `Some` value', () {
      const Option<String> opt = Some('some');
      expect(
        opt.flatMap((value) => Some(value.length)),
        const Some<int>(4),
      );
    });

    test('should not apply a function when `None` value', () {
      const Option<String> opt = None();
      expect(
        opt.flatMap((value) => Some(value.length)),
        const None<int>(),
      );
    });
  });

  group('flatten', () {
    test('should return Some<T> when received Some<Some<T>> value', () {
      const Option<Option<String>> opt = Some(Some('some-some'));
      expect(opt.flatten(), const Some<String>('some-some'));
    });

    test('should return None<T> when received Some<None<T>> value', () {
      const Option<Option<String>> opt = Some(None());
      expect(opt.flatten(), const None<String>());
    });

    test('should return None<T> when received None<Option<T>> value', () {
      const Option<Option<String>> opt = None();
      expect(opt.flatten(), const None<String>());
    });
  });
}
