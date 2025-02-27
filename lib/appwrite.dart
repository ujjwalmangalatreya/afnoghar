

import 'package:appwrite/appwrite.dart';

class AppWrite {
  static late final Client _client;
  static late final Databases database;
  static late final Account account;
  static late final Storage storage;
  static late Realtime realtime;


  // Database constants
  static const String databaseId = '678f27e000215c383c73';
  static const String userCollectionId = '6793a5e3002301870c79';
  static const String bucketId = '678f27f80034007fdad5';
  static const String postingCollectionId ='6793a5ed0005f04ed7ca';
  static const String postingImagesStorageId ='6790b885000dd6898334';


  static void init() {
    _client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("678a893b0021b298bf0d")
        .setSelfSigned(status: true);
    // Initialize services after client is set up
    database = Databases(_client);
    account = Account(_client);
    storage = Storage(_client);
    realtime = Realtime(_client);
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