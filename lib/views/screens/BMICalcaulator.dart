import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:feather_icons/feather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hungry_app/views/utils/AppColor.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  double weight = 50.5;
  double height = 150.0;
  double bmi = 0.0;

  bool showResult = false;

  String getBMIStatus() {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Pre-obese';
    } else if (bmi >= 30 && bmi < 35) {
      return 'Obese';
    } else {
      return 'Severely Obese';
    }
  }

  saveBMI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('bmi', bmi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('BMI Calculator', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const Text('Weight'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          weight -= 0.5;
                        });
                      },
                      icon: const Icon(FeatherIcons.minus, color: Colors.white),
                    ),
                  ),
                  Text(
                    '$weight kg',
                    style: const TextStyle(fontSize: 25),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          weight += 0.5;
                        });
                      },
                      icon: const Icon(FeatherIcons.plus, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              const Text('Height'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          height -= 1;
                        });
                      },
                      icon: const Icon(FeatherIcons.minus, color: Colors.white),
                    ),
                  ),
                  Text(
                    '$height cm',
                    style: const TextStyle(fontSize: 25),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          height += 1;
                        });
                      },
                      icon: const Icon(FeatherIcons.plus, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                bmi = weight / ((height / 100) * (height / 100));
                showResult = true;
                saveBMI();
              });
            },
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  'Calculate BMI',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          showResult
              ? Column(
                  children: [
                    const Text(
                      'Your BMI is',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      bmi.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 30),
                    ),
                    Text(
                      getBMIStatus(),
                      style: const TextStyle(fontSize: 25, color: Colors.black),
                    )
                  ],
                )
              : Column(
                  children: [
                    const Text(
                      'Your BMI is',
                      style: TextStyle(fontSize: 25, color: Colors.transparent),
                    ),
                    Text(
                      bmi.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 30, color: Colors.transparent),
                    ),
                  ],
                ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
