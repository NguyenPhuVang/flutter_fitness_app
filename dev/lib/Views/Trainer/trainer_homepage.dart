import 'package:dev/tablayout/tab_chatpt.dart';
import 'package:dev/tablayout/tab_homept.dart';
import 'package:dev/tablayout/tab_setting_pt.dart';
import 'package:dev/tablayout/tab_training.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class TrainerHomePage extends StatefulWidget {
  const TrainerHomePage({super.key});

  @override
  _TrainerHomePageState createState() => _TrainerHomePageState();
}

void signOut() async {
  await FirebaseAuth.instance.signOut();
}


class _TrainerHomePageState extends State<TrainerHomePage>{


  final screen = [const HomePT(), const Training(), const ChatPT(), const SettingPT()];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screen[index],
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: GNav(
                backgroundColor: Colors.white,
                activeColor: Colors.black,
                color: Colors.grey,
                padding: const EdgeInsets.all(16),
                tabBackgroundColor: Colors.grey.shade300,
                onTabChange: (index) {
                  setState(() {
                    this.index = index;
                  });
                },
                gap: 8,
                tabs: const [
                  GButton(icon: Icons.home, text: 'Trang chủ',),
                  GButton(icon: Icons.fact_check_sharp, text: 'Bài tập',),
                  GButton(icon: Icons.chat_bubble, text: 'Chat',),
                  GButton(icon: Icons.settings, text: 'Cài đặt',),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
