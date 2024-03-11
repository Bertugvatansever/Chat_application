// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String id;
    String nickName;
    String phoneNumber;
    dynamic imageUrl;
    int updatedTime;
    String userToken;

    User({
        required this.id,
        required this.nickName,
        required this.phoneNumber,
        required this.imageUrl,
        required this.updatedTime,
        required this.userToken
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        nickName: json["nickName"],
        phoneNumber: json["phoneNumber"],
        imageUrl: json["imageUrl"],
        updatedTime: json["updatedTime"],
        userToken:  json["userToken"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nickName": nickName,
        "phoneNumber": phoneNumber,
        "imageUrl": imageUrl,
        "updatedTime": updatedTime,
        "userToken" : userToken
    };
}
