import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:foody_zidio/Database/database.dart';
import 'package:foody_zidio/service/shared_pref.dart';
import 'package:foody_zidio/widget/widget_support.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SharedPreferenceHelper _sharedPreferenceHelper =
      SharedPreferenceHelper();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  String? name;
  String? email;
  String? profileImageUrl;
  File? selectedImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    String? userName = await _sharedPreferenceHelper.getUserName();
    String? userEmail = await _sharedPreferenceHelper.getUserEmail();
    String? userProfile = await _sharedPreferenceHelper.getUserProfile();

    setState(() {
      name = userName;
      email = userEmail;
      profileImageUrl = userProfile;

      _nameController.text = userName ?? '';
      _emailController.text = userEmail ?? '';
    });
  }

  Future<void> getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('user_id.jpg');
        await storageRef.putFile(selectedImage!);
        String downloadURL = await storageRef.getDownloadURL();

        await _sharedPreferenceHelper.saveUserProfile(downloadURL);
        String? userId = await _sharedPreferenceHelper.getUserId();
        if (userId != null) {
          await _databaseMethods.updateUserProfile(userId, _nameController.text,
              _emailController.text, _passwordController.text);
        }

        setState(() {
          profileImageUrl = downloadURL;
        });

        // Show SnackBar after successful update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error uploading profile image: $e');
      }
    }
  }

  Future<void> updateUserProfile() async {
    String newName = _nameController.text;
    String newEmail = _emailController.text;
    String newPassword = _passwordController.text;

    await _sharedPreferenceHelper.saveUserName(newName);
    await _sharedPreferenceHelper.saveUserEmail(newEmail);
    await _sharedPreferenceHelper.saveUserProfile(profileImageUrl!);

    String? userId = await _sharedPreferenceHelper.getUserId();
    if (userId != null) {
      await _databaseMethods.updateUserProfile(
          userId, newName, newEmail, newPassword);
    }

    setState(() {
      name = newName;
      email = newEmail;
    });

    // Show SnackBar after successful update
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "SETTINGS",
          style: AppWidget.semiBoldWhiteTextFeildStyle(),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: getImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: getImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: selectedImage != null
                              ? FileImage(selectedImage!)
                              : (profileImageUrl != null &&
                                      profileImageUrl!.isNotEmpty)
                                  ? NetworkImage(profileImageUrl!)
                                  : AssetImage("images/person.png")
                                      as ImageProvider,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              child: Column(
                children: [
                  _buildInfoCard(Icons.person, 'Name', _nameController),
                  SizedBox(height: 20.0),
                  _buildInfoCard(Icons.email, 'Email', _emailController),
                  SizedBox(height: 20.0),
                  _buildInfoCard(Icons.lock, 'New Password', _passwordController),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: updateUserProfile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Center(
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      IconData icon, String title, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 20.0),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: title,
                isDense: true,
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
