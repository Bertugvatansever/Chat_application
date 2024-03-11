import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_text_field/phone_text_field.dart';

// ignore: must_be_immutable
class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});
  final TextEditingController _loginuserName = TextEditingController();
  final TextEditingController _loginuserPassword = TextEditingController();
  String _loginuserNumber = "";
  List<String> errorList = ["Bilgilerinizi kontrol ediniz."];
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(36), topEnd: Radius.circular(36))),
          isScrollControlled: true,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                    width: screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            Text(
                              "Uygulamamıza Giriş Yapın",
                              style: TextStyle(
                                  fontSize: 24.sp, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            SizedBox(
                              width: 275.w,
                              height: 45.h,
                              child: TextField(
                                controller: _loginuserName,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(bottom: 5.h),
                                    labelText: "Kullanıcı Adı",
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.indigo)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      width: 2.w,
                                    ))),
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 275.w,
                              height: 45.h,
                              child: TextField(
                                controller: _loginuserPassword,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(bottom: 5.h),
                                    labelText: "Şifre",
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.indigo)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      width: 2.w,
                                    ))),
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 275.w,
                              height: 80.h,
                              child: PhoneTextField(
                                onSubmit: (value) {
                                  _loginuserNumber = value;
                                },
                                decoration: InputDecoration(
                                    labelText: "Telefon Numarası",
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(width: 2.0.w))),
                                initialCountryCode: '+90',
                                dialogTitle: "Ülke Seçiniz",
                                invalidNumberMessage:
                                    "Geçersiz telefon numarası",
                                countryViewOptions:
                                    CountryViewOptions.countryCodeOnly,
                                showCountryCodeAsIcon: true,
                                onChanged: (value) {
                                  _loginuserNumber =
                                      value.completeNumber.toString();

                                  print(value.completeNumber.toString());
                                },
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await _userController.signIn(
                                      _loginuserName.text,
                                      _loginuserPassword.text);
                                  if (_userController
                                      .user.value.id.isNotEmpty) {
                                    Get.to(() => const HomePage());
                                  }
                                  await _userController.getUsers();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(150.w, 45.h)),
                                child: Text("Giriş Yap")),
                            SizedBox(
                              height: 25.h,
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        minimumSize: Size(300.w, 65.h),
      ),
      child: Text("Giriş Yap"),
    );
  }

  void errorDialog(BuildContext context, int errorindex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          titleTextStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
          backgroundColor: Colors.white,
          title: Text(
            "Hata",
            style: TextStyle(
              fontSize: 20.0.sp,
            ),
          ),
          content: Text(
            errorList[errorindex],
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Tamam",
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 16.0.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
