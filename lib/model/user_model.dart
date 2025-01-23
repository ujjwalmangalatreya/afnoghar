import 'package:flutter/material.dart';
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

  // Factory constructor to create UserModel from Appwrite document
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

  // Convert UserModel to Map for Appwrite
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
        collectionId: AppWrite.userCollectionId,  // Replace with your user collection ID
        documentId: userId,  // Use the current user's ID
        data: {
          "myPostingIDs": myPostingIDsList,  // Field that stores the posting IDs
        },
      );
      print("User postings updated successfully.");
    } catch (e) {
      print("Error updating user postings: $e");
    }
  }
}