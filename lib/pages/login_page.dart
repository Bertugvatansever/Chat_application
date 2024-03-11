import 'package:chat_application/widgets/login_widget.dart';
import 'package:chat_application/widgets/register_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double signfractionHigh = 0.518;
  double loginfractionHigh = 0.425;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeigth = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // ARKA PLAN FOTOĞRAFI
      // SafeArea bazı ekran çakışmalarını önlüyor
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeigth,
          decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.difference,
              image: DecorationImage(
                image: AssetImage("assets/pattern.jpg"),
                fit: BoxFit.fitHeight,
              )),
          // Ekran Arayüzü
          child: Container(
            // Gölge vererek arka planı biraz kararttık.
            decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: screenWidth,
                  height: 410.h,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Center(
                          child: Text(
                        "Enjoy the new experience of chatting with global friends",
                        style: TextStyle(
                            fontSize: 24.sp, fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Connect people around the world for ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      // Kayıt Ol Butonu
                      RegisterWidget(),
                      SizedBox(
                        height: 25.h,
                      ),
                      // Giriş yap Butonu
                      LoginWidget()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
