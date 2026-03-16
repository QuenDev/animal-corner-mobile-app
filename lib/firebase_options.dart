
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAZSKEdw0n52mHffa32cx3igFUW3A1O0XI',
    appId: '1:179423395003:web:f0421078594e6f7e963d9e',
    messagingSenderId: '179423395003',
    projectId: 'pet-application-final',
    authDomain: 'pet-application-final.firebaseapp.com',
    storageBucket: 'pet-application-final.appspot.com',
    measurementId: 'G-LHNTXM9PJ7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTUY09bt4keo_Uc6H3c6A_1i7t7qI-Dvg',
    appId: '1:179423395003:android:e50e4a563512306d963d9e',
    messagingSenderId: '179423395003',
    projectId: 'pet-application-final',
    storageBucket: 'pet-application-final.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBafcZpmtVKIT5ryZDkqm7uSNROmDDueQ4',
    appId: '1:179423395003:ios:65b5e542cafe5ddf963d9e',
    messagingSenderId: '179423395003',
    projectId: 'pet-application-final',
    storageBucket: 'pet-application-final.appspot.com',
    iosClientId: '179423395003-707ge269muk4lpji8k98fqk7quqe560t.apps.googleusercontent.com',
    iosBundleId: 'com.example.adminPanel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBafcZpmtVKIT5ryZDkqm7uSNROmDDueQ4',
    appId: '1:179423395003:ios:65b5e542cafe5ddf963d9e',
    messagingSenderId: '179423395003',
    projectId: 'pet-application-final',
    storageBucket: 'pet-application-final.appspot.com',
    iosClientId: '179423395003-707ge269muk4lpji8k98fqk7quqe560t.apps.googleusercontent.com',
    iosBundleId: 'com.example.adminPanel',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAZSKEdw0n52mHffa32cx3igFUW3A1O0XI',
    appId: '1:179423395003:web:10123e229771e625963d9e',
    messagingSenderId: '179423395003',
    projectId: 'pet-application-final',
    authDomain: 'pet-application-final.firebaseapp.com',
    storageBucket: 'pet-application-final.appspot.com',
    measurementId: 'G-047LV0FF23',
  );
}
