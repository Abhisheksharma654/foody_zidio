import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foody_zidio/pages/forgetpassword.dart';
import 'package:foody_zidio/pages/home.dart';
import 'package:foody_zidio/pages/signup.dart';
import 'package:foody_zidio/widget/widget_support.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (builder) =>  Home()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF44336),
            Color(0xFFF44336),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildLogo(context),
              const SizedBox(height: 150.0),
              _buildLoginForm(context),
            ],
          ),
        ),
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
      elevation: 10.0,
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
            const SizedBox(height: 70.0),
            Text("Login", style: AppWidget.HeadlineTextFeildStyle()),
            const SizedBox(height: 10.0),
            _buildEmailField(),
            const SizedBox(height: 10.0),
            _buildPasswordField(),
            const SizedBox(height: 40.0),
            _buildLoginButton(),
            const SizedBox(height: 20.0),
            _buildLoginPrompt(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintStyle: AppWidget.semiBoldTextFeildStyle(),
        prefixIcon: const Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        hintStyle: AppWidget.semiBoldTextFeildStyle(),
        prefixIcon: const Icon(Icons.password_outlined),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return _isLoading
        ? CircularProgressIndicator()
        : GestureDetector(
            onTap: _login,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: 'Poppins1',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          " Don't have an account?",
          style: AppWidget.semiBoldTextFeildStyle(),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Signup()),
            );
          },
          child: const Text(
            ' SignUp Now',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
