import 'package:dev/tablayout/tab_home.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Macro extends StatefulWidget {
  const Macro({super.key});

  @override
  State<Macro> createState() => _MacroState();
}

class _MacroState extends State<Macro> {
  final TextEditingController _proCon = TextEditingController();
  final _carbCon = TextEditingController();
  final _fatCon = TextEditingController();
  double pro = 40;
  double carb = 40;
  double fat = 40;
  double p = 0;
  double f = 0;
  double c = 0;
  double sum = 0;
  String tb = " ";
  String dam = " ";
  String beo = " ";

  String calPro() {
    p = ((tdee - 500) * (pro / 100)) / 4;
    dam = p.toStringAsFixed(0);
    return dam;
  }

  String calFat() {
    f = ((tdee - 500) * (fat / 100)) / 9;
    beo = f.toStringAsFixed(0);
    return beo;
  }

  String calCarb() {
    c = ((tdee - 500) * (carb / 100)) / 4;
    tb = c.toStringAsFixed(0);
    return tb;
  }

  @override
  void dispose() {
    _carbCon.dispose();
    _proCon.dispose();
    _fatCon.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _proCon.text = "40";
    _carbCon.text = "40";
    _fatCon.text = "20";
    pro = double.parse(_proCon.text);
    carb = double.parse(_carbCon.text);
    fat = double.parse(_fatCon.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    '100%',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    width: 800,
                    height: 400,
                    child: PieChart(
                        swapAnimationCurve: Curves.easeInOut,
                        swapAnimationDuration:
                            const Duration(milliseconds: 750),
                        PieChartData(sections: [
                          PieChartSectionData(
                              value: fat,
                              color: Colors.amber,
                              titleStyle: const TextStyle(fontSize: 20),
                              title: '${_fatCon.text}%'),
                          PieChartSectionData(
                              value: pro,
                              color: Colors.red,
                              titleStyle: const TextStyle(fontSize: 20),
                              title: '${_proCon.text}%'),
                          PieChartSectionData(
                              value: carb,
                              color: Colors.green,
                              titleStyle: const TextStyle(fontSize: 20),
                              title: "${_carbCon.text}%")
                        ])),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 100),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.square,
                          color: Colors.red,
                          size: 40,
                        ),
                        Text(
                          "Protein",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Icon(
                          Icons.square,
                          color: Colors.green,
                          size: 40,
                        ),
                        Text(
                          "Carb",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Icon(
                          Icons.square,
                          color: Colors.yellow,
                          size: 40,
                        ),
                        Text(
                          "Fat",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    const Text(
                      "Số gam đạm cần phải nạp: ",
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      "${calPro()} gam",
                      style: const TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    const Text(
                      "Số gam tinh bột cần phải nạp: ",
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      "${calCarb()} gam",
                      style: const TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    const Text(
                      "Số gam chất béo cần phải nạp: ",
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      "${calFat()} gam",
                      style: const TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
