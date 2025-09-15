class RoomUser {
  String? id;
  Null? user;
  String? room;
  int? status;
  String? createdAt;
  String? updatedAt;

  RoomUser(
      {this.id,
      this.user,
      this.room,
      this.status,
      this.createdAt,
      this.updatedAt});

  RoomUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    room = json['room'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['room'] = this.room;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
