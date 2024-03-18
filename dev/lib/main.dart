import 'package:dev/Views/admin/admin_homepage.dart';
import 'package:dev/Views/layout/auth_page.dart';
import 'package:dev/Views/layout/home.dart';
import 'package:dev/Views/layout/homepage.dart';
import 'package:dev/Views/layout/login.dart';
import 'package:dev/Views/layout/register_pt.dart';
import 'package:dev/Views/layout/splash.dart';
import 'package:dev/push_noti/push_noti.dart';
import 'package:dev/tablayout/tab_chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Views/Trainer/trainer_create_exersise_calendar.dart';
import 'Views/Trainer/trainer_homepage.dart';
import 'Views/admin/admin_manage_user.dart';
import 'Views/admin/admin_pt_user_manage.dart';
import 'Views/layout/home_survey.dart';
import 'Views/layout/intro_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  await  PushNoti().initNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthApp',
      routes: {
        'splash': (context) => const Splash(),
        'intro_page': (context) => const IntroPage(),
        'register': (context) => const RegisterPT(),
        'login': (context) => const Login(),
        'home': (context) => const Home(),
        'home_survey': (context) => HomeSurvey(),
        'homepage': (context) => const HomePage(),
        'admin_homepage': (context) => const AdminHomePage(),
        'admin_manage_user': (context) => const AdminManageUser(),
        'trainer_homepage': (context) => const TrainerHomePage(),
        'tab_chat': (context) => const Chat(),
        'admin_pt_user_manage': (context) => const AdminPTUserManagePage(),
        'trainer_create_exersise_calendar': (context) => const TrainerCreateExersiseCalendarPage(uid: '',),

      },
      home: const AuthPage(),
    );
  }
}
