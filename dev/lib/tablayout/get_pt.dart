import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetPT extends StatefulWidget {
  final String ptID;
  const GetPT({super.key, required this.ptID});

  @override
  _GetPTState createState() => _GetPTState();
}

class _GetPTState extends State<GetPT> {
  @override
  Widget build(BuildContext context) {
    CollectionReference reference =
        FirebaseFirestore.instance.collection("trainers");

    return FutureBuilder<DocumentSnapshot>(
        future: reference.doc(widget.ptID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text(
                'Đang tải danh sách ....');
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text(
                    "Tên: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(data['name'], style: const TextStyle(fontSize: 20)),
                ]),
                Row(children: [
                  const Text("Kinh nghiệm: ", style: TextStyle(fontSize: 20)),
                  Text(data['experience'], style: const TextStyle(fontSize: 20)),
                ]),
                Row(children: [
                  const Text("Email: ", style: TextStyle(fontSize: 20)),
                  Text(data['email'], style: const TextStyle(fontSize: 20)),
                ]),
                Row(children: [
                  const Text("Số điện thoại: ", style: TextStyle(fontSize: 20)),
                  Text(data['mobile'], style: const TextStyle(fontSize: 20)),
                ]),
              ],
            );
          }
        });
  }
}
