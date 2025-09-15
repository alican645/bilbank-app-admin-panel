import 'package:dio/dio.dart';

abstract class ApiService{
  // Token'in geçerliliğini kontrol eden fonksiyon
  Future<bool> isTokenExpired() ;

  // Token yenileyen fonksiyon
  Future<void> refreshToken() ;

  // Token alıp doğrulama işlemi
  Future<String> ensureValidToken() ;

  // Generic GET fonksiyonu
  Future<Response> getRequest(String endpoint) ;

  // Generic POST fonksiyonu
  Future<Response> postRequest(String endpoint, Object? data) ;

  Future<Response> postPublic(String endpoint, Object data);



}