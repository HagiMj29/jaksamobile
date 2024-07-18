import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:http_parser/http_parser.dart';

class AppConfig {
  static const String baseUrl = "http://192.168.1.6:8000/api";
  static const String baseStorage = 'http://192.168.1.6:8000/storage/';
}

class ApiServices {
  final String baseUrl;

  ApiServices({required this.baseUrl});

  String getFullPdfUrl(String relativePath) {
    return '${AppConfig.baseStorage}$relativePath';
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String noHp, String nikKtp, String password, String alamat) async {
    final Uri uri = Uri.parse('$baseUrl/register');
    final Map<String, String> body = {
      'name': name,
      'email': email,
      'no_hp': noHp,
      'nik_ktp': nikKtp,
      'password': password,
      'alamat': alamat,
    };

    final http.Response response = await http.post(uri, body: body);

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to Register: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> uploadPengaduan({
    required String userId,
    required String noHp,
    required String nikKtp,
    required String laporanPengaduan,
    required Uint8List pdfKtp,
    required Uint8List pdfPengaduan,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/pengaduanpegawai');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'user_id': userId,
      'no_hp': noHp,
      'nik_ktp': nikKtp,
      'laporan_pengaduan': laporanPengaduan,
    });

    request.files.add(http.MultipartFile.fromBytes(
      'input_pdf_ktp',
      pdfKtp,
      filename: 'ktp.pdf',
      contentType: MediaType('application', 'pdf'),
    ));

    request.files.add(http.MultipartFile.fromBytes(
      'input_pdf_pengaduan',
      pdfPengaduan,
      filename: 'pengaduan.pdf',
      contentType: MediaType('application', 'pdf'),
    ));

    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 201) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }

  Future<Map<String, dynamic>> updatePengaduan(int id,{
    required String userId,
    required String noHp,
    required String nikKtp,
    required String laporanPengaduan,
    Uint8List? pdfKtp,
    Uint8List? pdfPengaduan,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/pengaduanpegawai/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'user_id': userId,
      'no_hp': noHp,
      'nik_ktp': nikKtp,
      'laporan_pengaduan': laporanPengaduan,
    });

    if (pdfKtp != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'input_pdf_ktp',
        pdfKtp,
        filename: 'ktp.pdf',
        contentType: MediaType('application', 'pdf'),
      ));
    }

    if (pdfPengaduan != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'input_pdf_pengaduan',
        pdfPengaduan,
        filename: 'pengaduan.pdf',
        contentType: MediaType('application', 'pdf'),
      ));
    }

    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 200) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }


  Future<Map<String, dynamic>> uploadPengaduanKorupsi({
    required String userId,
    required String noHp,
    required String nikKtp,
    required String uraianSingkat,
    required String laporanPengaduan,
    required Uint8List pdfKtp,
    required Uint8List pdfPengaduan,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/pengaduankorupsi');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'user_id': userId,
      'no_hp': noHp,
      'nik_ktp': nikKtp,
      'uraian_singkat_laporan' :uraianSingkat,
      'laporan_pengaduan': laporanPengaduan,
    });

    request.files.add(http.MultipartFile.fromBytes(
      'input_pdf_ktp',
      pdfKtp,
      filename: 'ktp.pdf',
      contentType: MediaType('application', 'pdf'),
    ));

    request.files.add(http.MultipartFile.fromBytes(
      'input_pdf_pengaduan',
      pdfPengaduan,
      filename: 'pengaduan.pdf',
      contentType: MediaType('application', 'pdf'),
    ));

    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 201) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }

  Future<Map<String, dynamic>> updatePengaduanKorupsi(int id,{
    required String userId,
    required String noHp,
    required String nikKtp,
    required String uraianSingkat,
    required String laporanPengaduan,
    Uint8List? pdfKtp,
    Uint8List? pdfPengaduan,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/pengaduankorupsi/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'user_id': userId,
      'no_hp': noHp,
      'nik_ktp': nikKtp,
      'uraian_singkat_laporan' :uraianSingkat,
      'laporan_pengaduan': laporanPengaduan,
    });

    if (pdfKtp != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'input_pdf_ktp',
        pdfKtp,
        filename: 'ktp.pdf',
        contentType: MediaType('application', 'pdf'),
      ));
    }

    if (pdfPengaduan != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'input_pdf_pengaduan',
        pdfPengaduan,
        filename: 'pengaduan.pdf',
        contentType: MediaType('application', 'pdf'),
      ));
    }

    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 200) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }


  Future<Map<String, dynamic>> uploadJaksa({
    required String userId,
    required String sekolah,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/jaksa');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'user_id': userId,
        'sekolah': sekolah,
      },
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to upload pengaduan: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> editJaksa(int id,{
    required String userId,
    required String sekolah,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/jaksa/$id');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'user_id': userId,
        'sekolah': sekolah,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to upload pengaduan: ${response.body}');
    }
  }



  Future<Map<String, dynamic>> uploadPelayananHukum({
    required String userId,
    required String noHp,
    required String nikKtp,
    required String bentukPermasalahan,
    required Uint8List pdfKtp,
    required Uint8List pdfBentukPermasalahan,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/hukum');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'user_id': userId,
      'no_hp': noHp,
      'nik_ktp': nikKtp,
      'bentuk_permasalahan' :bentukPermasalahan,
    });

    request.files.add(http.MultipartFile.fromBytes(
      'input_pdf_ktp',
      pdfKtp,
      filename: 'ktp.pdf',
      contentType: MediaType('application', 'pdf'),
    ));

    request.files.add(http.MultipartFile.fromBytes(
      'input_pdf_permasalahan',
      pdfBentukPermasalahan,
      filename: 'permasalahan.pdf',
      contentType: MediaType('application', 'pdf'),
    ));

    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 201) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload penyuluhan: $responseData');
    }
  }

  Future<Map<String, dynamic>> updatePenyuluhanHukum(int id,{
    required String userId,
    required String noHp,
    required String nikKtp,
    required String bentukPermasalahan,
    Uint8List? pdfKtp,
    Uint8List? pdfBentukPermasalahan,

  }) async {
    final Uri uri = Uri.parse('$baseUrl/hukum/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'user_id': userId,
      'no_hp': noHp,
      'nik_ktp': nikKtp,
      'bentuk_permasalahan' :bentukPermasalahan,
    });

    if (pdfKtp != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'input_pdf_ktp',
        pdfKtp,
        filename: 'ktp.pdf',
        contentType: MediaType('application', 'pdf'),
      ));
    }

    if (pdfBentukPermasalahan != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'input_pdf_permasalahan',
        pdfBentukPermasalahan,
        filename: 'permasalahan.pdf',
        contentType: MediaType('application', 'pdf'),
      ));
    }

    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 200) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to update penyuluhan hukum: $responseData');
    }
  }

  Future<Map<String, dynamic>> uploadAliran({
    required String userId,
    required String noHp,
    required String nikKtp,
    required String laporanPengaduan,
    required Uint8List pdfKtp,
    required Uint8List pdfPengaduan,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/aliran');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'user_id': userId,
      'no_hp': noHp,
      'nik_ktp': nikKtp,
      'laporan_pengaduan': laporanPengaduan,
    });

    request.files.add(http.MultipartFile.fromBytes(
      'input_pdf_ktp',
      pdfKtp,
      filename: 'ktp.pdf',
      contentType: MediaType('application', 'pdf'),
    ));

    request.files.add(http.MultipartFile.fromBytes(
      'input_pdf_pengaduan',
      pdfPengaduan,
      filename: 'pengaduan.pdf',
      contentType: MediaType('application', 'pdf'),
    ));

    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 201) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }

  Future<Map<String, dynamic>> updateAliran(int id,{
    required String userId,
    required String noHp,
    required String nikKtp,
    required String laporanPengaduan,
    Uint8List? pdfKtp,
    Uint8List? pdfPengaduan,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/aliran/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'user_id': userId,
      'no_hp': noHp,
      'nik_ktp': nikKtp,
      'laporan_pengaduan': laporanPengaduan,
    });

    if (pdfKtp != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'input_pdf_ktp',
        pdfKtp,
        filename: 'ktp.pdf',
        contentType: MediaType('application', 'pdf'),
      ));
    }

    if (pdfPengaduan != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'input_pdf_pengaduan',
        pdfPengaduan,
        filename: 'pengaduan.pdf',
        contentType: MediaType('application', 'pdf'),
      ));
    }

    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 200) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }

  Future<Map<String, dynamic>> uploadPosko({
    required String userId,
    required String noHp,
    required String nikKtp,
    required String laporanPengaduan,
    required Uint8List pdfKtp,
    required Uint8List pdfPengaduan,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/posko');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'user_id': userId,
      'no_hp': noHp,
      'nik_ktp': nikKtp,
      'laporan_pengaduan': laporanPengaduan,
    });

    request.files.add(http.MultipartFile.fromBytes(
      'input_pdf_ktp',
      pdfKtp,
      filename: 'ktp.pdf',
      contentType: MediaType('application', 'pdf'),
    ));

    request.files.add(http.MultipartFile.fromBytes(
      'input_pdf_pengaduan',
      pdfPengaduan,
      filename: 'pengaduan.pdf',
      contentType: MediaType('application', 'pdf'),
    ));

    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 201) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }

  Future<Map<String, dynamic>> updatePosko(int id,{
    required String userId,
    required String noHp,
    required String nikKtp,
    required String laporanPengaduan,
    Uint8List? pdfKtp,
    Uint8List? pdfPengaduan,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/posko/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'user_id': userId,
      'no_hp': noHp,
      'nik_ktp': nikKtp,
      'laporan_pengaduan': laporanPengaduan,
    });

    if (pdfKtp != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'input_pdf_ktp',
        pdfKtp,
        filename: 'ktp.pdf',
        contentType: MediaType('application', 'pdf'),
      ));
    }

    if (pdfPengaduan != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'input_pdf_pengaduan',
        pdfPengaduan,
        filename: 'pengaduan.pdf',
        contentType: MediaType('application', 'pdf'),
      ));
    }

    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 200) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }

  Future<Map<String, dynamic>> updateStatusPegawai(int id,{
    required String status,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/editstatuspegawai/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'status': status,
    });
    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 200) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }

  Future<Map<String, dynamic>> updateStatusKorupsi(int id,{
    required String status,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/editstatuskorupsi/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'status': status,
    });
    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 200) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }

  Future<Map<String, dynamic>> updateStatusJaksa(int id,{
    required String status,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/editstatusjaksa/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'status': status,
    });
    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 200) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }

  Future<Map<String, dynamic>> updateStatusHukum(int id,{
    required String status,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/editstatushukum/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'status': status,
    });
    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 200) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }

  Future<Map<String, dynamic>> updateStatusAliran(int id,{
    required String status,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/editstatusaliran/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'status': status,
    });
    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 200) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }

  Future<Map<String, dynamic>> updateStatusPosko(int id,{
    required String status,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/editstatusposko/$id');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'status': status,
    });
    final response = await request.send();
    final String responseData = await utf8.decodeStream(response.stream);

    if (response.statusCode == 200) {
      return json.decode(responseData.toString());
    } else {
      throw Exception('Failed to upload pengaduan: $responseData');
    }
  }




}



