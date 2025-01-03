import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/core/globalVariables.dart';
import 'package:m80_esports/models/devices_model.dart';

class EditDevice extends StatefulWidget {
  final DeviceModel device;
  final String deviceType;
  const EditDevice({super.key, required this.device, required this.deviceType});
  @override
  State<EditDevice> createState() => _EditDeviceState();
}

class _EditDeviceState extends State<EditDevice> {
  TextEditingController _deviceName = TextEditingController();
  TextEditingController _devicePrice = TextEditingController();
  TextEditingController _capacityPrice = TextEditingController();
  int capacity = 0;
  bool isAvailable = false;
  bool isDeleted = false;
  @override
  void initState() {
    _deviceName.text = widget.device.deviceName;
    _devicePrice.text = widget.device.price.toString();
    capacity = widget.device.capacity;
    _capacityPrice.text = widget.device.capacityPrice.toString();
    isAvailable = widget.device.isAvailable;
    isDeleted = widget.device.deleted!;
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
      body: Padding(
        padding: EdgeInsets.all(w * 0.03),
        child: SingleChildScrollView(
          child: SizedBox(
            height: h * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Status : ', style: textStyle(false)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAvailable = !isAvailable;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: w * 0.02),
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 0.03, vertical: w * 0.03),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isAvailable
                                        ? ColorConst.successAlert
                                        : ColorConst.errorAlert),
                                borderRadius: BorderRadius.circular(w * 0.03)),
                            child: Center(
                              child: Text(
                                isAvailable ? 'Available' : 'Not available',
                                style: textStyle(false),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isDeleted = !isDeleted;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: w * 0.02),
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 0.03, vertical: w * 0.03),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isDeleted
                                        ? ColorConst.errorAlert
                                        : ColorConst.successAlert),
                                borderRadius: BorderRadius.circular(w * 0.03)),
                            child: Center(
                              child: Text(
                                isDeleted ? 'Deleted' : 'Not deleted',
                                style: textStyle(false),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Device Name : ', style: textStyle(false)),
                    SizedBox(
                      width: w * 0.5,
                      child: TextField(
                        controller: _deviceName,
                        style: textStyle(true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorConst.textColor))),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Device price : ', style: textStyle(false)),
                    SizedBox(
                      width: w * 0.5,
                      child: TextField(
                        controller: _devicePrice,
                        style: textStyle(true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorConst.textColor))),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Device capacity : ', style: textStyle(false)),
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
                              size: w * 0.05,
                              color: ColorConst.textColor,
                            )),
                        Text(capacity.toString(), style: textStyle(true)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                capacity >= 10 ? 10 : capacity++;
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              size: w * 0.05,
                              color: ColorConst.textColor,
                            ))
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Capacity price : ', style: textStyle(false)),
                    SizedBox(
                      width: w * 0.5,
                      child: TextField(
                        controller: _capacityPrice,
                        readOnly: capacity > 1 ? false : true,
                        style: textStyle(true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorConst.textColor))),
                      ),
                    )
                  ],
                ),
                statItem('Toatal Minutes played :',
                    "${widget.device.totalMinutesPlayed.toStringAsFixed(2)} min"),
                statItem('Toatal Revenue :',
                    "${widget.device.totalRevenue.toStringAsFixed(2)} /-"),
                statItem('Total Bills :', "${widget.device.totalBills}"),
                widget.device.deviceName != _deviceName.text ||
                        widget.device.price.toString() != _devicePrice.text ||
                        widget.device.capacity != capacity ||
                        widget.device.isAvailable != isAvailable ||
                        widget.device.deleted != isDeleted
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: ColorConst.backgroundColor,
                              content: Text(
                                  'Are you sure you want to save the changes?',
                                  style: textStyle(false)),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('No')),
                                TextButton(
                                    onPressed: () async {
                                      if (_deviceName.text.isEmpty ||
                                          _devicePrice.text.isEmpty ||
                                          _capacityPrice.text.isEmpty) {
                                        toastMessage(
                                            context: context,
                                            label:
                                                'Required fields cannot be empty!',
                                            isSuccess: false);
                                        Navigator.pop(context);
                                      } else {
                                        if (widget.device.deviceName ==
                                            _deviceName.text
                                                .trim()
                                                .toUpperCase()) {
                                          await FirebaseFirestore.instance
                                              .collection('Organisations')
                                              .doc('m80Esports')
                                              .collection('cafes')
                                              .doc(selectedCafe)
                                              .collection('devices')
                                              .doc(widget.deviceType)
                                              .collection(widget.deviceType)
                                              .doc(widget.device.deviceName)
                                              .update(widget.device
                                                  .copyWith(
                                                      price: double.parse(
                                                          _devicePrice.text),
                                                      capacity: capacity,
                                                      capacityPrice:
                                                          _capacityPrice
                                                                  .text.isEmpty
                                                              ? 0
                                                              : double.parse(
                                                                  _capacityPrice
                                                                      .text),
                                                      isAvailable: isAvailable,
                                                      deleted: isDeleted)
                                                  .toJson());
                                          toastMessage(
                                              context: context,
                                              label:
                                                  'New changes updated successfully',
                                              isSuccess: true);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          QuerySnapshot devices =
                                              await FirebaseFirestore.instance
                                                  .collection('Organisations')
                                                  .doc('m80Esports')
                                                  .collection('cafes')
                                                  .doc(selectedCafe)
                                                  .collection('devices')
                                                  .doc(widget.deviceType)
                                                  .collection(widget.deviceType)
                                                  .where('deleted',
                                                      isEqualTo: false)
                                                  .get();
                                          List deviceNames = [];
                                          for (DocumentSnapshot a
                                              in devices.docs) {
                                            deviceNames.add(a['deviceName']);
                                          }
                                          if (deviceNames.contains(_deviceName
                                              .text
                                              .trim()
                                              .toUpperCase())) {
                                            toastMessage(
                                                context: context,
                                                label:
                                                    'Device name already exist',
                                                isSuccess: false);
                                            Navigator.pop(context);
                                          } else {
                                            await FirebaseFirestore.instance
                                                .collection('Organisations')
                                                .doc('m80Esports')
                                                .collection('cafes')
                                                .doc(selectedCafe)
                                                .collection('devices')
                                                .doc(widget.deviceType)
                                                .collection(widget.deviceType)
                                                .doc(_deviceName.text
                                                    .trim()
                                                    .toUpperCase())
                                                .set(widget.device
                                                    .copyWith(
                                                        deviceName: _deviceName
                                                            .text
                                                            .toUpperCase(),
                                                        price: double.parse(
                                                            _devicePrice.text),
                                                        capacity: capacity,
                                                        capacityPrice:
                                                            _capacityPrice.text
                                                                    .isEmpty
                                                                ? 0
                                                                : double.parse(
                                                                    _capacityPrice
                                                                        .text),
                                                        isAvailable:
                                                            isAvailable,
                                                        deleted: isDeleted)
                                                    .toJson());
                                            await FirebaseFirestore.instance
                                                .collection('Organisations')
                                                .doc('m80Esports')
                                                .collection('cafes')
                                                .doc(selectedCafe)
                                                .collection('devices')
                                                .doc(widget.deviceType)
                                                .collection(widget.deviceType)
                                                .doc(widget.device.deviceName)
                                                .delete();
                                            toastMessage(
                                                context: context,
                                                label:
                                                    'Changes saved successfully',
                                                isSuccess: true);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        }
                                      }
                                    },
                                    child: Text('Yes')),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          height: h * 0.05,
                          width: w * 0.5,
                          decoration: BoxDecoration(
                              color: ColorConst.buttons,
                              borderRadius: BorderRadius.circular(w * 0.03)),
                          child: Center(
                            child: Text(
                              'Save Changes',
                              style: textStyle(false),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: h * 0.05)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
