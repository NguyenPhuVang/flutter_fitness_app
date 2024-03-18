import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Controller/UserController.dart';
import 'package:dev/Views/layout/homepage.dart';
import 'package:dev/tablayout/get_pt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CancelRent extends StatefulWidget {
  const CancelRent({super.key});

  @override
  State<CancelRent> createState() => _CancelRentState();
}

class _CancelRentState extends State<CancelRent> {
  final user = FirebaseAuth.instance.currentUser;
  String id = " ";
  String ptid = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          ptid = '${doc['id_pt']}';
          print(ptid);
        });
      });
    });
  }


  List<String> ptIDs = [];
  List<String> ptNames = [];
  Future getPT() async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("active", isEqualTo: true)
        .where("id", isEqualTo: ptid)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        ptIDs.add(doc.reference.id);
        ptNames.add('${doc['name']}');
      });
    });
  }

  @override
  void initState() {
    getUserByEmail(user!.email);
    getPT();
    super.initState();
  }

  final UsersController _usersController = UsersController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hủy thuê PT'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getPT(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: ptIDs.length,
              itemBuilder: (context, index) {
                if (ptid != " ") {
                  return ListTile(
                    title: Container(
                      height: 120,
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          GetPT(ptID: ptIDs[index]),
                          const SizedBox(
                            width: 50,
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Xác nhận hủy',
                                          style: TextStyle(fontSize: 25),
                                          textAlign: TextAlign.center,
                                        ),
                                        content: const Text(
                                            'Bạn chắc chắn muốn hủy thuê pt ?',
                                            style: TextStyle(fontSize: 25)),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30),
                                                  child: SizedBox(
                                                    width: 150,
                                                    height: 50,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: const Color.fromARGB(
                                                                  255,
                                                                  128,
                                                                  241,
                                                                  132),
                                                          side: const BorderSide(
                                                              width: 3,
                                                              color: Color.fromARGB(
                                                                  255,
                                                                  128,
                                                                  241,
                                                                  132)),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                      onPressed: () {
                                                        _usersController.cancelRent(user!);
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const HomePage()));
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              'Hủy thuê thành công',
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 2,
                                                          textColor:
                                                              Colors.white,
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(255,
                                                                  80, 182, 133),
                                                          fontSize: 20,
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Chắc chắn',
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  )),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 30),
                                                  child: SizedBox(
                                                    width: 150,
                                                    height: 50,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: const Color.fromARGB(
                                                              255, 221, 90, 85),
                                                          side: const BorderSide(
                                                              width: 3,
                                                              color: Color
                                                                  .fromARGB(255,
                                                                  221, 90, 85)),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(10))),
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const CancelRent()));
                                                      },
                                                      child: const Text(
                                                        'Trở về',
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                                size: 40,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    ),
                    onTap: () {},
                  );
                } else {
                  return const Scaffold();
                }
              },
            );
          }),
    );
  }
}
