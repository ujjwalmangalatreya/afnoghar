import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamroghar/appwrite.dart';
import 'package:hamroghar/model/app_constants.dart';

class UserViewModel {

  Future<void> signUp(String email, String password, String firstName,
      String lastName, String city, String country, String bio,
      File imageFileOfUser) async {
    Get.snackbar("Please Wait", "We are creating your account.");

    try {
      // Create user account
      final user = await AppWrite.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );

      final String currentUserId = user.$id;

      // Update local user data
      AppConstants.currentUser.id = currentUserId;
      AppConstants.currentUser.firstName = firstName;
      AppConstants.currentUser.lastName = lastName;
      AppConstants.currentUser.city = city;
      AppConstants.currentUser.country = country;
      AppConstants.currentUser.bio = bio;
      AppConstants.currentUser.email = email;
      AppConstants.currentUser.password = password;

      // Save user data to database and upload image
      await saveUserToAppwrite(
        bio, city, country, email, firstName, lastName, currentUserId,
      ).whenComplete(() async {
        await addImageToAppwriteStorage(imageFileOfUser, currentUserId);
      });

      Get.snackbar("Congratulations", "Your account has been created.");
    } on AppwriteException catch (e) {
      Get.snackbar("Error", e.message ?? "An error occurred");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> saveUserToAppwrite(
      String bio,
      String city,
      String country,
      String email,
      String firstName,
      String lastName,
      String id) async {
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
      collectionId: "users",
      documentId: id,
      data: dataMap,
    );
  }

  Future<void> addImageToAppwriteStorage(File imageFileOfUser, String currentUserId) async {
    try {
      // Create file ID using user ID
      final String fileId = '$currentUserId.png';

      await AppWrite.storage.createFile(
        bucketId: AppWrite.bucketId,
        fileId: fileId,
        file: InputFile.fromPath(
          path: imageFileOfUser.path,
          filename: fileId,
        ),
      );

      // Update user's display image in memory
      AppConstants.currentUser.displayImage =
          MemoryImage(imageFileOfUser.readAsBytesSync());
    } on AppwriteException catch (e) {
      Get.snackbar("Error", "Failed to upload image: ${e.message}");
    }
  }
}