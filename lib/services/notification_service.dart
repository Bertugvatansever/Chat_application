import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<String?> getToken() async {
    // bildirim göndermek için izin ister
    await _firebaseMessaging.requestPermission();
    // cihazın kimliği gibi bir şey
    String? fcmToken = await _firebaseMessaging.getToken();
    print("token:" + fcmToken.toString());
    return fcmToken;
  }

  Future<void> sendNotification(
      String token, String notificationTitle, String notificationBody) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ya29.a0Ad52N3-___-PZss5bjZfj3L4WQN4pEdDC4H4Wk1hV1WnIqYNfW1sclBBvzb2GwV0GUFQjkxIK3yXXuvnfjqt15v5UVjcuqi2FLI4jjQIi1TKQcL-0xTwvjj1Tb18vkA8Hi5osXo7vPnRpHZi2NQfqEOXKBg3xiPHj3BXaCgYKAaMSARMSFQHGX2MiK_v4hQUNOAWb-Kzk6O4Xuw0171'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/chatapp-7c72a/messages:send'));
    request.body =
        '''{\r\n   "message":{\r\n      "token":"$token",\r\n      "data":{},\r\n      "notification":{\r\n        "title":"$notificationTitle",\r\n        "body":"$notificationBody",\r\n      }\r\n   }\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
// Bildirim işlemi uyguluma dışında çalışacağı için bu her şeyin dışında bir yerde tanımlanmalı o yüzden buraya tanımladık

Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  // RemoteMessage bir bildirim tipidir ve gelen bildirimin bütün verilerini saklar
  if (message.notification != null) {
    print("Bildirim geldi");
  }
}
