// import 'dart:developer';

// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sportzlyticz_coach/application/landingpage.dart';
// import 'package:sportzlyticz_coach/appuser.dart';
// import 'package:sportzlyticz_coach/onboarding/otpverification.dart';
// import 'package:sportzlyticz_coach/themeconfig.dart';

// class AmplifyFunctions {
//   Future<String> signInCustomAuth(phoneNumber, context) async {
//     //log("ph: $phoneNumber");
//     try {
//       await Amplify.Auth.signOut();
//       //print("Signed out");
//       SignInResult result =
//           await Amplify.Auth.signIn(username: phoneNumber, password: "061628");
//       //log("result : ${result.isSignedIn}");
//       //log("result : ${result.nextStep?.signInStep}");
//       // if (result.nextStep?.signInStep ==
//       //         'CONFIRM_SIGN_IN_WITH_CUSTOM_CHALLENGE' ||
//       //     result.nextStep?.signInStep ==
//       //         AuthSignInStep.confirmSignInWithCustomChallenge) {
//       AppUser.userPhonenumber = phoneNumber;
//       Navigator.pop(context);
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => OTPVerificationScreen(phoneNumber),
//       ));
//       // }
//       return "";
//     } on AuthException catch (e) {
//       //print('Failed to sign in: ${e.message}');
//       if (e.message.trim() == "Sign in failed" ||
//           e.message.trim() == "NOT_AUTHORIZED : Kindly Signup") {
//         return "SIGNUP";
//       }
//       Get.snackbar("Error", "${e.message}", backgroundColor: Colors.red);
//       Navigator.pop(context);
//       return "";
//     } finally {
//       // setState(() {
//       //   _isLoading = false;
//       // });
//     }
//   }

//   verifyOtpAuth(otp, context) async {
//     try {
//       var res = await Amplify.Auth.confirmSignIn(confirmationValue: otp);
//       //log("AMplify result : ${res.isSignedIn}");
//       //log("AMplify result : ${res.nextStep?.signInStep}");
//       if (res.isSignedIn == true) {
//         var sharedPreference = await SharedPreferences.getInstance();
//         sharedPreference.setBool('isUserLoggedIn', true);
//         Navigator.pop(context);
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => LandingPage()),
//           (route) => false,
//         );
//       } else {
//         AppUser.userPhonenumber = "";
//         Get.snackbar(
//           "Login Failed",
//           "Please try again later",
//           isDismissible: true,
//           snackPosition: SnackPosition.BOTTOM,
//           snackStyle: SnackStyle.FLOATING,
//           backgroundColor: olympicRed,
//         );
//         Navigator.pop(context);
//         Navigator.pop(context);
//       }
//     } on AuthException catch (err) {
//       Get.snackbar("Login Failed", "${err.message}");
//       //log("Error", error: err);
//       Navigator.pop(context);
//       Navigator.pop(context);
//     } catch (err) {
//       Get.snackbar("Login Failed", "Invalid Otp");
//       //log("Error", error: err);
//       Navigator.pop(context);
//       Navigator.pop(context);
//     }
//   }
// }
