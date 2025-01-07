import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/features/homePage/screens/bevarages.dart';
import 'package:m80_esports/features/homePage/screens/device_page.dart';
import 'package:m80_esports/features/homePage/screens/home_page.dart';
import 'package:m80_esports/features/homePage/screens/income_page.dart';
import 'package:m80_esports/features/homePage/screens/invoice_list.dart';
import 'package:m80_esports/features/homePage/screens/price_list.dart';
import 'package:m80_esports/features/homePage/screens/qr_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expandable/expandable.dart';
import '../../../core/globalVariables.dart';
import '../../authPage/screens/login_page.dart';

final ScrollController scrollController = ScrollController();

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BottomNavBar> {
  final _pageController = PageController(initialPage: 1);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 1);

  int maxCount = 3;

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [QrPage(), HomePage(), PriceList()];
    return Scaffold(
      drawer:
          //currentUser!.userRole == 'INTERNAL'?
          Drawer(
        backgroundColor: ColorConst.backgroundColor,
        width: w * 0.7,
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: h * 0.03, horizontal: w * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: ColorConst.backgroundColor,
                  backgroundImage: const AssetImage(ImageConst.logo),
                  radius: w * 0.07,
                ),
                title: Text(currentUser!.userName, style: textStyle(true)),
                subtitle: Text(
                  currentUser!.userRole,
                  style: textStyle(false),
                ),
              ),
              // TextButton(
              //     onPressed: () => Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => InvoiceListPage())),
              //     child: Text('Recent bills', style: textStyle(true))),
              TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => IncomePage())),
                  child: Text('Income', style: textStyle(true))),
              TextButton(
                  onPressed: () {},
                  child: Text('Users', style: textStyle(true))),
              TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DevicePage())),
                  child: Text('Devices', style: textStyle(true))),
              TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BevaragesPage())),
                  child: Text('Beverages', style: textStyle(true))),
              const SizedBox(),
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
                                  prefs.remove('selectedCafe');
                                  prefs.remove('cafe');
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                },
                                child: const Text('Yes'))
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.logout_outlined,
                          color: ColorConst.textColor),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Sign out', style: textStyle(false)),
                    ],
                  )),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('M80 Esports', style: textStyle(true)),
                    Text('App version : $version', style: textStyle(false))
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      /// Drawer for the externals
      // Drawer(
      //     backgroundColor: ColorConst.backgroundColor,
      //     width: w * 0.7,
      //     child: Padding(
      //       padding: EdgeInsets.symmetric(
      //           vertical: h * 0.03, horizontal: w * 0.03),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           ListTile(
      //             leading: CircleAvatar(
      //               backgroundColor: ColorConst.backgroundColor,
      //               backgroundImage: const AssetImage(ImageConst.logo),
      //               radius: w * 0.07,
      //             ),
      //             title:
      //                 Text(currentUser!.userName, style: textStyle(true)),
      //             subtitle: Text(
      //               currentUser!.organisationName,
      //               style: textStyle(false),
      //             ),
      //           ),
      //           ExpandablePanel(
      //               theme: const ExpandableThemeData(
      //                   useInkWell: false,
      //                   iconColor: ColorConst.textColor,
      //                   iconSize: 20),
      //               header: Container(
      //                 height: 30,
      //                 width: double.infinity,
      //                 child: Text(
      //                   'Cafes near you',
      //                   style: textStyle(true),
      //                 ),
      //               ),
      //               collapsed: const SizedBox(),
      //               expanded: Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: [
      //                     ListTile(
      //                       leading: Icon(Icons.arrow_right),
      //                       title:
      //                           Text('Bel road', style: textStyle(false)),
      //                       trailing: Icon(Icons.info_outline),
      //                     ),
      //                     ListTile(
      //                       leading: Icon(Icons.arrow_right),
      //                       title: Text('Vidhyaranyapura',
      //                           style: textStyle(false)),
      //                       trailing: Icon(Icons.info_outline),
      //                     ),
      //                   ],
      //                 ),
      //               )),
      //           ExpandablePanel(
      //               theme: const ExpandableThemeData(
      //                   useInkWell: false,
      //                   iconColor: ColorConst.textColor,
      //                   iconSize: 20),
      //               header: Container(
      //                 height: 30,
      //                 width: double.infinity,
      //                 child: Text(
      //                   'Your Bookings',
      //                   style: textStyle(true),
      //                 ),
      //               ),
      //               collapsed: const SizedBox(),
      //               expanded: Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: [
      //                     ListTile(
      //                       title: Text('Monday', style: textStyle(false)),
      //                       trailing:
      //                           Text('10:30 AM', style: textStyle(false)),
      //                     ),
      //                     ListTile(
      //                       title:
      //                           Text('Wednesday', style: textStyle(false)),
      //                       trailing:
      //                           Text('05:00 PM', style: textStyle(false)),
      //                     ),
      //                   ],
      //                 ),
      //               )),
      //           ExpandablePanel(
      //               theme: const ExpandableThemeData(
      //                   useInkWell: false,
      //                   iconColor: ColorConst.textColor,
      //                   iconSize: 20),
      //               header: Container(
      //                 height: 30,
      //                 width: double.infinity,
      //                 child: Text(
      //                   'Playing Time',
      //                   style: textStyle(true),
      //                 ),
      //               ),
      //               collapsed: const SizedBox(),
      //               expanded: Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: [
      //                     ListTile(
      //                       title: Text('Tuesday', style: textStyle(false)),
      //                       trailing:
      //                           Text('2:30 hrs', style: textStyle(false)),
      //                     ),
      //                     ListTile(
      //                       title: Text('Sunday', style: textStyle(false)),
      //                       trailing:
      //                           Text('1:30 hrs', style: textStyle(false)),
      //                     ),
      //                   ],
      //                 ),
      //               )),
      //           const SizedBox(),
      //           GestureDetector(
      //               onTap: () {
      //                 showDialog(
      //                   context: context,
      //                   barrierDismissible: false,
      //                   builder: (context) {
      //                     return AlertDialog(
      //                       backgroundColor: ColorConst.backgroundColor,
      //                       title: Text(
      //                         'Logout',
      //                         style: textStyle(true),
      //                       ),
      //                       content: Text(
      //                         'Are you sure you want to logout?',
      //                         style: textStyle(false),
      //                       ),
      //                       actions: [
      //                         TextButton(
      //                             onPressed: () => Navigator.pop(context),
      //                             child: const Text('No')),
      //                         TextButton(
      //                             onPressed: () async {
      //                               Amplify.Auth.signOut();
      //                               SharedPreferences prefs =
      //                                   await SharedPreferences
      //                                       .getInstance();
      //                               prefs.setBool('isLoggedIn', false);
      //                               prefs.remove('selectedCafe');
      //                               prefs.remove('cafe');
      //                               Navigator.pushAndRemoveUntil(
      //                                   context,
      //                                   MaterialPageRoute(
      //                                       builder: (context) =>
      //                                           const LoginPage()),
      //                                   (route) => false);
      //                             },
      //                             child: const Text('Yes'))
      //                       ],
      //                     );
      //                   },
      //                 );
      //               },
      //               child: Row(
      //                 children: [
      //                   const Icon(Icons.logout_outlined,
      //                       color: ColorConst.textColor),
      //                   const SizedBox(
      //                     width: 10,
      //                   ),
      //                   Text('Sign out', style: textStyle(false)),
      //                 ],
      //               )),
      //           Center(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Text('M80 Esports', style: textStyle(true)),
      //                 Text('App version : $version',
      //                     style: textStyle(false))
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),

      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            leading: Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu, color: ColorConst.textColor));
            }),
            floating: true,
            backgroundColor: ColorConst.backgroundColor,
            surfaceTintColor: Colors.green,
            centerTitle: true,
            // expandedHeight: h * 0.05,
            flexibleSpace: FlexibleSpaceBar(
              background: Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(selectedCafe, style: textStyle(true)),
              )),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: ColorConst.textColor,
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: ColorConst.textColor,
                    )
                  ],
                ),
              )
            ],
          ),
          SliverFillRemaining(
              child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
                bottomBarPages.length, (index) => bottomBarPages[index]),
          ))
        ],
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: ColorConst.backgroundColor.withOpacity(0.8),
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,
              notchColor: ColorConst.buttons.withOpacity(0.7),
              removeMargins: false,
              bottomBarWidth: w * 0.5,
              showShadow: true,
              durationInMilliSeconds: 300,
              itemLabelStyle: textStyle(false),
              elevation: 1,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.qr_code_2_outlined,
                    color: ColorConst.textColor,
                  ),
                  activeItem: Icon(
                    Icons.qr_code_2_outlined,
                    color: ColorConst.textColor,
                  ),
                  itemLabel: 'QR Code',
                ),
                BottomBarItem(
                  inActiveItem:
                      Icon(CupertinoIcons.home, color: ColorConst.textColor),
                  activeItem:
                      Icon(CupertinoIcons.home, color: ColorConst.textColor),
                  itemLabel: 'Home',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.list_alt,
                    color: ColorConst.textColor,
                  ),
                  activeItem: Icon(
                    Icons.list_alt,
                    color: ColorConst.textColor,
                  ),
                  itemLabel: 'Price List',
                ),
              ],
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}
