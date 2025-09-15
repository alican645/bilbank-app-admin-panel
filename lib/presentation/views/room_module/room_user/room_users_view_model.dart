// room_users_view_model.dart
import 'package:flutter/material.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service_impl.dart';
import 'package:bilbank_admin_panel/data/apiService/api_response.dart';
import 'package:bilbank_admin_panel/data/apiService/api_constants.dart';

class RoomUsersViewModel extends ChangeNotifier {
  RoomUsersViewModel({ApiService? api}) : _api = api ?? ApiServiceImpl();

  final ApiService _api;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  List<RoomUserViewData> _users = [];
  List<RoomUserViewData> get users => _users;

  /// Aktif kullanıcıları getirir.
  /// Endpoint: GET /api/rooms/getRoomActiveReservations?room_id={id}
  Future<void> fetchActiveUsers(String roomId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Not: Projendeki ApiService.getRequest imza farklı ise (ör. query param adı),
      // buradaki "query" kullanımını kendi imzana göre uyarlayabilirsin.
      final res = await _api.getRequest(
        ApiConstants.getRoomActiveReservationsPath(roomId),
       
      );

      final parsed = ApiResponse<List<dynamic>>.fromJson(
        res.data as Map<String, dynamic>,
        (obj) => (obj as List).toList(),
      );

      if (!parsed.isSuccess || parsed.data == null) {
        _error = parsed.errorMessage ?? 'Kullanıcılar getirilemedi';
        _users = [];
      } else {
        _users = parsed.data!
            .map((e) => _mapItemToViewData(e))
            .whereType<RoomUserViewData>()
            .toList();
      }
    } catch (e) {
      _error = e.toString();
      _users = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Backend’ten gelen item’ı (ör. reservation) UI DTO’suna çevir.
  /// Esnek alan isimleri: user {first_name/last_name/username/name, avatar_url/photoUrl}, role vb.
  RoomUserViewData? _mapItemToViewData(dynamic raw) {
    if (raw is! Map) return null;

    final user = (raw['user'] is Map) ? raw['user'] as Map : const {};
    final status = raw['status']; // int? → rol bilgisi olabilir

    // İsim
    final first = (user['first_name'] ?? user['firstName'] ?? '') as String;
    final last  = (user['last_name']  ?? user['lastName']  ?? '') as String;
    final uname = (user['username']   ?? user['name']      ?? '') as String;
    final fullName = [first, last].where((s) => s.isNotEmpty).join(' ').trim();
    final name = (fullName.isNotEmpty ? fullName : uname).isEmpty
        ? (raw['id']?.toString() ?? 'Bilinmiyor')
        : (fullName.isNotEmpty ? fullName : uname);

    // Avatar
    final avatarUrl = (user['avatar_url'] ??
                       user['photoUrl']   ??
                       user['avatar']     ??
                       '') as String;

    // Rol & admin belirleme (örnek kural: status == 1 → Admin)
    final isAdmin = status == 1;
    final role = isAdmin
        ? 'Admin'
        : (user['role']?.toString() ?? 'Kullanıcı');

    return RoomUserViewData(
      name: name,
      role: role,
      isAdmin: isAdmin,
      avatarUrl: avatarUrl,
    );
  }
}

/// UI’de kullanılacak sade DTO
class RoomUserViewData {
  final String name;
  final String role;
  final bool isAdmin;
  final String avatarUrl;

  RoomUserViewData({
    required this.name,
    required this.role,
    required this.isAdmin,
    required this.avatarUrl,
  });
}
