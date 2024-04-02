import 'dart:io';
import 'package:businessapp/splashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global/global_var.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();


  Platform.isAndroid?
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD4n2_tOa260oCsVUuQrT3AhZa0IDWht3Q",
          appId: "1:664543025337:android:300f633224e4fda1f9e368",
          messagingSenderId: "664543025337",
          projectId: "thumela-version-2",
      ),
  )
  : await Firebase.initializeApp();

   sharedPreferences = await SharedPreferences.getInstance();

   //  await Permission.locationWhenInUse.isDenied.then((valueOfPermission)
   //  {
   //    if(valueOfPermission)
   //    {
   //     Permission.locationWhenInUse.request();
   //    }
   // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: const MySplashScreen(),
    );
  }
}
