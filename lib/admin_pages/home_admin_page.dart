import 'package:flutter/material.dart';
import 'package:mobilejaksasumbar/admin_pages/jaksa_masuk_sekolah_admin/jaksa_masuk_sekolah_admin.dart';
import 'package:mobilejaksasumbar/admin_pages/pengaduan_korupsi_admin/pengaduan_korupsi_admin.dart';
import 'package:mobilejaksasumbar/admin_pages/pengaduan_pegawai_page/pengaduan_pegawai_admin.dart';
import 'package:mobilejaksasumbar/admin_pages/pengawasan_aliran_kepercayaan_admin/pengawasan_aliran_kepercayaan_admin.dart';
import 'package:mobilejaksasumbar/admin_pages/penyuluhan_hukum_admin/penyuluhan_hukum_admin.dart';
import 'package:mobilejaksasumbar/admin_pages/posko_pilkada_admin/posko_pilkada_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api_services.dart';

Future<String?> getUserName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_name');
}

Future<String?> getUserEmail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_email');
}

class HomeAdminPage extends StatefulWidget {
  final ApiServices apiService;
  final int userId;
  const HomeAdminPage({Key? key, required this.apiService, required this.userId}) : super(key: key);

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Welcome to Admin Page")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> PengaduanPegawaiAdmin()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.airline_seat_recline_normal_rounded,
                      color: Colors.green,
                      size: 50,
                    ),
                    Text(
                      "Pengaduan Pegawai",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PengaduanKorupsiAdmin()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.money_outlined,
                      color: Colors.red,
                      size: 50,
                    ),
                    Text(
                      "Pengaduan Tindak Pidana Korupsi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>JaksaMasukSekolahAdmin()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: Colors.blue,
                      size: 50,
                    ),
                    Text(
                      "Jaksa Masuk Sekolah",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PenyuluhanHukumAdmin()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.list_alt,
                      color: Colors.brown,
                      size: 50,
                    ),
                    Text(
                      "Penyuluhan Hukum",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PengawasanAliranKepercayaanAdmin()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 50,
                    ),
                    Text(
                      "Pengawasan Aliran dan Kepercayaan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PoskoPilkadaAdmin()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.house_siding_sharp,
                      color: Colors.orange,
                      size: 50,
                    ),
                    Text(
                      "Posko Pilkada",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
