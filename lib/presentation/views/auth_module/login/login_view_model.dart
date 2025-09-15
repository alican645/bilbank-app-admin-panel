

import 'dart:developer';

import 'package:bilbank_admin_panel/data/apiService/api_constants.dart';
import 'package:bilbank_admin_panel/data/apiService/api_response.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service_impl.dart';
import 'package:bilbank_admin_panel/data/local_storage/local_storage.dart';
import 'package:bilbank_admin_panel/data/local_storage/local_storage_impl.dart';
import 'package:bilbank_admin_panel/data/local_storage/local_storage_keys.dart';
import 'package:bilbank_admin_panel/data/model/requests/login_register_request.dart';
import 'package:bilbank_admin_panel/data/model/response/login_response.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier{
  final ApiService apiService = ApiServiceImpl();
  final LocalStorage _localStorage = LocalStorageImpl();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ApiResponse<LoginResponse>? _apiResponse;
  ApiResponse<LoginResponse>? get apiResponse => _apiResponse;

  String _email = '';
  String _password = '';
  bool _rememberMe = false;

  String get email => _email;
  String get password => _password;
  bool get rememberMe => _rememberMe;

  set rememberMe(bool val) {
    _rememberMe = val;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await apiService.postPublic(
        ApiConstants.loginUserAccount,
        LoginRegisterRequest(email: email, password: password).toJson(),
      );

      log('Login Response: ${res.data}', name: 'Login');

      _apiResponse = ApiResponse.fromJson(
        res.data,
        (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
      );

      if (_apiResponse?.isSuccess == true && _apiResponse?.data != null) {
        final token = _apiResponse!.data!.accessToken;

        if (token == null || token.isEmpty) throw Exception('Token boş döndü');

        await _localStorage.setValue<String>(LocalStorageKeys.accessToken, token);

        if (_rememberMe) {
          await _localStorage.setValue<bool>(LocalStorageKeys.rememberCheck, true);
          await _localStorage.setValue<String>(LocalStorageKeys.rememberMeEmail, email);
          await _localStorage.setValue<String>(LocalStorageKeys.rememberMePassword, password);
        }

        return true;
      } else {
        return false;
      }
    } catch (e, st) {
      log('Login Error: $e\n$st');
      _apiResponse = ApiResponse<LoginResponse>(
        code: 500,
        error: ApiError(message: 'Giriş başarısız', description: '$e'),
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// LocalStorage'den remember bilgilerini al
  Future<void> loadRememberedValues() async {
    _rememberMe = await _localStorage.getValue<bool>(LocalStorageKeys.rememberCheck, false);
    _email = await _localStorage.getValue<String>(LocalStorageKeys.rememberMeEmail, '');
    _password = await _localStorage.getValue<String>(LocalStorageKeys.rememberMePassword, '');
    notifyListeners();
  }

  Future<void> clearRememberMe() async {
  _rememberMe = false;
  await _localStorage.remove(LocalStorageKeys.rememberCheck);
  await _localStorage.remove(LocalStorageKeys.rememberMeEmail);
  await _localStorage.remove(LocalStorageKeys.rememberMePassword);
  notifyListeners();
}
}
