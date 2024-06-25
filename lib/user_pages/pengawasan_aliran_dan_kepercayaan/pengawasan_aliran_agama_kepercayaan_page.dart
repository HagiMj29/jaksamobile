import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilejaksasumbar/user_pages/pengawasan_aliran_dan_kepercayaan/add_pengawasan_aliran_kepercayaan.dart';
import 'package:mobilejaksasumbar/user_pages/pengawasan_aliran_dan_kepercayaan/detail_pengawasan_aliran_kepercayaan.dart';
import 'package:mobilejaksasumbar/user_pages/pengawasan_aliran_dan_kepercayaan/edit_pengawasan_aliran_kepercayaan.dart';
import '../../model/api_services.dart';
import '../../model/model_aliran.dart';
import 'package:http/http.dart' as http;

class PengawasanAliranDanKepercayaan extends StatefulWidget {
  final int userId;
  final String noHp;
  final String nikKtp;
  final ApiServices apiService;
  const PengawasanAliranDanKepercayaan({Key? key, required this.userId, required this.noHp, required this.nikKtp, required this.apiService}) : super(key: key);

  @override
  State<PengawasanAliranDanKepercayaan> createState() => _PengawasanAliranDanKepercayaanState();
}

class _PengawasanAliranDanKepercayaanState extends State<PengawasanAliranDanKepercayaan> {

  String? noHp;
  String? nikKtp;
  List<Result> _aliranList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchaliran();
    });
  }

  void _fetchaliran() async {
    try {
      http.Response res =
      await http.get(Uri.parse('${AppConfig.baseUrl}/aliran'));
      if (res.statusCode == 200) {
        setState(() {
          _aliranList =
              modelAliranFromJson(res.body).result;
          _aliranList = _aliranList.where((pengaduan) => pengaduan.userId == widget.userId).toList();
        });
      } else {
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Color _getStatusColor(String status) {
    if (status == 'diproses') {
      return Colors.orange;
    } else if (status == 'disetujui') {
      return Colors.green;
    } else if (status == 'ditolak') {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  String _getFormattedStatus(String status) {
    if (status == 'diproses') {
      return 'Diproses';
    } else if (status == 'disetujui') {
      return 'Disetujui';
    } else if (status == 'ditolak') {
      return 'Ditolak';
    } else {
      return status;
    }
  }

  void _gotoAddAliran() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPengawasanAliranKepercayaan(
          userId: widget.userId,
          noHp : widget.noHp,
          nikKtp : widget.nikKtp,
          apiService: ApiServices(baseUrl: AppConfig.baseUrl),
        ),
      ),
    );

    if (result != null && result['success'] == true) {
    }
  }

  Future<void> deleteAliran(int id) async {
    try {
      // Hapus item secara lokal terlebih dahulu
      setState(() {
        _aliranList.removeWhere((pengaduan) => pengaduan.id == id);
      });

      final response = await http.delete(Uri.parse('${AppConfig.baseUrl}/aliran/$id'));

      if (response.statusCode == 200) {
        print('Pengaduan Pengawasan Aliran Kepercayaan deleted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data Berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Jika gagal, tambahkan item kembali ke daftar
        setState(() {
          _fetchaliran();
        });
        print('Failed to delete Pengaduan Aliran Kepercayaan: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data gagal dihapus'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error deleting Pengaduan Aliran Kepercayaan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat menghapus data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pengawasam Aliran dan Kepercayaan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: (){
             _gotoAddAliran();
          }, icon: Icon(Icons.add_box))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                      itemCount: _aliranList.length,
                      itemBuilder: (context, index) {
                        Result result = _aliranList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPengawasanAliranKepercayaan(
                                  data: result,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shadowColor: Colors.grey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        "Pengaduan ke",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        result.id.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        "Status : ",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        _getFormattedStatus(result.status),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: _getStatusColor(result.status),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 15, bottom: 10),
                                  child:
                                  Text("Tekan untuk detail pengaduan anda...."),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (_getFormattedStatus(result.status) == 'Diproses') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditPengawasanAliranKepercayaan(
                                                  pengaduanpegawai:
                                                  result, userId: widget.userId,),
                                              ),
                                            );
                                          } else if (_getFormattedStatus(result.status) == 'Disetujui' ||
                                              _getFormattedStatus(result.status) == 'Ditolak') {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Anda sudah tidak bisa mengedit data ini'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(CupertinoIcons.pen),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      InkWell(
                                        onTap: () {
                                          if (_getFormattedStatus(result.status) == 'Diproses') {
                                            deleteAliran(result.id);
                                          } else if (_getFormattedStatus(result.status) == 'Disetujui' ||
                                              _getFormattedStatus(result.status) == 'Ditolak') {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Anda sudah tidak bisa menghapus data ini'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(CupertinoIcons.trash),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ))
          ],
        ),
      ),
    );
  }
}
