import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/controllers/chat_controller.dart';
import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/models/users.dart';
import 'package:chat_application/pages/call_history_page.dart';
import 'package:chat_application/pages/chatting_page.dart';
import 'package:chat_application/pages/discover_page.dart';
import 'package:chat_application/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  final ChatController _chatController = Get.find();
  final UserController _userController = Get.find();
  @override
  void initState() {
    super.initState();
    _chatController.getChats(_userController.user.value.id);
    _chatController.listenChats(
        _userController.user.value.id, _chatController.chats);
  }

  // Sayfa kapandığında dinleme işlemini iptal ediyorum
  @override
  void dispose() {
    _chatController.chatsStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {




    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // SingleChildScrollViewla kullan
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: SizedBox(),
        leadingWidth: 0,
        backgroundColor: Color.fromARGB(255, 231, 225, 225),
        title: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          width: 360.w,
          height: 60.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(Icons.search,
                    size: 35, color: Color.fromARGB(255, 139, 139, 139)),
              ),
              SizedBox(
                width: 20.w,
              ),
              SizedBox(
                width: 290.w,
                height: 60.h,
                child: TextField(
                  onChanged: (value) {
                    filterChats(value);
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                      hintText: "Mesaj veya kullanıcı ara...",
                      hintStyle: TextStyle(
                        fontSize: 21.sp,
                        color: Colors.grey,
                      ),
                      // genel çizgiyi yok eder
                      enabledBorder: InputBorder.none,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none),
                  // yazının içine girince olan çizgiyi yok eder
                  autocorrect: false,
                  enableSuggestions: false,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 21.sp,
                      decoration: TextDecoration.none),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 231, 225, 225),
          child: Column(
            children: [
              SizedBox(
                height: 15.h,
              ),
              SizedBox(
                  width: 360.w,
                  height: 620.h,
                  child: Obx(
                    () => ListView.builder(
                      itemCount: _chatController.allChats.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            // kaydırma işlemini gerçekleştirir.
                            Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                _chatController.removeChat(
                                    _chatController.allChats[index].chatId);
                                _chatController.chats
                                    .remove(_chatController.chats[index]);
                                _chatController.allChats
                                    .remove(_chatController.allChats[index]);
                              },
                              background: Container(
                                color: Colors.indigo,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Konuşma Siliniyor...",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              child: Material(
                                child: Ink(
                                  height: 100.h,
                                  width: 360.w,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: InkWell(
                                      splashColor:
                                          Color.fromARGB(255, 177, 184, 175),
                                      onTap: () {
                                        Future.delayed(
                                            Duration(milliseconds: 500), () {
                                          User tempuser = User(
                                              id: _chatController
                                                  .chats[index].chatUser["id"],
                                              nickName: _chatController
                                                  .chats[index]
                                                  .chatUser["nickName"],
                                              phoneNumber: _chatController
                                                  .chats[index]
                                                  .chatUser["phoneNumber"],
                                              imageUrl: _chatController
                                                  .chats[index]
                                                  .chatUser["imageUrl"],
                                              updatedTime: _chatController
                                                  .chats[index]
                                                  .chatUser["updatedTime"],
                                              userToken: _chatController
                                                  .chats[index]
                                                  .chatUser["userToken"]);
                                          //
                                          _chatController.getMessageList(
                                              _userController.user.value.id,
                                              tempuser);
                                          Get.to(ChatPage(user: tempuser));
                                        });
                                      },
                                      child: isMessageFromMe(index)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        );
                      },
                    ),
                  )),
              Container(
                width: screenWidth,
                height: 86.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => DiscoverPage());
                      },
                      icon: Icon(Icons.language),
                      iconSize: 35,
                      color: Colors.grey,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.forum),
                      iconSize: 35,
                      color: Colors.indigo,
                    ),
                    Container(
                        width: 65.w,
                        height: 65.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: Colors.indigo,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.indigo,
                                  spreadRadius: 4,
                                  blurRadius: 7),
                            ]),
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.add,
                            size: 35,
                            color: Colors.white,
                          ),
                        )),
                    IconButton(
                      onPressed: () {
                        Get.to(() => CallHistoryPage());
                      },
                      icon: Icon(Icons.call),
                      iconSize: 35,
                      color: Colors.grey,
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => ProfilPage());
                      },
                      icon: Icon(Icons.person),
                      iconSize: 35,
                      color: Colors.grey,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget isMessageFromMe(int index) {
    final chat = _chatController.allChats[index];
    final imageUrl = chat.chatUser["imageUrl"];
    final nickName = chat.chatUser["nickName"];
    final lastMessage = chat.lastMessage;

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: imageUrl != null
              // resim yüklenirken yuvarlaklık vermek için kullandık
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: 30,
                    );
                  },
                )
              : Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.indigo,
                ),
        ),
        SizedBox(width: 21.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 13.h),
                child: Text(
                  nickName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  if (chat.isMessageFromMe == true)
                    Icon(
                      Icons.send,
                      size: 25,
                    ),
                  if (chat.isMessageFromMe != null &&
                      chat.isMessageFromMe == true)
                    SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
            _chatController.allChats[index].isMessageFromMe == true
                ? Padding(
                    padding: EdgeInsets.only(
                      top: 15.h,
                      left: 8.w,
                      right: 8.0.w,
                      bottom: 22.h,
                    ),
                    child: Text(_chatController.chatDateTimeConvert(chat)),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                      top: 15.h,
                      left: 8.w,
                      right: 8.0.w,
                      bottom: 15.h,
                    ),
                    child: Text(_chatController.chatDateTimeConvert(chat)),
                  ),
            if (chat.isMessageFromMe == false)
              Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.indigo,
                ),
                child: Center(
                    child: Text(
                  "1",
                  style: TextStyle(color: Colors.white),
                )),
              ),
          ],
        ),
      ],
    );
  }

  void filterChats(String query) {
    // userController.allUsers.clear();
    // yazı alanı boş değilse
    _chatController.allChats.clear();
    if (query.trim().isNotEmpty) {
      _chatController.allChats.addAll(_chatController.chats
          // listenin içine gir ve her bir class için arama yerindeki yazının sorgusunu yap
          .where((chat) =>
              chat.chatUser["nickName"]
                  .trim()
                  .toLowerCase()
                  .contains(query.trim().toLowerCase()) ||
              chat.lastMessage
                  .trim()
                  .toLowerCase()
                  .contains(query.trim().toLowerCase()))
          .toList());
    }
    // eğer boşsa hepsini getir
    else {
      _chatController.allChats.addAll(_chatController.chats);
    }
  }
}
