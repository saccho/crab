// ignore_for_file: avoid_print

import 'package:crab/crab.dart';

enum Version { version1, version2 }

Option<int> getVersionNum(List<int> header) {
  if (header.isEmpty) {
    return const None();
  }
  return Some(header.first);
}

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
  final versionNum = getVersionNum([1, 2, 3, 4]);
  if (versionNum.isNone) {
    // If you cannot get `versionNum`
    print('invalid header length');
  } else {
    // If you can get `versionNum`
    final version = parseVersion(versionNum.unwrap());
    // Define processing for success and error
    if (version.isErr) {
      print('error parsing header: ${version.unwrapErr()}');
    } else {
      print('working with version: ${version.unwrap()}');
    }
  }

  // The above process is equivalent to the following process
  getVersionNum([1, 2, 3, 4]).mapOrElse(
    () => print('invalid header length'),
    (vn) {
      parseVersion(vn).mapOrElse(
        (err) => print('error parsing header: $err'),
        (v) => print('working with version: $v'),
      );
    },
  );
}
