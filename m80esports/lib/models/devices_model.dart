class DeviceModel {
  int capacity;
  String deviceName;
  double price;
  DateTime startTime;
  bool status;
  int totalBills;
  double totalMinutesPlayed;
  double totalRevenue;
  double? capacityPrice;
  bool? deleted;
  bool isAvailable;

  DeviceModel({
    required this.capacity,
    required this.deviceName,
    required this.price,
    required this.startTime,
    required this.status,
    required this.totalBills,
    required this.totalMinutesPlayed,
    required this.totalRevenue,
    this.capacityPrice,
    this.deleted,
    required this.isAvailable,
  });

  DeviceModel copyWith({
    int? capacity,
    String? deviceName,
    double? price,
    DateTime? startTime,
    bool? status,
    int? totalBills,
    double? totalMinutesPlayed,
    double? totalRevenue,
    double? capacityPrice,
    bool? deleted,
    bool? isAvailable,
  }) =>
      DeviceModel(
        capacity: capacity ?? this.capacity,
        deviceName: deviceName ?? this.deviceName,
        price: price ?? this.price,
        startTime: startTime ?? this.startTime,
        status: status ?? this.status,
        totalBills: totalBills ?? this.totalBills,
        totalMinutesPlayed: totalMinutesPlayed ?? this.totalMinutesPlayed,
        totalRevenue: totalRevenue ?? this.totalRevenue,
        capacityPrice: capacityPrice ?? this.capacityPrice,
        deleted: deleted ?? this.deleted,
        isAvailable: isAvailable ?? this.isAvailable,
      );

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        capacity: int.tryParse(json['capacity'].toString()) ?? 0,
        deviceName: json["deviceName"] ?? "",
        price: double.tryParse(json['price'].toString()) ?? 0,
        startTime: json["startTime"]?.toDate(),
        status: json["status"] ?? false,
        totalBills: int.tryParse(json['totalBills'].toString()) ?? 0,
        totalMinutesPlayed:
            double.tryParse(json['totalMinutesPlayed'].toString()) ?? 0,
        totalRevenue: double.tryParse(json['totalRevenue'].toString()) ?? 0,
        capacityPrice: double.tryParse(json['capacityPrice'].toString()) ?? 0,
        deleted: json["deleted"] ?? false,
        isAvailable: json["isAvailable"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "capacity": capacity,
        "deviceName": deviceName,
        "price": price,
        "startTime": startTime,
        "status": status,
        "totalBills": totalBills,
        "totalMinutesPlayed": totalMinutesPlayed,
        "totalRevenue": totalRevenue,
        'capacityPrice': capacityPrice,
        'deleted': deleted,
        'isAvailable': isAvailable,
      };

  Map<String, dynamic> updateJson() {
    final data = <String, dynamic>{};
    data["capacity"] = capacity;
    data["deviceName"] = deviceName;
    data["price"] = price;
    data["startTime"] = startTime;
    data["status"] = status;
    data["totalBills"] = totalBills;
    data["totalMinutesPlayed"] = totalMinutesPlayed;
    data["totalRevenue"] = totalRevenue;
    data['capacityPrice'] = capacityPrice;
    data['deleted'] = deleted;
    data['isAvailable'] = isAvailable;
    return data;
  }
}
