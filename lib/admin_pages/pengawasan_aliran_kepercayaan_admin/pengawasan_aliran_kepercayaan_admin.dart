import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/api_services.dart';
import '../../model/model_aliran.dart';
import '../../user_pages/pengawasan_aliran_dan_kepercayaan/detail_pengawasan_aliran_kepercayaan.dart';

class PengawasanAliranKepercayaanAdmin extends StatefulWidget {
  const PengawasanAliranKepercayaanAdmin({super.key});

  @override
  State<PengawasanAliranKepercayaanAdmin> createState() => _PengawasanAliranKepercayaanAdminState();
}

class _PengawasanAliranKepercayaanAdminState extends State<PengawasanAliranKepercayaanAdmin> {
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
          _aliranList = _aliranList;
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
          "Pengawasam Aliran dan Kepercayaan",
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
                                          //       builder: (context) => EditPengawasanAliranKepercayaan(
                                          //         pengaduanpegawai:
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
                                          //   deleteAliran(result.id);
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
