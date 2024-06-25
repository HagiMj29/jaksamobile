// To parse this JSON data, do
//
//     final modelHukum = modelHukumFromJson(jsonString);

import 'dart:convert';

ModelHukum modelHukumFromJson(String str) => ModelHukum.fromJson(json.decode(str));

String modelHukumToJson(ModelHukum data) => json.encode(data.toJson());

class ModelHukum {
  String message;
  List<Result> result;

  ModelHukum({
    required this.message,
    required this.result,
  });

  factory ModelHukum.fromJson(Map<String, dynamic> json) => ModelHukum(
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
  int userId;
  String userName;
  String noHp;
  String nikKtp;
  String inputPdfKtp;
  String bentukPermasalahan;
  String inputPdfPermasalahan;
  String status;

  Result({
    required this.id,
    required this.userId,
    required this.userName,
    required this.noHp,
    required this.nikKtp,
    required this.inputPdfKtp,
    required this.bentukPermasalahan,
    required this.inputPdfPermasalahan,
    required this.status,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    userId: json["user_id"],
    userName: json["user_name"],
    noHp: json["no_hp"],
    nikKtp: json["nik_ktp"],
    inputPdfKtp: json["input_pdf_ktp"],
    bentukPermasalahan: json["bentuk_permasalahan"],
    inputPdfPermasalahan: json["input_pdf_permasalahan"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "user_name": userName,
    "no_hp": noHp,
    "nik_ktp": nikKtp,
    "input_pdf_ktp": inputPdfKtp,
    "bentuk_permasalahan": bentukPermasalahan,
    "input_pdf_permasalahan": inputPdfPermasalahan,
    "status": status,
  };
}
