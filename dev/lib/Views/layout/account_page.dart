import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/layout/change_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _heightRegex = RegExp(r'^\d+\.\d+$'); // Validate height
  final _weightRegex = RegExp(r'^\d+$');
  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser!;
  String id = " ";
  String name = " ";
  String email = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;
        setState(() {
          _name.text = '${doc['name']}';
          _height.text = '${doc['height(cm)']}';
          _weight.text = '${doc['weight(kg)']}';
          this.email = '${doc['email']}';
          _phone.text = '${doc['phone']}';
        });
      });
    });
  }

  Future updateUser(
      String name, String phone, String height, String weight) async {
    final docPt = FirebaseFirestore.instance.collection('users').doc(id);
    final data = {
      'height(cm)': height,
      'name': name,
      'phone': phone,
      'weight(kg)': weight,
    };
    await docPt.update(data);
  }

  @override
  void initState() {
    getUserByEmail(user?.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
        title: 'Thông tin tài khoản',
        leading: Container(
            padding: const EdgeInsets.all(6),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            )),
        child: SettingsScreen(
          title: 'Cài đặt thông tin',
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.black,
                  ),
                  Positioned(
                    bottom: 50,
                    left: 290,
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              _name.text,
              style: TextStyle(color: Colors.grey[600], fontSize: 30),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            buildChangePassword(),
            // buildUserInfo()
            Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextFormField(
                        controller: _name,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Tên',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                        controller: _phone,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Số điện thoại',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                        initialValue: email,
                        readOnly: true,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: _height,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'Chiều cao',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: _weight,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'Cân nặng',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_name.text.trim() == "" ||
                              _phone.text.trim() == "" ||
                              _weight.text.trim() == "" ||
                              _height.text.trim() == "") {
                            showToastValidation();
                          } else if (!isPhoneNoValid(_phone.text.trim())) {
                            showToastValidationPhone();
                          } else if (!_heightRegex
                              .hasMatch(_height.text.trim())) {
                            showToastValidationHeight();
                          } else if (!_weightRegex
                              .hasMatch(_weight.text.trim())) {
                            showToastValidationWeight();
                          } else {
                            updateUser(_name.text.trim(), _phone.text.trim(),
                                _height.text.trim(), _weight.text.trim());
                            Navigator.pop(context);
                            showToastSuccess();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Lưu thông tin',
                            style: TextStyle(fontSize: 23),
                          ),
                        )),
                  ],
                )),
          ],
        ));
  }

  Widget buildChangePassword() => SimpleSettingsTile(
        title: 'Đổi mật khẩu',
        subtitle: '',
        leading: Container(
            padding: const EdgeInsets.all(6),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
            child: const Icon(
              Icons.key,
              color: Colors.white,
            )),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const ChangePassword()));
        },
      );
}

void showToastSuccess() {
  Fluttertoast.showToast(
    msg: 'Thay đổi thông tin thành công',
  );
}

void showToastValidation() {
  Fluttertoast.showToast(
    msg: 'Vui lòng nhập đầy đủ thông tin',
  );
}

void showToastValidationPhone() {
  Fluttertoast.showToast(
    msg: 'Số điện thoại không hợp lệ',
  );
}

void showToastValidationHeight() {
  Fluttertoast.showToast(
    msg: 'Vui lòng nhập theo định dạng VD: 1.7',
  );
}

void showToastValidationWeight() {
  Fluttertoast.showToast(
    msg: 'Vui lòng nhập đúng định dạng VD: 70',
  );
}

bool isPhoneNoValid(String? phoneNo) {
  if (phoneNo == null) return false;
  final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  return regExp.hasMatch(phoneNo);
}
