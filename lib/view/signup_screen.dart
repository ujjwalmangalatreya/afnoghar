import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamroghar/global.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _firstNameTextEditingController =
      TextEditingController();
  final TextEditingController _lastNameTextEditingController =
      TextEditingController();
  final TextEditingController _countryTextEditingController =
      TextEditingController();
  final TextEditingController _cityTextEditingController =
      TextEditingController();
  final TextEditingController _bioTextEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? imageFileOfUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.amber],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Create New Account",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.amber],
            begin: FractionalOffset(0, 0),
            end: FractionalOffset(1, 0),
            stops: [0, 1],
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Image.asset(
                "images/signup.png",
                width: 240,
              ),
            ),
            Text(
              "Don't have an account? Create here",
              style: TextStyle(
                color: Colors.pink,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            //Registration Form....
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //Email
                      Padding(
                        padding: const EdgeInsets.only(top: 26),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                          style: TextStyle(
                            fontSize: 24,
                          ),
                          controller: _emailTextEditingController,
                          validator: (valueEmail) {
                            if (!valueEmail!.contains("@")) {
                              return "Please Enter Valid email";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      //Password
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                          style: TextStyle(
                            fontSize: 24,
                          ),
                          controller: _passwordTextEditingController,
                          validator: (valuePassword) {
                            if (valuePassword!.length < 5) {
                              return "Password must be at least 6 or more character";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      //First Name
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "First Name",
                          ),
                          style: TextStyle(
                            fontSize: 24,
                          ),
                          controller: _firstNameTextEditingController,
                          validator: (valueFirstName) {
                            if (valueFirstName!.isEmpty) {
                              return "Please Enter your First Name";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      // Last Name
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Last Name",
                          ),
                          style: TextStyle(
                            fontSize: 24,
                          ),
                          controller: _lastNameTextEditingController,
                          validator: (valueLastName) {
                            if (valueLastName!.isEmpty) {
                              return "Please Enter Your Last Name";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      //Country
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Country",
                          ),
                          style: TextStyle(
                            fontSize: 24,
                          ),
                          controller: _countryTextEditingController,
                          validator: (valueCountry) {
                            if (valueCountry!.isEmpty) {
                              return "Please Enter Country";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      //City
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "City",
                          ),
                          style: TextStyle(
                            fontSize: 24,
                          ),
                          controller: _cityTextEditingController,
                          validator: (valueCity) {
                            if (valueCity!.isEmpty) {
                              return "Please Enter City";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      //Bio
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Bio",
                          ),
                          style: TextStyle(
                            fontSize: 25,
                          ),
                          maxLines: 4,
                          controller: _bioTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ],
                  )),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: MaterialButton(
                  onPressed: () async {
                    var imageFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (imageFile != null) {
                      imageFileOfUser = File(imageFile.path);
                    }
                    setState(() {
                      imageFileOfUser;
                    });
                  },
                  child: imageFileOfUser == null
                      ? const Icon(Icons.add_a_photo)
                      : CircleAvatar(
                          backgroundColor: Colors.pink,
                          radius: MediaQuery.of(context).size.width / 5.0,
                          child: CircleAvatar(
                            backgroundImage: FileImage(imageFileOfUser!),
                            radius: MediaQuery.of(context).size.width / 5.0,
                          ),
                        )),
            ),

            Padding(
              padding:
                  const EdgeInsets.only(top: 44.0, right: 60.0, left: 60.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      imageFileOfUser == null) {
                    Get.snackbar("Field Missing",
                        "Please choose image and fill out complete signup form");
                    return;
                  }
                  if (_emailTextEditingController.text.isEmpty &&
                      _passwordTextEditingController.text.isEmpty) {
                    Get.snackbar("Field Missing",
                        "Please fill out complete signup form");
                    return;
                  }
                  userViewModel.signUp(
                    _emailTextEditingController.text.trim(),
                    _passwordTextEditingController.text.trim(),
                    _firstNameTextEditingController.text.trim(),
                    _lastNameTextEditingController.text.trim(),
                    _cityTextEditingController.text.trim(),
                    _countryTextEditingController.text.trim(),
                    _bioTextEditingController.text.trim(),
                    imageFileOfUser!,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
