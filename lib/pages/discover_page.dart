import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/controllers/chat_controller.dart';
import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/models/users.dart';
import 'package:chat_application/pages/chatting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DiscoverPage extends StatefulWidget {
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  bool _issearchOpen = false;
  // UserController classını kullanıma hazır hale getiriyorum
  final UserController userController = Get.find();
  final ChatController chatController = Get.find();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Başlangıçta tüm kullanıcıları listele
  }

  @override
  void dispose() {
    chatController.getChats(userController.user.value.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        backgroundColor: Colors.indigo,
        title: _issearchOpen
            ? Container(
                width: 300.w,
                height: 30.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: SizedBox(
                        width: 230.w,
                        height: 20.h,
                        child: TextField(
                            decoration: const InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                            controller: searchController,
                            onChanged: (value) {
                              filterUsers(value.trim());
                            },
                            onSubmitted: (value) {
                              filterUsers(value.trim());
                            },
                            // yazı yazarken alttaki çizgiyi yok eder
                            enableSuggestions: false),
                      ),
                    ),
                  ],
                ),
              )
            : const Text(
                'Kullanıcılar',
                style: TextStyle(color: Colors.white),
              ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _issearchOpen = !_issearchOpen;
                  // userController.allUsers .addAll( userController.users);
                });

                if (!_issearchOpen) {
                  userController.allUsers.clear();
                  userController.allUsers.addAll(userController.users);
                  searchController.clear();
                }
              },
              icon:
                  !_issearchOpen ? const Icon(Icons.search) : Icon(Icons.close),
              iconSize: 30,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 231, 225, 225),
        child: Obx(
          () => ListView.builder(
            itemCount: userController.allUsers.length,
            itemBuilder: (context, index) {
              if (userController.allUsers[index].id==userController.user.value.id) {
                return SizedBox();
              } else {
                return Material(
                child: Ink(
                  width: ScreenUtil().screenWidth,
                  height: 100.h,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 231, 225, 225),
                  ),
                  child: InkWell(
                      splashColor: Colors.indigo.withOpacity(0.4),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (_issearchOpen) {
                            Get.to(() =>
                                ChatPage(user: userController.allUsers[index]));
                            chatController.getMessageList(
                                userController.user.value.id,
                                userController.allUsers[index]);
                          } else {
                            Get.to(() =>
                                ChatPage(user: userController.allUsers[index]));
                            chatController.getMessageList(
                                userController.user.value.id,
                                userController.allUsers[index]);
                          }
                        });
                      },
                      child: listTileWidget(0, index)),
                ),
              );
              }
            },
          ),
        ),
      ),
    );
  }

  // arama filtrelemesi
  void filterUsers(String query) {
    log(query);
    // userController.allUsers.clear();
    // yazı alanı boş değilse
    userController.allUsers.clear();
    if (query.trim().isNotEmpty) {
      log("ife girdi is not empty");

      userController.allUsers.addAll(userController.users
          // listenin içine gir ve her bir class için arama yerindeki yazının sorgusunu yap
          .where((user) => user.nickName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList());

      log(userController.users.toString());
    }
    // eğer boşsa hepsini getir
    else {
      log("else girdi");

      userController.allUsers.addAll(userController.users);
    }
  }

  Widget listTileWidget(int paddingValue, int index) {
    if (index == 0) {
      paddingValue = 12;
    } else {
      paddingValue = 0;
    }

    return Padding(
      padding: EdgeInsets.only(top: paddingValue.h),
      child: ListTile(
        leading: _issearchOpen
            ? userController.allUsers[index].imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: userController.allUsers[index].imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageBuilder: (context, imageProvider) {
                      return CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 30,
                      );
                    },
                  )
                : CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                    backgroundColor: Colors.indigo.withOpacity(0.2),
                  )
            : userController.allUsers[index].imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: userController.allUsers[index].imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageBuilder: (context, imageProvider) {
                      return CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 30,
                      );
                    },
                  )
                : CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                    backgroundColor: Colors.indigo.withOpacity(0.2),
                  ),
        title: Padding(
          padding: EdgeInsets.only(left: 8.0.w),
          child: Text(
            userController.allUsers[index].nickName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0.sp,
                color: Colors.indigo),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8.0.h, left: 8.0.w),
          child: Text(
            userController.allUsers[index].phoneNumber,
            style: const TextStyle(color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Container(
          width: 45.w,
          height: 45.w,
          color: Colors.indigo,
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
