import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:hamroghar/appwrite.dart';
import 'package:hamroghar/global.dart';
import 'package:hamroghar/model/app_constants.dart';

class PostingViewModel {
  addListingInfo() async {
    postingModel.setImagesNames();

    Map<String, dynamic> dataMap = {
      "address": postingModel.address,
      "amenities": postingModel.amenities,
      "bathrooms": postingModel.bathroomsJson,
      "description": postingModel.description,
      "beds": postingModel.bedsJson,
      "city": postingModel.city,
      "country": postingModel.country,
      "hostID": AppConstants.currentUser.id,
      "imageName": postingModel.imageNames,
      "name": postingModel.name,
      "price": postingModel.price,
      "rating": 3.5,
      "type": postingModel.type,
    };
    final response = await AppWrite.database.createDocument(
      databaseId: AppWrite.databaseId,
      collectionId: AppWrite.postingCollectionId,
      documentId: ID.unique(),
      data: dataMap,
    );
    postingModel.id = response.$id;
    debugPrint('Document created successfully with ID: ${response.$id}');

    await AppConstants.currentUser.addPostingsToMyPostings(postingModel);
  }

  addImageToStorage() async {
    try {
      for (int i = 0; i < postingModel.displayImages!.length; i++) {
        Uint8List imageBytes = postingModel.displayImages![i]
            .bytes;
        String fileName = postingModel.imageNames![i];

        final response = await AppWrite.storage.createFile(
          bucketId: AppWrite.postingImagesStorageId,
          fileId: ID.unique(), // Automatically generate a unique file ID
          file: InputFile.fromBytes(
            bytes: imageBytes,
            filename: fileName,
          ),
        );

        debugPrint('File uploaded successfully with ID: ${response.$id}');
      }
    } catch (e) {
      debugPrint('Error uploading images: $e');
    }
  }

  updateListingInfo() async {
    postingModel.setImagesNames();

    Map<String, dynamic> dataMap = {
      "address": postingModel.address,
      "amenities": postingModel.amenities,
      "bathrooms": postingModel.bathroomsJson,
      "description": postingModel.description,
      "beds": postingModel.bedsJson,
      "city": postingModel.city,
      "country": postingModel.country,
      "hostID": AppConstants.currentUser.id,
      "imageName": postingModel.imageNames,
      "name": postingModel.name,
      "price": postingModel.price,
      "rating": 3.5,
      "type": postingModel.type,
    };
    await AppWrite.database.updateDocument(
      databaseId: AppWrite.databaseId,
      collectionId: AppWrite.postingCollectionId,
      documentId: postingModel.id!,
      data: dataMap,
    );
  }
}
