import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/features/homePage/screens/cafeList_page.dart';
import 'package:m80_esports/models/user_model.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController phoneNumber_controller = TextEditingController();
  TextEditingController userName_controller = TextEditingController();
  TextEditingController otp_controller = TextEditingController();
  // TextEditingController email_controller = TextEditingController();

  bool otpPage = false;
  bool signUpPage = false;
  bool isLoading = false;
  var countryCode;
  String? selectedOrg;
  String session = '';
  String? gender;
  DateTime? pickedDate;

  /// 1st function
  Future<void> userlogin() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Amplify.Auth.signOut();
      SignInResult result = await Amplify.Auth.signIn(
        username: '$countryCode${phoneNumber_controller.text}',
      );
      //log("result : ${result.isSignedIn}");
      //log("result : ${result.nextStep?.signInStep}");
      // if (result.nextStep?.signInStep ==
      //         'CONFIRM_SIGN_IN_WITH_CUSTOM_CHALLENGE' ||
      //     result.nextStep?.signInStep ==
      //         AuthSignInStep.confirmSignInWithCustomChallenge) {
      // AppUser.userPhonenumber = phoneNumber;
      setState(() {
        otpPage = true;
        isLoading = false;
      });
    } on AuthException catch (e) {
      if (e.message.trim() == "Sign in failed" ||
          e.message.trim() == "Error: NOT_AUTHORIZED : Kindly Sigup") {
        setState(() {
          signUpPage = true;
          isLoading = false;
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await Amplify.Auth.confirmSignIn(
          confirmationValue: otp_controller.text);
      //log("AMplify result : ${res.isSignedIn}");
      //log("AMplify result : ${res.nextStep?.signInStep}");
      if (res.isSignedIn == true) {
        getCurrentUserDetails();
        setState(() {
          isLoading = false;
        });
      } else {
        toastMessage(
            context: context, label: 'Incorrect OTP', isSuccess: false);
        setState(() {
          isLoading = false;
        });
      }
    } catch (err) {
      print('Error during OTP verification: $err');
      toastMessage(
        context: context,
        label: err.toString(),
        isSuccess: false,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getCurrentUserDetails() async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document:
              '''query GetCurrentUserDetails(\$input: GetCurrentUserDetailsInput) {
          getCurrentUserDetails(input: \$input)
        }''',
          variables: {
            'input': {'contact_number': '${phoneNumber_controller.text}'}
          },
        ),
      );
      var userResponse = await operation.response;
      Map<String, dynamic> body = jsonDecode(userResponse.data);
      Map<String, dynamic> currentUserDetails =
          jsonDecode(body['getCurrentUserDetails']);
      if (currentUserDetails['Data']['Items'][0]['part_of_organisation'] ==
          true) {
        currentUser = UserModel.fromJson(currentUserDetails);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        final String userJson = jsonEncode(currentUser);
        await prefs.setString('currentUser', userJson);
        toastMessage(
            context: context,
            label: 'Logged in Successfully!',
            isSuccess: true);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CafeList()));
      } else {
        try {
          var orgOperations = Amplify.API.query(
            request: GraphQLRequest(
              document:
                  '''query ListOrganisations(\$input: ListOrganisationsInput) {
    listOrganisations(input: \$input)
  }''',
              variables: {
                "input": {
                  // next_token: ""
                }
              },
            ),
          );
          var orgResponse = await orgOperations.response;
          Map<String, dynamic> body = jsonDecode(orgResponse.data);
          Map<String, dynamic> listOrganisations =
              jsonDecode(body['listOrganisations']);
          List items = listOrganisations['Data']['Items'];
          print(
              "FROM TEXT ------ ${listOrganisations['Data']['Items'][0]['organisation_name']}");
          setState(() {
            isLoading = false;
          });
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                Map org = {};
                return StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return AlertDialog(
                      backgroundColor: ColorConst.backgroundColor,
                      title: Text(
                        'Select an Organisation',
                        style: textStyle(true),
                      ),
                      content: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: ColorConst.textColor),
                            borderRadius: BorderRadius.circular(w * 0.03)),
                        width: w * 0.7,
                        child: DropdownButton(
                          dropdownColor: ColorConst.backgroundColor,
                          padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                          hint: Text("Available Organisations",
                              style: textStyle(false)),
                          icon: Icon(
                            CupertinoIcons.chevron_down,
                            size: w * 0.04,
                          ),
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: textStyle(false),
                          value: selectedOrg,
                          items: List.generate(
                            items.length,
                            (index) {
                              return DropdownMenuItem(
                                value: items[index],
                                child: Text(items[index]['organisation_name']),
                              );
                            },
                          ),
                          onChanged: (newValue) {
                            org = newValue as Map<String, dynamic>;
                            print(
                                "ORG NAME FROM ONCHANGED ---- ${org['organisation_name']}");
                            print(items[0]['organisation_name'] ==
                                org['organisation_name']);
                            setState(() {
                              selectedOrg = org['organisation_name'].toString();
                            });
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () async {
                              if (selectedOrg == null) {
                                toastMessage(
                                    context: context,
                                    label: 'Please select a cafe!',
                                    isSuccess: false);
                              } else {
                                addUserToOrganisation(
                                    organisation_id: org['organisation_id']);
                              }
                            },
                            child: const Text('Ok')),
                      ],
                    );
                  },
                );
              });
        } catch (e) {}
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> userSignUp() async {
    setState(() {
      isLoading = true;
    });
    final url = '$api/UserSignUp';
    final body = jsonEncode({
      'contact_number': phoneNumber_controller.text,
      'user_name': userName_controller.text.trim(),
      'country_code': countryCode.toString().trim(),
      // "email_id": email_controller.text.trim(),
      "date_of_birth": pickedDate.toString(),
      "gender": gender
    });
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      print('SIGNUP RESPONSE STATUS = ${response.statusCode}');
      if (response.statusCode == 200) {
        SignInResult result = await Amplify.Auth.signIn(
          username: '$countryCode${phoneNumber_controller.text}',
        );
        setState(() {
          signUpPage = false;
          otpPage = true;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        toastMessage(
            context: context, label: "Something went wrong", isSuccess: false);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      toastMessage(
          context: context, label: 'Error during signup: $e', isSuccess: false);
    }
  }

  Future<void> addUserToOrganisation({required String organisation_id}) async {
    try {
      var operation = Amplify.API.mutate(
          request: GraphQLRequest(
              document:
                  '''mutation AddUserToOrganisation(\$input: addUserToOrganisationInput) {
    addUserToOrganisation(input: \$input)
  }''',
              variables: {
            'inputs': {
              'contact_number': phoneNumber_controller.text,
              'organisation_id': organisation_id
            }
          }));
      var response = await operation.response;
      var body = jsonDecode(response.data);
      getCurrentUserDetails();
    } catch (e) {
      return toastMessage(
          context: context, label: 'Error : $e', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneValidation = RegExp(r"[0-9]{10}");
    // final emailValidation = RegExp(r'^[\w-.]+@([\w-]+\.)+\w{2,4}');
    List genders = ['Male', 'Female', 'Trans-gender', 'Other'];
    return bgAnime(
        widget: Scaffold(
            body: Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(w * 0.03),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.1),
                  Center(
                      child: Image(
                          image: const AssetImage(ImageConst.logo),
                          height: h * 0.3)),
                  SizedBox(height: h * 0.03),
                  Text(
                      signUpPage
                          ? 'Create an account'
                          : otpPage
                              ? 'Enter the OTP'
                              : 'Login with Mobile number',
                      style: textStyle(false)),
                  SizedBox(height: h * 0.03),
                  TextFormField(
                    controller: phoneNumber_controller,
                    keyboardType: TextInputType.number,
                    readOnly: signUpPage || otpPage ? true : false,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    validator: (value) {
                      if (!phoneValidation.hasMatch(value!)) {
                        return 'Enter a valid Phone number';
                      } else {
                        return null;
                      }
                    },
                    maxLength: 10,
                    style: textStyle(false),
                    decoration: InputDecoration(
                      counterText: '',
                      prefixIcon: CountryCodePicker(
                        initialSelection: "+91",
                        onInit: (value) {
                          countryCode = value;
                        },
                        onChanged: (value) {
                          countryCode = value;
                          print(countryCode);
                        },
                        hideMainText: false,
                        showFlag: false,
                        barrierColor: Colors.black.withOpacity(0),
                        textStyle: textStyle(false),
                      ),
                      hintText: 'Enter your Mobile number *',
                      hintStyle: TextStyle(
                          color: ColorConst.textColor.withOpacity(0.5)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w * 0.03),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(w * 0.03),
                          borderSide:
                              const BorderSide(color: ColorConst.textColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(w * 0.03),
                          borderSide:
                              const BorderSide(color: ColorConst.textColor)),
                    ),
                  ),
                  SizedBox(height: signUpPage ? h * 0.01 : h * 0.03),

                  /// CHECK USER BUTTON
                  if (signUpPage == false && otpPage == false)
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (countryCode == null) {
                            toastMessage(
                                context: context,
                                label: 'Please select your country code!',
                                isSuccess: false);
                          } else if (phoneNumber_controller.text.isEmpty) {
                            toastMessage(
                                context: context,
                                label: 'Please enter your Mobile number!',
                                isSuccess: false);
                          } else {
                            userlogin();
                          }
                        }
                      },
                      child: Container(
                          width: w * 0.3,
                          height: h * 0.05,
                          decoration: BoxDecoration(
                              color: ColorConst.buttons,
                              borderRadius: BorderRadius.circular(w * 0.1)),
                          child: Center(
                              child:
                                  Text('Send OTP', style: textStyle(false)))),
                    ),
                  signUpPage
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: userName_controller,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.words,
                              style: textStyle(false),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your name';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your name *',
                                hintStyle: TextStyle(
                                    color:
                                        ColorConst.textColor.withOpacity(0.5)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(w * 0.03),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(w * 0.03),
                                    borderSide: const BorderSide(
                                        color: ColorConst.textColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(w * 0.03),
                                    borderSide: const BorderSide(
                                        color: ColorConst.textColor)),
                              ),
                            ),
                            SizedBox(height: h * 0.01),
                            // TextFormField(
                            //   controller: email_controller,
                            //   keyboardType: TextInputType.emailAddress,
                            //   style: textStyle(false),
                            //   autovalidateMode: AutovalidateMode.onUnfocus,
                            //   validator: (email) {
                            //     if (!emailValidation.hasMatch(email!)) {
                            //       return "Enter a valid Email";
                            //     } else {
                            //       return null;
                            //     }
                            //   },
                            //   decoration: InputDecoration(
                            //     hintText: 'Enter your Email *',
                            //     hintStyle: TextStyle(
                            //         color:
                            //             ColorConst.textColor.withOpacity(0.5)),
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(w * 0.03),
                            //     ),
                            //     enabledBorder: OutlineInputBorder(
                            //         borderRadius:
                            //             BorderRadius.circular(w * 0.03),
                            //         borderSide: const BorderSide(
                            //             color: ColorConst.textColor)),
                            //     focusedBorder: OutlineInputBorder(
                            //         borderRadius:
                            //             BorderRadius.circular(w * 0.03),
                            //         borderSide: const BorderSide(
                            //             color: ColorConst.textColor)),
                            //   ),
                            // ),
                            //SizedBox(height: h * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorConst.textColor),
                                      borderRadius:
                                          BorderRadius.circular(w * 0.03)),
                                  width: w * 0.45,
                                  height: h * 0.06,
                                  child: DropdownButton(
                                    dropdownColor: ColorConst.backgroundColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.03),
                                    hint: Text("Gender *",
                                        style: TextStyle(
                                            color: ColorConst.textColor
                                                .withOpacity(0.5))),
                                    icon: Icon(
                                      CupertinoIcons.chevron_down,
                                      size: w * 0.04,
                                    ),
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    style: textStyle(false),
                                    value: gender,
                                    items: List.generate(
                                      genders.length,
                                      (index) {
                                        return DropdownMenuItem(
                                          value: genders[index],
                                          child: Text(
                                            genders[index],
                                            style: textStyle(false),
                                          ),
                                        );
                                      },
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        gender = newValue.toString();
                                      });
                                    },
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var datePicked =
                                        await DatePicker.showSimpleDatePicker(
                                      context,
                                      initialDate: pickedDate,
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime.now(),
                                      dateFormat: "dd-MMMM-yyyy",
                                      locale: DateTimePickerLocale.en_us,
                                      itemTextStyle: textStyle(true),
                                      textColor: ColorConst.textColor,
                                      backgroundColor:
                                          ColorConst.backgroundColor,
                                    );
                                    setState(() {
                                      pickedDate = datePicked;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorConst.textColor),
                                        borderRadius:
                                            BorderRadius.circular(w * 0.03)),
                                    width: w * 0.45,
                                    height: h * 0.06,
                                    child: Center(
                                        child: Text(
                                      pickedDate != null
                                          ? DateFormat('dd-MMMM-yyyy')
                                              .format(pickedDate as DateTime)
                                          : 'Date of Birth *',
                                      style: TextStyle(
                                          color: pickedDate != null
                                              ? ColorConst.textColor
                                              : ColorConst.textColor
                                                  .withOpacity(0.5),
                                          fontSize: w * 0.03),
                                    )),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: h * 0.02),
                            otpPage
                                ? FractionallySizedBox(
                                    child: Pinput(
                                    controller: otp_controller,
                                    length: 4,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                  ))
                                : const SizedBox(),
                            SizedBox(height: h * 0.02),

                            /// SIGNUP BUTTON
                            otpPage
                                ? GestureDetector(
                                    onTap: () async {
                                      // if (otp_controller.text.isEmpty) {
                                      //   toastMessage(
                                      //       context: context,
                                      //       label: 'Enter the OTP',
                                      //       isSuccess: false);
                                      // } else {
                                      //   verifyOTP();
                                      // }
                                    },
                                    child: Container(
                                        width: w * 0.3,
                                        height: h * 0.05,
                                        decoration: BoxDecoration(
                                            color: ColorConst.buttons,
                                            borderRadius:
                                                BorderRadius.circular(w * 0.1)),
                                        child: Center(
                                            child: Text('Verify',
                                                style: textStyle(false)))),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        if (userName_controller.text.isEmpty) {
                                          toastMessage(
                                              context: context,
                                              label: 'Please enter your Name!',
                                              isSuccess: false);
                                        }
                                        // else if (email_controller
                                        //     .text.isEmpty) {
                                        //   toastMessage(
                                        //       context: context,
                                        //       label: 'Please enter your Email!',
                                        //       isSuccess: false);
                                        // }
                                        else if (gender == null) {
                                          toastMessage(
                                              context: context,
                                              label:
                                                  'Please select your Gender!',
                                              isSuccess: false);
                                        } else if (pickedDate == null) {
                                          toastMessage(
                                              context: context,
                                              label:
                                                  'Please select your D.O.B!',
                                              isSuccess: false);
                                        } else {
                                          userSignUp();
                                        }
                                      }
                                    },
                                    child: Container(
                                        width: w * 0.3,
                                        height: h * 0.05,
                                        decoration: BoxDecoration(
                                            color: ColorConst.buttons,
                                            borderRadius:
                                                BorderRadius.circular(w * 0.1)),
                                        child: Center(
                                            child: Text('SignUp',
                                                style: textStyle(false)))),
                                  )
                          ],
                        )
                      : otpPage
                          ? FractionallySizedBox(
                              child: Pinput(
                              controller: otp_controller,
                              length: 4,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            ))
                          : const SizedBox(),
                  SizedBox(height: h * 0.03),

                  /// LOGIN BUTTON
                  if (otpPage == true && signUpPage == false)
                    GestureDetector(
                      onTap: () async {
                        if (otp_controller.text.isEmpty) {
                          toastMessage(
                              context: context,
                              label: 'Enter the OTP',
                              isSuccess: false);
                        } else {
                          verifyOTP();
                        }
                      },
                      child: Container(
                          width: w * 0.3,
                          height: h * 0.05,
                          decoration: BoxDecoration(
                              color: ColorConst.buttons,
                              borderRadius: BorderRadius.circular(w * 0.1)),
                          child: Center(
                              child: Text('Verify', style: textStyle(false)))),
                    ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  if (otpPage == true || signUpPage == true)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          otpPage = false;
                          signUpPage = false;
                          userName_controller.clear();
                          otp_controller.clear();
                          // email_controller.clear();
                          gender = null;
                          pickedDate = null;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.back,
                            color: ColorConst.textColor,
                          ),
                          SizedBox(
                            width: w * 0.03,
                          ),
                          Text('Go back', style: textStyle(false))
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
        if (isLoading) loadingWidget()
      ],
    )));
  }
}
