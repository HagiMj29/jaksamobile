import 'package:flutter/material.dart';
import 'package:mobilejaksasumbar/admin_pages/pengawasan_aliran_kepercayaan_admin/pengawasan_aliran_kepercayaan_admin.dart';

import '../../model/api_services.dart';
import '../../model/model_aliran.dart';

class EditAliranAdmin extends StatefulWidget {
  final Result pengaduankepercayaan;
  const EditAliranAdmin({Key? key, required this.pengaduankepercayaan}) : super(key: key);

  @override
  State<EditAliranAdmin> createState() => _EditAliranAdminState();
}

class _EditAliranAdminState extends State<EditAliranAdmin> {
  final ApiServices apiService = ApiServices(baseUrl: AppConfig.baseUrl);
  late TextEditingController _status;
  late String _selectedStatus;
  final List<String> _statuses = ['diproses', 'disetujui', 'ditolak'];

  @override
  void initState() {
    _selectedStatus = widget.pengaduankepercayaan.status ?? _statuses[0];
    super.initState();
  }

  Future<void> _updateStatus() async {
    try {
      await apiService.updateStatusAliran(widget.pengaduankepercayaan.id,  status: _selectedStatus, );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Status berhasil diperbarui'),
        backgroundColor: Colors.green,
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PengawasanAliranKepercayaanAdmin(
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
