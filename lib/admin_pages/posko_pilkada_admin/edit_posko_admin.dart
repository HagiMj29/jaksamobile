import 'package:flutter/material.dart';
import 'package:mobilejaksasumbar/admin_pages/posko_pilkada_admin/posko_pilkada_admin.dart';
import 'package:mobilejaksasumbar/model/model_posko.dart';

import '../../model/api_services.dart';

class EditPoskoAdmin extends StatefulWidget {
  final Result pengaduanposko;
  const EditPoskoAdmin({Key? key, required this.pengaduanposko});

  @override
  State<EditPoskoAdmin> createState() => _EditPoskoAdminState();
}

class _EditPoskoAdminState extends State<EditPoskoAdmin> {
  final ApiServices apiService = ApiServices(baseUrl: AppConfig.baseUrl);
  late TextEditingController _status;
  late String _selectedStatus;
  final List<String> _statuses = ['diproses', 'disetujui', 'ditolak'];

  @override
  void initState() {
    _selectedStatus = widget.pengaduanposko.status ?? _statuses[0];
    super.initState();
  }

  Future<void> _updateStatus() async {
    try {
      await apiService.updateStatusPosko(widget.pengaduanposko.id,  status: _selectedStatus, );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Status berhasil diperbarui'),
        backgroundColor: Colors.green,
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PoskoPilkadaAdmin(
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
