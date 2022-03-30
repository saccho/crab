## 0.2.0

- Added `Result` methods. You can use almost all the features of Rust's `Result` trait (exclude nightly-only features).
- Fixed `Ok#toString`, `Err#toString`, `Some#toString`, and `None#toString`.
- **Breaking**: `Result#flatMep` is removed. You can use `Result#andThen` instead.
- **Breaking**: Changed `Ok.value` and `Err.err` to private. You can use `Result#unwrap` and `Result#unwrapErr` instead.
- **Breaking**: Changed `Some.value` to private. You can use `Option#unwrap` instead.

## 0.1.0

- Initial release
