/// Error thrown by the runtime system when `unwrap` fails.
class UnwrapError<T> extends Error {
  UnwrapError(
    this.message, {
    this.obj,
  });

  final String message;
  final T? obj;

  @override
  String toString() => obj != null ? '$message: $obj' : message;
}
