import 'package:flutter/material.dart';

import '../../model/api_services.dart';
import '../../model/model_jaksa.dart';

class EditJaksaPage extends StatefulWidget {
  final int userId;
  final Result jaksa;
  const EditJaksaPage({Key? key, required this.userId, required this.jaksa}) : super(key: key);



  @override
  State<EditJaksaPage> createState() => _EditJaksaPageState();
}

class _EditJaksaPageState extends State<EditJaksaPage> {
  final ApiServices apiService = ApiServices(baseUrl: AppConfig.baseUrl);
  late TextEditingController sekolahController = TextEditingController();

  @override
  void initState(){
    super.initState();
    sekolahController = TextEditingController(text: widget.jaksa.sekolah);
  }


  Future<void> submitEditJaksa() async {
    try{
      await apiService.editJaksa(
          widget.jaksa.id,
          userId: widget.userId.toString(),
          sekolah: sekolahController.text
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('berhasil mengubah data'),
          backgroundColor: Colors.green
      ));
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal mengubah data: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                onPressed: submitEditJaksa,
                child: Text('Kirim Pengaduan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
