class DeviceCategoryModel {
  String deviceType;
  bool? deleted;

  DeviceCategoryModel({
    required this.deviceType,
    this.deleted,
  });

  DeviceCategoryModel copyWith({
    String? deviceType,
    bool? deleted,
  }) =>
      DeviceCategoryModel(
        deviceType: deviceType ?? this.deviceType,
        deleted: deleted ?? this.deleted,
      );

  factory DeviceCategoryModel.fromJson(Map<String, dynamic> json) =>
      DeviceCategoryModel(
        deviceType: json["deviceType"] ?? "",
        deleted: json["deleted"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "deviceType": deviceType,
        'deleted': deleted,
      };

  Map<String, dynamic> updateJson() {
    final data = <String, dynamic>{};
    data["deviceType"] = deviceType;
    data['deleted'] = deleted;
    return data;
  }
}
