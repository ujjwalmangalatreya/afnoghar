
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamroghar/appwrite.dart';
import 'package:hamroghar/global.dart';
import 'package:hamroghar/model/app_constants.dart';
import 'package:hamroghar/view/guest_home_screen.dart';
import 'package:hamroghar/view/host_home_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

   String _hostingTitles = "Show My Hosting Dashboard";

  modifyHostingMode() async{
    if (AppConstants.currentUser.isHost!) {
      if (AppConstants.currentUser.isCurrentlyHosting!) {
        AppConstants.currentUser.isCurrentlyHosting = false;
        Get.to(()=>GuestHomeScreen());
      } else {
        AppConstants.currentUser.isCurrentlyHosting = true;
        Get.to(()=>HostHomeScreen());
      }
    } else {
      await AppWrite.account.get().then((user) async {
        String userId = user.$id; // Get the user ID
        print("User id is ::::"+userId);
        await userViewModel.becomeHost(userId); // Pass it to becomeHost
      }).catchError((error) {
        print("Error fetching user ID: $error");
      });
      AppConstants.currentUser.isHost = true;
      AppConstants.currentUser.isCurrentlyHosting = true;
      Get.to(()=>HostHomeScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    if (AppConstants.currentUser.isHost!) {
      if (AppConstants.currentUser.isCurrentlyHosting!) {
        _hostingTitles = "Show my Guest Dashboard";
      } else {
        _hostingTitles = "Show my Host Dashboard";
      }
    } else {
      _hostingTitles = "Become a host";
    }

  }

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
                      onPressed: () {},
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: MediaQuery.of(context).size.width / 4.5,
                        child: CircleAvatar(
                          backgroundImage:
                              AppConstants.currentUser.displayImage,
                          radius: MediaQuery.of(context).size.width / 4.6,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
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

            //BUTTONS
            ListView(
              shrinkWrap: true,
              children: [
                //PERSONAL INFORMATION BUTTON
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.amber],
                      begin: FractionalOffset(0, 0),
                      end: FractionalOffset(1, 0),
                      stops: [0, 1],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: () {},
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: Text(
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(size: 34, Icons.person_2),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                //CHANGE TO HOST BUTTON
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.amber],
                      begin: FractionalOffset(0, 0),
                      end: FractionalOffset(1, 0),
                      stops: [0, 1],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: () {
                      modifyHostingMode();
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: Text(
                        _hostingTitles,
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(size: 34, Icons.hotel_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                // LOGOUT BUTTON
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.amber],
                      begin: FractionalOffset(0, 0),
                      end: FractionalOffset(1, 0),
                      stops: [0, 1],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: () {},
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(size: 34, Icons.logout_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
