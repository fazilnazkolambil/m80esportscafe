import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/models/user_model.dart';

String version = '1.0.0';
var w;
var h;
UserModel? currentUser;
String selectedCafe = '';
List deviceCategory = [];
double discount = 0;

final loadingProvider = StateProvider((ref) => false);

AnimationController? animation_controller;

/// TEXT STATS
Widget statItem(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: textStyle(false),
      ),
      Text(
        value,
        style: textStyle(true),
      ),
    ],
  );
}

/// API
final api = 'https://admnaj65zk.execute-api.ap-south-1.amazonaws.com/Prod';
final apiKey = 'gqaVtRdX5jfIa844tqf12F9deUr0v6maaR4vX3F7';
final headers = {
  'Content-Type': 'application/json',
  'x-api-key': apiKey,
};

/// TEXT STYLE
TextStyle textStyle(bool heading) {
  return TextStyle(
    color: ColorConst.textColor,
    fontSize: heading ? w * 0.04 : w * 0.03,
    fontWeight: heading ? FontWeight.w600 : null,
  );
}

/// TOAST MESSAGE
toastMessage({
  required BuildContext context,
  required String label,
  required bool isSuccess,
}) {
  // if (isSuccess == true) {
  //   MotionToast.success(
  //           title: Text(
  //             'Success !',
  //           ),
  //           dismissable: true,
  //           toastDuration: Duration(seconds: 1),
  //           enableAnimation: true,
  //           position: MotionToastPosition.center,
  //           description: Text(label))
  //       .show(context);
  // } else {
  //   MotionToast.error(
  //           title: Text(
  //             'Error !',
  //           ),
  //           enableAnimation: true,
  //           toastDuration: Duration(seconds: 3),
  //           position: MotionToastPosition.center,
  //           description: Text(label))
  //       .show(context);
  // }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      label,
      style: textStyle(false),
    ),
    backgroundColor:
        isSuccess ? ColorConst.successAlert : ColorConst.errorAlert,
    duration: Duration(seconds: 3),
    dismissDirection: DismissDirection.horizontal,
    behavior: SnackBarBehavior.floating,
  ));
}

/// BACKGROUND ANIMATION
bgAnime({required Widget widget}) {
  return AnimateGradient(
      controller: animation_controller,
      duration: Duration(seconds: 3),
      primaryColors: [
        ColorConst.backgroundColor,
        ColorConst.errorAlert,
        ColorConst.successAlert
      ],
      secondaryColors: [
        ColorConst.buttons,
        ColorConst.successAlert,
        ColorConst.errorAlert
      ],
      child: widget);
}

/// LOADING WIDGET
Widget loadingScreen() {
  return GestureDetector(
    onTap: () {},
    behavior: HitTestBehavior.opaque,
    child: Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Lottie.asset(Gifs.loadingGif, height: w * 0.2),
      ),
    ),
  );
}
