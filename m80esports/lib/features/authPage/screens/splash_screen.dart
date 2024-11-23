import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/features/homePage/screens/cafeList_page.dart';
import 'package:m80_esports/features/authPage/screens/login_page.dart';
import 'package:m80_esports/features/homePage/screens/home_page.dart';
import 'package:m80_esports/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/globalVariables.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  String? selectedCafe;
  List cafe = [];
  getDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('currentUser');
    if (userJson != null) {
      Map<String, dynamic> _user = jsonDecode(userJson);
      setState(() {
        currentUser = UserModel.fromJson(_user);
        isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      });
    } else {
      return null;
    }
  }

  @override
  void initState() {
    getDate();
    Future.delayed(const Duration(seconds: 3)).then((value) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                isLoggedIn ? CafeList() : const LoginPage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return bgAnime(
        widget: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: const AssetImage(ImageConst.logo),
              height: h * 0.3,
            ),
            Lottie.asset(Gifs.loadingGif, height: w * 0.2)
          ],
        ),
      ),
    ));
  }
}
