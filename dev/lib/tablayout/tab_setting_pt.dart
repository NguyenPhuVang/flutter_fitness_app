import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/layout/account_page_pt.dart';
import 'package:dev/Views/layout/login.dart';
import 'package:dev/tablayout/tab_homept.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingPT extends StatefulWidget {
  const SettingPT({super.key});

  @override
  State<SettingPT> createState() => SettingPTState();
}

void signOut() {
  FirebaseAuth.instance.signOut();
}

class SettingPTState extends State<SettingPT> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool hidePass = true;
  final user = FirebaseAuth.instance.currentUser;

  String id = " ";
  String ptID = " ";
  List<String> u = [];
  Future getPT(String? email) async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
          id = doc.reference.id;
          ptID = '${doc['id']}';
      });
    });

    await FirebaseFirestore.instance
        .collection("users")
        .where("id_pt", isEqualTo: ptID)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        u.add(doc.reference.id);
      });
    });

    u.forEach((String i)  async {
       await FirebaseFirestore.instance.collection("users").doc(i).update({
      'id_pt': "",
      'call_id': "",
      'call_name': ""
    });
    });
  }
 
  
  void deletePT() async {
    await FirebaseFirestore.instance.collection("trainers").doc(id).delete();
  }


  void  deletePTAccount(String email, String pass) async {
     User user = await FirebaseAuth.instance.currentUser!;

    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: pass);

    await user.reauthenticateWithCredential(credential).then((value) {
      value.user!.delete().then((res) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Login()));
      });
    }).catchError((onError) {
      Fluttertoast.showToast(
        msg: 'Tài khoản hoặc mật khẩu không đúng',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 80, 182, 133),
        fontSize: 25,
      );
    });
    deletePT();
    getPT(user.email);
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // padding: EdgeInsets.all(24),
          children: [
            Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  child: Center(
                      child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
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
                          left: 40,
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
                SettingsGroup(
                  titleTextStyle: const TextStyle(fontSize: 0),
                  title: "",
                  children: const <Widget>[
                    AccountPagePT(),
                  ],
                ),
              ],
            ),
            SizedBox(
                height: 20,
                child: Container(
                  color: Colors.grey[200], // Đặt màu nền cho Container
                )),
            SettingsGroup(
              titleTextStyle: const TextStyle(fontSize: 0),
              title: "",
              children: <Widget>[
                buildBugFeed(),
                buildFeedBack(),
              ],
            ),
            SizedBox(
              height: 20,
              child: Container(
                color: Colors.grey[200], // Đặt màu nền cho Container
              ),
            ),
            SettingsGroup(
              titleTextStyle: const TextStyle(fontSize: 0),
              title: "",
              children: <Widget>[
                buildDelete(),
                buildLogout(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLogout() => SimpleSettingsTile(
        title: 'Đăng xuất',
        subtitle: '',
        leading: Container(
            padding: const EdgeInsets.all(6),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            )),
        onTap: () {
          signOut();
          Navigator.pushNamed(context, 'login');
        },
      );

  Widget buildDelete() => SimpleSettingsTile(
        title: 'Xóa tài khoản',
        subtitle: '',
        leading: Container(
            padding: const EdgeInsets.all(6),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            )),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Xóa tài khoản',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  content: SizedBox(
                    width: 500,
                    height: 300,
                    child: Column(
                      children: [
                        TextField(
                          controller: _email,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          obscureText: hidePass,
                          controller: _pass,
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
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: SizedBox(
                                  width: 150,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 128, 241, 132),
                                        side: const BorderSide(
                                            width: 3,
                                            color: Color.fromARGB(
                                                255, 128, 241, 132)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: () {
                                      deletePTAccount(_email.text.trim(),
                                          _pass.text.trim());
                                    },
                                    child: const Text(
                                      'Chắc chắn',
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.black),
                                    ),
                                  ),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: SizedBox(
                                  width: 150,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 221, 90, 85),
                                        side: const BorderSide(
                                            width: 3,
                                            color: Color.fromARGB(
                                                255, 221, 90, 85)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePT()));
                                    },
                                    child: const Text(
                                      'Trở về',
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.black),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      );

  Widget buildBugFeed() => SimpleSettingsTile(
        title: 'Báo lỗi',
        subtitle: '',
        leading: Container(
            padding: const EdgeInsets.all(6),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: const Icon(
              Icons.bug_report,
              color: Colors.white,
            )),
        onTap: () {},
      );

  Widget buildFeedBack() => SimpleSettingsTile(
        title: 'Gửi đánh giá',
        subtitle: '',
        leading: Container(
            padding: const EdgeInsets.all(6),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
            child: const Icon(
              Icons.feedback,
              color: Colors.white,
            )),
        onTap: () {},
      );
}
