class InvoiceModel {
  double capacityPrice;
  String deviceName;
  DateTime? endTime;
  double extraAmount;
  List extras;
  String id;
  bool paid;
  double paidbyCash;
  double paidbyBank;
  double playCost;
  double playTime;
  int remainingCapacity;
  DateTime startTime;
  int totalCapacity;

  InvoiceModel({
    required this.capacityPrice,
    required this.deviceName,
    this.endTime,
    required this.extraAmount,
    required this.extras,
    required this.id,
    required this.paid,
    required this.paidbyBank,
    required this.paidbyCash,
    required this.playCost,
    required this.playTime,
    required this.remainingCapacity,
    required this.startTime,
    required this.totalCapacity,
  });

  InvoiceModel copyWith({
    double? capacityPrice,
    String? deviceName,
    DateTime? endtime,
    double? extraAmount,
    List? extras,
    String? id,
    bool? paid,
    double? paidbyCash,
    double? paidbyBank,
    double? playCost,
    double? playTime,
    int? remainingCapacity,
    DateTime? startTime,
    int? totalCapacity,
  }) =>
      InvoiceModel(
        capacityPrice: capacityPrice ?? this.capacityPrice,
        deviceName: deviceName ?? this.deviceName,
        endTime: endtime ?? this.endTime,
        extraAmount: extraAmount ?? this.extraAmount,
        extras: extras ?? this.extras,
        id: id ?? this.id,
        paid: paid ?? this.paid,
        playCost: playCost ?? this.playCost,
        playTime: playTime ?? this.playTime,
        startTime: startTime ?? this.startTime,
        paidbyBank: paidbyBank ?? this.paidbyBank,
        paidbyCash: paidbyCash ?? this.paidbyCash,
        remainingCapacity: remainingCapacity ?? this.remainingCapacity,
        totalCapacity: totalCapacity ?? this.totalCapacity,
      );

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        capacityPrice: double.tryParse(json['capacityPrice'].toString()) ?? 0,
        deviceName: json["deviceName"] ?? "",
        endTime: json["endTime"]?.toDate(),
        extraAmount: double.tryParse(json['extraAmount'].toString()) ?? 0,
        extras: json["extras"] ?? [],
        id: json["id"] ?? "",
        paid: json["paid"] ?? false,
        playCost: double.tryParse(json['playCost'].toString()) ?? 0,
        playTime: double.tryParse(json['playTime'].toString()) ?? 0,
        startTime: json["startTime"]?.toDate(),
        paidbyBank: double.tryParse(json['paidbyBank'].toString()) ?? 0,
        paidbyCash: double.tryParse(json['paidbyCash'].toString()) ?? 0,
        remainingCapacity: json["remainingCapacity"] ?? 0,
        totalCapacity: json["totalCapacity"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "capacityPrice": capacityPrice,
        "deviceName": deviceName,
        "endTime": endTime,
        "extraAmount": extraAmount,
        "extras": extras,
        "id": id,
        "paid": paid,
        "playCost": playCost,
        "playTime": playTime,
        "startTime": startTime,
        "paidbyBank": paidbyBank,
        "paidbyCash": paidbyCash,
        "remainingCapacity": remainingCapacity,
        'totalCapacity': totalCapacity,
      };

  Map<String, dynamic> updateJson() {
    final data = <String, dynamic>{};
    data["capacityPrice"] = capacityPrice;
    data["deviceName"] = deviceName;
    data["endTime"] = endTime;
    data["extraAmount"] = extraAmount;
    data["extras"] = extras;
    data["id"] = id;
    data["paid"] = paid;
    data["playCost"] = playCost;
    data["playTime"] = playTime;
    data["startTime"] = startTime;
    data["paidbyBank"] = paidbyBank;
    data["paidbyCash"] = paidbyCash;
    data["remainingCapacity"] = remainingCapacity;
    data['totalCapacity'] = totalCapacity;
    return data;
  }
}
