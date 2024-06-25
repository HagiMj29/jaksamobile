import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobilejaksasumbar/user_pages/penyuluhan_hukum_page/add_penyuluhan_hukum.dart';
import 'package:mobilejaksasumbar/user_pages/penyuluhan_hukum_page/detail_penyuluhan_page.dart';
import 'package:mobilejaksasumbar/user_pages/penyuluhan_hukum_page/edit_penyuluhan_hukum.dart';
import '../../model/api_services.dart';
import '../../model/model_penyuluhan_hukum.dart';


class PenyuluhanHukumPage extends StatefulWidget {
  final int userId;
  final String noHp;
  final String nikKtp;
  final ApiServices apiService;
  const PenyuluhanHukumPage({Key? key, required this.userId, required this.noHp, required this.nikKtp, required this.apiService}) : super(key: key);

  @override
  State<PenyuluhanHukumPage> createState() => _PenyuluhanHukumPageState();
}

class _PenyuluhanHukumPageState extends State<PenyuluhanHukumPage> {
  String? noHp;
  String? nikKtp;
  List<Result> penyuluhanHukumList = [];


  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchpenyuluhanHukum();
    });
  }


  void _fetchpenyuluhanHukum() async {
    try {
      http.Response res =
      await http.get(Uri.parse('${AppConfig.baseUrl}/hukum'));
      if (res.statusCode == 200) {
        setState(() {
          penyuluhanHukumList =
              modelHukumFromJson(res.body).result;
          penyuluhanHukumList =
              penyuluhanHukumList.where((pengaduan) => pengaduan.userId ==
                  widget.userId).toList();
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

  void _goToPenyuluhanHukum() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPenyuluhanHukum(
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


  Future<void> deletePenyuluhan(int id) async {
    try {
      // Hapus item secara lokal terlebih dahulu
      setState(() {
        penyuluhanHukumList.removeWhere((penyuluhan) => penyuluhan.id == id);
      });

      final response = await http.delete(Uri.parse('${AppConfig.baseUrl}/hukum/$id'));

      if (response.statusCode == 200) {
        print('Pneyuluhan Hukum deleted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data Berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Jika gagal, tambahkan item kembali ke daftar
        setState(() {
          _fetchpenyuluhanHukum();
        });
        print('Failed to delete Penyuluhan Hukum: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data gagal dihapus'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error deleting Penyuluhan Hukum: $e');
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
          "Pengaduan Pelayanan Hukum",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {
            _goToPenyuluhanHukum();
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
                      itemCount: penyuluhanHukumList.length,
                      itemBuilder: (context, index) {
                        Result result = penyuluhanHukumList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPenyuluhanHukumPage(
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
                                            color: _getStatusColor(
                                                result.status),
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
                                                builder: (context) => EditPenyuluhanHukum(
                                                  penyuluhanHukumList:
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
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
                                            deletePenyuluhan(result.id);
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
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
