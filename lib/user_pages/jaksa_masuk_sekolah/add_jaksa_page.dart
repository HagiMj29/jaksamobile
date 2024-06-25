import 'package:flutter/material.dart';

import '../../model/api_services.dart';

class AddJaksaPage extends StatefulWidget {
  final int userId;
  final ApiServices apiService;
  const AddJaksaPage({Key? key, required this.userId, required this.apiService}) : super(key: key);

  @override
  State<AddJaksaPage> createState() => _AddJaksaPageState();
}

class _AddJaksaPageState extends State<AddJaksaPage> {
  final TextEditingController sekolahController = TextEditingController();


  Future<void> _submitJaksa() async {
      try{
        await widget.apiService.uploadJaksa(
            userId: widget.userId.toString(),
            sekolah: sekolahController.text
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('berhasil menambahkan data'),
          backgroundColor: Colors.green
        ));
      }catch (e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menambahkan data: $e'),
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
                controller: sekolahController,
                decoration: InputDecoration(labelText: 'Sekolah'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitJaksa,
                child: Text('Kirim Pengaduan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
