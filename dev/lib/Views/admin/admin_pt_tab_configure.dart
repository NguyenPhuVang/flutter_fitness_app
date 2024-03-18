import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/admin/adget_pt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminPTTabConfigure extends StatefulWidget {
  const AdminPTTabConfigure({super.key});

  @override
  AdminPTTabConfigureState createState() => AdminPTTabConfigureState();
}

class AdminPTTabConfigureState extends State<AdminPTTabConfigure> {
  List<String> ptIDs = [];
  List<String> ptNames = [];
  Future getPT() async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("active", isEqualTo: true)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        ptIDs.add(doc.reference.id);
        print(ptIDs);
      });
    });
  }

  // String? u;
  // Future deleteUPT(String uid) async {
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("id_pt", isEqualTo: uid)
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((DocumentSnapshot doc) {
  //       u = doc.reference.id;
  //       print(u);
  //     });
  //   });

  //   await FirebaseFirestore.instance.collection("users").doc(u).update({
  //     'id_pt': "",
  //     'call_id': "",
  //     'call_name': ""
  //   });
  // }

  Future deletePT(String uid) async {
    try {
      await FirebaseFirestore.instance.collection("trainers").doc(uid).delete();
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const AdminPTTabConfigure()));
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý tài khoản PT"),
        backgroundColor: Colors.lightBlueAccent[200],
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
        future: getPT(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: ptIDs.length,
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
                  child: AdminGetPT(ptID: ptIDs[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
