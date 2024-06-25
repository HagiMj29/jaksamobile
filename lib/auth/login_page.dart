import 'package:flutter/material.dart';
import 'package:mobilejaksasumbar/admin_pages/home_admin_page.dart';
import 'package:mobilejaksasumbar/model/sharedpreferences.dart';
import 'package:mobilejaksasumbar/user_pages/home_user_page.dart';
import 'package:mobilejaksasumbar/user_pages/home_user_page.dart';
import '../model/api_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiServices apiServices = ApiServices(baseUrl: AppConfig.baseUrl);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  void _login() async {
    if (keyForm.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;

      try {
        final response = await apiServices.login(email, password);
        final user = response['user'] as Map<String, dynamic>;
        final userId = user['id'];
        final username = user['name'];
        final nohp = user['no_hp'];
        final nikktp = user['nik_ktp'];
        final status = user['status'];

        await SharedPreferencesHelper.saveUserProfile(user);

        if (status == 'user') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeUserPage(
                userId: userId,
                username: username,
                noHp : nohp,
                nikKtp : nikktp,
                apiService: ApiServices(baseUrl: AppConfig.baseUrl),
              ),
            ),
                (Route<dynamic> route) => false,
          );
        } else if (status == 'admin') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeAdminPage(
                userId: userId,
                apiService: ApiServices(baseUrl: AppConfig.baseUrl),
              ),
            ),
                (Route<dynamic> route) => false,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful'),
            backgroundColor: Colors.green,
          ),
        );

        print('Login successful: $response');
      } catch (e) {
        print('Login failed: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: keyForm,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 150,),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Masukkan username dan password",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black, width: 30)),
                            hintText: "Email",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black, width: 30)),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,

                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: _login,
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                        ),
                        child: Center(child: Text('Login', style: TextStyle(
                            fontSize:25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),)),
                      ),
                    ),
                    SizedBox(height: 30,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
