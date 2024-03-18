import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/layout/pt_detail.dart';
import 'package:dev/tablayout/get_pt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChoosePT extends StatefulWidget {
  const ChoosePT({super.key});

  @override
  State<ChoosePT> createState() => _ChoosePTState();
}

List<String> training_packages = [
  'Gói ngày',
  'Gói tuần',
  'Gói tháng',
  'Gói năm'
];

class _ChoosePTState extends State<ChoosePT> {
  final user = FirebaseAuth.instance.currentUser;
  String id = " ";
  String prequently = " ";
  String ptId = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          id = '${doc['id']}';
          ptId = '${doc['id_pt']}';
        });
      });
    });

    await FirebaseFirestore.instance
        .collection("trainning_purpose")
        .where("user_id", isEqualTo: id)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          prequently = '${doc['prequently']}';
        });
      });
    });
  }

  List<String> ptIDs = [];
  List<String> ptNames = [];
  Future getPT() async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("active", isEqualTo: true)
        .where("teachdays", isEqualTo: prequently)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        ptIDs.add(doc.reference.id);
        ptNames.add('${doc['name']}');
      });
    });
  }

  @override
  void initState() {
    getUserByEmail(user?.email);
    getPT();
    // getPurpose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DANH SÁCH PT'),
        ),
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
                      child: GetPT(ptID: ptIDs[index]),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PTDetail(
                                ptId: ptIDs[index],
                              )));
                    },
                  );
              },
            );
          },
        ),
      ),
    );
  }
}
