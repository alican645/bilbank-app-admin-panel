import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:bilbank_admin_panel/data/apiService/api_constants.dart';
import 'package:bilbank_admin_panel/data/apiService/api_response.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service_impl.dart';
import 'package:bilbank_admin_panel/data/model/requests/login_register_request.dart';

class RegisterViewModel extends ChangeNotifier {
  RegisterViewModel({ApiService? api}) : apiService = api ?? ApiServiceImpl();

  final ApiService apiService;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ApiResponse? _registerResponse;
  ApiResponse? get registerResponse => _registerResponse;

  Future<ApiResponse?> registerAccount(LoginRegisterRequest request) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.postPublic(
        ApiConstants.registerUserAccount,
        request.toJson(),
      );

      _registerResponse = ApiResponse.fromJson(response.data, null);

      if (_registerResponse?.isSuccess == true) {
        log('✅ RegisterAccount Success: ${_registerResponse?.data}');
      } else {
        log('❌ RegisterAccount Failed: ${_registerResponse?.errorMessage}');
      }
      return _registerResponse;
    } catch (e) {
      _registerResponse = ApiResponse(
        code: -1,
        error: ApiError(
          message: "İstek sırasında hata oluştu",
          description: e.toString(),
        ),
      );
      log('❌ RegisterAccount Exception: $e');
      return _registerResponse;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearRegisterResponse() {
    _registerResponse = null;
    notifyListeners();
  }
}
