import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/api_services.dart';
import '../../model/model_pengaduan_korupsi.dart';
import '../../user_pages/pengaduan_tindak_pidana_korupsi/detail_pengaduan_tindak_pidana_korupsi.dart';

class PengaduanKorupsiAdmin extends StatefulWidget {
  const PengaduanKorupsiAdmin({super.key});

  @override
  State<PengaduanKorupsiAdmin> createState() => _PengaduanKorupsiAdminState();
}

class _PengaduanKorupsiAdminState extends State<PengaduanKorupsiAdmin> {
  List<Result> _pengaduanKorupsiList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchpengaduankorupsi();
    });
  }


  void _fetchpengaduankorupsi() async {
    try {
      http.Response res =
      await http.get(Uri.parse('${AppConfig.baseUrl}/pengaduankorupsi'));
      if (res.statusCode == 200) {
        setState(() {
          _pengaduanKorupsiList =
              modelPengaduanKorupsiFromJson(res.body).result;
          _pengaduanKorupsiList = _pengaduanKorupsiList;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pengaduan Tindak Pidana Korupsi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                      itemCount: _pengaduanKorupsiList.length,
                      itemBuilder: (context, index) {
                        Result result = _pengaduanKorupsiList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPengaduanTindakPidanaKorupsi(
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
                                        "Nama : ",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        result.userName.toString(),
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
                                          // if (_getFormattedStatus(result.status) == 'Diproses') {
                                          //   Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //       builder: (context) => EditPengaduanTindakPidanaKorupsi(
                                          //         pengaduanKorupsi:
                                          //         result, userId: widget.userId,),
                                          //     ),
                                          //   );
                                          // } else if (_getFormattedStatus(result.status) == 'Disetujui' ||
                                          //     _getFormattedStatus(result.status) == 'Ditolak') {
                                          //   ScaffoldMessenger.of(context).showSnackBar(
                                          //     SnackBar(
                                          //       content: Text('Anda sudah tidak bisa mengedit data ini'),
                                          //       backgroundColor: Colors.red,
                                          //     ),
                                          //   );
                                          // }
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
                                          // if (_getFormattedStatus(result.status) == 'Diproses') {
                                          //   deletePengaduan(result.id);
                                          // } else if (_getFormattedStatus(result.status) == 'Disetujui' ||
                                          //     _getFormattedStatus(result.status) == 'Ditolak') {
                                          //   ScaffoldMessenger.of(context).showSnackBar(
                                          //     SnackBar(
                                          //       content: Text('Anda sudah tidak bisa menghapus data ini'),
                                          //       backgroundColor: Colors.red,
                                          //     ),
                                          //   );
                                          // }
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
