// To parse this JSON data, do
//
//     final modelPengaduanKorupsi = modelPengaduanKorupsiFromJson(jsonString);

import 'dart:convert';

ModelPengaduanKorupsi modelPengaduanKorupsiFromJson(String str) => ModelPengaduanKorupsi.fromJson(json.decode(str));

String modelPengaduanKorupsiToJson(ModelPengaduanKorupsi data) => json.encode(data.toJson());

class ModelPengaduanKorupsi {
  String message;
  List<Result> result;

  ModelPengaduanKorupsi({
    required this.message,
    required this.result,
  });

  factory ModelPengaduanKorupsi.fromJson(Map<String, dynamic> json) => ModelPengaduanKorupsi(
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
  String uraianSingkatLaporan;
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
    required this.uraianSingkatLaporan,
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
    uraianSingkatLaporan: json["uraian_singkat_laporan"],
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
    "uraian_singkat_laporan": uraianSingkatLaporan,
    "laporan_pengaduan": laporanPengaduan,
    "input_pdf_pengaduan": inputPdfPengaduan,
    "status": status,
  };
}
