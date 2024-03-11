import 'dart:async';
import 'dart:developer';
import 'package:chat_application/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:chat_application/models/chats.dart';
import 'package:chat_application/models/messages.dart';
import 'package:chat_application/models/users.dart';
import 'package:chat_application/services/chat-service.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final NotificationService _notificationService = NotificationService();
  RxList<Messages> messageList = <Messages>[].obs;
  RxList<Chat> allChats = <Chat>[].obs;
  RxList<Chat> chats = <Chat>[].obs;
  // Getx tanımlama
  RxInt sayi = 0.obs;
  RxString etsx = "".obs;
  StreamSubscription? messagesStreamSubscription;
  StreamSubscription? chatsStreamSubscription;
//dissmissible
  Future<void> sendMessage(User currentuser, User chatUser, String message,
      String tempuserId) async {
    await _chatService.sendMessage(currentuser, chatUser, message, tempuserId);
    await _notificationService.sendNotification(
        chatUser.userToken, chatUser.nickName, message);
  }

  void getMessageList(String currentuserId, User chatUser) async {
    messageList.clear();
    List<Messages> messages =
        await _chatService.getMessageList(currentuserId, chatUser);
    messageList.assignAll(messages);
  }

  void deleteMessage(
      String currentUserId, User chatUser, String messageId) async {
    await _chatService.removeMessage(currentUserId, chatUser, messageId);
    try {
      messageList.removeWhere((element) => element.messageId == messageId);

      await _chatService.updateChatAfterDelete(
          currentUserId, chatUser, messageList.last);
    } catch (e) {
      log(e.toString());
    }
  }

  void removeChat(String chatId) {
    _chatService.removeChat(chatId);
  }

  void getChats(String currentuserId) async {
    List<Chat> chatsList = await _chatService.getChats(currentuserId);
    // Listeyi eşitliyor
    chats.assignAll(chatsList);
    allChats.assignAll(chatsList);
  }

  void listenMessage(String currentuserId, User chatUser) {
    messagesStreamSubscription =
        _chatService.listenMessage(currentuserId, chatUser).listen((event) {
      if (event.docs.isNotEmpty) {
        // Son belgeyi alın
        var lastDocument = event.docs.first;
        // Belgenin içeriğini alın ve Messages nesnesine dönüştürün
        var lastMessage =
            Messages.fromJson(lastDocument.data() as Map<String, dynamic>);
        // Son mesajı listeye ekleyin

        if (messageList
            .where((e) => e.messageId == lastMessage.messageId)
            .isEmpty) {
          messageList.add(lastMessage);
        }
        // print("Last Message: " + lastMessage.text);
      }
    });
  }

  void listenChats(String currentuserId, List<Chat> chatsList) {
    chatsStreamSubscription =
        _chatService.listenChats(currentuserId, chatsList).listen((event) {
      event.docs.forEach((doc) {
        if (chatsList
            .where((element) => element.chatId == doc.data()['chatId'])
            .isEmpty) {
          Chat newChat = Chat.fromJson(doc.data());
          chatsList.add(newChat);
        } else {
          for (int i = 0; i < chatsList.length; i++) {
            if (chatsList[i].chatId == doc.data()['chatId']) {
              // Mevcut chat bulundu, güncelleme yap
              Chat updatedChat = Chat.fromJson(doc.data());
              chatsList[i] = updatedChat;
            }
          }
        }
        allChats.clear();
        allChats.addAll(chatsList);
      });
    });
  }

  Future<int> calculateMessage(String currentuserId) async {
    int messageCount = await _chatService.calculateMessage(currentuserId);
    return messageCount;
  }

  String chatDateTimeConvert(Chat chat) {
    int sendTime = chat.dateTime;
    String formatTime =
        DateFormat.Hms().format(DateTime.fromMillisecondsSinceEpoch(sendTime));
    return formatTime;
  }

  String messageDateTimeConvert(Messages message) {
    int sendTime = message.dateTime;
    String formatTime =
        DateFormat.Hms().format(DateTime.fromMillisecondsSinceEpoch(sendTime));
    return formatTime;
  }
}
