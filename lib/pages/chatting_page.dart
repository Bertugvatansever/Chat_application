import 'package:chat_application/controllers/chat_controller.dart';
import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/models/messages.dart';
import 'package:chat_application/models/users.dart';
import 'package:chat_application/widgets/chat_page_bar_widget.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.user});
  final User user;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

TextEditingController writeController = TextEditingController();

class _ChatPageState extends State<ChatPage> {
  bool hasScrolled = false;
  String tempuserId = "";
  final ChatController chatController = Get.find();
  final UserController userController = Get.find();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Yazı yazma kısmını dinliyorum.
    writeController.addListener(() {
      if (writeController.text.isEmpty && this.mounted) {
        iconIndex = 0;
        setState(() {});
      } else if (writeController.text.isNotEmpty && this.mounted) {
        iconIndex = 1;
        setState(() {});
      }
    });
    // mesajları dinliyorum
    chatController.listenMessage(userController.user.value.id, widget.user);
    // sayfa açıldığında en aşağıya kaydırıyorum
    Future.delayed(const Duration(milliseconds: 500), () {
      if (hasScrolled == false) {
        scrollToBottom(500);
        hasScrolled = true;
      }
    });
    // mesaj tespiti için idyi aldım
    tempuserId = userController.user.value.id;
  }

  @override
  void dispose() {
    chatController.messagesStreamSubscription?.cancel();
    super.dispose();
  }

  int iconIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Klavye taşmasını engeller
        resizeToAvoidBottomInset: false,
        body: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          color: const Color.fromARGB(255, 231, 225, 225),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ChatPageBarWidget(user: widget.user),
              Expanded(
                child: SizedBox(
                  width: ScreenUtil().screenWidth,
                  height: 556.h,
                  child: Obx(
                    () {
                      // Mesaj listesini tarihlerine göre sırala
                      chatController.messageList
                          .sort((a, b) => a.dateTime.compareTo(b.dateTime));
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: chatController.messageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (chatController.messageList[index].senderId ==
                              userController.user.value.id) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: Ink(
                                        child: InkWell(
                                          onLongPress: () {
                                            showDeleteConfirmationDialog(
                                                chatController
                                                    .messageList[index],
                                                index);
                                          },
                                          child: BubbleSpecialThree(
                                            text: chatController
                                                .messageList[index].text,
                                            color: const Color.fromARGB(
                                                255, 94, 113, 218),
                                            tail: true,
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: Text(chatController
                                          .messageDateTimeConvert(chatController
                                              .messageList[index])),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.h,
                                )
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: Ink(
                                        child: InkWell(
                                          onLongPress: () {
                                            showDeleteConfirmationDialog(
                                                chatController
                                                    .messageList[index],
                                                index);
                                          },
                                          child: BubbleSpecialThree(
                                            text: chatController
                                                .messageList[index].text,
                                            isSender: false,
                                            color: Colors.white,
                                            tail: true,
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15.w),
                                      child: Text(chatController
                                          .messageDateTimeConvert(chatController
                                              .messageList[index])),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.h,
                                )
                              ],
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: 120.h,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // container tıklanamasın diye yapıldı.
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 350.w,
                              height: 60.h,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 231, 225, 225),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    height: 60.h,
                                    width: 220.w,
                                    child: TextField(
                                        controller: writeController,
                                        scrollPadding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        decoration: InputDecoration(
                                            hintText: "Buraya yazın...",
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                                left: 20.w, top: 10.h))),
                                  ),
                                  Container(
                                    width: 1.w,
                                    color: Colors.grey,
                                    height: 30.h,
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  iconChange(iconIndex)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconChange(int index) {
    if (index == 0) {
      return Row(
        children: [
          const Icon(
            Icons.mood,
            color: Color.fromARGB(255, 121, 120, 120),
            size: 30,
          ),
          SizedBox(
            width: 20.w,
          ),
          const Icon(
            Icons.photo_camera,
            color: Color.fromARGB(255, 104, 100, 100),
            size: 30,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          const Icon(
            Icons.mood,
            color: Color.fromARGB(255, 121, 120, 120),
            size: 30,
          ),
          SizedBox(
            width: 20.w,
          ),
          GestureDetector(
            onTap: () async {
              // Rx tipindeki Bir class varsa bunun propertylerine value ile erişim sağlanıyor.

              playClickSound();

              String message = writeController.text;

              writeController.clear();

              await chatController.sendMessage(
                  userController.user.value, widget.user, message, tempuserId);
              scrollToBottom(100);
            },
            child: CircleAvatar(
              backgroundColor: Colors.indigo,
              maxRadius: 17.w,
              child: Padding(
                padding: EdgeInsets.only(left: 3.0.w),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  void scrollToBottom(int scrollMilliseconds) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: scrollMilliseconds),
      curve: Curves.easeOut,
    );
  }

  void playClickSound() {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
  }

  void showDeleteConfirmationDialog(Messages message, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Mesajı Sil',
            style: TextStyle(color: Colors.indigo),
          ),
          content: const Text('Bu mesajı silmek istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                chatController.deleteMessage(userController.user.value.id,
                    widget.user, message.messageId);

                Navigator.of(context).pop();
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}
