// To parse this JSON data, do
//
//     final pokedex = pokedexFromJson(jsonString);

import 'dart:convert';

GamingCenters pokedexFromJson(String str) =>
    GamingCenters.fromJson(json.decode(str));

String pokedexToJson(GamingCenters data) => json.encode(data.toJson());

class GamingCenters {
  String status;
  Data data;

  GamingCenters({
    required this.status,
    required this.data,
  });

  factory GamingCenters.fromJson(Map<String, dynamic> json) => GamingCenters(
        status: json["Status"],
        data: Data.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Data": data.toJson(),
      };
}

class Data {
  List<Item> items;

  Data({
    required this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  String centerStatus;
  String centerCode;
  String centerZipCode;
  String centerAddress;
  String organisationId;
  List<ManagerDetail> managerDetails;
  String centerName;
  int createdOn;
  String centerId;
  int? discount;

  Item({
    required this.centerStatus,
    required this.centerCode,
    required this.centerZipCode,
    required this.centerAddress,
    required this.organisationId,
    required this.managerDetails,
    required this.centerName,
    required this.createdOn,
    required this.centerId,
    this.discount,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        centerStatus: json["center_status"],
        centerCode: json["center_code"],
        centerZipCode: json["center_zip_code"],
        centerAddress: json["center_address"],
        organisationId: json["organisation_id"],
        managerDetails: List<ManagerDetail>.from(
            json["manager_details"].map((x) => ManagerDetail.fromJson(x))),
        centerName: json["center_name"],
        createdOn: json["created_on"],
        centerId: json["center_id"],
        discount: json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "center_status": centerStatus,
        "center_code": centerCode,
        "center_zip_code": centerZipCode,
        "center_address": centerAddress,
        "organisation_id": organisationId,
        "manager_details":
            List<dynamic>.from(managerDetails.map((x) => x.toJson())),
        "center_name": centerName,
        "created_on": createdOn,
        "center_id": centerId,
        "discount": discount,
      };
}

class ManagerDetail {
  String organisationId;
  String userStatus;
  String countryCode;
  String userType;
  String userId;
  String userName;
  String contactNumber;

  ManagerDetail({
    required this.organisationId,
    required this.userStatus,
    required this.countryCode,
    required this.userType,
    required this.userId,
    required this.userName,
    required this.contactNumber,
  });

  factory ManagerDetail.fromJson(Map<String, dynamic> json) => ManagerDetail(
        organisationId: json["organisation_id"],
        userStatus: json["user_status"],
        countryCode: json["country_code"],
        userType: json["user_type"],
        userId: json["user_id"],
        userName: json["user_name"],
        contactNumber: json["contact_number"],
      );

  Map<String, dynamic> toJson() => {
        "organisation_id": organisationId,
        "user_status": userStatus,
        "country_code": countryCode,
        "user_type": userType,
        "user_id": userId,
        "user_name": userName,
        "contact_number": contactNumber,
      };
}
