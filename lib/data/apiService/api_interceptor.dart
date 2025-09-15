
import 'package:bilbank_admin_panel/data/local_storage/local_storage_impl.dart';
import 'package:bilbank_admin_panel/data/local_storage/local_storage_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Her isteğe otomatik token ekle
    final token = await LocalStorageImpl().getValue<String>(LocalStorageKeys.accessToken,"");
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Başarılı cevabı logla
    debugPrint('✅ Response [${response.statusCode}] => ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Başarısız istekte dönen JSON mesajını logla
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    debugPrint('❌ Error [$statusCode] => $data');

    // İstersen sadece message alanını logla
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      debugPrint('❌ Error message: ${data['message']}');
    }

    super.onError(err, handler);
  }
}
