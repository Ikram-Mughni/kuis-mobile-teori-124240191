import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_exception.dart';

// Utilitas eksekusi HTTP request dan validasi respons
class Api {
  // Eksekusi HTTP GET Request
  Future<dynamic> get(String url, {String? token}) async {
    dynamic responseJson;
    try {
      final Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }

      final response = await http.get(Uri.parse(url), headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    }
    return responseJson;
  }

  // Eksekusi HTTP POST Request
  Future<dynamic> post(String url, dynamic body, {String? token}) async {
    dynamic responseJson;
    try {
      final Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    }
    return responseJson;
  }

  // Validasi status code HTTP
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Terjadi kesalahan server dengan kode status: ${response.statusCode}',
        );
    }
  }
}
