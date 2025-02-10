import 'dart:convert';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamroghar/appwrite.dart';
import 'package:hamroghar/global.dart';
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
      debugPrint("Posting information successfully retrieved.");
    } catch (e) {
      debugPrint("Error fetching posting information: $e");
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
    // Handle imageNames
    if (postingModel["imageName"] != null) {
      debugPrint("Raw imageName data: ${postingModel["imageName"]}");
      List<dynamic> rawList = postingModel["imageName"];
      imageNames = rawList.map((e) => e.toString()).toList();
      debugPrint("Converted imageNames: $imageNames");
    } else {
      imageNames = [];
      debugPrint("No imageNames found");
    }
    name = postingModel["name"] ?? "";
    price = postingModel["price"] ?? 0;
    type = postingModel["type"] ?? "";
  }

  getAppPostingImagesFromDatabase() async {
    displayImages = [];
    debugPrint("Fetching images for: $imageNames");
    try {
      for (String imageName in imageNames ?? []) {
        try {
          debugPrint("Fetching image with fileId: $imageName");
          Uint8List imageData = await AppWrite.storage.getFileView(
            bucketId: AppWrite.postingImagesStorageId,
            fileId: imageName,
          );
          displayImages?.add(MemoryImage(imageData));
          debugPrint("Successfully fetched image: $imageName");
        } catch (e) {
          debugPrint("Error fetching image with fileId $imageName: $e");
        }
      }
    } catch (e) {
      debugPrint("Error in getAppPostingImagesFromDatabase: $e");
    }
    return displayImages;
  }

  getFirstImageFromDatabase()async{
    if(displayImages!.isEmpty){
      return displayImages!.first;
    }
    Uint8List imageData = await AppWrite.storage.getFileView(
      bucketId: AppWrite.postingImagesStorageId,
      fileId: imageNames!.first,
    );
    displayImages!.add(MemoryImage(imageData));
    return displayImages!.first;
  }


  getAmenitiesString(){
    if(amenities!.isEmpty){
      return "";
    }
    String amenitiesString = amenities.toString();
    return amenitiesString.substring(1,amenitiesString.length -1 );

  }

  double getCurrentRating(){
    if(reviews!.isEmpty){
      return 4;
    }
    double rating = 0;
    for (var review in reviews!) {
      rating +=   review.rating!;
    }
    rating /= reviews!.length;
    return rating;
  }


  getHostFromDatabase()async{
      await host!.getContactInfoFromDatabase();
      await host!.getImageFromDatabase();

  }

  int getGuestNumber(){
    int? numGuests = 0;
    numGuests = numGuests + beds!['small']!;
    numGuests = numGuests + beds!['medium']! * 2;
    numGuests = numGuests + beds!['large']! * 2;

    return numGuests;
  }

  String getBedRoomText() {
    String text = "";

    if (beds!['small'] != 0) {
      text += "${beds!['small']} single/twin";
    }

    if (beds!['medium'] != 0) {
      if (text.isNotEmpty) text += " , ";
      text += "${beds!['medium']} double";
    }

    if (beds!['large'] != 0) {
      if (text.isNotEmpty) text += ", ";
      text += "${beds!['large']} queen/king";
    }
    return text;
  }
  String getBathroomText(){
    String text = " ";
    if(bathrooms!['full'] != 0){
      text = "$text${bathrooms!['full']} full";
    }
    if(bathrooms!['half'] !=0){
      if (text.isNotEmpty) text += " , ";
      text = "$text${bathrooms!['half']} half";
    }
    return text;
  }


  String getFullAddress(){
    return "${address!} , ${city!} , ${country!}";
  }


  getAllBookingFromDatabase()async{
    try {
      final DocumentList snapshots = await AppWrite.database.listDocuments(
        databaseId: AppWrite.databaseId,
        collectionId: AppWrite.bookingCollectionId,
        queries: [
          Query.equal('postingId', AppWrite.postingCollectionId),
        ],
      );

      for (var snapshot in snapshots.documents) {
        BookingModel newBooking = BookingModel();
        await newBooking.getBookingInfoFromPosting(this, snapshot.data as DocumentList);
        bookings!.add(newBooking);
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }


  List<DateTime> getAllBookedDates(){
    List<DateTime> dates = [];
    bookings!.forEach((booking){
      dates.addAll(booking.dates as Iterable<DateTime>);
    });
    return dates;

  }

  makeNewBooking(List<DateTime> dates,context) async{
    Map<String,dynamic> bookingData = {
      'dates' : dates,
      'name' : AppConstants.currentUser.getFullNameOfUser(),
      'userID' : AppConstants.currentUser.id,
      'payment' : bookingPrice
    };

    //DocumnerReference refrence = await FirebaseFirestore.instance.collection('postings').doc(id).collection('bookings').add(bookingData);

    BookingModel newBooking = BookingModel();

    newBooking.createBooking(this,AppConstants.currentUser.createUserFromContact(),dates);
    //newBooking.id = refrence.id;

    bookings!.add(newBooking);
    await AppConstants.currentUser.addBookingToFirestore(newBooking,bookingPrice!);

    Get.snackbar("Listings", "Booking Successful");

  }


}