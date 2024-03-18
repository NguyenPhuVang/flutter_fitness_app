import 'package:dev/model/Trainer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainerController {
  factory TrainerController(){
    if (_this == null) _this = TrainerController._();
    return _this;
  }

  static TrainerController _this = TrainerController._();
  TrainerController._();

  Future addUser(String name, String phone, String email, String experience,
      String qualification, DateTime dOB, String teachdays) async {
        Trainer().addUser(name, phone, email, experience, qualification, dOB, teachdays);
  }

  void addExersiseToUser(DateTime dob, String nameExsersise, String uid, User user){
    Trainer().addExersiseToUser(dob, nameExsersise, uid, user);
  }

  void getExersiseOfUser(String uid){
    Trainer().getExersiseOfUser(uid);
  }

  Stream<List<String>> getExerciseNamesStream(String? uid, User user) {
   return Trainer().getExerciseNamesStream(uid, user);
  }
}