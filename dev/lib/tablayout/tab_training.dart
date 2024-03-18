import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Controller/ExerciseController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../Views/Trainer/trainer_homepage.dart';


class Training extends StatefulWidget {
  const Training({super.key});

  @override
  State<Training> createState() => TrainingState();
}

List<String> equipments = [
  'Không',
  'Tạ đơn',
  'Dây',
  'Thảm trải',
  'Dây nhảy',
  'Xà đơn',
  'Xà kép',
  'Xà cao'
];
List<String> muscleGroup = [
  'Bắp chân',
  'Lưng',
  'Tay sau',
  'Tay trước',
  'Bụng',
  'Vai',
];
List<String> level = [
  'Dễ',
  'Trung bình',
  'Nâng cao',
];
class TrainingState extends State<Training> {
  final user = FirebaseAuth.instance.currentUser;
  String dropdownEquipment = equipments.first;
  String dropdownMuscleGroup = muscleGroup.first;
  String dropdownLevel = level.first;

  final _name = TextEditingController();
  final _set = TextEditingController();
  final _rep = TextEditingController();
  // final _level = TextEditingController();
  // final _muscleGroup = TextEditingController();
  // final _equipment = TextEditingController();



  @override
  void dispose() {
    // _name.dispose();
    // _set.dispose();
    // _rep.dispose();
    // _level.dispose();
    // _muscleGroup.dispose();
    // _equipment.dispose();
    super.dispose();
  }

  // Future addExersise(String name, String set, String rep, String level,
  //     String muscleGroup, String equipment) async {
  //   final docEx = FirebaseFirestore.instance.collection('exersise').doc();
  //   final data = {
  //     'set': set,
  //     'rep': rep,
  //     'level': level,
  //     'name': name,
  //     'muscleGroup': muscleGroup,
  //     'equipment': equipment,
  //     'id': docEx.id,
  //     'pt_uid': '${user?.uid}',
  //   };
  //   await docEx.set(data);
  // }

  void showToastSuccess() {
    Fluttertoast.showToast(
      msg: 'Tạo bài tập thành công',
    );
  }

  void showToastValidation() {
    Fluttertoast.showToast(
      msg: 'Vui lòng nhập đầy đủ thông tin ',
    );
  }

  final ExcerciseController _excerciseController = ExcerciseController();

  File ? _selectImage;
  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _selectImage = File(image!.path);
    });
  }

  @override
  void initState() {
    // getUserByEmail(user?.email);
    super.initState();
  }
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tạo bài tập",
          style: TextStyle(color: Colors.black),
        ),
          backgroundColor: Colors.grey[300],
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.grey[100],
        body: SizedBox(
            height: deviceHeight,
            child: Column(children: [
              Row(children: [
                OpenContainer(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedBuilder: (context, action) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      // borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 32.0,
                    ),
                  ),
                  openBuilder: (context, action) => Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const Text(
                          'Tạo bài tập',
                          style: TextStyle(color: Colors.black, fontSize: 23),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: _name,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              labelText: 'Tên bài tập',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: _set,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              labelText: 'Số set',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: _rep,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              labelText: 'Số rep',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DropdownButtonFormField<String>(
                          value: dropdownLevel,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (String? l) {
                            setState(() {
                              dropdownLevel = l!;
                            });
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Cấp độ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: level
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DropdownButtonFormField<String>(
                          value: dropdownMuscleGroup,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (String? muscle) {
                            setState(() {
                              dropdownMuscleGroup = muscle!;
                            });
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Nhóm cơ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: muscleGroup
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DropdownButtonFormField<String>(
                          value: dropdownEquipment,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (String? equip) {
                            setState(() {
                              dropdownEquipment = equip!;
                            });
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Dụng cụ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: equipments
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (_selectImage != null) {
                              setState(() {
                                _selectImage = null;
                              });
                            } else {
                              getImage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: _selectImage != null ? Colors.red : Colors.black54,
                            padding: const EdgeInsets.only(
                              right: 70,
                              left: 70,
                              top: 15,
                              bottom: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: _selectImage != null
                              ? Icon(Icons.close)
                              : Text('Upload Image'),
                        ),
                        SizedBox(
                          height: deviceHeight*0.3,
                          child:_selectImage != null ? Image.file(_selectImage!, fit: BoxFit.fitWidth,) : const Text("Vui lòng chọn ảnh cho bài tập ..."),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_name.text.trim() == "" ||
                                _set.text.trim() == "" ||
                                _rep.text.trim() == "") {
                              showToastValidation();
                            } else {
                              _excerciseController.addExersise(
                                  _name.text.trim(),
                                  _set.text.trim(),
                                  _rep.text.trim(),
                                  dropdownLevel,
                                  dropdownMuscleGroup,
                                  dropdownEquipment, user!);
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => const TrainerHomePage()));
                              showToastSuccess();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.black54,
                            padding: const EdgeInsets.only(
                                right: 90, left: 90, top: 15, bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Lưu'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 130),
                  child: Text(
                    "Bài tập",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ]),
              ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(
                      height: deviceHeight*0.75,
                      child: buildExerciseList(),
                    ),
                  ])
            
            ])
            )
            );
  }
  Future<List<QueryDocumentSnapshot>> getExersise() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('exersise')
          .where('pt_uid', isEqualTo: '${user?.uid}')
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Lỗi khi truy vấn Firestore: $e');
      return [];
    }
  }

  Widget buildExerciseList() {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future:  getExersise(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Hiện tại chưa có bài tập',
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
              var exersise = snapshot.data![index];
              var name = exersise['name'] as String;
              var set = exersise['set'] as String;
              var rep = exersise['rep'] as String;
              var level = exersise['level'] as String;
              var muscle = exersise['muscleGroup'] as String;
              var equipment = exersise['equipment'] as String;

              return buildExerciseListItem(
                  name, set, rep, level, muscle, equipment);
            },
          );
        }
      },
    );
  }

  Widget buildExerciseListItem(String name, String set, String rep, String level,
      String muscle, String equipment) {
    return ListTile(
      title: Container(
        height: 150,
        width: 150,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text("Tên: "),
                  Text(name),
                ]),
                Row(children: [
                  const Text("Set: "),
                  Text(set),
                ]),
                Row(children: [
                 const Text("Rep: "),
                  Text(rep),
                ]),
                Row(children: [
                  const Text("Level: "),
                  Text(level),
                ]),
                Row(children: [
                  const Text("Nhóm cơ: "),
                  Text(muscle),
                ]),
                Row(children: [
                  const Text("Dụng cụ: "),
                  Text(equipment),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
  }

