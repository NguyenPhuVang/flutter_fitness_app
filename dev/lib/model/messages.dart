import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Messages({required this.senderId, required this.senderEmail, required this.receiverId, required this.message, required this.timestamp,});


  //Chuyển đổi data thành map
  Map<String, dynamic> toMap(){
    return{
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiveId': receiverId,
      'message': message,
      'time': timestamp
    };
  }
}