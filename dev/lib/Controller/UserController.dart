import 'package:dev/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UsersController{
  factory UsersController(){
    if (_this == null) _this = UsersController._();
    return _this;
  }

  static UsersController _this = UsersController._();
  UsersController._();

  Future<UserCredential> (String email, pass, name, phone) async {
    Users().signup(email, pass, name, phone);
  }

  void addUser (String name, phone, email, pass){
    Users().addUser(name, phone, email, pass);
  }

  void cancelRent(User user){
    Users().cancelRent(user);
  }

  void addUserWH(String weight, height, age, experience, activityIntensity, healthStatus){
    Users().addUserWH(weight, height, age, experience, activityIntensity, healthStatus);
  }

  void addPurpose(int daysToTrain, String prequently, String id){
    Users().addPurpose(daysToTrain, prequently, id);
  }
}