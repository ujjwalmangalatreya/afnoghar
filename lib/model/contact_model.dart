import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:hamroghar/appwrite.dart';
import 'package:hamroghar/model/user_model.dart';


class ContactModel {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  MemoryImage? displayImage;

  ContactModel({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.displayImage,
    
  });

  String getFullNameOfUser() {
    return fullName = "${firstName!} ${lastName!}";
  }

  UserModel createUserFromContact() {
    return UserModel(
      id: id!,
      firstName: firstName!,
      lastName: lastName!,
      displayImage: displayImage!,
    );
  }

  getContactInfoFromDatabase() async{
    //get the user id appwrite
    final user = await AppWrite.account.get();
    final userID = user.$id;

    // search for the user derails in user document
    final response = await AppWrite.database.listDocuments(
        databaseId: AppWrite.databaseId,
        collectionId: AppWrite.userCollectionId,
      queries: [
        Query.equal('userId', userID), // Adjust the query based on your user document schema
      ],
    );
    //fetch first and last name from it.
    final userDocument = response.documents.first.data;
    final firstName = userDocument['firstName'] ?? 'Unknown';
    final lastName = userDocument['lastName'] ?? 'Unknown';
  }

  getImageFromDatabase()async{
    if(displayImage != null){
      return displayImage!;
    }
    // Get image from appwrite store which has image name as userid.png
    final user = await AppWrite.account.get();
    final userId = user.$id;

    // Fetch the image from Appwrite Storage
    final imageData = await AppWrite.storage.getFileView(
      bucketId: AppWrite.bucketId,
      fileId: "$userId.png",
    );

    // Cache the image data
    displayImage = MemoryImage(imageData);
    return displayImage;
  }
}
