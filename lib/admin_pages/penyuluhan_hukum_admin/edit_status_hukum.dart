import 'package:flutter/material.dart';
import 'package:mobilejaksasumbar/admin_pages/penyuluhan_hukum_admin/penyuluhan_hukum_admin.dart';

import '../../model/api_services.dart';
import '../../model/model_penyuluhan_hukum.dart';

class EditStatusHukum extends StatefulWidget {
  final Result pengaduanhukum;
  const EditStatusHukum({Key? key, required this.pengaduanhukum}) : super(key: key);

  @override
  State<EditStatusHukum> createState() => _EditStatusHukumState();
}

class _EditStatusHukumState extends State<EditStatusHukum> {
  final ApiServices apiService = ApiServices(baseUrl: AppConfig.baseUrl);
  late TextEditingController _status;
  late String _selectedStatus;
  final List<String> _statuses = ['diproses', 'disetujui', 'ditolak'];


  @override
  void initState() {
    _selectedStatus = widget.pengaduanhukum.status ?? _statuses[0];
    super.initState();
  }

  Future<void> _updateStatus() async {
    try {
      await apiService.updateStatusHukum(widget.pengaduanhukum.id,  status: _selectedStatus, );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Status berhasil diperbarui'),
        backgroundColor: Colors.green,
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PenyuluhanHukumAdmin(
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
