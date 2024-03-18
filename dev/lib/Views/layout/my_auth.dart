import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/Trainer/trainer_homepage.dart';
import 'package:dev/Views/admin/admin_homepage.dart';
import 'package:dev/Views/layout/homepage.dart';
import 'package:dev/Views/layout/login.dart';
import 'package:flutter/material.dart';

import 'intro_page.dart';

class MyAuth extends StatelessWidget {
  final String? email;
  const MyAuth({required this.email});

  @override
  Widget build(BuildContext context) {
    bool? isAnswered;
    CollectionReference userref = FirebaseFirestore.instance.collection("users");

    String id = " ";
    String userType = " ";
    FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;       
        isAnswered = bool.parse("${doc['isAnswer']}");
        userType = "${doc['type']}";
      });
    });

    String trainer = " ";
    FirebaseFirestore.instance
        .collection("trainers")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;       
        trainer = "${doc['type']}";
      });
    });


    return FutureBuilder<DocumentSnapshot>(
      future: userref.doc(id).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          if((isAnswered == true && userType == 'user')){
            return const HomePage();
          }else if(userType == 'admin'){
            return const AdminHomePage();
          }else if (trainer == 'trainer'){
            return const TrainerHomePage();
          }else{
            return const IntroPage();
          }
        }else if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }else{
          return const Login();
        }
      })
    );
  }
}