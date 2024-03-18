import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/layout/register.dart';
import 'package:dev/Views/layout/register_pt.dart';
import 'package:dev/Views/layout/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String? errorMessage;
  bool hidePass = true;
  String? admin = "admin";
  String? user = "user";
  String? trainer = "trainer";

  final _email = TextEditingController();
  final _pass = TextEditingController();
  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassWord(String email, String pw) async {
    try {
      if (_email.text == "" && _pass.text == "" ||
          _email.text == "" && _pass.text != "" ||
          _email.text != "" && _pass.text == "") {
            Fluttertoast.showToast(
          msg: 'Không được để trống',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          textColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 80, 182, 133),
          fontSize: 20,
        );
      } else if (_email.text != "" && _pass.text != ""){
        // showDialog(context: context, builder: (context){
        //   return Center(child: CircularProgressIndicator(),);
        // });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pw);
        // Fluttertoast.showToast(
        //   msg: 'Đăng nhập thành công',
        // );
        // Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        Fluttertoast.showToast(
          msg: 'Sai mật khẩu hoặc tài khoản',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          textColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 80, 182, 133),
          fontSize: 20,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Đăng nhập thất bại',
        );
      }
    }
  }

  Future<String?> getTypeByEmailUser(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0]['type'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Lỗi khi truy vấn Firestore: $e');
      return null;
    }
  }

  Future<String?> getTypeByEmailTrainer(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('trainers')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0]['type'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Lỗi khi truy vấn Firestore: $e');
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg:
            'Vui lòng kiểm tra mail để đổi mật khẩu\nNếu chưa nhận được, vui lòng kiểm tra lại mail đã nhập',
      );
    } on FirebaseAuthException catch (e) {
      if (email == null) {
        Fluttertoast.showToast(
          msg: 'Vui lòng nhập email để tiến hành gửi mail đổi mật khẩu',
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Vui lòng kiểm tra lại email',
        );
      }
    }
  }

  void clearTextField() {
    _email.clear();
    _pass.clear();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/discipline.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.2, left: deviceWidth * 0.3, right: 0),
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(color: Colors.white, fontSize: 45,),
                    textAlign: TextAlign.center,
                  ),
                ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: deviceHeight * 0.3, right: 35, left: 35),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person_rounded,
                            color: Colors.black,
                          ),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Nhập tài khoản',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16), // Thay đổi kích thước
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _pass,
                        obscureText: hidePass,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            suffixIcon: IconButton(
                              icon: hidePass
                                  ? const Icon(
                                      Icons.visibility_off,
                                      color: Colors.black,
                                    )
                                  : const Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  hidePass = !hidePass;
                                });
                              },
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Nhập mật khẩu',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              resetPassword(_email.text.trim());
                            },
                            child: const Text(
                              'Quên mật khẩu',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              color: Colors.black,
                              onPressed: () {
                                signInWithEmailAndPassWord(
                                    _email.text.trim(), _pass.text.trim());
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Splash()));
                              },
                              icon: const Icon(Icons.arrow_forward, size: 36,),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Register()));
                            },
                            child: const Text(
                              'Đăng ký',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const RegisterPT()));
                            },
                            child: const Text(
                              'Đăng ký PT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
