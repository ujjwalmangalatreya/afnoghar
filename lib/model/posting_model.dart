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
    this.id,
    this.name,
    this.type,
    this.price,
    this.description,
    this.address,
    this.city,
    this.country,
    this.rating,
  }) {
    displayImages = [];
    amenities = [];
    beds = {};
    bathrooms = {};
    bookings = [];
    reviews = [];
  }

  setImagesNames() {
    imageNames ??= [];
    for (int i = 0; i < displayImages!.length; i++) {
      imageNames!.add("image$i.png");
    }
  }

  Future<void> getPostingInformationFromDatabase(String postingID) async {
    try {
      final postingModel = await AppWrite.database.getDocument(
        databaseId: AppWrite.databaseId,
        collectionId: AppWrite.postingCollectionId,
        documentId: postingID,
      );
      final postingData = postingModel.data;
      await getPostingInformationFromPostingModel(postingData);
      print("Posting information successfully retrieved.");
    } catch (e) {
      print("Error fetching posting information: $e");
    }
  }

  Future<void> getPostingInformationFromPostingModel(Map<String, dynamic> postingModel) async {
    address = postingModel["address"] ?? "";
    amenities = List<String>.from(postingModel["amenities"] ?? []);
    bathrooms = postingModel["bathrooms"] is String
        ? Map<String, int>.from(jsonDecode(postingModel["bathrooms"]))
        : Map<String, int>.from(postingModel["bathrooms"] ?? {});
    beds = postingModel["beds"] is String
        ? Map<String, int>.from(jsonDecode(postingModel["beds"]))
        : Map<String, int>.from(postingModel["beds"] ?? {});
    city = postingModel["city"] ?? "";
    country = postingModel["country"] ?? "";
    description = postingModel["description"] ?? "";
    String hostId = postingModel["hostID"] ?? "";
    host = ContactModel(id: hostId);
    imageNames = List<String>.from(postingModel["imageNames"] ?? []);
    name = postingModel["name"] ?? "";
    price = postingModel["price"] ?? 0;
    type = postingModel["type"] ?? "";

    print(postingModel["name"]);
  }

  Future<List<MemoryImage>?> getAppPostingImagesFromDatabase() async {
    displayImages = [];
    try {
      for (String imageName in imageNames ?? []) {
        Uint8List imageData = await AppWrite.storage.getFileView(
          bucketId: AppWrite.bucketId,
          fileId: imageName,
        );
        displayImages?.add(MemoryImage(imageData));
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
    return displayImages;
  }
}