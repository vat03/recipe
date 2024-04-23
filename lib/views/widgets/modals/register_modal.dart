import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:hungry_app/firebase/auth.dart';
import 'package:hungry_app/firebase/firestore.dart';
import 'package:hungry_app/views/screens/page_switcher.dart';
import 'package:hungry_app/views/utils/AppColor.dart';
import 'package:hungry_app/views/widgets/custom_text_field.dart';
import 'package:hungry_app/views/widgets/modals/login_modal.dart';

class RegisterModal extends StatefulWidget {
  const RegisterModal({super.key});

  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  Future<void> _register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await AuthenticateFirebase.registerWithEmailAndPassword(
            emailController.text, passwordController.text)
        .then((value) async => {
              if (value != null)
                {
                  await Firestore.addData('users', {
                    'uid': value.uid,
                    'email': emailController.text,
                    'fullName': fullNameController.text,
                    'createdAt': DateTime.now()
                  }).then((value) async => {
                        // await prefs.setString('docid', value.id),
                        Navigator.of(context).pop(),
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => PageSwitcher()))
                      })
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 85 / 100,
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            physics: const BouncingScrollPhysics(),
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 35 / 100,
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 6,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              // header
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'inter'),
                ),
              ),
              // Form
              CustomTextField(
                  title: 'Email',
                  hint: 'youremail@email.com',
                  controller: emailController),
              CustomTextField(
                  title: 'Full Name',
                  hint: 'Your Full Name',
                  controller: fullNameController,
                  margin: const EdgeInsets.only(top: 16)),
              CustomTextField(
                  title: 'Password',
                  hint: '**********',
                  controller: passwordController,
                  obsecureText: true,
                  margin: const EdgeInsets.only(top: 16)),
              CustomTextField(
                  title: 'Retype Password',
                  hint: '**********',
                  controller: confirmPasswordController,
                  obsecureText: true,
                  margin: const EdgeInsets.only(top: 16)),
              // Register Button
              Container(
                margin: const EdgeInsets.only(top: 32, bottom: 6),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _register();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: AppColor.primarySoft,
                  ),
                  child: Text('Register',
                      style: TextStyle(
                          color: AppColor.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'inter')),
                ),
              ),
              // Login textbutton
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    isScrollControlled: true,
                    builder: (context) {
                      return const LoginModal();
                    },
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Have an account? ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                          style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'inter',
                          ),
                          text: 'Log in')
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
