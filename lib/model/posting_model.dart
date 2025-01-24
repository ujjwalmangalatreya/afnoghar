import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hamroghar/appwrite.dart';
import 'package:hamroghar/model/app_constants.dart';
import 'package:hamroghar/model/booking_model.dart';
import 'package:hamroghar/model/contact_model.dart';
import 'package:hamroghar/model/review_model.dart';

class PostingModel {
  String? id;
  String? name;
  String? type;
  int? price;
  String? description;
  String? address;
  String? city;
  String? country;
  double? rating;
  ContactModel? host;
  List<String>? imageNames;
  List<MemoryImage>? displayImages;
  List<String>? amenities;
  List<BookingModel>? bookings;
  List<ReviewModel>? reviews;

  Map<String, int>? beds;
  Map<String, int>? bathrooms;

  String get bedsJson => jsonEncode(beds);

  String get bathroomsJson => jsonEncode(bathrooms);

  set bedsFromJson(String jsonString) {
    beds = Map<String, int>.from(jsonDecode(jsonString));
  }

  set bathroomsFromJson(String jsonString) {
    bathrooms = Map<String, int>.from(jsonDecode(jsonString));
  }

  PostingModel({
    this.id = "",
    this.type = "",
    this.price = 0,
    this.description = "",
    this.address = "",
    this.city = "",
    this.country = "",
    this.rating = 0,
  }) {
    displayImages = [];
    amenities = [];
    beds = {};
    bathrooms = {};
    rating = 0;
    bookings = [];
    reviews = [];
  }


  setImagesNames() {
    imageNames = [];
    for (int i = 0; i < displayImages!.length; i++) {
      imageNames!.add("image$i.png");
    }
  }

  getPostingInformationFromDatabase(postingID) async {
    try {
      // Fetch the posting document from the database
      final postingModel = await AppWrite.database.getDocument(
        databaseId: AppWrite.databaseId,
        collectionId: AppWrite.postingCollectionId,
        documentId: postingID,
      );
      // Access the data property of the document
      final postingData = postingModel.data;
      // Populate this posting model with the fetched data
      await getPostingInformationFromPostingModel(postingData);
      print("Posting information successfully retrieved.");
    } catch (e) {
      // Handle errors gracefully
      print("Error fetching posting information: $e");
    }
  }

  getPostingInformationFromPostingModel(Map<String, dynamic> postingModel) {
    address = postingModel["address"] ?? "";
    amenities = List<String>.from(postingModel["amenities"] ?? []);
    bathrooms = (postingModel["bathrooms"] != null)
        ? Map<String, int>.from(jsonDecode(postingModel["bathrooms"]))
        : {};
    beds = (postingModel["beds"] != null)
        ? Map<String, int>.from(jsonDecode(postingModel["beds"]))
        : {};
    city = postingModel["city"] ?? "";
    country = postingModel["country"] ?? "";
    description = postingModel["description"] ?? "";
    // Host data handling
    String hostId = postingModel["hostID"] ?? "";
    host = ContactModel(id: hostId);
    // Image names
    imageNames = List<String>.from(postingModel["imageNames"] ?? []);
    // Other details
    name = postingModel["name"] ?? "";
    price = postingModel["price"] ?? 0.0;
    type = postingModel["type"] ?? "";
  }


  getAppPostingImagesFromDatabase() async {
   displayImages = [];
    try {
      for (int i = 0; i < (imageNames?.length ?? 0); i++) {
        Uint8List imageData = await AppWrite.storage.getFileView(
          bucketId: AppWrite.bucketId, // Replace with your bucket ID
          fileId: "image$i.png",
            // File path structure
        );
        // Add the image as a MemoryImage to the list
        displayImages?.add(MemoryImage(imageData));
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
    return displayImages;
  }
}