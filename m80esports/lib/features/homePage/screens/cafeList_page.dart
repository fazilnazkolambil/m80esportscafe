import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/features/authPage/screens/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:m80_esports/features/homePage/screens/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/globalVariables.dart';

class CafeList extends StatefulWidget {
  const CafeList({super.key});
  @override
  State<CafeList> createState() => _CafeListState();
}

class _CafeListState extends State<CafeList> {
  // GamingCenters? centers;
  Map<String, dynamic> centers = {};
  List images = [
    'assets/images/GC 1.jpg',
    'assets/images/GC 2.jpg',
    'assets/images/GC 3.jpg'
  ];

  // Future<void> listGamingCenter() async {
  //   final url = '$api/listGamingCenter';
  //   if (currentUser['Data']['Items'].isEmpty) {
  //     print('currentUser or its data is null');
  //     toastMessage(
  //         context: context,
  //         label: 'User information is missing!',
  //         isSuccess: false);
  //     return;
  //   }
  //   final body = jsonEncode({
  //     "organisation_id": currentUser['Data']['Items'][0]['organisation_id'],
  //     "user_id": currentUser['Data']['Items'][0]['user_id'],
  //   });
  //   try {
  //     final response =
  //         await http.post(Uri.parse(url), headers: headers, body: body);
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         centers = jsonDecode(response.body);
  //       });
  //     } else {
  //       toastMessage(
  //           context: context, label: 'Something went wrong!', isSuccess: false);
  //     }
  //   } catch (error) {
  //     print('Error during API call: $error');
  //     toastMessage(
  //         context: context,
  //         label: 'Failed to fetch gaming centers!',
  //         isSuccess: false);
  //   }
  // }

  // Future<void> listGamingCenter() async {
  //   const String query = """
  // query ListGamingCenters(\$organisationId: String!, \$userId: String!) {
  //   listGamingCenters(organisationId: \$organisationId, userId: \$userId) {
  //     items {
  //       centerName
  //       centerAddress
  //       centerStatus
  //       centerZipCode
  //       managerDetails {
  //         userId
  //         userName
  //         contactNumber
  //       }
  //     }
  //   }
  // }
  // """;
  //   if (currentUser['Data']['Items'].isEmpty) {
  //     print('currentUser or its data is null');
  //     toastMessage(
  //         context: context,
  //         label: 'User information is missing!',
  //         isSuccess: false);
  //     return;
  //   }

  //   final variables = {
  //     "organisationId": currentUser['Data']['Items'][0]['organisation_id'],
  //     "userId": currentUser['Data']['Items'][0]['user_id'],
  //   };

  //   try {
  //     print(GraphQLProvider.of(context).value);
  //     final client = GraphQLProvider.of(context).value;
  //     final QueryResult result = await client.query(
  //       QueryOptions(
  //         document: gql(query),
  //         variables: variables,
  //       ),
  //     );
  //     if (result.hasException) {
  //       print('Result has Exception');
  //       print('GraphQL Error: ${result.exception.toString()}');
  //       toastMessage(
  //           context: context,
  //           label: 'Failed to fetch gaming centers!',
  //           isSuccess: false);
  //     } else {
  //       print('Result has no Exception');
  //       setState(() {
  //         centers = result.data!['listGamingCenters']['items'];
  //       });
  //     }
  //   } catch (error) {
  //     print('Error during GraphQL call: $error');
  //     toastMessage(
  //         context: context,
  //         label: 'Failed to fetch gaming centers!',
  //         isSuccess: false);
  //   }
  // }
  bool isLoading = false;
  listGamingCenter() async {
    setState(() {
      isLoading = true;
    });
    try {
      var operation = Amplify.API.query(
          request: GraphQLRequest(
              document:
                  '''query listGamingCenter(\$input: ListGamingCenterInput) {
    listGamingCenter(input: \$input)
  }''',
              variables: {
            'input': {
              'organisation_id': currentUser!.data.items[0].organisationId,
              'user_id': currentUser!.data.items[0].userId,
              // 'next_token': ''
            }
          }));

      var response = await operation.response;
      var body = jsonDecode(response.data);
      print(body);
      setState(() {
        centers = jsonDecode(body['listGamingCenter']);
        isLoading = false;
      });
    } catch (e) {
      toastMessage(context: context, label: 'Error : $e', isSuccess: false);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    print('CURRENTUSER -- ${currentUser!.data.items[0].userRole}');
    listGamingCenter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return bgAnime(
        widget: Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.backgroundColor,
        leading: SizedBox(),
        title: Text('Select Cafe', style: textStyle(true)),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: ColorConst.backgroundColor,
                      title: Text(
                        'Logout',
                        style: textStyle(true),
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: textStyle(false),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('No')),
                        TextButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('isLoggedIn', false);
                              await prefs.remove('currentUser');
                              prefs.remove('selectedCafe');
                              prefs.remove('cafe');
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            child: const Text('Yes'))
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                child: const Icon(Icons.logout_outlined,
                    color: ColorConst.textColor),
              )),
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider.builder(
                  itemCount: 3,
                  itemBuilder: (context, index, realIndex) {
                    return Image(image: AssetImage(images[index]));
                  },
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: true,
                      enableInfiniteScroll: true)),
              Expanded(
                child: centers.isEmpty
                    ? Center(
                        child: Text(
                        'Loading...',
                        style: textStyle(false),
                      ))
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: centers['Data']['Items'].length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              // SharedPreferences prefs =
                              //     await SharedPreferences.getInstance();
                              // prefs.setBool('isLoggedIn', false);
                              // prefs.remove('selectedCafe');
                              // prefs.remove('cafe');
                              // cafe.clear();
                              // setState(() {
                              //   selectedCafe = gamingCafe[index].keys.first;
                              //   cafe.add(gamingCafe[index]);
                              // });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottomNavBar()));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: h * 0.15,
                                  width: w,
                                  margin: EdgeInsets.all(w * 0.05),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.circular(w * 0.05),
                                    boxShadow: [
                                      BoxShadow(
                                        color: centers['Data']['Items'][index]
                                                    ['center_status'] ==
                                                'ACTIVE'
                                            ? ColorConst.successAlert
                                                .withOpacity(0.7)
                                            : ColorConst.errorAlert
                                                .withOpacity(0.7),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image(image: AssetImage(ImageConst.logo)),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              centers['Data']['Items'][index]
                                                  ['center_name'],
                                              style: textStyle(true),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              centers['Data']['Items'][index]
                                                  ['center_address'],
                                              style: textStyle(false),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              centers['Data']['Items'][index]
                                                      ['manager_details'][0]
                                                  ['contact_number'],
                                              style: textStyle(false),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (centers['Data']['Items'][index]
                                        ['discount'] !=
                                    null)
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: w * 0.05,
                                          vertical: h * 0.01),
                                      decoration: BoxDecoration(
                                        color: ColorConst.errorAlert,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(w * 0.05),
                                          bottomLeft: Radius.circular(w * 0.05),
                                        ),
                                      ),
                                      child: Text(
                                          '${centers['Data']['Items'][index]['discount']}% OFF',
                                          style: textStyle(false)),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
          if (isLoading) loadingWidget()
        ],
      ),
    ));
  }
}
