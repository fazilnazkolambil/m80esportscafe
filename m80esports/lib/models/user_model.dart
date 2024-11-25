// To parse this JSON data, do
//
//     final pokedex = pokedexFromJson(jsonString);

import 'dart:convert';

UserModel pokedexFromJson(String str) => UserModel.fromJson(json.decode(str));

String pokedexToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String userId;
  String contactNumber;
  String userType;
  String userRole;
  String organisationId;
  String countryCode;
  bool partOfOrganisation;
  String userName;
  String userStatus;
  int? totalMinutesPlayed;
  String organisationName;
  List<UserModel>? userOrganisations;

  UserModel({
    required this.userId,
    required this.contactNumber,
    required this.userType,
    required this.userRole,
    required this.organisationId,
    required this.countryCode,
    required this.partOfOrganisation,
    required this.userName,
    required this.userStatus,
    this.totalMinutesPlayed,
    required this.organisationName,
    this.userOrganisations,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["user_id"],
        contactNumber: json["contact_number"],
        userType: json["user_type"],
        userRole: json["user_role"],
        organisationId: json["organisation_id"],
        countryCode: json["country_code"],
        partOfOrganisation: json["part_of_organisation"],
        userName: json["user_name"],
        userStatus: json["user_status"],
        totalMinutesPlayed: json["total_minutes_played"],
        organisationName: json["organisation_name"],
        userOrganisations: json["user_organisations"] == null
            ? []
            : List<UserModel>.from(
                json["user_organisations"]!.map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "contact_number": contactNumber,
        "user_type": userType,
        "user_role": userRole,
        "organisation_id": organisationId,
        "country_code": countryCode,
        "part_of_organisation": partOfOrganisation,
        "user_name": userName,
        "user_status": userStatus,
        "total_minutes_played": totalMinutesPlayed,
        "organisation_name": organisationName,
        "user_organisations": userOrganisations == null
            ? []
            : List<dynamic>.from(userOrganisations!.map((x) => x.toJson())),
      };
}
