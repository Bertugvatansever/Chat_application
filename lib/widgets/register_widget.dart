import 'package:chat_application/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_text_field/phone_text_field.dart';

// ignore: must_be_immutable
class RegisterWidget extends StatefulWidget {
  RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

enum AuthMode { login, register, phone }

class _RegisterWidgetState extends State<RegisterWidget> {
  final TextEditingController _signuserName = TextEditingController();
  final TextEditingController _signuserPassword = TextEditingController();
  final TextEditingController _signuserPasswordConfirm =
      TextEditingController();
  String _signuserNumber = "";
  final TextEditingController _signphoneConfirm = TextEditingController();
  String error = '';
  AuthMode mode = AuthMode.login;
  List<String> errorList = [
    "Lütfen bütün yerleri doldurunuz.",
    "Lütfen şifrenizin doğrulama işlemini kontrol edin",
    "Kayıt sırasında bir hata oluştu."
  ];
  final UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36))),
            builder: (context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SizedBox(
                    width: screenWidth,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25.h,
                        ),
                        Text(
                          "Uygulamamıza Kayıt Olun",
                          style: TextStyle(
                              fontSize: 24.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        SizedBox(
                          width: 275.w,
                          height: 45.h,
                          child: TextField(
                            controller: _signuserName,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5.h),
                                labelText: "Kullanıcı Adı",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.indigo)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
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
                            controller: _signuserPassword,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5.h),
                                labelText: "Şifre",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.indigo)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
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
                            controller: _signuserPasswordConfirm,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5.h),
                                labelText: "Şifrenizi doğrulayın",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.indigo)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
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
                              _signuserNumber = value;
                            },
                            invalidNumberMessage: "Geçersiz Telefon Numarası",
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5.h),
                                labelText: "Telefon Numarası",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 2.0.w))),
                            initialCountryCode: '+90',
                            dialogTitle: "Ülke Seçiniz",
                            countryViewOptions:
                                CountryViewOptions.countryCodeOnly,
                            showCountryCodeAsIcon: true,
                            onChanged: (value) {
                              _signuserNumber = value.completeNumber.toString();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.h),
                          child: ElevatedButton(
                              onPressed: () async {
                                // bütün her yer doluysa
                                if (_signuserName.text.isNotEmpty &&
                                    _signuserPassword.text.isNotEmpty &&
                                    _signuserPasswordConfirm.text.isNotEmpty &&
                                    _signuserNumber.isNotEmpty) {
                                  // doğrulama şifreleri aynı ise
                                  if (_signuserPassword.text ==
                                      _signuserPasswordConfirm.text) {
                                    bool? confirm =
                                        await _userController.registerUser(
                                            _signuserName.text,
                                            _signuserPassword.text,
                                            _signuserNumber);
                                    if (confirm == true) {
                                      await showSuccessDialog(context);
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(36),
                                                  topRight:
                                                      Radius.circular(36))),
                                          builder: (context) {
                                            return SingleChildScrollView(
                                              child: Padding(
                                                // Klavye boşluğu ekliyor
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child: SizedBox(
                                                  width: screenWidth,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 25.h,
                                                      ),
                                                      Text(
                                                        "Telefon Numaranı Doğrula",
                                                        style: TextStyle(
                                                          fontSize: 24.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 25.h,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8,
                                                                right: 8),
                                                        child: Text(
                                                          "Lütfen sana gönderdiğimiz 6 haneli kodu gir.",
                                                          style: TextStyle(
                                                              fontSize: 24.sp),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 25.h,
                                                      ),
                                                      SizedBox(
                                                        width: 200.w,
                                                        child: Container(
                                                          height: 70.h,
                                                          child: TextFormField(
                                                            controller:
                                                                _signphoneConfirm,
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLength: 6,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              prefixIcon: Icon(Icons
                                                                  .phone_android_outlined),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                borderSide: BorderSide(
                                                                    style: BorderStyle
                                                                        .solid,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 25.h,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () {},
                                                          child:
                                                              Text("Doğrula"),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .indigo,
                                                                  foregroundColor:
                                                                      Colors
                                                                          .white,
                                                                  minimumSize:
                                                                      Size(
                                                                          150.w,
                                                                          45.h))),
                                                      SizedBox(
                                                        height: 25.h,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    } else {
                                      errorDialog(context, 2);
                                    }
                                  }
                                  // doğrulama şifresi hatalıysa
                                  else {
                                    errorDialog(context, 1);
                                  }
                                } else {
                                  errorDialog(context, 0);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(150.w, 45.h)),
                              child: Text("Kayıt Ol")),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        minimumSize: Size(300.w, 65.h),
      ),
      child: Text("Kayıt Ol"),
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

  Future<void> showSuccessDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
              fontSize: 30.sp),
          title: Row(
            children: [
              Text("Tebrikler"),
              SizedBox(width: 10.w),
              Icon(
                Icons.check_circle,
                color: Colors.indigo,
                size: 40,
              ),
            ],
          ),
          content: Row(
            children: [
              Expanded(
                  child: Text(
                'Başarıyla uygulamaya kayıt oldunuz.',
                style: TextStyle(fontSize: 20.sp),
              )),
            ],
          ),
        );
      },
    );
    // AlertDialog 2 saniye sonra otomatik olarak kapatılır
    await Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pop();
    });
  }
}
