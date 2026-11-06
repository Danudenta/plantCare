/// Exception saat koneksi terputus (simulasi).
class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}
