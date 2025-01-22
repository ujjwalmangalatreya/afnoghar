import 'package:hamroghar/model/contact_model.dart';
import 'package:hamroghar/model/posting_model.dart';

class BookingModel {
  String id = "";
  PostingModel? posting;
  ContactModel? contact;
  List<DateTime>? dates;

  BookingModel();
}
