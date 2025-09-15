

import 'package:bilbank_admin_panel/data/apiService/api_constants.dart';
import 'package:bilbank_admin_panel/data/apiService/api_response.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service_impl.dart';
import 'package:bilbank_admin_panel/data/model/model/room_model.dart';
import 'package:flutter/material.dart';

class EditRoomViewModel extends ChangeNotifier {
  EditRoomViewModel({ApiService? api}) : _api = api ?? ApiServiceImpl();

  final ApiService _api;

  RoomModel? _room;
  RoomModel? get room => _room;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  // Görsel amaçlı metinler
  String get titleText => _room?.title ?? '';
  String get rewardText => (_room?.reward ?? 0).toString();
  String get entryFeeText => (_room?.entryFee ?? 0).toString();
  String get maxUsersText => (_room?.maxUsers ?? 0).toString();
  String get minUsersText => (_room?.minUsers ?? 0).toString();
  String get roomTypeLabel => _room?.roomType?.label ?? '';
  String get roomStatusLabel => _room?.roomStatus?.label ?? '';

  /// Dışarıdan gelen odayı set et ve ekrana yansıt
  void initWithRoom(RoomModel room) {
    _room = room;
    _error = null;
    notifyListeners();
  }

  /// (İLERİDE) Odayı güncelle
  /// ApiConstants.updateRoom: `PUT /rooms/{id}`  → Oda meta bilgisini günceller
  Future<ApiResponse<dynamic>?> saveRoom(Map<String, dynamic> payload) async {
    if (_room?.id == null) return null;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _api.getRequest(
        
        ""
      );
      final parsed = ApiResponse.fromJson(res.data, null);
      if (!parsed.isSuccess) _error = parsed.errorMessage ?? 'Kayıt başarısız';
      return parsed;
    } catch (e) {
      _error = e.toString();
      return ApiResponse(code: 500, error: ApiError(message: 'Hata', description: '$e'));
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  
}
