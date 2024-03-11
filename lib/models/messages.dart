// To parse this JSON data, do
//
//     final messages = messagesFromJson(jsonString);

import 'dart:convert';

Messages messagesFromJson(String str) => Messages.fromJson(json.decode(str));

String messagesToJson(Messages data) => json.encode(data.toJson());

class Messages {
  String messageId;
  String text;
  String senderId;
  int dateTime;

  Messages({
    required this.messageId,
    required this.text,
    required this.senderId,
    required this.dateTime,
  });

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        messageId: json["messageId"],
        text: json["text"],
        senderId: json["senderId"],
        dateTime: json["dateTime"]
      );

  Map<String, dynamic> toJson() => {
        "messageId": messageId,
        "text": text,
        "senderId": senderId,
        "dateTime": dateTime,
      };
}
