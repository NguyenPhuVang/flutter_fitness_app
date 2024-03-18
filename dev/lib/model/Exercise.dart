import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Exercise {
  static String? _id;
  static String? _ptUID;
  static String? _name;
  static String? _rep;
  static String? _set;
  static String? _muscleGroup;
  static String? _level;
  static String? _equipment;

  String? get id => _id;
  String? get ptUID => _ptUID;
  String? get name => _name;
  String? get rep => _rep;
  String? get set => _set;
  String? get muscleGroup => _muscleGroup;
  String? get level => _level;
  String? get equipment => _equipment;

  Future addExersise(String name, String set, String rep, String level,
      String muscleGroup, String equipment, User user) async {
    user = FirebaseAuth.instance.currentUser!;
    final docEx = FirebaseFirestore.instance.collection('exersise').doc();
    final data = {
      'set': set,
      'rep': rep,
      'level': level,
      'name': name,
      'muscleGroup': muscleGroup,
      'equipment': equipment,
      'id': docEx.id,
      'pt_uid': user.uid,
    };
    await docEx.set(data);
  }

}