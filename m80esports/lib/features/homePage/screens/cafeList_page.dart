import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/features/authPage/screens/login_page.dart';
import 'package:m80_esports/features/homePage/screens/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/globalVariables.dart';

class CafeList extends ConsumerStatefulWidget {
  const CafeList({super.key});
  @override
  ConsumerState<CafeList> createState() => _CafeListState();
}

class _CafeListState extends ConsumerState<CafeList> {
  // GamingCenters? centers;

  List images = [
    'assets/images/GC 1.jpg',
    'assets/images/GC 2.jpg',
    'assets/images/GC 3.jpg'
  ];

  List centers = [];

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

  // listGamingCenter() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     var operation = Amplify.API.query(
  //         request: GraphQLRequest(
  //             document:
  //                 '''query listGamingCenter(\$input: ListGamingCenterInput) {
  //   listGamingCenter(input: \$input)
  // }''',
  //             variables: {
  //           'input': {
  //             'organisation_id': currentUser!.organisationId,
  //             'user_id': currentUser!.userId,
  //             // 'next_token': ''
  //           }
  //         }));

  //     var response = await operation.response;

  //     Map<String, dynamic> body = jsonDecode(response.data);
  //     print(body['listGamingCenter']);
  //     setState(() {
  //       centers = jsonDecode(body['listGamingCenter']);
  //       print("CENTERS ======= $centers");
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     toastMessage(context: context, label: 'Error : $e', isSuccess: false);
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> getCafe() async {
    var data = await FirebaseFirestore.instance
        .collection('Organisations')
        .doc('m80Esports')
        .collection('cafes')
        .get();
    for (int i = 0; i < data.docs.length; i++) {
      setState(() {
        centers.add(data.docs[i]);
      });
    }
  }

  @override
  void initState() {
    selectedCafe = '';
    deviceCategory.clear();
    getCafe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
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
                              Amplify.Auth.signOut();
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
                        itemCount: centers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              selectedCafe = centers[index]['label'];
                              if (deviceCategory.isEmpty) {
                                var data = await FirebaseFirestore.instance
                                    .collection('Organisations')
                                    .doc('m80Esports')
                                    .collection('cafes')
                                    .doc(selectedCafe)
                                    .collection('devices')
                                    .where('deleted', isEqualTo: false)
                                    .get();
                                for (var device in data.docs) {
                                  deviceCategory.add(device);
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BottomNavBar()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BottomNavBar()));
                              }
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
                                        color: centers[index]['status']
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
                                              centers[index]['label'],
                                              style: textStyle(true),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              centers[index]['address'],
                                              style: textStyle(false),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                            // Text(
                                            //   centers['Data']['Items'][index]
                                            //           ['manager_details'][0]
                                            //       ['contact_number'],
                                            //   style: textStyle(false),
                                            //   overflow: TextOverflow.ellipsis,
                                            //   maxLines: 1,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (centers[index]['discount'] != 0)
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
                                          '${centers[index]['discount']}% OFF',
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
          if (isLoading) loadingScreen()
        ],
      ),
    ));
  }
}
