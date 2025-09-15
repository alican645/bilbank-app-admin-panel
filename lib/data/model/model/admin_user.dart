class AdminUser {
  AdminUser({
    this.userId,
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.balance,
    this.avatar,
    this.status,
  });

  final String? userId;
  final String? id;
  final String? username;
  final String? fullName;
  final String? email;
  final num? balance;
  final String? avatar;
  final String? status;

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      userId: json['userId']?.toString(),
      id: json['_id']?.toString() ?? json['id']?.toString(),
      username: json['username']?.toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      balance: _tryParseNum(json['balance']),
      avatar: json['avatar']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      '_id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'balance': balance,
      'avatar': avatar,
      'status': status,
    };
  }

  String get displayName {
    final name = (fullName ?? '').trim();
    if (name.isNotEmpty && name.toLowerCase() != 'undefined undefined') {
      return name;
    }
    final usernameFallback = (username ?? '').trim();
    if (usernameFallback.isNotEmpty) {
      return usernameFallback;
    }
    final emailFallback = (email ?? '').trim();
    if (emailFallback.isNotEmpty) {
      return emailFallback;
    }
    return id ?? 'Kullanıcı';
  }

  String? get avatarUrl {
    final value = avatar?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  String get secondaryText {
    final emailText = (email ?? '').trim();
    if (emailText.isNotEmpty) {
      return emailText;
    }
    final usernameText = (username ?? '').trim();
    if (usernameText.isNotEmpty) {
      return usernameText;
    }
    return '';
  }
}

class UsersPagination {
  UsersPagination({
    this.currentPage,
    this.totalPages,
    this.totalUsers,
    this.hasNextPage,
    this.hasPrevPage,
  });

  final int? currentPage;
  final int? totalPages;
  final int? totalUsers;
  final bool? hasNextPage;
  final bool? hasPrevPage;

  bool get hasNext {
    if (hasNextPage != null) return hasNextPage!;
    if (currentPage != null && totalPages != null) {
      return currentPage! < totalPages!;
    }
    return false;
  }

  bool get hasPrev {
    if (hasPrevPage != null) return hasPrevPage!;
    if (currentPage != null) {
      return currentPage! > 1;
    }
    return false;
  }

  factory UsersPagination.fromJson(Map<String, dynamic> json) {
    return UsersPagination(
      currentPage: _tryParseInt(json['currentPage']),
      totalPages: _tryParseInt(json['totalPages']),
      totalUsers: _tryParseInt(json['totalUsers']),
      hasNextPage: _tryParseBool(json['hasNextPage']),
      hasPrevPage: _tryParseBool(json['hasPrevPage']),
    );
  }
}

int? _tryParseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

num? _tryParseNum(dynamic value) {
  if (value is num) return value;
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed;
  }
  return null;
}

bool? _tryParseBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) {
    final lower = value.toLowerCase();
    if (lower == 'true') return true;
    if (lower == 'false') return false;
  }
  if (value is num) {
    if (value == 1) return true;
    if (value == 0) return false;
  }
  return null;
}
