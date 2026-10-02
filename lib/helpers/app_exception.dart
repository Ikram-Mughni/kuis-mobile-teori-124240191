// Kelas penanganan exception kustom
class AppException implements Exception {
  final String? message;
  final String? prefix;

  AppException([this.message, this.prefix]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

// Exception untuk kegagalan koneksi data
class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Gagal mengambil data: ");
}

// Exception untuk permintaan tidak valid (HTTP 400)
class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(message, "Permintaan tidak valid: ");
}

// Exception untuk otentikasi tidak valid (HTTP 401)
class UnauthorisedException extends AppException {
  UnauthorisedException([String? message])
      : super(message, "Sesi tidak valid: ");
}

// Exception untuk validasi input (HTTP 422)
class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message, "Input tidak valid: ");
}
