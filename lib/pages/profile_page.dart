import 'dart:io';
import 'package:chat_application/controllers/chat_controller.dart';
import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/pages/login_page.dart';
import 'package:chat_application/services/auth-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfilPage extends StatefulWidget {
  ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final UserController userController = Get.find();
  final ChatController chatController = Get.find();
  int? messageCount;

  @override
  void initState() {
    super.initState();
    calculateMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: const Text(
          "Profilim",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 231, 225, 225),
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
            ),
            Obx(
              () => GestureDetector(
                onTap: () {
                  userController.updateProfilePhoto();
                },
                child: Container(
                  width: 150.w,
                  height: 150.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 3.w,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: userController.imageFile.value.path.isNotEmpty
                        ? Image.file(
                            File(userController.imageFile.value.path),
                            fit: BoxFit.cover,
                          )
                        : (userController.user.value.imageUrl != null &&
                                userController.user.value.imageUrl.isNotEmpty)
                            ? Image.network(
                                userController.user.value.imageUrl,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 80,
                              ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(
              height: 25.h,
            ),
            Text(
              userController.user.value.nickName,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Text(
              userController.user.value.phoneNumber,
              style: TextStyle(fontSize: 15.sp),
            ),
            SizedBox(
              height: 25.h,
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(
              height: 25.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (messageCount == null)
                          ? CircularProgressIndicator()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  messageCount.toString(),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Mesajlar",
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 70.w, right: 30.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "120 saat",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Aktif süre",
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25.h,
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(
              height: 50.h,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Çıkış Yap"),
                      content: const Text(
                          "Hesabınızdan çıkış yapmak istediğinize emin misiniz ?"),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            await AuthService().signOut();
                            Get.to(() => const LoginPage());
                          },
                          child: const Text("Evet"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Hayır"),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300.w, 70.h),
                maximumSize: Size(300.w, 70.h),
                backgroundColor: Colors.indigo,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 35.w,
                  ),
                  const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  Text(
                    "Çıkış Yap",
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateMessage() async {
    messageCount =
        await chatController.calculateMessage(userController.user.value.id);
    setState(() {});
  }
}
