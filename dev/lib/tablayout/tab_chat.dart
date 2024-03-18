import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/layout/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final user = FirebaseAuth.instance.currentUser;
  String id = " ";
  String ptid = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          ptid = '${doc['id_pt']}';
        });
      });
    });
  }

  @override
  void initState() {
    getUserByEmail(user!.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("trainers").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Lỗi hệ thống');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }


  Widget _buildUserListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    //hiển thị toàn bộ user ngoại trừ người hiện tại
    if (FirebaseAuth.instance.currentUser!.email != data['email'] && data['id'] == ptid) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Stack(alignment: Alignment.bottomRight, children: [
          CircleAvatar(
            radius: 30,
            child: Icon(Icons.person),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 5,
            ),
          ),
        ]),
        title: Text(
          data['name'],
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatPage(
                    receiveUserName: data['name'],
                    receiveUID: data['id'],
                  )));
        },
      );
    } else {
      return Container();
    }
  }
}
