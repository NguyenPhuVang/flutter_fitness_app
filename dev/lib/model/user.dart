import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users {
  static String ?_id;
  static String ?_idpackage;
  static String ?_idpt;
  static String ?_name;
  static String ?_password;
  static String ?_phone;
  static Float ?_weight;
  static Float ?_height;
  static String ?_z_index;
  static String ?_exp;
  static String ?_isAnswer;
  static String ?_type;

  String? get id => _id;
  String? get idpackage => _idpackage;
  String? get idpt => _idpt;
  String? get name => _name;
  String? get password => _password;
  String? get phone => _phone;
  Float? get weight => _weight;
  Float? get height => _height;
  String? get z_index => _z_index;
  String? get exp => _exp;
  String? get isAnswer => _isAnswer;
  String? get type => _type;

  Future<UserCredential> signup(String email, password, name, phone) async {
    Timestamp now = Timestamp.fromDate(DateTime.now());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        'id': userCredential.user!.uid,
        'name': name.trim(),
        'phone': phone.trim(),
        'email': email,
        'password': password,
        'isAnswer': false,
        'type': "user",
        'id_pt': "",
        'id_package':"",
        'created_date': now,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future addUser(String name, String phone, String email, String pass) async {
    await FirebaseFirestore.instance.collection('users').doc().set({
      'id': FirebaseFirestore.instance.collection('users').doc().id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': pass,
      'isAnswer': false,
      'type': "user",
    });
  }

  Future cancelRent(User user) async {
    user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
        {'id_pt': "", 'call_id': "", 'call_name': "", 'id_package': ""});
  }

  Future addUserWH(String weight,String height,String age,String experience,
      String activityIntensity,String healthStatus) async {
    await FirebaseFirestore.instance.collection("users").doc(id).update({
      'weight(kg)': weight,
      'height(cm)': height,
      'age': age,
      'exp': experience,
      'z-index': activityIntensity,
      'health_status': healthStatus,
      'isAnswer': true,
    });
  }

  Future addPurpose(int daysToTrain, String prequently, String id) async {
    await FirebaseFirestore.instance
        .collection("trainning_purpose")
        .doc(id)
        .set({
      'purpose': prequently,
      'prequently':'$daysToTrain buoi',
      'user_id': id
    });
  }

}



