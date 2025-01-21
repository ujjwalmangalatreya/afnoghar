

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamroghar/model/app_constants.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 50, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //USER INFO
            Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
              child: Center(
                child: Column(
                  children: [
                    //IMAGE
                    MaterialButton(
                      onPressed: (){},
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: MediaQuery.of(context).size.width /4.5,
                        child: CircleAvatar(
                          backgroundImage: AppConstants.currentUser.displayImage,
                          radius: MediaQuery.of(context).size.width /4.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),
                      //NAME AND EMAIL
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                              Text(
                                AppConstants.currentUser.getFullNameOfUser(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                        Text(
                          AppConstants.currentUser.email.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),

    );
  }
}
