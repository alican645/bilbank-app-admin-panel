class ApiResponse<T> {
  final int code;
  final T? data;
  final ApiError? error;

  ApiResponse({
    required this.code,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'] ?? 0,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      error: json['error'] != null
          ? ApiError.fromJson(json['error'])
          : null,
    );
  }

  bool get isSuccess => code == 200 || code == 201;

  /// 🔽 Mesajları birleşik göster
  String? get errorMessage {
    if (error == null) return null;
    if (error!.description?.isNotEmpty == true) {
      return "${error!.message}\n${error!.description}";
    }
    return error!.message;
  }
}

class ApiError {
  final String message;
  final String? description;

  ApiError({required this.message, this.description});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] ?? 'Bilinmeyen hata',
      description: json['description'],
    );
  }
}
