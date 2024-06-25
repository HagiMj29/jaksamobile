import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobilejaksasumbar/user_pages/pengaduan_tindak_pidana_korupsi/pengaduan_tindak_pidana_korupsi_page.dart';

import '../../model/api_services.dart';
import '../../model/model_pengaduan_korupsi.dart';

class EditPengaduanTindakPidanaKorupsi extends StatefulWidget {
  final int userId;
  final Result pengaduanKorupsi;

  const EditPengaduanTindakPidanaKorupsi({Key? key, required this.userId, required this.pengaduanKorupsi}) : super(key: key);

  @override
  State<EditPengaduanTindakPidanaKorupsi> createState() => _EditPengaduanTindakPidanaKorupsiState();
}

class _EditPengaduanTindakPidanaKorupsiState extends State<EditPengaduanTindakPidanaKorupsi> {
  final ApiServices apiService = ApiServices(baseUrl: AppConfig.baseUrl);
  String? _pdfKtpPath;
  String? _pdfPengaduanPath;
  String? noHp;
  String? nikKtp;

  late TextEditingController _noHpController;
  late TextEditingController _nikKtpController;
  late TextEditingController _uraianSingkat = TextEditingController();
  late TextEditingController _laporanPengaduanController = TextEditingController();


  @override
  void initState(){
    super.initState();
    _noHpController = TextEditingController(text: widget.pengaduanKorupsi.noHp);
    _nikKtpController = TextEditingController(text: widget.pengaduanKorupsi.nikKtp);
    _uraianSingkat = TextEditingController(text: widget.pengaduanKorupsi.uraianSingkatLaporan);
    _laporanPengaduanController = TextEditingController(text: widget.pengaduanKorupsi.laporanPengaduan);
    _pdfKtpPath = widget.pengaduanKorupsi.inputPdfKtp;
    _pdfPengaduanPath = widget.pengaduanKorupsi.inputPdfPengaduan;
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

      await apiService.updatePengaduanKorupsi(
        widget.pengaduanKorupsi.id,
        userId: widget.userId.toString(),
        noHp: _noHpController.text,
        nikKtp: _nikKtpController.text,
        uraianSingkat: _uraianSingkat.text,
        laporanPengaduan: _laporanPengaduanController.text,
        pdfKtp: pdfKtpBytes,
        pdfPengaduan: pdfPengaduanBytes,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PengaduanTindakPidanaKorupsi(
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
