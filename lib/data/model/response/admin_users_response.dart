import 'package:bilbank_admin_panel/data/model/model/admin_user.dart';

class AdminUsersResponse {
  AdminUsersResponse({
    required this.users,
    this.pagination,
  });

  final List<AdminUser> users;
  final UsersPagination? pagination;

  factory AdminUsersResponse.fromJson(Map<String, dynamic> json) {
    return AdminUsersResponse(
      users: _parseUsers(json['users']),
      pagination: _parsePagination(json['pagination']),
    );
  }
}

List<AdminUser> _parseUsers(Object? data) {
  if (data is List) {
    return data
        .map((e) {
          if (e is Map<String, dynamic>) {
            return AdminUser.fromJson(e);
          }
          if (e is Map) {
            return AdminUser.fromJson(
                e.map((key, value) => MapEntry(key.toString(), value)));
          }
          return null;
        })
        .whereType<AdminUser>()
        .toList();
  }
  return <AdminUser>[];
}

UsersPagination? _parsePagination(Object? data) {
  if (data is Map<String, dynamic>) {
    return UsersPagination.fromJson(data);
  }
  if (data is Map) {
    return UsersPagination.fromJson(
      data.map((key, value) => MapEntry(key.toString(), value)),
    );
  }
  return null;
}
