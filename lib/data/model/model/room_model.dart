class RoomModel {
  String? title;
  RoomType? roomType;
  int? reward;
  int? entryFee;
  int? maxUsers;
  int? minUsers;
  EntryStatus? roomStatus;
  int? activeReservationCount;
  String? createdAt;
  String? updatedAt;
  String? id;

  RoomModel({
    this.title,
    this.roomType,
    this.reward,
    this.entryFee,
    this.maxUsers,
    this.minUsers,
    this.roomStatus,
    this.activeReservationCount,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  RoomModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    roomType = RoomTypeExtension.fromInt(json['room_type'] ?? 0);
    reward = json['reward'];
    entryFee = json['entry_fee'];
    maxUsers = json['max_users'];
    minUsers = json['min_users'];
    roomStatus = EntryStatusExtension.fromInt(json['room_status'] ?? 0);
    activeReservationCount = json['active_reservation_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'room_type': roomType?.toInt(),
      'reward': reward,
      'entry_fee': entryFee,
      'max_users': maxUsers,
      'min_users': minUsers,
      'room_status': roomStatus?.toInt(),
      'active_reservation_count': activeReservationCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'id': id,
    };
  }
}


enum EntryStatus {
  waiting,
  running,
  closed,
}

extension EntryStatusExtension on EntryStatus {
  static EntryStatus fromInt(int value) {
    switch (value) {
      case 0: return EntryStatus.waiting;
      case 1: return EntryStatus.running;
      case 2: return EntryStatus.closed;
      default: return EntryStatus.waiting;
    }
  }

  int toInt() => index;

  String get label {
    switch (this) {
      case EntryStatus.waiting: return "Bekliyor";
      case EntryStatus.running: return "Devam Ediyor";
      case EntryStatus.closed: return "Kapalı";
    }
  }
}


enum RoomType {
  ucretsiz,
  bronz,
  gumus,
  altin,
  elmas,
  platin,
  zumrut,
  palladyum,
}

extension RoomTypeExtension on RoomType {
  static RoomType fromInt(int value) {
    switch (value) {
      case 0: return RoomType.ucretsiz;
      case 1: return RoomType.bronz;
      case 2: return RoomType.gumus;
      case 3: return RoomType.altin;
      case 4: return RoomType.elmas;
      case 5: return RoomType.platin;
      case 6: return RoomType.zumrut;
      case 7: return RoomType.palladyum;
      default: return RoomType.ucretsiz;
    }
  }

  int toInt() => index;

  String get label {
    switch (this) {
      case RoomType.ucretsiz: return "Ücretsiz";
      case RoomType.bronz: return "Bronz";
      case RoomType.gumus: return "Gümüş";
      case RoomType.altin: return "Altın";
      case RoomType.elmas: return "Elmas";
      case RoomType.platin: return "Platin";
      case RoomType.zumrut: return "Zümrüt";
      case RoomType.palladyum: return "Palladyum";
    }
  }
}
