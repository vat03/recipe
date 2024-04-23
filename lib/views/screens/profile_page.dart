import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hungry_app/firebase/firestore.dart';
import 'package:hungry_app/views/utils/AppColor.dart';
import 'package:hungry_app/views/widgets/user_info_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> profileData = {
    'email': '',
    'fullName': '',
    'createdAt': '',
  };

  double bmi = 0.0;

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

  Future getProfileData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? email = user!.email;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bmi = (prefs.getDouble('bmi') ?? 0.0);

    Firestore.getData('users').then((value) => {
          print(value),
          value.forEach((element) {
            if (element['email'] == email) {
              setState(() {
                profileData = {
                  'email': element['email'],
                  'fullName': element['fullName'],
                  'createdAt': element['createdAt'] != null
                      ? element['createdAt'].toDate().toString()
                      : '',
                };
              });
            }
          })
        });

    // Code to get user profile data
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text('My Profile',
            style: TextStyle(
                fontFamily: 'inter',
                fontWeight: FontWeight.w400,
                fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Profile Picture Wrapper
          Container(
            color: AppColor.primary,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(100),
                      // Profile Picture
                      image: const DecorationImage(
                          image: AssetImage('assets/images/pp.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Section 2 - User Info Wrapper
          Container(
            margin: const EdgeInsets.only(top: 24),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfoTile(
                  margin: const EdgeInsets.only(bottom: 16),
                  label: 'Email',
                  value: profileData['email'] ?? '',
                ),
                UserInfoTile(
                  margin: const EdgeInsets.only(bottom: 16),
                  label: 'Full Name',
                  value: profileData['fullName'] ?? '',
                ),
                UserInfoTile(
                  margin: const EdgeInsets.only(bottom: 16),
                  label: 'Subscription Type',
                  value: 'Premium Subscription',
                  valueBackground: AppColor.secondary,
                ),
                UserInfoTile(
                  margin: const EdgeInsets.only(bottom: 16),
                  label: 'Joining Date',
                  value: profileData['createdAt'] ?? '',
                ),
                UserInfoTile(
                  margin: const EdgeInsets.only(bottom: 16),
                  label: 'Body Mass Index',
                  value: '${bmi.toStringAsPrecision(2)} ${getBMIStatus()}',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
