import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/models/gamingCenter_model.dart';
import 'package:m80_esports/models/user_model.dart';
import 'package:motion_toast/motion_toast.dart';

String version = '1.0.0';
var w;
var h;
UserModel? currentUser;
Map<String, dynamic> centers = {};
GamingCenters? center;
AnimationController? animation_controller;
String selectedCafe = 'Vidhyaranyapura';
List cafe = [
  {
    'Vidhyaranyapura': [
      {
        'PC Gaming': [
          {'name': 'PC 1', 'price': 120, 'status': false},
          {'name': 'PC 2', 'price': 120, 'status': true},
          {'name': 'PC 3', 'price': 120, 'status': true},
          {'name': 'PC 4', 'price': 120, 'status': false},
          {'name': 'PC 5', 'price': 120, 'status': false},
          {'name': 'PC 6', 'price': 120, 'status': false},
          {'name': 'PC 7', 'price': 120, 'status': false},
          {'name': 'PC 8', 'price': 120, 'status': false},
          {'name': 'PC 9', 'price': 120, 'status': false},
          {'name': 'PC 10', 'price': 120, 'status': false},
        ]
      },
      {
        'PS5': [
          {'name': 'Projector', 'price': 200, 'status': false},
          {'name': 'TV', 'price': 180, 'status': false},
        ]
      },
      {
        'Racing Simulator': [
          {'name': 'Simulator 1', 'price': 180, 'status': false},
          {'name': 'Simulator 2', 'price': 180, 'status': false},
        ]
      },
    ]
  },
];

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
  if (isSuccess == true) {
    MotionToast.success(
            title: Text(
              'Success !',
            ),
            dismissable: true,
            toastDuration: Duration(seconds: 1),
            enableAnimation: true,
            position: MotionToastPosition.center,
            description: Text(label))
        .show(context);
  } else {
    MotionToast.error(
            title: Text(
              'Error !',
            ),
            enableAnimation: true,
            toastDuration: Duration(seconds: 3),
            position: MotionToastPosition.center,
            description: Text(label))
        .show(context);
  }
}

/// BACKGROUND ANIMATION
bgAnime({required Widget widget}) {
  return AnimateGradient(
      controller: animation_controller,
      duration: Duration(seconds: 3),
      primaryColors: [
        ColorConst.backgroundColor,
        ColorConst.errorAlert,
        Colors.green,
      ],
      secondaryColors: [
        ColorConst.buttons,
        ColorConst.successAlert,
        Colors.red,
      ],
      child: widget);
}

/// LOADING WIDGET
Widget loadingWidget() {
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

/// GAMING CAFE
List gamingCafe = [
  {
    'Vidhyaranyapura': [
      {
        'PC Gaming': [
          {'name': 'PC 1', 'price': 120, 'status': false},
          {'name': 'PC 2', 'price': 120, 'status': true},
          {'name': 'PC 3', 'price': 120, 'status': true},
          {'name': 'PC 4', 'price': 120, 'status': false},
          {'name': 'PC 5', 'price': 120, 'status': false},
          {'name': 'PC 6', 'price': 120, 'status': false},
          {'name': 'PC 7', 'price': 120, 'status': false},
          {'name': 'PC 8', 'price': 120, 'status': false},
          {'name': 'PC 9', 'price': 120, 'status': false},
          {'name': 'PC 10', 'price': 120, 'status': false},
        ]
      },
      {
        'PS5': [
          {'name': 'Projector', 'price': 200, 'status': false},
          {'name': 'TV', 'price': 180, 'status': false},
        ]
      },
      {
        'Racing Simulator': [
          {'name': 'Simulator 1', 'price': 180, 'status': false},
          {'name': 'Simulator 2', 'price': 180, 'status': false},
        ]
      },
    ]
  },
  {
    'Bel Road': [
      {
        'PC Gaming': [
          {'name': 'PC 1', 'price': 120, 'status': false},
          {'name': 'PC 2', 'price': 120, 'status': false},
          {'name': 'PC 3', 'price': 120, 'status': false},
          {'name': 'PC 4', 'price': 120, 'status': false},
          {'name': 'PC 5', 'price': 120, 'status': false},
          {'name': 'PC 6', 'price': 120, 'status': false},
          {'name': 'PC 7', 'price': 120, 'status': false},
          {'name': 'PC 8', 'price': 120, 'status': false},
          {'name': 'PC 9', 'price': 120, 'status': false},
          {'name': 'PC 10', 'price': 120, 'status': false},
          {'name': 'PC 11', 'price': 120, 'status': false},
          {'name': 'PC 12', 'price': 120, 'status': false},
        ]
      },
      {
        'PS5': [
          {'name': 'Projector', 'price': 200, 'status': false},
          {'name': 'TV 1', 'price': 180, 'status': false},
          {'name': 'TV 2', 'price': 180, 'status': false},
        ]
      },
      {
        'Racing Simulator': [
          {'name': 'Simulator 1', 'price': 180, 'status': false},
          {'name': 'Simulator 2', 'price': 180, 'status': false},
        ]
      },
      {
        'VR': [
          {'name': 'VR', 'price': 180, 'status': false},
        ]
      },
    ]
  }
];
