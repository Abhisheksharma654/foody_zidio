import 'package:flutter/material.dart';
import 'package:foody_zidio/pages/signup.dart';
import 'package:foody_zidio/widget/widget_support.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGradientBackground(context),
          _buildWhiteContainer(context),
          _buildLoginContent(context),
        ],
      ),
    );
  }

  Widget _buildGradientBackground(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFff5c30),
            Color(0xFFe74b1a),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child:
          const SizedBox.shrink(), // Placeholder for potential future content
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
      child: Column(
        children: [
          _buildLogo(context),
          const SizedBox(height: 50.0),
          _buildLoginForm(context),
          const SizedBox(height: 70.0),
          _buildSignUpPrompt(),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Center(
      child: Image.asset(
        "images/logo.png",
        width: MediaQuery.of(context).size.width / 1.5,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Text("Login", style: AppWidget.HeadlineTextFeildStyle()),
            const SizedBox(height: 30.0),
            _buildEmailField(),
            const SizedBox(height: 30.0),
            _buildPasswordField(),
            const SizedBox(height: 20.0),
            _buildForgotPassword(),
            const SizedBox(height: 40.0),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintStyle: AppWidget.semiBoldTextFeildStyle(),
        prefixIcon: const Icon(Icons.email_outlined),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        hintStyle: AppWidget.semiBoldTextFeildStyle(),
        prefixIcon: const Icon(Icons.password_outlined),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Container(
      alignment: Alignment.topRight,
      child: Text(
        "Forgot Password?",
        style: AppWidget.semiBoldTextFeildStyle(),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        width: 200,
        decoration: BoxDecoration(
          color: const Color(0Xffff5722),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            "LOGIN",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: 'Poppins1',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Signup()));
      },
      child: Text(
        "Don't have an account? Sign up",
        style: AppWidget.semiBoldTextFeildStyle(),
      ),
    );
  }
}
