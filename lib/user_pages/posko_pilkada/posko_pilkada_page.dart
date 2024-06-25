import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilejaksasumbar/model/model_posko.dart';
import '../../model/api_services.dart';
import 'package:http/http.dart' as http;

class PoskoPilkadaPage extends StatefulWidget {
  final int userId;
  final String noHp;
  final String nikKtp;
  final ApiServices apiService;

  const PoskoPilkadaPage({Key? key, required this.userId, required this.noHp, required this.nikKtp, required this.apiService}) : super(key: key);

  @override
  State<PoskoPilkadaPage> createState() => _PoskoPilkadaPageState();
}

class _PoskoPilkadaPageState extends State<PoskoPilkadaPage> {

  String? noHp;
  String? nikKtp;
  List<Result> _poskoList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchPosko();
    });
  }

  void _fetchPosko() async {
    try {
      http.Response res =
      await http.get(Uri.parse('${AppConfig.baseUrl}/aliran'));
      if (res.statusCode == 200) {
        setState(() {
          _poskoList =
              modelPoskoFromJson(res.body).result;
          _poskoList = _poskoList.where((pengaduan) => pengaduan.userId == widget.userId).toList();
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
          "Posko Pilkada",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: (){
            // _gotoAddAliran();
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
                      itemCount: _poskoList.length,
                      itemBuilder: (context, index) {
                        Result result = _poskoList[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => DetailPengawasanAliranKepercayaan(
                            //       data: result,
                            //     ),
                            //   ),
                            // );
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
