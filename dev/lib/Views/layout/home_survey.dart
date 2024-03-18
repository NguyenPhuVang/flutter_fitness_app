import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Controller/UserController.dart';
import 'package:dev/Views/layout/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_survey/flutter_survey.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeSurvey extends StatefulWidget {
  @override
  _HomeSurveyState createState() => _HomeSurveyState();
}

class _HomeSurveyState extends State<HomeSurvey> {
  final UsersController _usersController = UsersController();
  final user = FirebaseAuth.instance.currentUser;

  String id = " ";
  String name = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;
        setState(() {
          this.name = '${doc['name']}';
        });
      });
    });
  }

  final _heightRegex = RegExp(r'^\d+\.\d+$'); // Validate height
  final _weightRegex = RegExp(r'^\d+$');
  List<QuestionResult> answerResults = [];

  void submitAnswer (List<QuestionResult> questionResults ) {
    String weight = questionResults[0].answers.first;
    String height = questionResults[1].answers.first;
    if (questionResults.length < 8){
      Fluttertoast.showToast(
        msg: 'Vui lòng điền đầy đủ thông tin khảo sát trên !',
      );
    } else if (!_heightRegex.hasMatch(height)) {
      showToastValidationHeight();
    } else if (!_weightRegex.hasMatch(weight)) {
      showToastValidationWeight();
    } else{
      String age = questionResults[2].answers.first;
      int daysToTrain = questionResults[3].answers.length;
      String experience = questionResults[4].answers.first;
      String activityIntensity = questionResults[5].answers.first;
      String trainingGoal = questionResults[6].answers.first;
      String healthStatus = questionResults[7].answers.first;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage()));
      _usersController.addUserWH(weight, height,age,experience, activityIntensity,healthStatus);
      _usersController.addPurpose(daysToTrain, trainingGoal, id);
    }
  }


  // Future addUserWH(String weight, String height, String age, String experience,
  //     String activityIntensity, String healthStatus) async {
  //   await FirebaseFirestore.instance.collection("users").doc(id).update({
  //     'weight(kg)': weight,
  //     'height(cm)': height,
  //     'age': age,
  //     'exp': experience,
  //     'z-index': activityIntensity,
  //     'health_status': healthStatus,
  //     'isAnswer': true,
  //   });
  // }

  // Future addPurpose(int daysToTrain, String prequently) async {
  //   await FirebaseFirestore.instance
  //       .collection("trainning_purpose")
  //       .doc(id)
  //       .set({
  //     'purpose': prequently,
  //     'prequently': '$daysToTrain buoi',
  //     'user_id': id
  //   });
  // }

  @override
  void initState() {
    getUserByEmail(user?.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Question> _initialData = [
      Question(
        question: "Cân nặng của bạn (Theo kg). VD: 60",
        isMandatory: true,
      ),
      Question(
        question: "Chiều cao của bạn (Theo mét). VD: 1.7",
        isMandatory: true,
      ),
      Question(
        question: "Tuổi của bạn. VD: 20",
        isMandatory: true,
      ),
      Question(
          question: "Số buổi bạn có thể tập trong tuần ?",
          isMandatory: true,
          singleChoice: false,
          answerChoices: const {
            "Thứ 2": null,
            "Thứ 3": null,
            "Thứ 4": null,
            "Thứ 5": null,
            "Thứ 6": null,
            "Thứ 7": null,
            "Chủ nhật": null,
          }),
      Question(
        isMandatory: true,
        question: 'Kinh nghiệm tập luyện',
        answerChoices: const {
          "Chưa có kinh nghiệm": null,
          "3 tháng kinh nghiệm": null,
          "6 tháng kinh nghiệm": null,
          "Trên 1 năm kinh nghiệm": null,
        },
      ),
      Question(
        isMandatory: true,
        question: 'Cường độ hoạt động',
        answerChoices: const {
          "Ít vận động": null,
          "Vận động nhẹ": null,
          "Vận động vừa": null,
          "Vận động nhiều": null,
          "Vận động nặng": null,
        },
      ),
      Question(
        isMandatory: true,
        question: 'Mục tiêu luyện tập',
        answerChoices: const {
          "Tăng cơ / Giảm mỡ": null,
          "Tăng sức mạnh": null,
          "Tăng cân / Tăng cơ": null,
          "Thi đấu thể hình": null,
        },
      ),
      Question(
        isMandatory: true,
        question:
            'Tình trạng sức khỏe, đừng ngần ngại chia sẻ câu chuyện của bạn',
      ),
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text("Khảo sát nhu cầu của người tập"),
          backgroundColor: Colors.lightBlueAccent[200],
        ),
        body: SizedBox(
          height: 1100,
          child: Stack(
            children: [
              Survey(
                initialData: _initialData,
                onNext: (questionResults) {
                  answerResults = questionResults;
                  // Lưu kết quả khảo sát
                },
              ),
              Positioned(
                top: null,
                left: null,
                right: 20.0,
                bottom: 20.0,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.lightBlue[200],
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.lightBlue[300],
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        submitAnswer(answerResults);
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
void showToastValidationHeight() {
  Fluttertoast.showToast(
    msg: 'Vui lòng nhập theo định dạng VD: 1.7',
  );
}

void showToastValidationWeight() {
  Fluttertoast.showToast(
    msg: 'Vui lòng nhập đúng định dạng VD: 60',
  );
}