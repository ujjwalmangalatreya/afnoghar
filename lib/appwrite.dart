

import 'package:appwrite/appwrite.dart';

class AppWrite {
  static late final Client _client;
  static late final Databases database;
  static late final Account account;
  static late final Storage storage;

  // Database constants
  static const String databaseId = '678f27e000215c383c73';
  static const String userCollectionId = '678f583900318840d9d4';
  static const String bucketId = '678f27f80034007fdad5';

  static void init() {
    _client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("678a893b0021b298bf0d")
        .setSelfSigned(status: true);

    // Initialize services after client is set up
    database = Databases(_client);
    account = Account(_client);
    storage = Storage(_client);
  }

  // Prevent multiple initializations
  static bool _isInitialized = false;

  static void ensureInitialized() {
    if (!_isInitialized) {
      init();
      _isInitialized = true;
    }
  }
}