import 'dart:io';
import 'package:chat_application/services/auth-service.dart';
import 'package:chat_application/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:chat_application/models/users.dart';
import 'package:chat_application/services/user-service.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  final NotificationService _notificationService = NotificationService();
  // RxList olarak tanımlayarak Getx tipinde bir liste tanımladık
  // Sonrasında obs ekleyerek bu listenin dinleneceğinin haberini verdik
  Rx<User> user = User(
          id: "",
          nickName: "",
          phoneNumber: "",
          imageUrl: "",
          updatedTime: 1,
          userToken: "")
      .obs;
  Rx<File> imageFile = File("").obs;
  List<User> users = <User>[];
  RxList<User> allUsers = <User>[].obs;

  @override
  // Controller çağırıldığında ilk çağırılan methoddur.
  void onInit() {
    super.onInit();
    getUsers(); // Sınıf başlatıldığında kullanıcıları al
    getcurrentUser();
    listenUsers();
  }

  getcurrentUser() async {
    try {
      String? id = _authService.getcurrentUserId();

      if (id != null) {
        user.value = await _userService.getcurrentUser(id);
      }
    } catch (e) {}
  }

  Future<void> getUsers() async {
    try {
      var userList = await _userService.getUsers();
      users.assignAll(userList);
      users.removeWhere((element) => element.id == user.value.id);
      allUsers.addAll(users);
    } catch (e) {
      // Hata yönetimi
      print("Kullanıcılar getirilirken hata oluştu: $e");
    }
  }

  void listenUsers() {
    _userService.listenUsers().listen((event) {
      event.docs.forEach((userDoc) {
        // Firestore'dan gelen belgeyi kullanıcı nesnesine dönüştür
        User tempUser = User.fromJson(userDoc.data() as Map<String, dynamic>);
        print(tempUser.id);
        // users listesinde böyle bir kullanıcı var mı

        if (users.where((element) => element.id == tempUser.id).isEmpty) {
          users.add(tempUser);
        } else {
          users.removeWhere((element) => element.id == tempUser.id);

          users.add(tempUser);
          // for (int i = 0; i < users.length; i++) {
          //   if (users[i].id == tempUser.id) {
          //     users[i] = tempUser; // Kullanıcıyı güncelle
          //     break;
          //   }
          // }
        }

        users.removeWhere((element) => element.id == user.value.id);
        allUsers.clear();
        allUsers.addAll(users);
      });
    });
  }

  Future<void> signIn(String email, String password) async {
    String? userId;
    try {
      userId = await _authService.signIn(email, password);
    } catch (e) {
      Get.dialog(AlertDialog(
        // title üst başlık
        titleTextStyle: TextStyle(color: Colors.indigo, fontSize: 30.sp),
        title: Text("Hata!"),
        // content içerik kısmı
        content: Text(e.toString()),
        contentTextStyle: TextStyle(fontSize: 17.sp, color: Colors.black),
        // actions içerik alt kısmı
      ));
    }

    if (userId != null) {

          String? userToken = await _notificationService.getToken();
        await _userService.updateUserToken(
        userId, userToken??"");

        
      user.value = await _userService.getcurrentUser(userId);
  
    }
  }

  Future<bool> registerUser(
      String nickName, String password, String phoneNumber) async {
    String? userId = await _authService.registerUser(nickName, password);
    String? userToken = await _notificationService.getToken();
    bool confirm = await _userService.saveRegisterUser(
        userId, nickName, password, phoneNumber, userToken);
    return confirm;
  }

  Future<void> updateProfilePhoto() async {
    // kullanıcıya galeriden fotoğraf seçme şansı tanınıyor
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        imageFile.value = File(pickedFile.path);
        // seçilen fotoğrafı Firebasestorage a yerleştiriyor ve urlsini alıyor.
        String url = await _userService.uploadProfilePhoto(imageFile.value);
        // aldığımız urlyi gidip veritabanımıza yüklüyoruz
        _userService.updateUserProfilePhoto(user.value.id, url);

        // Resmin URL'sini Firestore'a kaydet
      } catch (error) {
        print('Error uploading image: $error');
      }
    }
  }
}
