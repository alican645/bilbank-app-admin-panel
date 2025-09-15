class RoomState {
  String? title;
  int? roomType;
  int? reward;
  int? entryFee;
  int? maxUsers;
  int? roomStatus;
  int? activeReservationCount;
  bool? reserved;

  RoomState(
      {this.title,
      this.roomType,
      this.reward,
      this.entryFee,
      this.maxUsers,
      this.roomStatus,
      this.activeReservationCount,
      this.reserved});

  RoomState.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    roomType = json['room_type'];
    reward = json['reward'];
    entryFee = json['entry_fee'];
    maxUsers = json['max_users'];
    roomStatus = json['room_status'];
    activeReservationCount = json['active_reservation_count'];
    reserved = json['reserved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['room_type'] = this.roomType;
    data['reward'] = this.reward;
    data['entry_fee'] = this.entryFee;
    data['max_users'] = this.maxUsers;
    data['room_status'] = this.roomStatus;
    data['active_reservation_count'] = this.activeReservationCount;
    data['reserved'] = this.reserved;
    return data;
  }
}
