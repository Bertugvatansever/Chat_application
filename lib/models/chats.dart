import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  String ownerId;
  String chatId;
  int dateTime;
  String lastMessage;
  bool? isMessageFromMe;
  Map<String, dynamic> chatUser;

  Chat(
      {required this.ownerId,
      required this.chatId,
      required this.dateTime,
      required this.lastMessage,
      required this.chatUser,
      required this.isMessageFromMe});

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        ownerId: json["ownerId"],
        chatId: json["chatId"],
        dateTime: json["dateTime"].toInt(),
        lastMessage: json["lastMessage"],
        chatUser: json["chatUser"],
        isMessageFromMe: json["isMessageFromMe"],
      );

  Map<String, dynamic> toJson() => {
        "ownerId": ownerId,
        "chatId": chatId,
        "dateTime": dateTime,
        "lastMessage": lastMessage,
        "chatUser": chatUser,
      };
}
