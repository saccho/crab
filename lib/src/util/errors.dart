/// Error thrown by the runtime system when `unwrap` fails.
class UnwrapError extends Error {
  UnwrapError(
    this.message, {
    this.obj,
  });

  final String message;
  final Object? obj;

  @override
  String toString() => obj != null ? '$message: $obj' : message;
}
