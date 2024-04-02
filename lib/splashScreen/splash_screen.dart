import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../authentication/auth_screen.dart';
import '../mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>
{
  iniTimer()
  {
    Timer(const Duration(seconds: 3), () async
    {

      if(FirebaseAuth.instance.currentUser == null)
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
      }
      else
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
      }

    });
  }

  @override
  void initState() {
    super.initState();

    iniTimer();

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                  "images/splash.png"
              ),
            ),
            const Text("Business App",
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 3,
                fontSize: 26,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
