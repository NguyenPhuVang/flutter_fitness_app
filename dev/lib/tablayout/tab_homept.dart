import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Views/Trainer/trainer_create_exersise_calendar.dart';

class HomePT extends StatefulWidget {
  const HomePT({super.key});

  @override
  State<HomePT> createState() => _HomePTState();
}

class _HomePTState extends State<HomePT> {
  final user = FirebaseAuth.instance.currentUser;

  String ptname = " ";

  Future getPTByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          // id = doc.reference.id;
          ptname = '${doc['name']}';
        });
      });
    });
  }

  Future<int> countAllExersiseFromPt(String? uid) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("exersise")
        .where("pt_uid", isEqualTo: '${user?.uid}')
        .get();

    int totalCount = snapshot.size;
    return totalCount;
  }

  Future<int> countAllUserRentPt(String? uid) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("id_pt", isEqualTo: '${user?.uid}')
        .get();

    int totalCount = snapshot.size;
    return totalCount;
  }

  @override
  void initState() {
    getPTByEmail(user?.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                height: deviceHeight*0.35,
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100], // Màu xanh dương nhạt
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(35.0),
                    bottomRight: Radius.circular(35.0),
                  ),
                ),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        width: deviceWidth,
                        height: deviceHeight*0.15,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 5.0,
                              spreadRadius: 1.1,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible( // Sử dụng Flexible thay vì Text để đảm bảo xuống dòng khi cần
                                  child: Text(
                                    "Xin chào, $ptname",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[100],
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Hãy kiểm tra các hoạt động của bạn",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Container(
                              width: deviceWidth*0.45,
                              height: deviceHeight*0.15,
                              margin: const EdgeInsets.all(7),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 5.0,
                                    spreadRadius: 1.1,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Tổng bài tập đã tạo",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: const FaIcon(
                                          FontAwesomeIcons.dumbbell,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      countExersise(),
                                    ],
                                  ),
                                ],
                              )),
                          Container(
                              width: deviceWidth*0.45,
                              height: deviceHeight*0.15,
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 5.0,
                                    spreadRadius: 1.1,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Số người thuê bạn",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: const FaIcon(
                                          FontAwesomeIcons.universalAccess,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      countUserRentPt(),
                                    ],
                                  ),
                                ],
                              )),
                        ],
                      )),
                ])),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Danh sách học viên",
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                    height: deviceHeight*0.55,
                    child: buildExerciseList(),
                  ),
                ]),
          ]),
        ),
      ),
    );
  }

  Future<List<QueryDocumentSnapshot>> getExersise() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id_pt', isEqualTo: '${user?.uid}')
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Lỗi khi truy vấn Firestore: $e');
      return [];
    }
  }
  Widget buildExerciseList() {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: getExersise(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Hiện tại chưa có người tập thuê bạn',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var users = snapshot.data![index];
              var name = users['name'] as String;
              var phone = users['phone'] as String;
              var email = users['email'] as String;
              var uid = users['id'] as String;

              return buildExerciseListItem(name, phone, email, uid);
            },
          );
        }
      },
    );
  }
  Widget buildExerciseListItem(String name, String phone, String email, String uid) {
    return  GestureDetector(
      onTap: () {
        _navigateToCreateExersiseCalendar(uid); // Chuyển trang và truyền UID
      },
      child: ListTile(
      title: Container(
        height: 140,
        width: 150,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text("Tên: ",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Text(name,
                    style: const TextStyle(
                        fontSize: 20,
                  )),
                ]),
                // Row(children: [
                //   Text("Kinh nghiệm: "),
                //   Text(experience),
                // ]),
                Row(children: [
                  const Text("Số điện thoại: ",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Text(phone,
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                ]),
                Row(children: [
                  const Text("Email: ",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Text(email,
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                ]),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget countExersise() {
    return FutureBuilder<int>(
      future: countAllExersiseFromPt(
          user?.uid), // Gọi hàm countAllExersiseFromPt với uid
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Hiển thị tiến trình khi đang đợi dữ liệu
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else {
          int totalCount = snapshot.data ??
              0; // Lấy dữ liệu hoặc mặc định là 0 nếu không có dữ liệu

          return Text(
            '$totalCount',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }
  Widget countUserRentPt() {
    return FutureBuilder<int>(
      future: countAllUserRentPt(
          user?.uid), // Gọi hàm countAllExersiseFromPt với uid
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Hiển thị tiến trình khi đang đợi dữ liệu
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else {
          int totalCount = snapshot.data ??
              0; // Lấy dữ liệu hoặc mặc định là 0 nếu không có dữ liệu

          return Text(
            '$totalCount',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }
  void _navigateToCreateExersiseCalendar(String uid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrainerCreateExersiseCalendarPage(uid: uid),
      ),
    );
  }
}
