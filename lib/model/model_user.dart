// To parse this JSON data, do
//
//     final modelUser = modelUserFromJson(jsonString);

import 'dart:convert';

ModelUser modelUserFromJson(String str) => ModelUser.fromJson(json.decode(str));

String modelUserToJson(ModelUser data) => json.encode(data.toJson());

class ModelUser {
  String message;
  List<Result> result;

  ModelUser({
    required this.message,
    required this.result,
  });

  factory ModelUser.fromJson(Map<String, dynamic> json) => ModelUser(
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  int id;
  String name;
  String email;
  String noHp;
  String nikKtp;
  String password;
  String alamat;

  Result({
    required this.id,
    required this.name,
    required this.email,
    required this.noHp,
    required this.nikKtp,
    required this.password,
    required this.alamat,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    noHp: json["no_hp"],
    nikKtp: json["nik_ktp"],
    password: json["password"],
    alamat: json["alamat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "no_hp": noHp,
    "nik_ktp": nikKtp,
    "password": password,
    "alamat": alamat,
  };
}
