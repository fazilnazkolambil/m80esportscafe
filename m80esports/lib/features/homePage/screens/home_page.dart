import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/core/globalVariables.dart';

import 'bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return bgAnime(
        widget: DefaultTabController(
      length: cafe[0][selectedCafe].length,
      child: Scaffold(
          body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: ColorConst.backgroundColor,
            leadingWidth: w,
            leading: TabBar(
                dividerColor: ColorConst.buttons,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                //indicatorPadding: const EdgeInsets.all(-10),
                overlayColor:
                    const WidgetStatePropertyAll(ColorConst.backgroundColor),
                indicator: BoxDecoration(
                    color: ColorConst.secondaryColor,
                    border: Border.all(
                        color: ColorConst.textColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(w * 0.03)),
                tabs: List.generate(cafe[0][selectedCafe].length, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.05, vertical: w * 0.01),
                    child: Text(cafe[0][selectedCafe][index].keys.first,
                        style: textStyle(true)),
                  );
                })),
            centerTitle: true,
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                      children: List.generate(
                    cafe[0][selectedCafe].length,
                    (i) {
                      List setups = cafe[0][selectedCafe][i]
                          [cafe[0][selectedCafe][i].keys.first];
                      return ListView.separated(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              height: h * 0.2,
                              width: w,
                              padding: EdgeInsets.all(w * 0.03),
                              margin: EdgeInsets.all(w * 0.03),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(w * 0.05),
                                  boxShadow: [
                                    BoxShadow(
                                      color: setups[index]['status']
                                          ? ColorConst.errorAlert
                                              .withOpacity(0.7)
                                          : ColorConst.successAlert
                                              .withOpacity(0.7),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image(
                                      image: const AssetImage(ImageConst.logo),
                                      width: w * 0.3),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(setups[index]['name'],
                                          style: textStyle(true)),
                                      setups[index]['status']
                                          ? Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Start time : ${DateFormat.jm().format(DateTime.now())}',
                                                      style: textStyle(false)),
                                                  Text(
                                                    'Play time : 1:30 hrs',
                                                    style: textStyle(false),
                                                  ),
                                                  Text('Total Amount : 150/-',
                                                      style: textStyle(false)),
                                                  Container(
                                                    height: h * 0.035,
                                                    width: w * 0.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    w * 0.04),
                                                        color:
                                                            ColorConst.buttons),
                                                    child: Center(
                                                        child: Text('End',
                                                            style: textStyle(
                                                                false))),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: h * 0.035,
                                                    width: w * 0.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    w * 0.04),
                                                        color:
                                                            ColorConst.buttons),
                                                    child: Center(
                                                        child: Text('Start',
                                                            style: textStyle(
                                                                false))),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: w * 0.04,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet<void>(
                                                      context: context,
                                                      backgroundColor:
                                                          ColorConst
                                                              .backgroundColor,
                                                      isScrollControlled: false,
                                                      builder: (BuildContext
                                                          context) {
                                                        return SizedBox(
                                                          height: h * 0.3,
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <Widget>[
                                                                Text(
                                                                    'Bookings will be available soon!',
                                                                    style: textStyle(
                                                                        true)),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    height: h * 0.035,
                                                    width: w * 0.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    w * 0.04),
                                                        color:
                                                            ColorConst.buttons),
                                                    child: Center(
                                                        child: Text('Book',
                                                            style: textStyle(
                                                                false))),
                                                  ),
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: h * 0.02),
                          itemCount: setups.length);
                    },
                  )),
                )
              ],
            ),
          )
        ],
      )),
    ));
  }
}
