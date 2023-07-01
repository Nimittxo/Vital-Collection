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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDr7p83rTiC-jjnZXMJI8wkqC5X9vk5aok',
    appId: '1:176584428229:android:09f33e75c4b01d57c47eac',
    messagingSenderId: '176584428229',
    projectId: 'health-tracker-aa3ae',
    databaseURL: 'https://health-tracker-aa3ae-default-rtdb.firebaseio.com',
    storageBucket: 'health-tracker-aa3ae.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCceC0xok3iahKwYquW2p66s9lLDodFkDI',
    appId: '1:176584428229:ios:de9cc6fbb035f3d3c47eac',
    messagingSenderId: '176584428229',
    projectId: 'health-tracker-aa3ae',
    databaseURL: 'https://health-tracker-aa3ae-default-rtdb.firebaseio.com',
    storageBucket: 'health-tracker-aa3ae.appspot.com',
    androidClientId: '176584428229-v76oknbrf13g38clqckjc90jv6ge2rmj.apps.googleusercontent.com',
    iosClientId: '176584428229-bvdsrtvn0143cb3re67fsn8aeqqb4p7c.apps.googleusercontent.com',
    iosBundleId: 'com.example.healthTracker',
  );
}
