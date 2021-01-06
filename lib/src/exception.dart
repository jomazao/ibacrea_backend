class BackendException implements Exception {
  final String message;
  final int statusCode;
  final String Url;

  BackendException(this.message, [this.statusCode, this.Url]);

  @override
  String toString() => message;
}
