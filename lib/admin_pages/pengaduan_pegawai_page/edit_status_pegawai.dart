import 'package:flutter/material.dart';
import 'package:mobilejaksasumbar/admin_pages/pengaduan_pegawai_page/pengaduan_pegawai_admin.dart';

import '../../model/api_services.dart';
import '../../model/model_pengaduan_pegawai.dart';

class EditStatusPegawai extends StatefulWidget {
  final Result pengaduanpegawai;
  const EditStatusPegawai({Key? key, required this.pengaduanpegawai}) : super(key: key);

  @override
  State<EditStatusPegawai> createState() => _EditStatusPegawaiState();
}

class _EditStatusPegawaiState extends State<EditStatusPegawai> {
  final ApiServices apiService = ApiServices(baseUrl: AppConfig.baseUrl);
  late TextEditingController _status;
  late String _selectedStatus;
  final List<String> _statuses = ['diproses', 'disetujui', 'ditolak'];

  @override
  void initState() {
    _selectedStatus = widget.pengaduanpegawai.status ?? _statuses[0];
    super.initState();
  }

  Future<void> _updateStatus() async {
    try {
      await apiService.updateStatusPegawai(widget.pengaduanpegawai.id,  status: _selectedStatus, );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Status berhasil diperbarui'),
        backgroundColor: Colors.green,
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PengaduanPegawaiAdmin(
          ),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal memperbarui status: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Pengaduan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButton<String>(
                value: _selectedStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
                items: _statuses.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateStatus,
                child: Text('Perbarui Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
