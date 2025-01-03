import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:m80_esports/core/amount_calculations.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/core/globalVariables.dart';
import 'package:m80_esports/features/homePage/controller/homePage_controller.dart';
import 'package:m80_esports/features/homePage/screens/invoiceView_page.dart';
import 'package:m80_esports/models/invoice_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: deviceCategory.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    return deviceCategory.isEmpty
        ? Center(child: Text("Loading...", style: textStyle(false)))
        : bgAnime(
            widget: Stack(
            children: [
              DefaultTabController(
                length: deviceCategory.length,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: ColorConst.backgroundColor,
                    leadingWidth: w,
                    leading: TabBar(
                        controller: _tabController,
                        dividerColor: ColorConst.buttons,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        overlayColor: const WidgetStatePropertyAll(
                            ColorConst.backgroundColor),
                        indicator: BoxDecoration(
                            color: ColorConst.secondaryColor,
                            border: Border.all(
                                color: ColorConst.textColor.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(w * 0.03)),
                        tabs: List.generate(deviceCategory.length, (index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 0.05, vertical: w * 0.01),
                            child: Text(deviceCategory[index]['deviceType'],
                                style: textStyle(true)),
                          );
                        })),
                    centerTitle: true,
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                            controller: _tabController,
                            children: List.generate(
                              deviceCategory.length,
                              (i) {
                                return ListDevices(
                                    deviceType: deviceCategory[i]
                                        ['deviceType']);
                              },
                            )),
                      )
                    ],
                  ),
                ),
              ),
              if (isLoading) loadingScreen()
            ],
          ));
  }
}

class ListDevices extends StatelessWidget {
  final String deviceType;
  const ListDevices({super.key, required this.deviceType});
  @override
  Widget build(BuildContext context) {
    Future<InvoiceModel> getInvoice({required String invoiceId}) async {
      var data = await FirebaseFirestore.instance
          .collection('Organisations')
          .doc('m80Esports')
          .collection('cafes')
          .doc(selectedCafe)
          .collection('invoice')
          .doc(invoiceId)
          .get();
      InvoiceModel invoiceModel =
          InvoiceModel.fromJson(data.data() as Map<String, dynamic>);
      return invoiceModel;
    }

    return Consumer(
      builder: (context, ref, child) {
        var data = ref.watch(deviceProvider(deviceType));
        return data.when(
          data: (devices) {
            return ListView.separated(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                var device = devices[index];
                String invoiceId =
                    '${device.deviceName}_Invoice${device.totalBills}';
                int playTime =
                    DateTime.now().difference(device.startTime).inMinutes;
                double playCost = calculateAmount(
                    playTime, device.deviceName.toString().toUpperCase());
                Future<List<Map<String, dynamic>>> fetchExtraItems() async {
                  final firestore = FirebaseFirestore.instance;
                  final List<Map<String, dynamic>> items = [];
                  try {
                    final querySnapshot = await firestore
                        .collection('Organisations')
                        .doc('m80Esports')
                        .collection('cafes')
                        .doc(selectedCafe)
                        .collection('foodItems')
                        .where('totalQuantity', isGreaterThan: 0)
                        .get();
                    for (var doc in querySnapshot.docs) {
                      items.add({
                        'name': doc['itemName'],
                        'quantity': 0,
                        'price': doc['price'],
                      });
                    }
                  } catch (e) {
                    print('Error fetching items: $e');
                  }
                  return items;
                }

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
                          color: device.status
                              ? ColorConst.successAlert.withOpacity(0.7)
                              : ColorConst.errorAlert.withOpacity(0.7),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(device.deviceName, style: textStyle(true)),
                          device.status
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: ColorConst
                                                      .backgroundColor,
                                                  title: Text('Start Now?',
                                                      style: textStyle(false)),
                                                  content: Text(
                                                      'Starting Time : ${DateFormat.jm().format(DateTime.now())}',
                                                      style: textStyle(true)),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text('Cancel')),
                                                    TextButton(
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Organisations')
                                                              .doc('m80Esports')
                                                              .collection(
                                                                  'cafes')
                                                              .doc(selectedCafe)
                                                              .collection(
                                                                  'devices')
                                                              .doc(deviceType)
                                                              .collection(
                                                                  deviceType)
                                                              .doc(device
                                                                  .deviceName)
                                                              .update({
                                                            'status': false,
                                                            'startTime':
                                                                DateTime.now()
                                                          });

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Organisations')
                                                              .doc('m80Esports')
                                                              .collection(
                                                                  'cafes')
                                                              .doc(selectedCafe)
                                                              .collection(
                                                                  'invoice')
                                                              .doc(invoiceId)
                                                              .set({
                                                            'deviceName': device
                                                                .deviceName,
                                                            'playTime': 0,
                                                            'extras': [],
                                                            'extraAmount': 0,
                                                            'capacityPrice': 0,
                                                            'startTime':
                                                                DateTime.now(),
                                                            'playCost': 0,
                                                            'id': invoiceId,
                                                            'remainingCapacity':
                                                                device.capacity >
                                                                        1
                                                                    ? 2
                                                                    : 0,
                                                            'paidbyCash': 0,
                                                            'paidbyBank': 0,
                                                            'paid': false,
                                                            'endTime': null,
                                                            'totalCapacity':
                                                                device.capacity
                                                          });
                                                          toastMessage(
                                                              context: context,
                                                              label:
                                                                  "${device.deviceName} started at ${DateFormat.jm().format(DateTime.now())}",
                                                              isSuccess: true);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Ok')),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: h * 0.035,
                                            width: w * 0.2,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.04),
                                                color: ColorConst.buttons),
                                            child: Center(
                                                child: Text('Start',
                                                    style: textStyle(false))),
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
                                                  ColorConst.backgroundColor,
                                              isScrollControlled: false,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                  height: h * 0.3,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
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
                                                  BorderRadius.circular(
                                                      w * 0.04),
                                              color: ColorConst.buttons,
                                            ),
                                            child: Center(
                                                child: Text('Book',
                                                    style: textStyle(false))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Expanded(
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          statItem('Start time : ',
                                              '${DateFormat.jm().format(device.startTime)}'),
                                          statItem(
                                              'Play time : ', '$playTime mins'),
                                          statItem('Play cost : ',
                                              '${playCost.toStringAsFixed(2)}/-'),
                                        ],
                                      ),
                                      SizedBox(
                                        width: w * 0.05,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              final items =
                                                  await fetchExtraItems();
                                              final invoiceSnapshot =
                                                  await getInvoice(
                                                      invoiceId: invoiceId);
                                              int? remainingCapacity =
                                                  invoiceSnapshot
                                                      .remainingCapacity;
                                              List existingExtras =
                                                  invoiceSnapshot.extras;
                                              for (var item in items) {
                                                final existingItem =
                                                    existingExtras.firstWhere(
                                                        (extra) =>
                                                            extra['name'] ==
                                                            item['name'],
                                                        orElse: () => null);
                                                item['quantity'] =
                                                    existingItem != null
                                                        ? existingItem[
                                                            'quantity']
                                                        : 0;
                                              }
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor: ColorConst
                                                        .backgroundColor,
                                                    title: Text(
                                                      'Add Extras',
                                                      style: textStyle(false),
                                                    ),
                                                    content: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          height: w * 0.2,
                                                          width: w * 0.2,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(w *
                                                                          0.03),
                                                              border: Border.all(
                                                                  color: ColorConst
                                                                      .textColor)),
                                                          child: Center(
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return _buildExtraItemsDialog(
                                                                            context,
                                                                            items,
                                                                            device.deviceName,
                                                                            invoiceId);
                                                                      },
                                                                    );
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  icon: Icon(
                                                                      Icons
                                                                          .emoji_food_beverage,
                                                                      color: ColorConst
                                                                          .textColor))),
                                                        ),
                                                        if (remainingCapacity >=
                                                            1)
                                                          Container(
                                                            height: w * 0.2,
                                                            width: w * 0.2,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(w *
                                                                            0.03),
                                                                border: Border.all(
                                                                    color: ColorConst
                                                                        .textColor)),
                                                            child: Column(
                                                              children: [
                                                                IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      if (remainingCapacity !=
                                                                          0) {
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('Organisations')
                                                                            .doc('m80Esports')
                                                                            .collection('cafes')
                                                                            .doc(selectedCafe)
                                                                            .collection('invoice')
                                                                            .doc(invoiceId)
                                                                            .update({
                                                                          'capacityPrice':
                                                                              FieldValue.increment(device.capacityPrice!),
                                                                          'remainingCapacity':
                                                                              FieldValue.increment(-1)
                                                                        });
                                                                        toastMessage(
                                                                            context:
                                                                                context,
                                                                            label:
                                                                                'Controller added',
                                                                            isSuccess:
                                                                                true);
                                                                        Navigator.pop(
                                                                            context);
                                                                      } else {
                                                                        toastMessage(
                                                                            context:
                                                                                context,
                                                                            label:
                                                                                'Maximum controllers selected',
                                                                            isSuccess:
                                                                                false);
                                                                      }
                                                                    },
                                                                    icon: Icon(
                                                                        Icons
                                                                            .gamepad_rounded,
                                                                        color: ColorConst
                                                                            .textColor)),
                                                                Text(
                                                                  '${remainingCapacity} Remaining Controllers',
                                                                  style: TextStyle(
                                                                      color: ColorConst
                                                                          .textColor,
                                                                      fontSize: w *
                                                                          0.02),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                      ],
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
                                                      BorderRadius.circular(
                                                          w * 0.04),
                                                  //color: ColorConst.buttons,
                                                  border: Border.all(
                                                      color: ColorConst
                                                          .successAlert)),
                                              child: Center(
                                                  child: Text('Add',
                                                      style: textStyle(false))),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor: ColorConst
                                                        .backgroundColor,
                                                    title: Text(
                                                      'End session',
                                                      style: textStyle(true),
                                                    ),
                                                    content: Text(
                                                      'Are you sure you want to end this session?',
                                                      style: textStyle(false),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child:
                                                              const Text('No')),
                                                      TextButton(
                                                          onPressed: () async {
                                                            int playTime = DateTime
                                                                    .now()
                                                                .difference(device
                                                                    .startTime)
                                                                .inMinutes;
                                                            double playCost =
                                                                calculateAmount(
                                                                    playTime,
                                                                    device
                                                                        .deviceName
                                                                        .toString()
                                                                        .toUpperCase());
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Organisations')
                                                                .doc(
                                                                    'm80Esports')
                                                                .collection(
                                                                    'cafes')
                                                                .doc(
                                                                    selectedCafe)
                                                                .collection(
                                                                    'devices')
                                                                .doc(deviceType)
                                                                .collection(
                                                                    deviceType)
                                                                .doc(device
                                                                    .deviceName)
                                                                .update({
                                                              'totalBills':
                                                                  FieldValue
                                                                      .increment(
                                                                          1),
                                                              'status': true,
                                                              'startTime':
                                                                  DateTime
                                                                      .now(),
                                                              'totalMinutesPlayed':
                                                                  FieldValue
                                                                      .increment(
                                                                          playTime),
                                                              'totalRevenue':
                                                                  FieldValue
                                                                      .increment(
                                                                          playCost)
                                                            });
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Organisations')
                                                                .doc(
                                                                    'm80Esports')
                                                                .collection(
                                                                    'cafes')
                                                                .doc(
                                                                    selectedCafe)
                                                                .collection(
                                                                    'invoice')
                                                                .doc(invoiceId
                                                                    .toString())
                                                                .update({
                                                              'playTime':
                                                                  playTime,
                                                              'playCost':
                                                                  playCost,
                                                              'endTime':
                                                                  DateTime.now()
                                                            });
                                                            var invoiceSnapshot =
                                                                await getInvoice(
                                                                    invoiceId:
                                                                        invoiceId);
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        InvoiceView(
                                                                            invoice:
                                                                                invoiceSnapshot)));
                                                          },
                                                          child:
                                                              const Text('Yes'))
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: h * 0.035,
                                              width: w * 0.2,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          w * 0.04),
                                                  // color: ColorConst.errorAlert,
                                                  border: Border.all(
                                                      color: ColorConst
                                                          .errorAlert)),
                                              child: Center(
                                                  child: Text('End',
                                                      style: textStyle(false))),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: h * 0.005),
            );
          },
          error: (error, stackTrace) => toastMessage(
              context: context, label: 'Error : $error', isSuccess: false),
          loading: () =>
              Center(child: Lottie.asset(Gifs.loadingGif, height: w * 0.2)),
        );
      },
    );
  }
}

Widget _buildExtraItemsDialog(
    BuildContext context, List items, String deviceName, String invoiceId) {
  return AlertDialog(
    backgroundColor: ColorConst.backgroundColor,
    title: Text('Select drinks', style: textStyle(true)),
    content: StatefulBuilder(
      builder: (BuildContext context, StateSetter setDialogState) {
        return SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    items[index]['name'],
                    style: textStyle(false),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (items[index]['quantity'] > 0) {
                            setDialogState(() {
                              items[index]['quantity']--;
                            });
                          }
                        },
                        icon: Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '${items[index]['quantity']}',
                        style: textStyle(false),
                      ),
                      IconButton(
                        onPressed: () {
                          setDialogState(() {
                            items[index]['quantity']++;
                          });
                        },
                        icon: Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () async {
          List selectedItems = [];
          for (var a in items) {
            if (a['quantity'] > 0) {
              selectedItems.add({
                'name': a['name'],
                'quantity': a['quantity'],
                'price': a['price'],
              });
            }
          }
          double extraAmount = 0;
          for (var item in selectedItems) {
            extraAmount = item['quantity'] * item['price'] + extraAmount;
          }
          await FirebaseFirestore.instance
              .collection('Organisations')
              .doc('m80Esports')
              .collection('cafes')
              .doc(selectedCafe)
              .collection('invoice')
              .doc(invoiceId)
              .update({
            'extras': selectedItems,
            'extraAmount': extraAmount,
          });
          for (var a in items) {
            FirebaseFirestore.instance
                .collection('Organisations')
                .doc('m80Esports')
                .collection('cafes')
                .doc(selectedCafe)
                .collection('foodItems')
                .doc(a['name'])
                .update(
                    {'totalQuantity': FieldValue.increment(-(a['quantity']))});
          }
          Navigator.pop(context, extraAmount);
        },
        child: Text('Confirm'),
      ),
    ],
  );
}
