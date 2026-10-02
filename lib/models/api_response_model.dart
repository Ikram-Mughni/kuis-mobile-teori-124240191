// Model wrapper untuk respons API
class ApiResponseModel<T> {
  final bool status;
  final String message;
  final T? data;

  ApiResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  // Factory konversi JSON ke ApiResponseModel
  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) create,
  ) {
    return ApiResponseModel<T>(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? create(json['data']) : null,
    );
  }
}
