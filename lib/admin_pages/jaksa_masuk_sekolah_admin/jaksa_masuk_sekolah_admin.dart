import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/api_services.dart';
import '../../model/model_jaksa.dart';

class JaksaMasukSekolahAdmin extends StatefulWidget {
  const JaksaMasukSekolahAdmin({super.key});

  @override
  State<JaksaMasukSekolahAdmin> createState() => _JaksaMasukSekolahAdminState();
}

class _JaksaMasukSekolahAdminState extends State<JaksaMasukSekolahAdmin> {
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
          _jaksaList = _jaksaList;
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
          "Jaksa Masuk Sekolah",
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
                                          // if (_getFormattedStatus(result.status) ==
                                          //     'Diproses') {
                                          //   Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           EditJaksaPage(
                                          //             jaksa: result,
                                          //             userId: widget.userId,
                                          //           ),
                                          //     ),
                                          //   );
                                          // } else if (_getFormattedStatus(
                                          //     result.status) ==
                                          //     'Disetujui' ||
                                          //     _getFormattedStatus(result.status) ==
                                          //         'Ditolak') {
                                          //   ScaffoldMessenger.of(context)
                                          //       .showSnackBar(
                                          //     SnackBar(
                                          //       content: Text(
                                          //           'Anda sudah tidak bisa mengedit data ini'),
                                          //       backgroundColor: Colors.red,
                                          //     ),
                                          //   );
                                          // }
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
                                          // if (_getFormattedStatus(result.status) ==
                                          //     'Diproses') {
                                          //   deleteJaksa(result.id);
                                          // } else if (_getFormattedStatus(
                                          //     result.status) ==
                                          //     'Disetujui' ||
                                          //     _getFormattedStatus(result.status) ==
                                          //         'Ditolak') {
                                          //   ScaffoldMessenger.of(context)
                                          //       .showSnackBar(
                                          //     SnackBar(
                                          //       content: Text(
                                          //           'Anda sudah tidak bisa menghapus data ini'),
                                          //       backgroundColor: Colors.red,
                                          //     ),
                                          //   );
                                          // }
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
