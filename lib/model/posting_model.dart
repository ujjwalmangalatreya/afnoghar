import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hamroghar/model/booking_model.dart';
import 'package:hamroghar/model/contact_model.dart';
import 'package:hamroghar/model/review_model.dart';

class PostingModel{
  String? id;
  String? name;
  String? type;
  double? price;
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

  Map<String,int>? beds;
  Map<String,int>? bathrooms;

  String get bedsJson => jsonEncode(beds);
  String get bathroomsJson => jsonEncode(bathrooms);

  set bedsFromJson(String jsonString) {
    beds = Map<String, int>.from(jsonDecode(jsonString));
  }
  set bathroomsFromJson(String jsonString) {
    bathrooms = Map<String, int>.from(jsonDecode(jsonString));
  }

  PostingModel({
    this.id="",
    this.type="",
    this.price=0,
    this.description="",
    this.address="",
    this.city="",
    this.country="",
    this.rating=0,
  }){
    displayImages =[];
    amenities =[];
    beds ={};
    bathrooms={};
    rating =0;
    bookings =[];
    reviews=[];
  }


  setImagesNames(){
    imageNames =[];
    for(int i = 0 ; i <displayImages!.length ;i++){
      imageNames!.add("image$i.png");
    }
  }


}