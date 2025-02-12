import 'package:businessapp/authentication/signin_screen.dart';
import 'package:businessapp/authentication/signup_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context)
  {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Thumela",
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.lock, color: Colors.white,),
                  text: "Sign in",
                ),
                Tab(
                  icon: Icon(Icons.person , color: Colors.white,),
                  text: "Sign up",
                )
              ],
              indicatorColor: Colors.white38,
              indicatorWeight: 5,
            ),
          ),
          body: Container(
            color: Colors.black87,
            child: const TabBarView(
              children: [
                SignInScreen(),
                SignUpScreen(),
              ],
            ),
          ),
        )
    );
  }
}
