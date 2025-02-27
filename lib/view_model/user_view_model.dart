import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamroghar/appwrite.dart';
import 'package:hamroghar/model/app_constants.dart';
import 'package:hamroghar/model/user_model.dart';
import 'package:hamroghar/view/guest_home_screen.dart';
import 'package:hamroghar/view/login_screen.dart';

class UserViewModel {
  UserModel userModel = UserModel();
  signUp(String email, String password, String firstName, String lastName,
      String city, String country, String bio, File imageFileOfUser) async {
      Get.snackbar("Please Wait", "We are creating your account.");

    try {
      final user = await AppWrite.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );

      final String currentUserId = user.$id;

      AppConstants.currentUser.id = currentUserId;
      AppConstants.currentUser.firstName = firstName;
      AppConstants.currentUser.lastName = lastName;
      AppConstants.currentUser.city = city;
      AppConstants.currentUser.country = country;
      AppConstants.currentUser.bio = bio;
      AppConstants.currentUser.email = email;
      AppConstants.currentUser.password = password;

      await saveUserToAppwrite(
        bio,
        city,
        country,
        email,
        firstName,
        lastName,
        currentUserId,
      ).whenComplete(() async {
        await addImageToAppwriteStorage(imageFileOfUser, currentUserId);
      });
      Get.snackbar("Congratulations", "Your account has been created.");
      Get.to(() => GuestHomeScreen());
    } on AppwriteException catch (e) {
      Get.snackbar("ERROR", e.message ?? "An error occurred");
      debugPrint(e.message);
    } catch (e) {
      Get.snackbar("ERROR", e.toString());
      debugPrint(e.toString());
    }
  }

  saveUserToAppwrite(String bio, String city, String country, String email,
      String firstName, String lastName, String id) async {
    final Map<String, dynamic> dataMap = {
      "bio": bio,
      "city": city,
      "country": country,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "isHost": false,
      "myPostingIDs": [],
      "savedPostingIDs": [],
      "earnings": 0,
    };

    await AppWrite.database.createDocument(
      databaseId: AppWrite.databaseId,
      collectionId: AppWrite.userCollectionId,
      documentId: id,
      data: dataMap,
    );
  }

  addImageToAppwriteStorage(File imageFileOfUser, String currentUserId) async {
    try {
      final String fileId = '$currentUserId.png';

      await AppWrite.storage.createFile(
        bucketId: AppWrite.bucketId,
        fileId: fileId,
        file: InputFile.fromPath(
          path: imageFileOfUser.path,
          filename: fileId,
        ),
      );
      AppConstants.currentUser.displayImage =
          MemoryImage(imageFileOfUser.readAsBytesSync());
    } on AppwriteException catch (e) {
      Get.snackbar("ERROR", "Failed to upload image: ${e.message}");
    }
  }

  userLogin(email, password) async {
    Get.snackbar("Please Wait", "Checking Your credentials..");
    try {
      final result = await AppWrite.account
          .createEmailPasswordSession(email: email, password: password);
      String currentUserID = result.userId;
      AppConstants.currentUser.id = currentUserID;
      await getUserInfo(currentUserID);
      await getImageFromStorage(currentUserID);
      await AppConstants.currentUser.getMyPostingFromDatabase();

      Get.snackbar("Logged-In", "You are logged in successfully");
      Get.to(() => GuestHomeScreen());
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("ERROR : IS this one", e.toString());
    }
  }

  getUserInfo(currentUserId) async {
    try {
      final response = await AppWrite.database.getDocument(
        databaseId: AppWrite.databaseId,
        collectionId: AppWrite.userCollectionId,
        documentId: currentUserId,
      );
      AppConstants.currentUser.firstName = response.data["firstName"] ?? "";
      AppConstants.currentUser.lastName = response.data["lastName"] ?? "";
      AppConstants.currentUser.email = response.data["email"] ?? "";
      AppConstants.currentUser.bio = response.data["bio"] ?? "";
      AppConstants.currentUser.city = response.data["city"] ?? "";
      AppConstants.currentUser.country = response.data["country"] ?? "";
      AppConstants.currentUser.isHost = response.data["isHost"] ?? false;
    } catch (e) {
      Get.snackbar("ERROR", e.toString());
    }
  }

  getImageFromStorage(String currentUserId) async {
    if (AppConstants.currentUser.displayImage != null) {
      return AppConstants.currentUser.displayImage;
    }
    try {
      final response = await AppWrite.storage.getFileView(
        bucketId: AppWrite.bucketId,
        fileId:
            "$currentUserId.png", // Ensure the file extension matches your storage file
      );
      final image = MemoryImage(response);
      AppConstants.currentUser.displayImage = image;
      return image;
    } catch (e) {
      Get.snackbar("ERROR", e.toString());
      return null;
    }
  }

  becomeHost(String userId) async {
    try {
      userModel.isHost = true;
      Map<String, dynamic> dataMap = {
        "isHost": true,
      };
      final response = await AppWrite.database.updateDocument(
        databaseId: AppWrite.databaseId,
        collectionId: AppWrite.userCollectionId,
        documentId: userId,
        data: dataMap,
      );
      debugPrint("User updated: ${response.data}");
    } catch (e) {
      debugPrint("Error updating user: $e");
      Get.snackbar("Error", "Failed to update user data");
    }
  }

  modifyCurrentlyHosting(bool isHosting){
    userModel.isCurrentlyHosting = isHosting;
  }


  logout() async {
    try {
      // Deletes the current session for the logged-in user
      await AppWrite.account.deleteSession(sessionId: 'current');

      // Navigate to the login screen
      Get.to(() => LoginScreen());
      debugPrint("User logged out successfully");
    } catch (e) {
      debugPrint("Error logging out: $e");
      Get.snackbar("Error", e.toString());
    }
  }


}
