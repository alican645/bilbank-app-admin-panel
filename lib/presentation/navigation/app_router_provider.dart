

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

class AppRouterProvider extends ChangeNotifier {
  final ApiService apiService = ApiServiceImpl();
  final LocalStorage _localStorage = LocalStorageImpl();

  String _initialLocation = '/login';
  String get initialLocation => _initialLocation;

  Future<void> autoLogin() async {
    try {
      final rememberCheck = await _localStorage.getValue<bool>(
        LocalStorageKeys.rememberCheck,
        false,
      );

      if (!rememberCheck) {
        _initialLocation = '/login';
        return;
      }

      final email = await _localStorage.getValue<String>(
        LocalStorageKeys.rememberMeEmail,
        '',
      );
      final password = await _localStorage.getValue<String>(
        LocalStorageKeys.rememberMePassword,
        '',
      );

      final res = await apiService.postPublic(
        ApiConstants.loginUserAccount,
        LoginRegisterRequest(email: email, password: password).toJson(),
      );

      final apiResponse = ApiResponse.fromJson(
        res.data,
        (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess == true && apiResponse.data != null) {
        _initialLocation = '/home';
      } else {
        _initialLocation = '/login';
      }
    } catch (err) {
      log('AutoLogin Hatası: $err');
      _initialLocation = '/login';
    }
  }
}
