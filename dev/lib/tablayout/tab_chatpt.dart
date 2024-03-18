import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/layout/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPT extends StatefulWidget {
  const ChatPT({super.key});

  @override
  State<ChatPT> createState() => _ChatPTState();
}

class _ChatPTState extends State<ChatPT> {
  final pt = FirebaseAuth.instance.currentUser;
  String id = " ";
  String uid = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          id = '${doc['id']}';
        });
      });
    });

    await FirebaseFirestore.instance
        .collection("users")
        .where("id_pt", isEqualTo: id)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          uid = '${doc['id']}';
        });
      });
    });
  }

  @override
  void initState(){
    getUserByEmail(pt!.email);
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
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
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
    if (FirebaseAuth.instance.currentUser!.email != data['email'] &&
        data['id_pt'] == id) {
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
