import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import '../../model/api_services.dart';
import '../../model/model_penyuluhan_hukum.dart';
import 'package:http/http.dart' as http;

class DetailPenyuluhanHukumPage extends StatefulWidget {
  final Result data;
  const DetailPenyuluhanHukumPage({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailPenyuluhanHukumPage> createState() => _DetailPenyuluhanHukumPageState();
}

class _DetailPenyuluhanHukumPageState extends State<DetailPenyuluhanHukumPage> {
  late final ApiServices apiServices;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    apiServices = ApiServices(baseUrl: 'http://192.168.1.6:8000/storage/app/');
  }

  Color _getStatusColor(String status) {
    if (status == 'diproses') {
      return Colors.orange;
    } else if (status == 'disetujui') {
      return Colors.green;
    } else if (status == 'ditolak') {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  String _getFormattedStatus(String status) {
    if (status == 'diproses') {
      return 'Diproses';
    } else if (status == 'disetujui') {
      return 'Disetujui';
    } else if (status == 'ditolak') {
      return 'Ditolak';
    } else {
      return status;
    }
  }

  Future<void> _openPdf(String relativePath) async {
    setState(() {
      isLoading = true; // Set isLoading menjadi true saat mulai mengunduh
    });

    final fullUrl = apiServices.getFullPdfUrl(relativePath);
    try {
      final localPath = await downloadPdf(fullUrl);
      setState(() {
        isLoading = false; // Set isLoading menjadi false setelah selesai mengunduh
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(filePath: localPath),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Set isLoading menjadi false jika terjadi kesalahan
      });
      print('Error loading PDF: $e');
    }
  }

  Future<String> downloadPdf(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final tempDir = await getTemporaryDirectory();
      final fileName = url.split('/').last;
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(response.bodyBytes, flush: true);
      return tempFile.path;
    } else {
      throw Exception('Failed to load PDF');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Pelayanan Hukum",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Pengguna: ${widget.data.userName}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Nomor HP: ${widget.data.noHp}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'NIK KTP: ${widget.data.nikKtp}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _openPdf(widget.data.inputPdfKtp);
              },
              child: Text("Lihat PDF KTP"),
            ),
            SizedBox(height: 10),
            Text(
              'Uraian Bentuk Permasalahan: ${widget.data.bentukPermasalahan}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _openPdf(widget.data.inputPdfPermasalahan);
              },
              child: Text("Lihat PDF Pengaduan"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  _getFormattedStatus(widget.data.status),
                  style: TextStyle(
                      fontSize: 18, color: _getStatusColor(widget.data.status)),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (isLoading) // Menampilkan indikator pengunduhan jika isLoading true
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String filePath;

  const PdfViewerPage({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lihat PDF'),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}