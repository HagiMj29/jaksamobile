import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilejaksasumbar/user_pages/jaksa_masuk_sekolah/add_jaksa_page.dart';
import 'package:mobilejaksasumbar/user_pages/jaksa_masuk_sekolah/edit_jaksa_page.dart';
import '../../model/api_services.dart';
import '../../model/model_jaksa.dart';
import 'package:http/http.dart' as http;

class JaksaMasukSekolah extends StatefulWidget {
  final int userId;
  final ApiServices apiService;

  const JaksaMasukSekolah(
      {Key? key, required this.userId, required this.apiService})
      : super(key: key);

  @override
  State<JaksaMasukSekolah> createState() => _JaksaMasukSekolahState();
}

class _JaksaMasukSekolahState extends State<JaksaMasukSekolah> {
  List<Result> _jaksaList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchJaksa();
    });
  }

  void _fetchJaksa() async {
    try {
      http.Response res =
          await http.get(Uri.parse('${AppConfig.baseUrl}/jaksa'));
      if (res.statusCode == 200) {
        setState(() {
          _jaksaList = modelJaksaFromJson(res.body).result;
          _jaksaList = _jaksaList
              .where((pengaduan) => pengaduan.userId == widget.userId)
              .toList();
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

  void _gotoAddJaksa() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddJaksaPage(
          userId: widget.userId,
          apiService: ApiServices(baseUrl: AppConfig.baseUrl),
        ),
      ),
    );

    if (result != null && result['success'] == true) {
    }
  }

  Future<void> deleteJaksa(int id) async {
    try {
      // Hapus item secara lokal terlebih dahulu
      setState(() {
        _jaksaList.removeWhere((jaksa) => jaksa.id == id);
      });

      final response = await http.delete(Uri.parse('${AppConfig.baseUrl}/jaksa/$id'));

      if (response.statusCode == 200) {
        print('Jaksa deleted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data Berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Jika gagal, tambahkan item kembali ke daftar
        setState(() {
          _fetchJaksa();
        });
        print('Failed to delete jaksa: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data gagal dihapus'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error deleting Jaksa: $e');
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
          "Jaksa Masuk Sekolah",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _gotoAddJaksa();
              },
              icon: Icon(Icons.add_box))
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
                  itemCount: _jaksaList.length,
                  itemBuilder: (context, index) {
                    Result result = _jaksaList[index];
                    return GestureDetector(
                      onTap: () {
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
                                    "${result.userName} ",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                  SizedBox(height: 10,),
                                  Text("Sekolah : ${result.sekolah}", style: TextStyle(
                                    fontSize: 20
                                  ),),
                                ],
                              ),
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
                                      if (_getFormattedStatus(result.status) ==
                                          'Diproses') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditJaksaPage(
                                              jaksa: result,
                                              userId: widget.userId,
                                            ),
                                          ),
                                        );
                                      } else if (_getFormattedStatus(
                                                  result.status) ==
                                              'Disetujui' ||
                                          _getFormattedStatus(result.status) ==
                                              'Ditolak') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Anda sudah tidak bisa mengedit data ini'),
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_getFormattedStatus(result.status) ==
                                          'Diproses') {
                                        deleteJaksa(result.id);
                                      } else if (_getFormattedStatus(
                                                  result.status) ==
                                              'Disetujui' ||
                                          _getFormattedStatus(result.status) ==
                                              'Ditolak') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Anda sudah tidak bisa menghapus data ini'),
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
