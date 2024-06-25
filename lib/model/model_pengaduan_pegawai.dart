// To parse this JSON data, do
//
//     final modelPengaduanPegawai = modelPengaduanPegawaiFromJson(jsonString);

import 'dart:convert';

ModelPengaduanPegawai modelPengaduanPegawaiFromJson(String str) => ModelPengaduanPegawai.fromJson(json.decode(str));

String modelPengaduanPegawaiToJson(ModelPengaduanPegawai data) => json.encode(data.toJson());

class ModelPengaduanPegawai {
  String message;
  List<Result> result;

  ModelPengaduanPegawai({
    required this.message,
    required this.result,
  });

  factory ModelPengaduanPegawai.fromJson(Map<String, dynamic> json) => ModelPengaduanPegawai(
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
  String laporanPengaduan;
  String inputPdfPengaduan;
  String status;

  Result({
    required this.id,
    required this.userId,
    required this.userName,
    required this.noHp,
    required this.nikKtp,
    required this.inputPdfKtp,
    required this.laporanPengaduan,
    required this.inputPdfPengaduan,
    required this.status,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    userId: json["user_id"],
    userName: json["user_name"],
    noHp: json["no_hp"],
    nikKtp: json["nik_ktp"],
    inputPdfKtp: json["input_pdf_ktp"],
    laporanPengaduan: json["laporan_pengaduan"],
    inputPdfPengaduan: json["input_pdf_pengaduan"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "user_name": userName,
    "no_hp": noHp,
    "nik_ktp": nikKtp,
    "input_pdf_ktp": inputPdfKtp,
    "laporan_pengaduan": laporanPengaduan,
    "input_pdf_pengaduan": inputPdfPengaduan,
    "status": status,
  };
}
