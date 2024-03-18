import 'package:dev/Controller/TrainerController.dart';
import 'package:dev/Views/layout/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPT extends StatefulWidget {
  const RegisterPT({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterPT> {
  final _emailText = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _active = TextEditingController();
  final _dateOfBirth = TextEditingController();
  final _experience = TextEditingController();
  final _qualification = TextEditingController();
  final _teachdays = TextEditingController();
  final _id = TextEditingController();

  @override
  void dispose() {
    _emailText.dispose();
    _name.dispose();
    _phone.dispose();
    _active.dispose();
    _dateOfBirth.dispose();
    _experience.dispose();
    _qualification.dispose();
    _teachdays.dispose();
    _id.dispose();
    super.dispose();
  }

  void showToastSuccess() {
    Fluttertoast.showToast(
      msg:
          'Thông tin của bạn đã được ghi nhận, vui lòng đợi thông tin gửi về mail',
    );
  }

  void showToastValidation() {
    Fluttertoast.showToast(
      msg: 'Vui lòng nhập đầy đủ thông tin',
    );
  }

  void showToastValidationEmail() {
    Fluttertoast.showToast(
      msg: 'Email không hợp lệ',
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

  final TrainerController _trainerController = TrainerController();

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
              Container(
                padding: EdgeInsets.only(left: deviceWidth*0.2, top: deviceHeight*0.07, right: 35),
                child: const Text(
                  'Đăng ký Personal Trainer',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 100, right: 35, left: 35),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: _name,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Họ tên',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: _emailText,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: _experience,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Kinh nghiệm làm việc',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: _qualification,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Chuyên môn',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 50,
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
                                // Cập nhật giá trị ngày sinh vào controller
                                _dateOfBirth.text =
                                    "${selectedDate.toLocal()}".split(' ')[0];
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: _phone,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Số điện thoại',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: _teachdays,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Số buổi có thể dạy',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_name.text.trim() == "" ||
                                _phone.text.trim() == "" ||
                                _emailText.text.trim() == "" ||
                                _experience.text.trim() == "" ||
                                _dateOfBirth.text == null) {
                              showToastValidation();
                            } else if (!EmailValidator.validate(
                                _emailText.text.trim())) {
                              showToastValidationEmail();
                            } else if (!isPhoneNoValid(_phone.text.trim())) {
                              showToastValidationPhone();
                            } else {
                              _trainerController.addUser(
                                  _name.text.trim(),
                                  _phone.text.trim(),
                                  _emailText.text.trim(),
                                  _experience.text.trim(),
                                  _qualification.text.trim(),
                                  DateTime.parse(_dateOfBirth.text),
                                  _teachdays.text.trim());
                              Navigator.pop(context);
                              showToastSuccess();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.white,
                            padding: const EdgeInsets.only(
                                right: 90, left: 90, top: 15, bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Gửi đơn',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold
                            , color: Colors.black),),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Login()));
                              },
                              child: const Text(
                                "Đăng nhập ngay",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
