import 'package:appwrite/models.dart';
import 'package:hamroghar/model/contact_model.dart';
import 'package:hamroghar/model/posting_model.dart';

class BookingModel {
  String id = "";
  PostingModel? posting;
  ContactModel? contact;
  List<DateTime>? dates;

  BookingModel();


  getBookingInfoFromPosting(PostingModel posting, DocumentList snapshot)async{
    // posting = posting ;
    // List<Timestamp> timestamp = List<Timestamp>.from(snapshot['dates']) ?? [];
    //
    // dates = [];
    // timestamp.forEach((timestamp){
    //   dates!.add((timestamp.toDate());
    // });
    //
    // //  String contactID = snapshot['userID'] ?? "" ;
    //   String fullName = snapshot['name'] ?? "";
    //
    //   _loadContactInfo(id,fullName);
    //
    //   contact = ContactModel(id: contactID);

  }

  _loadContactInfo(String id ,String fullName)async {
    String firstName = "";
    String lastName = "";
    firstName = fullName.split(" ")[0];
    lastName = fullName.split(" ")[1];

    contact = ContactModel(id: id,firstName: firstName,lastName: lastName);
  }
}
