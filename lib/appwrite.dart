

import 'package:appwrite/appwrite.dart';

class AppWrite{
  static final _client = Client();
  static final database = Databases(_client);
  static final account = Account(_client);
  static final storage = Storage(_client);

  static String databaseId = '678f27e000215c383c73';
  static String bucketId = '678f27f80034007fdad5';

  static void inti(){
    _client
    .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("678a893b0021b298bf0d")
        .setSelfSigned(status: true);
  }
}