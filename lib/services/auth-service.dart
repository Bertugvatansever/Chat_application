import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {
  Future<String?> registerUser(String nickName, String password) async {
    String? id = await signUp(nickName, password);
    // işlem başarıyla sonuçlanırsa
    return id;
  }

  // Kullanıcı giriş yaparken sorgu
  Future<String?> signIn(String email, String password) async {
    // e mail ve password ile kullanıcıyı otomatik kayıt ediyoruz.
    auth.UserCredential userCredential =
        // bu method signIn olacak ancak şu an hata alıyorum
        await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // otomatik oluşturulan id değerini alıyoruz
    String? userId = userCredential.user?.uid;
    // Kullanıcı başarıyla kaydedildiğinde buraya gelecek kod
    print('Kullanıcı başarıyla giriş yaptı: ${userCredential.user}');

    return userId;
  }

  // Kayıt olma fonksiyonu
  Future<String?> signUp(String email, String password) async {
    // e mail ve password ile kullanıcıyı otomatik kayıt ediyoruz.
    auth.UserCredential userCredential =
        // bu method signIn olacak ancak şu an hata alıyorum
        await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // otomatik oluşturulan id değerini alıyoruz
    String? userId = userCredential.user?.uid;
    // Kullanıcı başarıyla kaydedildiğinde buraya gelecek kod
    print('Kullanıcı başarıyla kayıt edildi.: ${userCredential.user}');

    return userId;
  }

  
  Future<void> signOut() async {
    await auth.FirebaseAuth.instance.signOut();
  }

  String? getcurrentUserId() {
    return auth.FirebaseAuth.instance.currentUser?.uid;
  }
}
