import 'package:chat_application/pages/call_history_page.dart';
import 'package:chat_application/pages/discover_page.dart';
import 'package:chat_application/pages/home_page.dart';
import 'package:chat_application/pages/profile_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // cloud messaging aracılığıyla bildirim göndermek için tanımlandı
  
  int currentIndexBar = 1;
  List<Widget> screens = [
    DiscoverPage(),
    const HomePage(),
    const HomePage(),
    CallHistoryPage(),
    ProfilPage()
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        child: SizedBox(
          height: 86.h,
          child: BottomNavigationBar(
              elevation: 20,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              currentIndex: currentIndexBar,
              selectedItemColor: Colors.indigo,
              unselectedItemColor: Colors.grey,
              onTap: (value) {
                setState(() {
                  currentIndexBar = value;
                });
              },
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.language,
                    size: 35,
                  ),
                  label: "",
                ),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.forum, size: 35), label: ""),
                BottomNavigationBarItem(
                  label: "",
                  icon: Container(
                      width: 65.w,
                      height: 65.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.indigo,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.indigo,
                                spreadRadius: 4,
                                blurRadius: 7),
                          ]),
                      child: GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.add,
                          size: 35,
                          color: Colors.white,
                        ),
                      )),
                ),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.call, size: 35), label: ""),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.person, size: 35), label: "")
              ]),
        ),
      ),
      body: screens[currentIndexBar],
    );
  }

  
}
