// To parse this JSON data, do
//
//     final pokedex = pokedexFromJson(jsonString);

import 'dart:convert';

UserModel pokedexFromJson(String str) => UserModel.fromJson(json.decode(str));

String pokedexToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String status;
  Data data;

  UserModel({
    required this.status,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
  String userId;
  String addedOn;
  String userType;
  String contactNumber;
  String userRole;
  String organisationId;
  String countryCode;
  String userStatus;
  String userName;
  bool partOfOrganisation;
  String organisationName;
  List<Item>? userOrganisations;

  Item({
    required this.userId,
    required this.addedOn,
    required this.userType,
    required this.contactNumber,
    required this.userRole,
    required this.organisationId,
    required this.countryCode,
    required this.userStatus,
    required this.userName,
    required this.partOfOrganisation,
    required this.organisationName,
    this.userOrganisations,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        userId: json["user_id"],
        addedOn: json["added_on"],
        userType: json["user_type"],
        contactNumber: json["contact_number"],
        userRole: json["user_role"],
        organisationId: json["organisation_id"],
        countryCode: json["country_code"],
        userStatus: json["user_status"],
        userName: json["user_name"],
        partOfOrganisation: json["part_of_organisation"],
        organisationName: json["organisation_name"],
        userOrganisations: json["user_organisations"] == null
            ? []
            : List<Item>.from(
                json["user_organisations"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "added_on": addedOn,
        "user_type": userType,
        "contact_number": contactNumber,
        "user_role": userRole,
        "organisation_id": organisationId,
        "country_code": countryCode,
        "user_status": userStatus,
        "user_name": userName,
        "part_of_organisation": partOfOrganisation,
        "organisation_name": organisationName,
        "user_organisations": userOrganisations == null
            ? []
            : List<dynamic>.from(userOrganisations!.map((x) => x.toJson())),
      };
}
