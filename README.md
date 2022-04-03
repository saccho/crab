# 🦀crab🦀

![](https://github.com/saccho/crab/workflows/Test/badge.svg)

Provides Rust-like `Result` and `Option` types, making it easier to handle error and option values.

## Defined types

### Result

`Result` is the type used for returning and propagating errors.

A simple function returning `Result` might be defined and used like so:

```dart
enum Version { version1, version2 }

Result<Version, String> parseVersion(int versionNum) {
  if (versionNum == 1) {
    return const Ok(Version.version1);
  }
  if (versionNum == 2) {
    return const Ok(Version.version2);
  }
  return const Err('invalid version');
}

void main() {
  final version = parseVersion(1);
  // Define processing for success and error
  if (version.isErr) {
    print('error parsing header: ${version.unwrapErr()}');
  } else {
    print('working with version: ${version.unwrap()}');
  }

  // It can also be defined as follows
  parseVersion(1).mapOrElse(
    (err) => print('error parsing header: $err'),
    (v) => print('working with version: $v'),
  );
}
```

### Option

Type `Option` represents an optional value: every `Option` is either `Some` and contains a value, or `None`, and does not.

Dart already supports null safety by appending a `?` to a type, but you can use the `Option` type to enhance the handling of optional value (which can also be interpreted as nullable values).

A simple function returning `Option` might be defined and used like so:

```dart
Option<int> getVersionNum(List<int> header) {
  if (header.isEmpty) {
    return const None();
  }
  return Some(header.first);
}

void main() {
  final versionNum = getVersionNum([1, 2, 3, 4]);
  // Define the processing when the value can be obtained and when it cannot be
  // obtained
  if (versionNum.isNone) {
    print('invalid header length');
  } else {
    print('version number: ${versionNum.unwrap()}');
  }

  // The above process is equivalent to the following process
  getVersionNum([1, 2, 3, 4]).mapOrElse(
    () => print('invalid header length'),
    (vn) => print('version number: $vn'),
  );
}
```

## References

This package was created with reference to the following implementation and description of Rust.

### Result

- Implementation: https://doc.rust-lang.org/stable/std/result/enum.Result.html
- Module description: https://doc.rust-lang.org/stable/std/result/index.html
### Option

- Implementation: https://doc.rust-lang.org/stable/std/option/enum.Option.html
- Module description: https://doc.rust-lang.org/stable/std/option/index.html
