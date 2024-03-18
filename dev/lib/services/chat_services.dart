
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/model/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  Future<void> sendMessage(String receiverID, String message) async {
    //lấy thông tin người dùng hiện tại
    final String crUser = _firebaseAuth.currentUser!.uid;
    final String crUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp time = Timestamp.now();

    //tạo tin nhắn
    Messages newMessage = Messages(
        senderId: crUser,
        senderEmail: crUserEmail,
        receiverId: receiverID,
        message: message,
        timestamp: time);

    //tạo phòng chat dựa trên id của user hiện tại
    List<String> ids = [crUser, receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");

    await _firebaseFirestore.collection('chats_rooms').doc(chatRoomID).collection("messages").add(
      newMessage.toMap()
    );
  }

  //lấy tin nhắn từ database
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID){
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firebaseFirestore.collection('chats_rooms').doc(chatRoomId).collection("messages").orderBy('time', descending: false).snapshots();
  }
}
