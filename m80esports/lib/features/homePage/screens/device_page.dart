import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/core/globalVariables.dart';
import 'package:m80_esports/features/homePage/controller/homePage_controller.dart';
import 'package:m80_esports/features/homePage/screens/edit_device.dart';
import 'package:m80_esports/models/devices_model.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});
  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  TextEditingController _category = TextEditingController();
  TextEditingController _discount = TextEditingController();
  TextEditingController _deviceName = TextEditingController();
  TextEditingController _devicePrice = TextEditingController();
  TextEditingController _capacityPrice = TextEditingController();
  int capacity = 1;

  String? selectedDeviceType;
  List deviceTypes = [];
  bool edit = false;
  Future<void> getDevices() async {
    var data = await FirebaseFirestore.instance
        .collection('Organisations')
        .doc('m80Esports')
        .collection('cafes')
        .doc(selectedCafe)
        .collection('devices')
        .where('deleted', isEqualTo: false)
        .get();
    for (var device in data.docs) {
      deviceTypes.add(device['deviceType']);
    }
    setState(() {});
  }

  @override
  void initState() {
    getDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Device Statistics',
          style: textStyle(true),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, color: ColorConst.textColor)),
        backgroundColor: ColorConst.backgroundColor.withOpacity(0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: h * 0.06,
                  width: w * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(w * 0.03),
                      border: Border.all(color: ColorConst.textColor)),
                  child: Center(
                    child: DropdownButton(
                      dropdownColor: ColorConst.backgroundColor,
                      padding: EdgeInsets.all(h * 0.01),
                      isExpanded: true,
                      underline: SizedBox(),
                      hint: Text(
                        "Select device type",
                        style: textStyle(false),
                      ),
                      style: TextStyle(color: ColorConst.textColor),
                      value: selectedDeviceType,
                      items: List.generate(
                              deviceTypes.length, (index) => deviceTypes[index])
                          .map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        selectedDeviceType = value.toString();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                                backgroundColor: ColorConst.backgroundColor,
                                title: Text(
                                  'Add a new type',
                                  style: textStyle(true),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _category,
                                        style: textStyle(true),
                                        decoration: InputDecoration(
                                          // label: Text('Device Type'),
                                          label: Text('Device type *'),
                                          labelStyle: textStyle(false),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(w * 0.03),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.03),
                                              borderSide: const BorderSide(
                                                  color: ColorConst.textColor)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.03),
                                              borderSide: const BorderSide(
                                                  color: ColorConst.textColor)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.02,
                                      ),
                                      TextFormField(
                                        controller: _discount,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        style: textStyle(true),
                                        decoration: InputDecoration(
                                          label: Text('Discount'),
                                          labelStyle: textStyle(false),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(w * 0.03),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.03),
                                              borderSide: const BorderSide(
                                                  color: ColorConst.textColor)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.03),
                                              borderSide: const BorderSide(
                                                  color: ColorConst.textColor)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.02,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (_category.text.isEmpty) {
                                            toastMessage(
                                                context: context,
                                                label: 'Enter Device type',
                                                isSuccess: false);
                                          } else {
                                            if (edit == true) {
                                              await FirebaseFirestore.instance
                                                  .collection('Organisations')
                                                  .doc('m80Esports')
                                                  .collection('cafes')
                                                  .doc(selectedCafe)
                                                  .collection('devices')
                                                  .doc(_category.text)
                                                  .update({
                                                'deviceType': _category.text
                                                    .trim()
                                                    .toUpperCase(),
                                                'discount':
                                                    _discount.text.isEmpty
                                                        ? 0
                                                        : double.parse(
                                                            _discount.text),
                                                'deleted': false
                                              });
                                              setState(() {
                                                edit = false;
                                              });
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .collection('Organisations')
                                                  .doc('m80Esports')
                                                  .collection('cafes')
                                                  .doc(selectedCafe)
                                                  .collection('devices')
                                                  .doc(_category.text
                                                      .trim()
                                                      .toUpperCase())
                                                  .set({
                                                'deviceType': _category.text
                                                    .trim()
                                                    .toUpperCase(),
                                                'discount':
                                                    _discount.text.isEmpty
                                                        ? 0
                                                        : double.parse(
                                                            _discount.text),
                                                'deleted': false
                                              });
                                            }

                                            _category.clear();
                                            _discount.clear();
                                          }
                                        },
                                        child: Container(
                                          height: h * 0.05,
                                          width: w * 0.2,
                                          decoration: BoxDecoration(
                                              color: ColorConst.buttons,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.03)),
                                          child: Center(
                                            child: Text(
                                              edit ? 'Update' : 'Add',
                                              style: textStyle(false),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('Organisations')
                                              .doc('m80Esports')
                                              .collection('cafes')
                                              .doc(selectedCafe)
                                              .collection('devices')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child: Lottie.asset(
                                                      Gifs.loadingGif,
                                                      width: w * 0.2,
                                                      height: h * 0.2));
                                            }

                                            var devices = snapshot.data!.docs;
                                            return SizedBox(
                                              height: h * 0.2,
                                              child:
                                                  !snapshot.hasData ||
                                                          snapshot.data!.docs
                                                              .isEmpty
                                                      ? Center(
                                                          child: Text(
                                                          'No devices available.',
                                                          style:
                                                              textStyle(false),
                                                        ))
                                                      : ListView.builder(
                                                          itemCount:
                                                              devices.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              title: Row(
                                                                children: [
                                                                  Text(
                                                                    devices[index]
                                                                        [
                                                                        'deviceType'],
                                                                    style: textStyle(
                                                                        false),
                                                                  ),
                                                                  SizedBox(
                                                                    width: w *
                                                                        0.03,
                                                                  ),
                                                                  if (devices[
                                                                          index]
                                                                      [
                                                                      'deleted'])
                                                                    Text(
                                                                      '(deleted)',
                                                                      style: TextStyle(
                                                                          color: ColorConst
                                                                              .errorAlert,
                                                                          fontSize:
                                                                              w * 0.03),
                                                                    ),
                                                                ],
                                                              ),
                                                              subtitle: Text(
                                                                'Discount : ${devices[index]['discount']}%',
                                                                style:
                                                                    textStyle(
                                                                        false),
                                                              ),
                                                              trailing:
                                                                  PopupMenuButton(
                                                                      color: ColorConst
                                                                          .backgroundColor,
                                                                      itemBuilder:
                                                                          (context) {
                                                                        return [
                                                                          if (!devices[index]
                                                                              [
                                                                              'deleted'])
                                                                            PopupMenuItem(
                                                                                onTap: () {
                                                                                  _category.text = devices[index]['deviceType'];
                                                                                  _discount.text = devices[index]['discount'].toString();
                                                                                  edit = true;
                                                                                  setState(() {});
                                                                                },
                                                                                textStyle: textStyle(false),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.edit_rounded,
                                                                                      color: ColorConst.successAlert,
                                                                                    ),
                                                                                    Text(
                                                                                      'Edit',
                                                                                      style: textStyle(false),
                                                                                    )
                                                                                  ],
                                                                                )),
                                                                          PopupMenuItem(
                                                                              onTap: () {
                                                                                showDialog(
                                                                                  context: context,
                                                                                  barrierDismissible: false,
                                                                                  builder: (context) {
                                                                                    return AlertDialog(
                                                                                      backgroundColor: ColorConst.backgroundColor,
                                                                                      title: Text(
                                                                                        devices[index]['deleted'] ? 'Are you sure you want to restore this type?' : 'Are you sure you want to delete this type?',
                                                                                        style: textStyle(true),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      actions: [
                                                                                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
                                                                                        TextButton(
                                                                                            onPressed: () async {
                                                                                              devices[index].reference.update({
                                                                                                'deleted': devices[index]['deleted'] ? false : true
                                                                                              });
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: const Text('Yes'))
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              textStyle: textStyle(false),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  devices[index]['deleted']
                                                                                      ? Icon(Icons.restore, color: ColorConst.successAlert)
                                                                                      : Icon(
                                                                                          Icons.delete_rounded,
                                                                                          color: ColorConst.errorAlert,
                                                                                        ),
                                                                                  Text(
                                                                                    devices[index]['deleted'] ? 'restore' : 'Delete',
                                                                                    style: textStyle(false),
                                                                                  )
                                                                                ],
                                                                              )),
                                                                        ];
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .more_vert_sharp,
                                                                          color:
                                                                              ColorConst.textColor)),
                                                            );
                                                          },
                                                        ),
                                            );
                                          })
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        _category.clear();
                                        _discount.clear();
                                        setState(() {
                                          edit = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Back'))
                                ],
                              ));
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: ColorConst.textColor,
                      size: w * 0.1,
                    ))
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [Text('data')],
            // ),
            SizedBox(
              height: h * 0.02,
            ),
            SizedBox(
              height: h * 0.7,
              child: Consumer(
                builder: (context, ref, child) {
                  var data = ref
                      .watch(allDevicesProvider(selectedDeviceType.toString()));
                  return data.when(
                    data: (device) {
                      return selectedDeviceType == null
                          ? Center(
                              child: Text(
                              'Select any device type',
                              style: textStyle(false),
                            ))
                          : device.isEmpty
                              ? Center(
                                  child: Text(
                                  'No devices found',
                                  style: textStyle(false),
                                ))
                              : ListView.separated(
                                  itemCount: device.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditDevice(
                                                    device: device[index],
                                                    deviceType:
                                                        selectedDeviceType
                                                            .toString(),
                                                  ))),
                                      child: Container(
                                        padding: EdgeInsets.all(w * 0.03),
                                        margin: EdgeInsets.all(w * 0.03),
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(w * 0.05),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    device[index].isAvailable &&
                                                            device[index]
                                                                    .deleted! ==
                                                                false
                                                        ? ColorConst.textColor
                                                        : ColorConst.errorAlert,
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                              )
                                            ]),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text(
                                                device[index].deviceName,
                                                style: textStyle(true),
                                              ),
                                            ),
                                            Divider(thickness: 1),
                                            SizedBox(height: 10),
                                            statItem("Total Minutes Played",
                                                "${(device[index].totalMinutesPlayed).toStringAsFixed(2)} minutes"),
                                            SizedBox(height: 10),
                                            statItem(
                                                "Total Bills",
                                                device[index]
                                                    .totalBills
                                                    .toString()),
                                            SizedBox(height: 10),
                                            statItem("Total Revenue",
                                                "${device[index].totalRevenue.toStringAsFixed(2)} /-"),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: h * 0.02,
                                  ),
                                );
                    },
                    error: (error, stackTrace) => toastMessage(
                        context: context,
                        label: 'Error : $error',
                        isSuccess: false),
                    loading: () => Center(
                        child: Lottie.asset(Gifs.loadingGif, height: w * 0.2)),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          if (selectedDeviceType == null) {
            toastMessage(
                context: context,
                label: 'Select a device type',
                isSuccess: false);
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                    backgroundColor: ColorConst.backgroundColor,
                    title: Text('Add device', style: textStyle(true)),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _deviceName,
                            style: textStyle(true),
                            decoration: InputDecoration(
                              labelStyle: textStyle(false),
                              label: Text('Device Name *'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(w * 0.03),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(w * 0.03),
                                  borderSide: const BorderSide(
                                      color: ColorConst.textColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(w * 0.03),
                                  borderSide: const BorderSide(
                                      color: ColorConst.textColor)),
                            ),
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          TextFormField(
                            controller: _devicePrice,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: textStyle(true),
                            decoration: InputDecoration(
                              label: Text('Price *'),
                              labelStyle: textStyle(false),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(w * 0.03),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(w * 0.03),
                                  borderSide: const BorderSide(
                                      color: ColorConst.textColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(w * 0.03),
                                  borderSide: const BorderSide(
                                      color: ColorConst.textColor)),
                            ),
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text('Capacity', style: textStyle(false)),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              capacity <= 1 ? 1 : capacity--;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.remove,
                                            size: w * 0.03,
                                            color: ColorConst.textColor,
                                          )),
                                      Text(capacity.toString(),
                                          style: textStyle(false)),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              capacity >= 10 ? 10 : capacity++;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            size: w * 0.03,
                                            color: ColorConst.textColor,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              if (capacity > 1)
                                SizedBox(
                                  width: w * 0.3,
                                  child: TextFormField(
                                    controller: _capacityPrice,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    style: textStyle(true),
                                    decoration: InputDecoration(
                                      label: Text('Capacity Price *'),
                                      labelStyle: textStyle(false),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(w * 0.03),
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
                                ),
                            ],
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          InkWell(
                            onTap: () async {
                              if (_deviceName.text.isEmpty) {
                                toastMessage(
                                    context: context,
                                    label: 'Enter device name',
                                    isSuccess: false);
                              } else if (_devicePrice.text.isEmpty) {
                                toastMessage(
                                    context: context,
                                    label: 'Enter device price',
                                    isSuccess: false);
                              } else if (capacity > 1 &&
                                  _capacityPrice.text.isEmpty) {
                                toastMessage(
                                    context: context,
                                    label: 'Enter capacity price',
                                    isSuccess: false);
                              } else {
                                QuerySnapshot data = await FirebaseFirestore
                                    .instance
                                    .collection('Organisations')
                                    .doc('m80Esports')
                                    .collection('cafes')
                                    .doc(selectedCafe)
                                    .collection('devices')
                                    .doc(selectedDeviceType)
                                    .collection(selectedDeviceType.toString())
                                    .get();
                                List deviceNames = [];
                                for (DocumentSnapshot a in data.docs) {
                                  deviceNames.add(a['deviceName']);
                                }
                                if (deviceNames.contains(
                                    _deviceName.text.trim().toUpperCase())) {
                                  toastMessage(
                                      context: context,
                                      label: 'Device name already exists',
                                      isSuccess: false);
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('Organisations')
                                      .doc('m80Esports')
                                      .collection('cafes')
                                      .doc(selectedCafe)
                                      .collection('devices')
                                      .doc(selectedDeviceType)
                                      .collection(selectedDeviceType.toString())
                                      .doc(
                                          _deviceName.text.trim().toUpperCase())
                                      .set(DeviceModel(
                                              capacity: capacity,
                                              deviceName: _deviceName.text
                                                  .trim()
                                                  .toUpperCase(),
                                              price: double.parse(
                                                  _devicePrice.text),
                                              startTime: DateTime.now(),
                                              status: true,
                                              totalBills: 0,
                                              totalMinutesPlayed: 0,
                                              totalRevenue: 0,
                                              capacityPrice:
                                                  _capacityPrice.text.isEmpty
                                                      ? 0
                                                      : double.parse(
                                                          _capacityPrice.text),
                                              deleted: false,
                                              isAvailable: true)
                                          .toJson());
                                  _deviceName.clear();
                                  _devicePrice.clear();
                                  _capacityPrice.clear();
                                  setState(() {
                                    capacity = 1;
                                  });
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: Container(
                              height: h * 0.05,
                              width: w * 0.2,
                              decoration: BoxDecoration(
                                  color: ColorConst.buttons,
                                  borderRadius:
                                      BorderRadius.circular(w * 0.03)),
                              child: Center(
                                child: Text(
                                  'Add',
                                  style: textStyle(false),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            _deviceName.clear();
                            _devicePrice.clear();
                            _capacityPrice.clear();
                            setState(() {
                              capacity = 1;
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Back'))
                    ],
                  ),
                );
              },
            );
          }
        },
        child: Container(
          height: h * 0.06,
          width: w * 0.35,
          decoration: BoxDecoration(
              color: ColorConst.buttons,
              borderRadius: BorderRadius.circular(w * 0.03)),
          child: Center(
            child: Text(
              'Add Device',
              style: textStyle(false),
            ),
          ),
        ),
      ),
    );
  }
}
