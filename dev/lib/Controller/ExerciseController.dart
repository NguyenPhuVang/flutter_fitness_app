import 'package:dev/model/Exercise.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExcerciseController{
  factory ExcerciseController(){
    if (_this == null) _this = ExcerciseController._();
    return _this;
  }

  static ExcerciseController _this = ExcerciseController._();
  ExcerciseController._();

  void addExersise(String name, String set, String rep, String level,
      String muscleGroup, String equipment, User user){
    Exercise().addExersise(name, set, rep, level, muscleGroup, equipment, user);
  }

}