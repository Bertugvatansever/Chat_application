import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:chat_application/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  Future<bool> saveRegisterUser(String? id, String nickName, String password,
      String phoneNumber, String? userToken) async {
    if (id != null) {
      try {
        // users tablosuna ulaşıyoruz
        CollectionReference usersRef =
            FirebaseFirestore.instance.collection('users');

        // users tablosuna veri giriyoruz.
        await usersRef.doc(id).set({
          'id': id,
          'nickName': nickName,
          'phoneNumber': phoneNumber,
          'updatedTime': DateTime.now().millisecondsSinceEpoch,
          'userToken': userToken
        });
        print('Kullanıcı başarıyla kaydedildi.');
        return true;
      } catch (e) {
        print('Hata: $e');
        return false;
      }
    } else {
      print("hata gerçekleşti");
      return false;
    }
  }

  Future<List<User>> getUsers() async {
    List<User> users = [];
    // Collection Reference firestore a ulaşmak için kullanılır.
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    // QuerySnapshot veritabanından birden fazla belge çağırırken kullanılır
    QuerySnapshot querysnap = await usersRef.get();
    users.clear();
    querysnap.docs.forEach((element) {
      User user = User.fromJson(element.data() as Map<String, dynamic>);
      String? currentid = auth.FirebaseAuth.instance.currentUser?.uid;

      if (currentid != user.id && currentid != null) {
        users.add(user);
      }
    });

    return users;
  }

  Future<User> getcurrentUser(String id) async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    // DocumentSnapshot bir adet belge çağırırken kullanılır.
    DocumentSnapshot documentSnapshot = await usersRef.doc(id).get();
    User user = User.fromJson(documentSnapshot.data() as Map<String, dynamic>);

    return user;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenUsers() {
    Stream<QuerySnapshot<Map<String, dynamic>>> userStream = FirebaseFirestore
        .instance
        .collection("users")
        .orderBy('updatedTime', descending: true)
        .limit(1)
        .snapshots();

    return userStream;
  }

  Future<String> uploadProfilePhoto(File image) async {
    final Reference ref = FirebaseStorage.instance
        // fotoğrafı storage a nereye koyacağımızı ve hangi isimle koyacağımızı belirledik
        .ref()
        .child('user_images')
        .child('image_${DateTime.now()}.jpg');
// fotoğrafı storage a koyduk
    await ref.putFile(image);
// storagedan url yi çektik
    final imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> updateUserProfilePhoto(
      String userId, String profilePhotoUrl) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'imageUrl': profilePhotoUrl,
      'updatedTime': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> updateUserToken(String userId, String token) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'userToken': token,
      'updatedTime': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
