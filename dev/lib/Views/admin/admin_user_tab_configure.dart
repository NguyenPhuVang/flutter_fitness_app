import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/admin/adget_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminUserTabConfigure extends StatefulWidget {
  const AdminUserTabConfigure({super.key});

  @override
  AdminUserTabConfigureState createState() => AdminUserTabConfigureState();
}

class AdminUserTabConfigureState extends State<AdminUserTabConfigure> {
  List<String> uIDs = [];
  Future getUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        uIDs.add(doc.reference.id);
      });
    });
  }

  Future deleteUser(String uid) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(uid).delete();
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AdminUserTabConfigure()));
      Fluttertoast.showToast(
        msg: 'Xóa thành công',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 80, 182, 133),
        fontSize: 20,
      );
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
        msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý tài khoản người dùng"),
        backgroundColor: Colors.lightBlueAccent[200],
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: uIDs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Container(
                  height: 120,
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: AdminGetUser(uID: uIDs[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
