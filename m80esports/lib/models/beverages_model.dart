class BeveragesModel {
  bool deleted;
  String itemName;
  DateTime lastAdded;
  double price;
  int totalQuantity;
  int sold;

  BeveragesModel({
    required this.deleted,
    required this.itemName,
    required this.price,
    required this.lastAdded,
    required this.totalQuantity,
    required this.sold,
  });

  BeveragesModel copyWith({
    bool? deleted,
    String? itemName,
    DateTime? lastAdded,
    double? price,
    int? totalQuantity,
    int? sold,
  }) =>
      BeveragesModel(
        deleted: deleted ?? this.deleted,
        itemName: itemName ?? this.itemName,
        lastAdded: lastAdded ?? this.lastAdded,
        price: price ?? this.price,
        totalQuantity: totalQuantity ?? this.totalQuantity,
        sold: sold ?? this.sold,
      );

  factory BeveragesModel.fromJson(Map<String, dynamic> json) => BeveragesModel(
        deleted: json["deleted"] ?? false,
        itemName: json['itemName'] ?? '',
        lastAdded: json["lastAdded"]?.toDate(),
        price: double.tryParse(json['price'].toString()) ?? 0,
        totalQuantity: int.tryParse(json['totalQuantity'].toString()) ?? 0,
        sold: int.tryParse(json['sold'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'deleted': deleted,
        "itemName": itemName,
        "lastAdded": lastAdded,
        "price": price,
        "totalQuantity": totalQuantity,
        "sold": sold,
      };

  Map<String, dynamic> updateJson() {
    final data = <String, dynamic>{};
    data['deleted'] = deleted;
    data["itemName"] = itemName;
    data["lastAdded"] = lastAdded;
    data["price"] = price;
    data["totalQuantity"] = totalQuantity;
    data["sold"] = sold;
    return data;
  }
}
