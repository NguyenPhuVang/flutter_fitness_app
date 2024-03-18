import 'package:dev/Controller/UserController.dart';
import 'package:dev/Views/layout/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final _emailText = TextEditingController();
  final _passWord = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _confirm = TextEditingController();

  

  String? ma;
  bool hidePass = true;
  bool createUserSuccess = true;
  @override
  void dispose() {
    _emailText.dispose();
    _passWord.dispose();
    _name.dispose();
    _phone.dispose();
    _confirm.dispose();
    super.dispose();
  }


  bool checkPass(String pw, String confirm) {
    if (pw == confirm) {
      return true;
    } else {
      return false;
    }
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

  void showToastValidationConfirmPassword() {
    Fluttertoast.showToast(
      msg: 'Xác nhận mật khẩu không chính xác',
    );
  }

  void showToastUnexpectedError() {
    Fluttertoast.showToast(
      msg: 'Đã có lỗi bất thường xảy ra, vui lòng thử lại sau ',
    );
  }

  void showToastAlreadyExistEmail() {
    Fluttertoast.showToast(
      msg:
          'Đã có tài khoản đăng ký email này, quý khách vui lòng đổi email khác',
    );
  }

  bool isPhoneNoValid(String? phoneNo) {
    if (phoneNo == null) return false;
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(phoneNo);
  }

  final UsersController _userController = UsersController();

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
              // Padding(
              //   padding: const EdgeInsets.only(top: 45),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => Login()));
              //     },
              //     child: Icon(Icons.arrow_back_ios),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.only(left: deviceWidth*0.2, top:deviceHeight*0.1, right: 0),
                child: const Text(
                  'Đăng ký tài khoản',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: deviceHeight*0.07, right: 35, left: 35),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 130,
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
                        obscureText: hidePass,
                        controller: _passWord,
                        decoration: InputDecoration(
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
                            labelText: 'Mật khẩu',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      new FlutterPwValidator(
                        controller: _passWord,
                        minLength: 6,
                        uppercaseCharCount: 1,
                        specialCharCount: 1,
                        width: 400,
                        height: 100,
                        onSuccess: () {},
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        obscureText: hidePass,
                        controller: _confirm,
                        decoration: InputDecoration(
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
                            labelText: 'Xác nhận mật khẩu',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
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
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      const Padding(
                      padding: EdgeInsets.only(left: 100),
                            child: Text(
                              'Đăng ký',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              color: Colors.black,
                              onPressed: () async {
                                if (_name.text.trim() == null ||
                                    _phone.text.trim() == null ||
                                    _emailText.text.trim() == null ||
                                    _passWord.text.trim() == null ||
                                    _confirm.text.trim() == null) {
                                  showToastValidation();
                                } else if (!EmailValidator.validate(
                                    _emailText.text.trim())) {
                                  showToastValidationEmail();
                                } else if (!isPhoneNoValid(
                                    _phone.text.trim())) {
                                  showToastValidationPhone();
                                } else if (!checkPass(_passWord.text.trim(),
                                    _confirm.text.trim())) {
                                  showToastValidationConfirmPassword();
                                } else {
                                  if (_passWord.text != _confirm.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Mật khẩu không hợp lệ")));
                                    return;
                                  }

                                  try {
                                    await _userController.Future(_emailText.text, _passWord.text,_name.text,_phone.text);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                  // signUp(_emailText.text.trim(),_passWord.text.trim(),_name.text.trim(),_phone.text.trim());
                                  if (createUserSuccess){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Login()));
                                    Fluttertoast.showToast(
                                      msg: 'Tạo tài khoản thành công',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      textColor: Colors.white,
                                      backgroundColor: Colors.greenAccent,
                                      fontSize: 30,
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.arrow_forward),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 85,
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
