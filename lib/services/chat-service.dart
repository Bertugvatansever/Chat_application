import 'dart:async';
import 'package:chat_application/models/chats.dart';
import 'package:chat_application/models/messages.dart';
import 'package:chat_application/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  Future<void> sendMessage(User currentuser, User chatUser, String message,
      String tempuserId) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('chats');
    // mesajın kimden geldiğini tespit edeceğiz
    bool isMessageFromMe;
    if (tempuserId == currentuser.id) {
      isMessageFromMe = true;
    } else {
      isMessageFromMe = false;
    }
    // Kendi sohbetimize kayıt etme yeri
    await collectionReference.doc(currentuser.id! + "-" + chatUser.id).set({
      "ownerId": currentuser.id,
      "chatId": currentuser.id + "-" + chatUser.id,
      "dateTime": DateTime.now().millisecondsSinceEpoch,
      "chatUser": chatUser.toJson(),
      "lastMessage": message,
      "isMessageFromMe": isMessageFromMe
    });

    String messageId = collectionReference
        .doc(currentuser.id! + "-" + chatUser.id)
        .collection("messages")
        .doc()
        .id;

    await collectionReference
        .doc(currentuser.id! + "-" + chatUser.id)
        .collection("messages")
        .doc(messageId)
        .set({
      "messageId": messageId,
      "text": message,
      "senderId": currentuser.id,
      "dateTime": DateTime.now().millisecondsSinceEpoch
    });
    // Konuştuğumuz kişiye kayıt etme yeri
    await collectionReference.doc(chatUser.id! + "-" + currentuser.id).set({
      "ownerId": chatUser.id,
      "chatId": chatUser.id + "-" + currentuser.id,
      "dateTime": DateTime.now().millisecondsSinceEpoch,
      "chatUser": currentuser.toJson(),
      "lastMessage": message,
      "isMessageFromMe": !isMessageFromMe,
    });

    String messagereceiverId = collectionReference
        .doc(chatUser.id! + "-" + currentuser.id)
        .collection("messages")
        .doc()
        .id;

    await collectionReference
        .doc(chatUser.id! + "-" + currentuser.id)
        .collection("messages")
        .doc(messagereceiverId)
        .set({
      "messageId": messagereceiverId,
      "text": message,
      "senderId": currentuser.id,
      "dateTime": DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<List<Messages>> getMessageList(
      String currentuserId, User chatUser) async {
    List<Messages> messages = [];
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("chats");
    QuerySnapshot querySnap = await collectionReference
        .doc(currentuserId + "-" + chatUser.id)
        .collection("messages")
        .get();
    querySnap.docs.forEach((element) {
      Messages message =
          Messages.fromJson(element.data() as Map<String, dynamic>);
      print(message);
      messages.add(message);
    });
    return messages;
  }

  Future<void> removeMessage(
    String currentUserId,
    User chatUser,
    String messageId,
  ) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("chats");
    await collectionReference
        .doc(currentUserId + "-" + chatUser.id)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  // Chat silme işlemi
  Future<void> removeChat(String chatId) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("chats");
    QuerySnapshot querySnapshot =
        await collectionReference.doc(chatId).collection("messages").get();
    querySnapshot.docs.forEach((document) {
      print(document.reference.id);
      document.reference.delete();
    });
    await collectionReference.doc(chatId).delete();
  }

  Future<void> updateChatAfterDelete(
      String currentUserId, User chatUser, Messages lastMessage) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("chats");

    await collectionReference.doc(currentUserId + "-" + chatUser.id).set({
      "ownerId": currentUserId,
      "chatId": currentUserId + "-" + chatUser.id,
      "dateTime": DateTime.now().millisecondsSinceEpoch,
      "chatUser": chatUser.toJson(),
      "lastMessage": lastMessage.text,
      "isMessageFromMe": true,
    });
  }

  Future<List<Chat>> getChats(String currentuserId) async {
    List<Chat> userChatList = [];
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("chats");
    QuerySnapshot querySnapshot = await collectionReference
        .where("ownerId", isEqualTo: currentuserId)
        .get();
    querySnapshot.docs.forEach((element) {
      Map<String, dynamic> allchat = element.data() as Map<String, dynamic>;
      String chatIdPrefix = currentuserId + "-";
      if (allchat.containsKey("chatId") &&
          allchat["chatId"].startsWith(chatIdPrefix)) {
        Chat chat = Chat.fromJson(allchat);
        userChatList.add(chat);
      }
    });
    return userChatList;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenChats(
      String currentuserId, List<Chat> chatsList) {
    Stream<QuerySnapshot<Map<String, dynamic>>> chatStream = FirebaseFirestore
        .instance
        .collection("chats")
        .where("ownerId", isEqualTo: currentuserId)
        .orderBy("dateTime", descending: true)
        .limit(1)
        .snapshots();
    return chatStream;
  }

  // canlı mesajları dinleme kısmı
  Stream<QuerySnapshot<Map<String, dynamic>>> listenMessage(
      String currentuserId, User chatUser) {
    Stream<QuerySnapshot<Map<String, dynamic>>> messageStream =
        FirebaseFirestore.instance
            .collection("chats")
            .doc(currentuserId + "-" + chatUser.id)
            .collection("messages")
            .orderBy('dateTime', descending: true)
            .limit(1)
            .snapshots();

    return messageStream;
  }

  Future<int> calculateMessage(String currentuserId) async {
    int messageCount = 0;
    CollectionReference chatsCollection =
        FirebaseFirestore.instance.collection("chats");

    // Belirli bir kullanıcının chat belgelerini al
    QuerySnapshot chatDocs = await chatsCollection
        .where("chatId", isGreaterThanOrEqualTo: currentuserId + "-")
        .where("chatId", isLessThan: currentuserId + "-\uFFFF")
        .get();

    // Her bir chat belgesi için messages koleksiyonunu al ve eleman sayısını hesapla
    for (QueryDocumentSnapshot chatDoc in chatDocs.docs) {
      CollectionReference messagesCollection =
          chatsCollection.doc(chatDoc.id).collection('messages');

      QuerySnapshot messageDocs = await messagesCollection.get();
      messageCount += messageDocs.size;

      print("Chat ID: ${chatDoc.id}, Message Count: $messageCount");
    }
    return messageCount;
  }
}
