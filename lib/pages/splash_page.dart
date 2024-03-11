import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/pages/login_page.dart';
import 'package:chat_application/pages/root_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
   SplashPage({super.key});


final UserController _userController=Get.find();
  @override
  Widget build(BuildContext context) {
return Obx(() {
  if (_userController.user.value.id.isEmpty) {
      return const LoginPage();
    } else {
      return const RootPage();
    }

});
  
  }
}