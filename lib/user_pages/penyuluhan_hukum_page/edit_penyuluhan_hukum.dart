import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobilejaksasumbar/user_pages/penyuluhan_hukum_page/penyuluhan_hukum_page.dart';

import '../../model/api_services.dart';
import '../../model/model_penyuluhan_hukum.dart';

class EditPenyuluhanHukum extends StatefulWidget {
  final int userId;
  final Result penyuluhanHukumList;
  const EditPenyuluhanHukum({Key? key, required this.userId, required this.penyuluhanHukumList}) : super(key: key);

  @override
  State<EditPenyuluhanHukum> createState() => _EditPenyuluhanHukumState();
}

class _EditPenyuluhanHukumState extends State<EditPenyuluhanHukum> {
  final ApiServices apiService = ApiServices(baseUrl: AppConfig.baseUrl);
  String? _pdfKtpPath;
  String? _pdfPengaduanPath;
  String? noHp;
  String? nikKtp;

  late TextEditingController _noHpController;
  late TextEditingController _nikKtpController;
  late TextEditingController _bentukPermasalahan = TextEditingController();

  @override
  void initState(){
    super.initState();
    _noHpController = TextEditingController(text: widget.penyuluhanHukumList.noHp);
    _nikKtpController = TextEditingController(text: widget.penyuluhanHukumList.nikKtp);
    _bentukPermasalahan = TextEditingController(text: widget.penyuluhanHukumList.bentukPermasalahan);
    _pdfKtpPath = widget.penyuluhanHukumList.inputPdfKtp;
    _pdfPengaduanPath = widget.penyuluhanHukumList.inputPdfPermasalahan;
  }

  Future<void> _pickPdfKtp() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdfKtpPath = result.files.single.path;
      });
      print('PDF KTP berhasil dipilih: ${result.files.single.name}');
    } else {
      print('Gagal memilih PDF KTP');
    }
  }

  Future<void> _pickPdfPengaduan() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdfPengaduanPath = result.files.single.path;
      });
      print('PDF Pengaduan berhasil dipilih: ${result.files.single.name}');
    } else {
      print('Gagal memilih PDF Pengaduan');
    }
  }

  Future<void> updatePengaduan() async {
    if (_pdfKtpPath == null || _pdfPengaduanPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('PDF KTP dan PDF Pengaduan harus dipilih'),
      ));
      return;
    }

    try {
      Uint8List pdfKtpBytes = await File(_pdfKtpPath!).readAsBytes();
      Uint8List pdfPengaduanBytes = await File(_pdfPengaduanPath!).readAsBytes();

      await apiService.updatePenyuluhanHukum(
        widget.penyuluhanHukumList.id,
        userId: widget.userId.toString(),
        noHp: _noHpController.text,
        nikKtp: _nikKtpController.text,
        bentukPermasalahan: _bentukPermasalahan.text,
        pdfKtp: pdfKtpBytes,
        pdfBentukPermasalahan: pdfPengaduanBytes,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PenyuluhanHukumPage(
            userId: widget.userId,
            apiService: apiService,
            nikKtp: _nikKtpController.text,
            noHp: _noHpController.text,
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pengaduan berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, {'success': true});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui pengaduan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Penyuluhan Hukum${widget.userId.toString()}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _noHpController,
                decoration: InputDecoration(labelText: 'Nomor HP'),
              ),
              TextField(
                controller: _nikKtpController,
                decoration: InputDecoration(labelText: 'NIK KTP'),
              ),
              TextField(
                controller: _bentukPermasalahan,
                decoration: InputDecoration(labelText: 'Bentuk Permasalahan'),
              ),
              ElevatedButton(
                onPressed: _pickPdfKtp,
                child: Text('Pilih PDF KTP'),
              ),
              // if (_pdfKtpPath != null)
              //   Container(
              //     height: 300,
              //     child: PDFView(
              //       filePath: _pdfKtpPath,
              //     ),
              //   ),
              ElevatedButton(
                onPressed: _pickPdfPengaduan,
                child: Text('Pilih PDF Pengaduan'),
              ),
              // if (_pdfPengaduanPath != null)
              //   Container(
              //     height: 300,
              //     child: PDFView(
              //       filePath: _pdfPengaduanPath,
              //     ),
              //   ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updatePengaduan,
                child: Text('Kirim Pengaduan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
