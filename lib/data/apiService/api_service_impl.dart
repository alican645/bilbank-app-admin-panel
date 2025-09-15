import 'dart:developer';

import 'package:bilbank_admin_panel/data/apiService/api_constants.dart';
import 'package:bilbank_admin_panel/data/apiService/api_interceptor.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service.dart';
import 'package:bilbank_admin_panel/data/local_storage/local_storage_impl.dart';
import 'package:bilbank_admin_panel/data/local_storage/local_storage_keys.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiServiceImpl extends ApiService{
  static final ApiServiceImpl _instance = ApiServiceImpl._internal();
  factory ApiServiceImpl() => _instance;
  ApiServiceImpl._internal();

  final Dio _dio = Dio(BaseOptions(
  baseUrl: ApiConstants.baseUrl,
  connectTimeout: Duration(seconds: 20),
  headers: {"Content-Type": "application/json"},
))
..interceptors.add(ApiInterceptor());

  // Token'in geçerliliğini kontrol eden fonksiyon
  @override
  Future<bool> isTokenExpired() async {

    String? token =await LocalStorageImpl().getValue<String>(LocalStorageKeys.accessToken,"");
    if (token == "") return true; // Eğer token yoksa geçersiz
    return JwtDecoder.isExpired(token);
  }

  // Token yenileyen fonksiyon
  @override
  Future<void> refreshToken() async {

    // String? refreshToken =await LocalStorageImpl().getValue<String>(LocalStorageKeys.refreshToken);
    // String? accessToken =await LocalStorageImpl().getValue<String>(LocalStorageKeys.accessToken);

    // if (refreshToken == null || accessToken == null) {
    //   throw Exception('Token bulunamadı.');
    // }

    // final response = await _dio.post(
    //   ApiConstants.refreshTokenEndpoint,
    //   data: {
    //     'accessToken': accessToken,
    //     'refreshToken': refreshToken,
    //   },
    // );

    // if (response.statusCode == 200) {
    //   final newAccessToken = response.data['accessToken'];
    //   final newRefreshToken = response.data['refreshToken'];

    //   await LocalStorageImpl().setValue<String>(LocalStorageKeys.accessToken, newAccessToken);
    //   await LocalStorageImpl().setValue<String>(LocalStorageKeys.refreshToken, newRefreshToken);
    // } else {
    //   throw Exception('Token yenileme başarısız oldu: ${response.statusCode}');
    // }
  }

  // Token alıp doğrulama işlemi
  @override
  Future<String> ensureValidToken() async {
    if (await isTokenExpired()) {
      await refreshToken();
    }
    String? token =await LocalStorageImpl().getValue<String>(LocalStorageKeys.accessToken,"");
    if (token == "") {
      throw Exception('Token alınamadı.');
    }
    return token;
  }

  // Generic GET fonksiyonu
  @override
  Future<Response> getRequest(String endpoint) async {
    try {
      final token = await ensureValidToken();
      return await _dio.get(
        endpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  // ---- Public (auth gerektirmez) ----
  Future<Response> postPublic(String endpoint, Object data) async {
    try {
      final res = await _dio.post(endpoint, data: data);
      return res;
    } on DioException catch (e) {
      log(e.toString());
        return e.response ?? Response(requestOptions: RequestOptions(path: endpoint), statusCode: 500, data: {'error': {'message': 'Bilinmeyen hata'}});
    }
  }
  
  // Generic POST fonksiyonu
  @override
  Future<Response> postRequest(String endpoint, Object? data) async {
    try {
      final token = await ensureValidToken();
      var response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if(response.statusCode==200 || response.statusCode==201){
        return response;
      }
      return response;
    } on DioException catch (e) {
      if(e.response!=null){
        String errorMessage = e.response?.data??"Sunucu Hatası Oluştu";
        throw Exception(errorMessage);
      }else{
        throw Exception('İstek gönderilirken bir hata oluştu: ${e.message}');
      }

    }
  }
}