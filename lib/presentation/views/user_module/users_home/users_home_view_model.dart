import 'package:bilbank_admin_panel/data/apiService/api_constants.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service_impl.dart';
import 'package:bilbank_admin_panel/data/model/model/admin_user.dart';
import 'package:bilbank_admin_panel/data/model/response/admin_users_response.dart';
import 'package:flutter/material.dart';

class UsersHomeViewModel extends ChangeNotifier {
  UsersHomeViewModel({ApiService? api}) : _apiService = api ?? ApiServiceImpl();

  final ApiService _apiService;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  List<AdminUser> _users = [];
  List<AdminUser> get users => _users;

  UsersPagination? _pagination;
  UsersPagination? get pagination => _pagination;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  Future<void> fetchUsers({int page = 1}) async {
    final safePage = page < 1 ? 1 : page;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final endpoint = safePage > 1
          ? '${ApiConstants.adminUsersPath}?page=$safePage'
          : ApiConstants.adminUsersPath;

      final response = await _apiService.getRequest(endpoint);
      final map = _ensureMap(response.data);

      if (map == null) {
        _error = 'Beklenmeyen yanıt formatı';
        return;
      }

      final parsed = AdminUsersResponse.fromJson(map);
      _users = parsed.users;
      _pagination = parsed.pagination;

      final responsePage = parsed.pagination?.currentPage;
      if (responsePage != null && responsePage > 0) {
        _currentPage = responsePage;
      } else {
        _currentPage = safePage;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

Map<String, dynamic>? _ensureMap(Object? data) {
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map) {
    return data.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}
