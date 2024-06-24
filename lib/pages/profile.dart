import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody_zidio/Content/bottom_nav.dart';
import 'package:foody_zidio/Content/onboard.dart';
import 'package:foody_zidio/Content/settings_updt.dart';
import 'package:foody_zidio/pages/home.dart';
import 'package:foody_zidio/pages/login.dart';
import 'package:foody_zidio/service/shared_pref.dart';
import 'package:foody_zidio/widget/widget_support.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email;
  double profileCompletion = 0.0;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });  
      await uploadItem();
    }
  }

  Future<void> uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImages").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserProfile(downloadUrl.toString());
      setState(() {
        profile = downloadUrl.toString();
        profileCompletion = calculateProfileCompletion();
      });
    }
  }

  double calculateProfileCompletion() {
    double completion = 0.0;
    if (profile != null && profile!.isNotEmpty) completion += 25.0;
    if (name != null && name!.isNotEmpty) completion += 25.0;
    if (email != null && email!.isNotEmpty) completion += 25.0;
    return completion;
  }

  Future<void> getSharedPrefs() async {
    profile = await SharedPreferenceHelper().getUserProfile();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    profileCompletion = calculateProfileCompletion();
    setState(() {});
  }

  Future<void> verifyUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      String? storedEmail = await SharedPreferenceHelper().getUserEmail();
      if (currentUser.email != storedEmail) {
        await signOut(context);
      } else {
        await getSharedPrefs();
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Onboard()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    verifyUser();
  }

 Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Onboard()),
      (route) => false, // This removes all routes from the stack
    );
  } catch (e) {
    print('Error signing out: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  
       backgroundColor: Colors.black,
        title: ProfileTitle(
            profileCompletionCount: (profileCompletion / 25).toInt(),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (builder) => BottomNav()));
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => SettingsPage()));
            },
            icon: const Icon(Icons.settings_rounded),
            color: Colors.white,
          ),
        ],
      ),
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: getImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : (profile != null && profile!.isNotEmpty)
                                ? NetworkImage(profile!)
                                : const AssetImage("images/person.png")
                                    as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name ?? "Name not set",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(email ?? "Email not set"),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Text(
                        "Complete your profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "(${(profileCompletion / 25).toInt()}/3)",
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Container(
                        height: 7,
                        margin: EdgeInsets.only(right: index == 2 ? 0 : 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: index < (profileCompletion / 25).toInt()
                              ? Colors.blue
                              : Colors.black12,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  color: Colors.white,
                  
                  shadowColor: Colors.black,
                  child: ListTile(
                    leading: const Icon(Icons.insights),
                    title: const Text("Activity"),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  
                ),
                const SizedBox(height: 5),
                Card(
                  elevation: 4,
                  color: Colors.white,
                  shadowColor: Colors.black,
                  child: ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text("Location"),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                const SizedBox(height: 5),
                Card(
                  elevation: 4,
                  color: Colors.white,
                  shadowColor: Colors.black,
                  child: ListTile(
                    leading: const Icon(CupertinoIcons.bell),
                    title: const Text("Notifications"),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                const SizedBox(height: 5),
                Card(
                  elevation: 4,
                  shadowColor: Colors.black,
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(CupertinoIcons.arrow_right_arrow_left),
                    title: const Text("Logout"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      signOut(
                          context); // Call the signOut method when Logout tile is tapped
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class ProfileTitle extends StatelessWidget {
  final int profileCompletionCount;

  const ProfileTitle({Key? key, required this.profileCompletionCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "PROFILE",
          style:AppWidget.semiBoldWhiteTextFeildStyle()
           
        ),
        const SizedBox(width: 5),
        Text(
          "(${profileCompletionCount}/3)",
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
