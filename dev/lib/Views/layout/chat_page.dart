import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/layout/chat_bubble.dart';
import 'package:dev/services/chat_services.dart';
import 'package:dev/tablayout/tab_call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.receiveUserName, required this.receiveUID});

  final String receiveUserName;
  final String receiveUID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMess() async {
    //Chỉ gửi khi có nhập tin nhắn
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.receiveUID, _messageController.text);
      _messageController.clear();
    }
  }

  String name = " ";
  String id = " ";
  String call_name = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          id = '${doc['call_id']}';
          name = '${doc['email']}';
          call_name = '${doc['call_name']}';
        });
      });
    });
  }

  Future getUserByName() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: widget.receiveUserName)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          id = '${doc['call_id']}';
          call_name = '${doc['call_name']}';
        });
      });
    });
  }

  Future getPT(String? email) async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          // id = '${doc['call_id']}';
          name = '${doc['email']}';
        });
      });
    });
  }

  @override
  void initState() {
    getUserByEmail(_firebaseAuth.currentUser?.email);
    getPT(_firebaseAuth.currentUser?.email);
    getUserByName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveUserName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                onJoin();
              },
              icon: const Icon(Icons.video_call))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            //danh sach tin nhắn
            child: _buildMessageList(),
          ),

          //Người dùng nhập tin nhắn
          _builtUserInput()
        ],
      ),
    );
  }

  Future<void> onJoin() async {
    if (id.isNotEmpty) {
      // await _handleCameraAndMic(Permission.camera);
      // await _handleCameraAndMic(Permission.microphone);
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CallView(
                callID: id,
                username: name,
                userid: call_name,
              )));
    }
  }

  // Future<void> _handleCameraAndMic(Permission permission) async {
  //   final status = await permission.request();
  //   log(status.toString());
  // }

  //message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatServices.getMessages(
          widget.receiveUID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading ....");
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItems(document))
              .toList(),
        );
      },
    );
  }

  //messgae items
  Widget _buildMessageItems(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    var align = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(
              height: 10,
            ),
            ChatBubble(message: data['message'])
          ],
        ),
      ),
    );
  }

  //user input
  Widget _builtUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              obscureText: false,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(10)),
                hintText: 'Nhập tin nhắn ....',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          IconButton(
              onPressed: sendMess,
              icon: const Icon(
                Icons.arrow_upward,
                size: 40,
              ))
        ],
      ),
    );
  }
}
