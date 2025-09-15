class RoomRequest {
  String? roomId;

  RoomRequest({this.roomId});

  RoomRequest.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    return data;
  }
}
