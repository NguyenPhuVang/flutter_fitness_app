import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/layout/change_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountPagePT extends StatefulWidget {
  const AccountPagePT({super.key});

  State<AccountPagePT> createState() => _AccountPagePTState();
}

class _AccountPagePTState extends State<AccountPagePT> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _dateOfBirth = TextEditingController();
  final _experience = TextEditingController();
  final _qualification = TextEditingController();
  final _teachdays = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _dateOfBirth.dispose();
    _experience.dispose();
    _qualification.dispose();
    _teachdays.dispose();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser!;
  String id = "";
  String email = "";
  String name = "";
  String phone = "";
  String experience = "";
  String qualification = "";
  String teachdays = "";
  Timestamp dOB = Timestamp(1695136010, 449000000);
  Future getTrainerByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;
        setState(() {
          // Lưu data từ db
          name = '${doc['name']}';
          phone = '${doc['mobile']}';
          qualification = '${doc['qualification']}';
          teachdays = '${doc['teachdays']}';
          experience = '${doc['experience']}';
          dOB = doc['date_of_birth'] ;
          // Lưu data từ TextFormField
          _name.text = '${doc['name']}';
          this.email = '${doc['email']}';
          _phone.text = '${doc['mobile']}';
          _qualification.text = '${doc['qualification']}';
          _teachdays.text = '${doc['teachdays']}';
          _experience.text = '${doc['experience']}';
          _dateOfBirth.text = doc['date_of_birth'].toDate().toLocal().toString().split(' ')[0] ;
        });
      });
    });
  }

  Future updateUser(String name, String phone, String experience,
      String qualification, DateTime dOB, String teachdays) async {
    final docPt = FirebaseFirestore.instance.collection('trainers').doc(id);
    final data = {
      'date_of_birth': dOB,
      'experience': experience,
      'qualification': qualification,
      'name': name,
      'mobile': phone,
      'teachdays': teachdays,
    };
    await docPt.update(data);
  }

  @override
  void initState() {
    getTrainerByEmail(user?.email);
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
                    size: 60,
                    color: Colors.black,
                  ),
                  Positioned(
                    bottom: 40,
                    left: 210,
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
              height: 10,
            ),
            Text(
              _name.text.toString(),
              style: TextStyle(color: Colors.grey[600], fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
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
                                borderRadius: BorderRadius.circular(10)))
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: _phone,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Số điện thoại',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _dateOfBirth,
                      readOnly: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        labelText: 'Ngày sinh',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate != null) {
                              _dateOfBirth.text =
                              "${selectedDate.toLocal()}".split(' ')[0];
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        initialValue: email,
                        readOnly: true,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: _experience,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Kinh nghiệm',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: _qualification,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Trình độ chuyên môn',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: _teachdays,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Ngày dạy',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_name.text.trim() == "" ||
                            _phone.text.trim() == "" ||
                            _teachdays.text.trim() == "" ||
                            _qualification.text.trim() == "" ||
                            _experience.text.trim() == "" ||
                            _dateOfBirth.text == null) {
                          showToastValidation();
                        }
                        else if (!isPhoneNoValid(_phone.text.trim())) {
                          showToastValidationPhone();
                        } else {
                          updateUser(
                              _name.text.trim(),
                              _phone.text.trim(),
                              _experience.text.trim(),
                              _qualification.text.trim(),
                              DateTime.parse(_dateOfBirth.text),
                              _teachdays.text.trim());
                          Navigator.pop(context);
                          showToastSuccess();
                        }
                      },
                      child: const Text('Lưu cập nhật'),
                    ),
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
    msg:
    'Thay đổi thông tin thành công',
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

bool isPhoneNoValid(String? phoneNo) {
  if (phoneNo == null) return false;
  final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  return regExp.hasMatch(phoneNo);
}