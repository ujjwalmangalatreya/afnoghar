import 'package:hamroghar/model/contact_model.dart';
import 'package:hamroghar/model/user_model.dart';

class AppConstants {
  static UserModel currentUser = UserModel();

  ContactModel createContactFromUserModel() {
    return ContactModel(
      id: currentUser.id,
      firstName: currentUser.firstName,
      lastName: currentUser.lastName,
      displayImage: currentUser.displayImage,
    );
  }
}
