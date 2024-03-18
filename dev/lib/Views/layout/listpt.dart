import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/layout/pt_detail.dart';
import 'package:dev/tablayout/get_pt.dart';
import 'package:flutter/material.dart';

class ListPT extends StatefulWidget {
  const ListPT({super.key});

  @override
  State<ListPT> createState() => _ListPTState();
}

class _ListPTState extends State<ListPT> {


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
        ptNames.add('${doc['name']}');
      });
    });
  }

   @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách PT hiện có'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getPT() , 
        builder: (context, snapshot){
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
        }
        ),
    );
  }
}