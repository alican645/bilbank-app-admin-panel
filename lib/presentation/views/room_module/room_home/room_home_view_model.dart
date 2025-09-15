

import 'package:bilbank_admin_panel/data/apiService/api_constants.dart';
import 'package:bilbank_admin_panel/data/apiService/api_response.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service.dart';
import 'package:bilbank_admin_panel/data/apiService/api_service_impl.dart';
import 'package:bilbank_admin_panel/data/model/model/room_model.dart';
import 'package:bilbank_admin_panel/data/model/model/room_state.dart';
import 'package:bilbank_admin_panel/data/model/requests/room_request.dart';
import 'package:flutter/material.dart';




class RoomHomeViewModel extends ChangeNotifier {
  RoomHomeViewModel({ApiService? api}) : _apiService = api ?? ApiServiceImpl();
  final ApiService _apiService;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  List<RoomModel> _rooms = [];
  List<RoomModel> get rooms => _rooms;

  bool _loadingRoomState = false;
  bool get loadingRoomState => _loadingRoomState;

  RoomState? _roomState;
  RoomState? get roomState => _roomState;


  Future<void> fetchRoomData() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _apiService.getRequest(ApiConstants.roomPath);
      final parsed = ApiResponse<List<RoomModel>>.fromJson(
        res.data as Map<String, dynamic>,
        (obj) => (obj as List)
            .map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      if (parsed.isSuccess && parsed.data != null) {
        _rooms = parsed.data!;
      } else {
        _error = parsed.errorMessage ?? 'Bilinmeyen hata';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }




}
