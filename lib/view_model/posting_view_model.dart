import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
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
    print('Document created successfully with ID: ${response.$id}');
    /** DocumentReference ref = await FirebaseFirestore.instacne.collection("postings").add(dataMap);
        posting.id = ref.id; **/
    await AppConstants.currentUser.addPostingsToMyPostings(postingModel);
  }

  // addImageToStorage() async {
  //   //TODO: NEED TO CONVERT THIS TO APPWRITE
  //   //   PostingModel posting = PostingModel();
  //   //   for(int i = 0 ; i< posting.displayImages!.length ; i++){
  //   //     Reference ref = FirebaseStorage.instance.ref()
  //   //         .child("postingImages")
  //   //         .child(posting.id!)
  //   //         .child(posting.imageNames![i]);
  //   //   }
  //   //   await ref.putData(posting.displayImages![i].bytes).whenComplete((){});
  // }

  addImageToStorage() async {
    try {
      for (int i = 0; i < postingModel.displayImages!.length; i++) {
        Uint8List imageBytes = postingModel.displayImages![i]
            .bytes;
        String fileName = postingModel.imageNames![i];

        final response = await AppWrite.storage.createFile(
          bucketId: AppWrite.postingImagesStorageId,
          fileId: ID.unique(), // Automatically generate a unique file ID
          file: InputFile(
            filename: fileName,
            bytes: imageBytes,
          ),
        );

        print('File uploaded successfully with ID: ${response.$id}');
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
  }
}
