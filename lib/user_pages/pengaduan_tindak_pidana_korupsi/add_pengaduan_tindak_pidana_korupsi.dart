import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../model/api_services.dart';

class AddPengaduanKorupsi extends StatefulWidget {
  final int userId;
  final String nikKtp;
  final String noHp;
  final ApiServices apiService;
  const AddPengaduanKorupsi({Key? key, required this.userId, required this.nikKtp, required this.noHp, required this.apiService}) : super(key: key);

  @override
  State<AddPengaduanKorupsi> createState() => _AddPengaduanKorupsiState();
}

class _AddPengaduanKorupsiState extends State<AddPengaduanKorupsi> {
  Uint8List? _pdfKtp;
  Uint8List? _pdfPengaduan;
  String? _pdfKtpPath;
  String? _pdfPengaduanPath;
  String? noHp;
  String? nikKtp;

  late TextEditingController _noHpController;
  late TextEditingController _nikKtpController;
  final TextEditingController _uraianSingkat = TextEditingController();
  final TextEditingController _laporanPengaduanController = TextEditingController();

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _noHpController = TextEditingController(text: widget.noHp);
    _nikKtpController = TextEditingController(text: widget.nikKtp);
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

  Future<void> _submitPengaduan() async {
    if (_pdfKtpPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('PDF KTP harus dipilih'),
      ));
      return;
    }

    if (_pdfPengaduanPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('PDF Pengaduan harus dipilih'),
      ));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      Uint8List pdfKtpBytes = await File(_pdfKtpPath!).readAsBytes();
      Uint8List pdfPengaduanBytes = await File(_pdfPengaduanPath!).readAsBytes();

      await widget.apiService.uploadPengaduanKorupsi(
        userId: widget.userId.toString(),
        noHp: _noHpController.text,
        nikKtp: _nikKtpController.text,
        uraianSingkat: _uraianSingkat.text,
        pdfKtp: pdfKtpBytes,
        laporanPengaduan: _laporanPengaduanController.text,
        pdfPengaduan: pdfPengaduanBytes,
      );
      setState(() {
        _isUploading = false;
      });

    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal mengirim pengaduan: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Pengaduan${widget.userId.toString()}'),
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
                controller: _uraianSingkat,
                decoration: InputDecoration(labelText: 'Uraian Singkat'),
              ),
              TextField(
                controller: _laporanPengaduanController,
                decoration: InputDecoration(labelText: 'Laporan Pengaduan'),
              ),
              ElevatedButton(
                onPressed: _pickPdfKtp,
                child: Text('Pilih PDF KTP'),
              ),
              if (_pdfKtpPath != null)
                Container(
                  height: 300,
                  child: PDFView(
                    filePath: _pdfKtpPath,
                  ),
                ),
              ElevatedButton(
                onPressed: _pickPdfPengaduan,
                child: Text('Pilih PDF Pengaduan'),
              ),
              if (_pdfPengaduanPath != null)
                Container(
                  height: 300,
                  child: PDFView(
                    filePath: _pdfPengaduanPath,
                  ),
                ),
              SizedBox(height: 20),
              _isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submitPengaduan,
                child: Text('Kirim Pengaduan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
