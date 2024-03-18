import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Views/Trainer/trainer_create_exersise_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Trainer {
  static String? _id;
  static String? _name;
  static String? _email;
  static String? _password;
  static String? _mobile;
  static DateTime? _dateOfBirth;
  static String? _type;
  static String? _teachdays;
  static String? _qualification;
  static String? _experience;

  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;
  String? get mobile => _mobile;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get type => _type;
  String? get teachdays => _teachdays;
  String? get qualification => _qualification;
  String? get experience => _experience;

  Future addUser(String name, String phone, String email, String experience,
      String qualification, DateTime dOB, String teachdays) async {
    final docPt = FirebaseFirestore.instance.collection('trainers').doc();
    final data = {
      'active': false,
      'date_of_birth': dOB,
      'experience': experience,
      'qualification': qualification,
      'name': name,
      'mobile': phone,
      'email': email,
      'id': docPt.id,
      'teachdays': teachdays,
      'type': "trainer",
    };
    await docPt.set(data);
  }
  
  void addExersiseToUser(DateTime dob, String nameExsersise, String uid, User user) async {
    String user_uid = uid; // Đây là uid của người dùng
    String? pt_uid = user.uid; // Đây là uid của người dùng
    String rep = "";
    String set = "";

    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');

     await FirebaseFirestore.instance
        .collection("exersise")
        .where("name", isEqualTo: nameExsersise)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        rep = '${doc['rep']}';
        set = '${doc['set']}';
      });
    });

    userCollection.doc(user_uid).collection('exersise_calendar').add({
      'user_id': user_uid,
      'pt_id': pt_uid,
      'created_date': DateTime.now(),
      'date': dob,
      'name': nameExsersise,
      'set': set,
      'rep': rep
    });
    showToastSuccess();
  }

  void getExersiseOfUser(String uid) async {
    String user_uid = uid; // Đây là uid của người dùng
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    userCollection.doc(user_uid).collection('exersise_calendar').get();
  }

  Stream<List<String>> getExerciseNamesStream(String? uid, User? user) {
    return FirebaseFirestore.instance
        .collection('exersise')
        .where('pt_uid', isEqualTo: user!.uid)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<String> exerciseNames = [];
      querySnapshot.docs.forEach((doc) {
        var name = doc['name'] as String;
        exerciseNames.add(name);
      });
      return exerciseNames;
    });
  }
}