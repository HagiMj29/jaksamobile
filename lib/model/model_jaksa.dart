// To parse this JSON data, do
//
//     final modelJaksa = modelJaksaFromJson(jsonString);

import 'dart:convert';

ModelJaksa modelJaksaFromJson(String str) => ModelJaksa.fromJson(json.decode(str));

String modelJaksaToJson(ModelJaksa data) => json.encode(data.toJson());

class ModelJaksa {
  String message;
  List<Result> result;

  ModelJaksa({
    required this.message,
    required this.result,
  });

  factory ModelJaksa.fromJson(Map<String, dynamic> json) => ModelJaksa(
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
  String sekolah;
  String status;

  Result({
    required this.id,
    required this.userId,
    required this.userName,
    required this.sekolah,
    required this.status,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    userId: json["user_id"],
    userName: json["user_name"],
    sekolah: json["sekolah"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "user_name": userName,
    "sekolah": sekolah,
    "status": status,
  };
}
