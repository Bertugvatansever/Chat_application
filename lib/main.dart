import 'package:chat_application/controllers/chat_controller.dart';
import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/pages/splash_page.dart';
import 'package:chat_application/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
// mesaj isteği ve kullanıcının tokenını alıyor



void main() async {
  // gerekli ayarları yapmak için bunu kullanıyoruz
  WidgetsFlutterBinding.ensureInitialized();
  // burada da firebasei uygulamaya yüklüyoruz
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Get paketini kullanmak için önce put etmemiz gerekiyor.
    Get.put(UserController());
    Get.put(ChatController());
    ScreenUtil.init(
      context,
      designSize: const Size(392.72727272727275, 826.9090909090909),
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Konusma Uygulamasi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}
