import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamroghar/appwrite.dart';
import 'package:hamroghar/model/app_constants.dart';
import 'package:hamroghar/model/booking_model.dart';
import 'package:hamroghar/model/contact_model.dart';
import 'package:hamroghar/model/posting_model.dart';
import 'package:hamroghar/model/review_model.dart';

class UserModel extends ContactModel {
  String? email;
  String? password;
  String? bio;
  String? city;
  String? country;
  bool? isHost;
  bool? isCurrentlyHosting;
  Map<String, dynamic>? documentData;

  List<PostingModel>? myPostings;
  List<BookingModel>? myBookings;
  List<ReviewModel>? myReviews;
  // Constructor
  UserModel({
    String? id = "",
    String? firstName = "",
    String? lastName = "",
    String? fullName = "",
    MemoryImage? displayImage,
    this.email = "",
    this.bio = "",
    this.city = "",
    this.country = "",
  }) : super(
      id: id,
      firstName: firstName,
      lastName: lastName,
      displayImage: displayImage) {
    isHost = false;
    isCurrentlyHosting = false;
    myPostings=[];
    myBookings=[];
    myReviews=[];
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'] ?? "", // Appwrite uses '\$id' for document IDs
      firstName: map['firstName'] ?? "",
      lastName: map['lastName'] ?? "",
      email: map['email'] ?? "",
      bio: map['bio'] ?? "",
      city: map['city'] ?? "",
      country: map['country'] ?? "",
    )
      ..isHost = map['isHost'] ?? false
      ..isCurrentlyHosting = map['isCurrentlyHosting'] ?? false
      ..documentData = map;
  }
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'bio': bio,
      'city': city,
      'country': country,
      'isHost': isHost,
      'isCurrentlyHosting': isCurrentlyHosting,
    };
  }

  addPostingsToMyPostings(PostingModel posting) async {
    try {
      myPostings!.add(posting);
      List<String> myPostingIDsList = myPostings!.map((element) => element.id!).toList();
      final userId = AppConstants.currentUser.id; // Get the current user's ID
      if (userId == null) {
        throw Exception("User ID is not available");
      }
      await AppWrite.database.updateDocument(
        databaseId: AppWrite.databaseId,
        collectionId: AppWrite.userCollectionId,
        documentId: userId,
        data: {
          "myPostingIDs": myPostingIDsList,
        },
      );
      print("User postings updated successfully.");
    } catch (e) {
      print("Error updating user postings: $e");
    }
  }

  getMyPostingFromDatabase() async {
    try {
      // Fetch the current user's account details
      var user = await AppWrite.account.get();
      // Fetch the user's document from the database
      var document = await AppWrite.database.getDocument(
        databaseId: AppWrite.databaseId,
        collectionId: AppWrite.userCollectionId,
        documentId: user.$id,
      );
      // Extract the list of posting IDs
      List<String> myPostingIDs = List<String>.from(document.data["myPostingIDs"] ?? []);
      // Iterate through the posting IDs and fetch their details
      for (String postingId in myPostingIDs) {
        PostingModel posting = PostingModel(id: postingId);
        await posting.getPostingInformationFromDatabase(postingId);
        await posting.getAppPostingImagesFromDatabase();
        myPostings?.add(posting);
      }
      print("Successfully retrieved all postings.");
    } catch (e) {
      Get.snackbar("ERROR", e.toString());
      print("Error fetching postings: $e");
    }
  }
}