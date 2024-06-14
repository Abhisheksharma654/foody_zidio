import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foody_zidio/Database/database.dart';
import 'package:foody_zidio/pages/bottomnav.dart';
import 'package:foody_zidio/pages/login.dart';
import 'package:foody_zidio/service/shared_pref.dart';
import 'package:foody_zidio/widget/widget_support.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";

  TextEditingController namecontroller = new TextEditingController();

  TextEditingController passwordcontroller = new TextEditingController();

  TextEditingController mailcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        ScaffoldMessenger.of(context).showSnackBar((const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            ))));
        String Id = randomAlphaNumeric(10);
        Map<String, dynamic> addUserInfo = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Wallet": "0",
          "Id": Id,
        };
        await DatabaseMethods().addUserDetail(addUserInfo, Id);
        await SharedPreferenceHelper().saveUserName(namecontroller.text);
        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserWallet('0');
        await SharedPreferenceHelper().saveUserId(Id);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const BottomNav()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exsists",
                style: TextStyle(fontSize: 18.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color(0xFFff5c30),
                    Color(0xFFe74b1a),
                  ])),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: const Text(""),
            ),
            Container(
              margin: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Center(
                      child: Image.asset(
                    "images/logo.png",
                    width: MediaQuery.of(context).size.width / 1.5,
                    fit: BoxFit.cover,
                  )),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            Text(
                              "Sign up",
                              style: AppWidget.HeadlineTextFeildStyle(),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            TextFormField(
                              controller: namecontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Name',
                                  hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon: const Icon(Icons.person_outlined)),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            TextFormField(
                              controller: mailcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter E-mail';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon: const Icon(Icons.email_outlined)),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            TextFormField(
                              controller: passwordcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Password';
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon: const Icon(Icons.password_outlined)),
                            ),
                            const SizedBox(
                              height: 80.0,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    email = mailcontroller.text;
                                    name = namecontroller.text;
                                    password = passwordcontroller.text;
                                  });
                                }
                                registration();
                              },
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: const Color(0Xffff5722),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Center(
                                      child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontFamily: 'Poppins1',
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70.0,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const LogIn()));
                      },
                      child: Text(
                        "Already have an account? Login",
                        style: AppWidget.semiBoldTextFeildStyle(),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}