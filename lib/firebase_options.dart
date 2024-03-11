// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDildMCzRdr7k7-VW4mdJapbj-kT6lz5K4',
    appId: '1:1058809854185:web:96a6ce2526604034995878',
    messagingSenderId: '1058809854185',
    projectId: 'chatapp-7c72a',
    authDomain: 'chatapp-7c72a.firebaseapp.com',
    storageBucket: 'chatapp-7c72a.appspot.com',
    measurementId: 'G-JP7B3W9CGK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD735wehaUeY0fCidl-pevqsHZ0CUt1IHU',
    appId: '1:1058809854185:android:a1d96990cdabab37995878',
    messagingSenderId: '1058809854185',
    projectId: 'chatapp-7c72a',
    storageBucket: 'chatapp-7c72a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTi-X3GRa4MzsCjcxHBx27OVUvPJ2ZcL0',
    appId: '1:1058809854185:ios:eded13ea02be0aec995878',
    messagingSenderId: '1058809854185',
    projectId: 'chatapp-7c72a',
    storageBucket: 'chatapp-7c72a.appspot.com',
    iosBundleId: 'com.example.chatApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTi-X3GRa4MzsCjcxHBx27OVUvPJ2ZcL0',
    appId: '1:1058809854185:ios:7a3f357f29d4fbc2995878',
    messagingSenderId: '1058809854185',
    projectId: 'chatapp-7c72a',
    storageBucket: 'chatapp-7c72a.appspot.com',
    iosBundleId: 'com.example.chatApplication.RunnerTests',
  );
}
