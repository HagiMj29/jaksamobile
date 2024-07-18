import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobilejaksasumbar/landing_page.dart';
import 'package:mobilejaksasumbar/user_pages/jaksa_masuk_sekolah/jaksa_masuk_sekolah_page.dart';
import 'package:mobilejaksasumbar/user_pages/pengaduan_pegawai/pengaduan_pegawai_page.dart';
import 'package:mobilejaksasumbar/user_pages/pengaduan_tindak_pidana_korupsi/pengaduan_tindak_pidana_korupsi_page.dart';
import 'package:mobilejaksasumbar/user_pages/pengawasan_aliran_dan_kepercayaan/pengawasan_aliran_agama_kepercayaan_page.dart';
import 'package:mobilejaksasumbar/user_pages/penyuluhan_hukum_page/penyuluhan_hukum_page.dart';
import 'package:mobilejaksasumbar/user_pages/posko_pilkada/posko_pilkada_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import '../model/api_services.dart';
import '../model/sharedpreferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

Future<String?> getUserId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

Future<String?> getUserName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_name');
}

Future<String?> getUserEmail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_email');
}

final List<String> imgList = [
  'images/image1.jpg',
  'images/image2.jpeg',
  'images/image3.jpg',
  'images/image4.jpg',

];

class HomeUserPage extends StatefulWidget {
  final int userId;
  final String username;
  final String noHp;
  final String nikKtp;
  final ApiServices apiService;

  const HomeUserPage({
    Key? key,
    required this.userId,
    required this.username,
    required this.apiService,
    required this.noHp,
    required this.nikKtp
  }) : super(key: key);

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  String? username;
  String? noHp;
  String? nikKtp;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _gotoPengaduanPegawai() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengaduanPegawaiPage(
          userId: widget.userId,
          noHp: widget.noHp,
          nikKtp: widget.nikKtp,
          apiService: ApiServices(baseUrl: AppConfig.baseUrl),
        ),
      ),
    );

    if (result != null && result['success'] == true) {}
  }

  void _gotoPengaduanKorupsi() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengaduanTindakPidanaKorupsi(
          userId: widget.userId,
          noHp: widget.noHp,
          nikKtp: widget.nikKtp,
          apiService: ApiServices(baseUrl: AppConfig.baseUrl),
        ),
      ),
    );

    if (result != null && result['success'] == true) {}
  }

  void _goToJaksaPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JaksaMasukSekolah(
          userId: widget.userId,
          apiService: ApiServices(baseUrl: AppConfig.baseUrl),
        ),
      ),
    );

    if (result != null && result['success'] == true) {}
  }

  void _goToPenyuluhanHukum() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PenyuluhanHukumPage(
          userId: widget.userId,
          noHp: widget.noHp,
          nikKtp: widget.nikKtp,
          apiService: ApiServices(baseUrl: AppConfig.baseUrl),
        ),
      ),
    );

    if (result != null && result['success'] == true) {}
  }

  void _goToAliran() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengawasanAliranDanKepercayaan(
          userId: widget.userId,
          noHp: widget.noHp,
          nikKtp: widget.nikKtp,
          apiService: ApiServices(baseUrl: AppConfig.baseUrl),
        ),
      ),
    );

    if (result != null && result['success'] == true) {}
  }

  void _goToPosko() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PoskoPilkadaPage(
          userId: widget.userId,
          noHp: widget.noHp,
          nikKtp: widget.nikKtp,
          apiService: ApiServices(baseUrl: AppConfig.baseUrl),
        ),
      ),
    );

    if (result != null && result['success'] == true) {}
  }

  Future<void> _loadUserInfo() async {
    try {
      final String? name = await SharedPreferencesHelper.getUserName();
      final String? nohp = await SharedPreferencesHelper.getUserNoHp();
      final String? nik = await SharedPreferencesHelper.getUserNik();
      if (name != null && nik != null && nohp != null) {
        setState(() {
          username = name;
          nikKtp = nik;
          noHp = nohp;
        });
      } else {
        print('Failed to load user info');
      }
    } catch (error) {
      print('Error loading user info: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
    return SideMenu(
      key: _sideMenuKey,
      menu: buildMenu(),
      type: SideMenuType.slide,
      inverse: true,
      background: Colors.green,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                final _state = _sideMenuKey.currentState;
                if (_state!.isOpened)
                  _state.closeSideMenu();
                else
                  _state.openSideMenu();
              },
            ),
            SizedBox(width: 15),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: imgList
                      .map(
                        (item) => Container(
                      child: Center(
                        child: Image.asset(
                          item,
                          width: 1000,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Text(
                  "Selamat Datang ${widget.username}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text("Silakan, apa laporan keluhan anda"),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _gotoPengaduanPegawai();
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
                    _gotoPengaduanKorupsi();
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
                  onTap: _goToJaksaPage,
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
                  onTap: _goToPenyuluhanHukum,
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
                    _goToAliran();
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
                    _goToPosko();
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
        ),
      ),
    );
  }

  Widget buildMenu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.person_2_rounded, size: 20.0, color: Colors.white),
            title: const Text("Profile"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.info, size: 20.0, color: Colors.white),
            title: const Text("Tentang Kami"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingPage()));
            },
            leading: const Icon(Icons.logout, size: 20.0, color: Colors.white),
            title: const Text("Logout"),
            textColor: Colors.white,
            dense: true,
          ),
        ],
      ),
    );
  }
}
