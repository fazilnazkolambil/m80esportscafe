import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/core/globalVariables.dart';
import 'package:m80_esports/features/homePage/controller/homePage_controller.dart';
import 'package:m80_esports/models/beverages_model.dart';

class BevaragesPage extends StatefulWidget {
  const BevaragesPage({super.key});
  @override
  State<BevaragesPage> createState() => _BevaragesPageState();
}

class _BevaragesPageState extends State<BevaragesPage> {
  TextEditingController _itemName = TextEditingController();
  TextEditingController _itemPrice = TextEditingController();
  TextEditingController _itemQuantity = TextEditingController();

  Widget bevarageFields(bool isEdit, String docName) {
    return AlertDialog(
      backgroundColor: ColorConst.backgroundColor,
      title: Text(isEdit ? 'Update' : 'Add', style: textStyle(true)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _itemName,
              style: textStyle(true),
              decoration: InputDecoration(
                labelStyle: textStyle(false),
                label: Text('Item Name *'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(w * 0.03),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: const BorderSide(color: ColorConst.textColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: const BorderSide(color: ColorConst.textColor)),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            TextFormField(
              controller: _itemPrice,
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
                    borderSide: const BorderSide(color: ColorConst.textColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: const BorderSide(color: ColorConst.textColor)),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            TextFormField(
              controller: _itemQuantity,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: textStyle(true),
              decoration: InputDecoration(
                label: Text('Item Quantity *'),
                labelStyle: textStyle(false),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(w * 0.03),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: const BorderSide(color: ColorConst.textColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    borderSide: const BorderSide(color: ColorConst.textColor)),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            InkWell(
              onTap: () async {
                if (_itemName.text.isEmpty) {
                  toastMessage(
                      context: context,
                      label: 'Enter item name',
                      isSuccess: false);
                } else if (_itemPrice.text.isEmpty) {
                  toastMessage(
                      context: context,
                      label: 'Enter item price',
                      isSuccess: false);
                } else if (_itemQuantity.text.isEmpty) {
                  toastMessage(
                      context: context,
                      label: 'Enter the initial quantity',
                      isSuccess: false);
                } else {
                  QuerySnapshot data = await FirebaseFirestore.instance
                      .collection('Organisations')
                      .doc('m80Esports')
                      .collection('cafes')
                      .doc(selectedCafe)
                      .collection('beverages')
                      .get();
                  List addedItems = [];
                  for (DocumentSnapshot a in data.docs) {
                    addedItems.add(a['itemName']);
                  }
                  if (addedItems
                      .contains(_itemName.text.trim().toUpperCase())) {
                    toastMessage(
                        context: context,
                        label: 'Device name already exists',
                        isSuccess: false);
                  } else {
                    await FirebaseFirestore.instance
                        .collection('Organisations')
                        .doc('m80Esports')
                        .collection('cafes')
                        .doc(selectedCafe)
                        .collection('beverages')
                        .doc(_itemName.text)
                        .set(BeveragesModel(
                                itemName: _itemName.text.trim(),
                                price: double.parse(_itemPrice.text),
                                totalQuantity: int.parse(_itemQuantity.text),
                                sold: 0,
                                deleted: false,
                                lastAdded: DateTime.now())
                            .toJson());
                    if (isEdit && docName != _itemName.text) {
                      await FirebaseFirestore.instance
                          .collection('Organisations')
                          .doc('m80Esports')
                          .collection('cafes')
                          .doc(selectedCafe)
                          .collection('beverages')
                          .doc(docName)
                          .delete();
                    }
                    _itemName.clear();
                    _itemPrice.clear();
                    _itemQuantity.clear();
                    Navigator.pop(context);
                  }
                }
              },
              child: Container(
                height: h * 0.05,
                width: w * 0.2,
                decoration: BoxDecoration(
                    color: ColorConst.buttons,
                    borderRadius: BorderRadius.circular(w * 0.03)),
                child: Center(
                  child: Text(
                    isEdit ? 'Update' : 'Add',
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
              _itemName.clear();
              _itemPrice.clear();
              _itemQuantity.clear();
              Navigator.pop(context);
            },
            child: Text('Back'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beverages',
          style: textStyle(true),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, color: ColorConst.textColor)),
        backgroundColor: ColorConst.backgroundColor.withOpacity(0),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Consumer(
            builder: (context, ref, child) {
              var data = ref.watch(getAllBeverages);
              return data.when(
                data: (beverages) {
                  return beverages.isEmpty
                      ? Center(
                          child: Text(
                          'No added beverages',
                          style: textStyle(false),
                        ))
                      : Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Text('${index + 1} -',
                                      style: textStyle(true)),
                                  title: Text(beverages[index].itemName,
                                      style: TextStyle(
                                          color: beverages[index].deleted
                                              ? ColorConst.errorAlert
                                              : ColorConst.textColor,
                                          fontWeight: FontWeight.w600)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      statItem(
                                          'Price',
                                          beverages[index]
                                              .price
                                              .toStringAsFixed(2)),
                                      statItem('Sold',
                                          beverages[index].sold.toString()),
                                      statItem(
                                          'Quantity left',
                                          beverages[index]
                                              .totalQuantity
                                              .toString()),
                                    ],
                                  ),
                                  trailing: PopupMenuButton(
                                      color: ColorConst.backgroundColor,
                                      itemBuilder: (context) {
                                        return [
                                          if (!beverages[index].deleted)
                                            PopupMenuItem(
                                                onTap: () {
                                                  _itemName.text =
                                                      beverages[index].itemName;
                                                  _itemPrice.text =
                                                      beverages[index]
                                                          .price
                                                          .toString();
                                                  _itemQuantity.text =
                                                      beverages[index]
                                                          .totalQuantity
                                                          .toString();
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          bevarageFields(
                                                              true,
                                                              beverages[index]
                                                                  .itemName));
                                                },
                                                textStyle: textStyle(false),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(
                                                      Icons.edit_rounded,
                                                      color: ColorConst
                                                          .successAlert,
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
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor: ColorConst
                                                        .backgroundColor,
                                                    content: Text(
                                                      beverages[index].deleted
                                                          ? 'Are you sure you want to recover this beverage?'
                                                          : 'Are you sure you want to delete this beverage?',
                                                      style: textStyle(true),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text('No')),
                                                      TextButton(
                                                          onPressed: () {
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
                                                                    'beverages')
                                                                .doc(beverages[
                                                                        index]
                                                                    .itemName)
                                                                .update({
                                                              'deleted': beverages[
                                                                          index]
                                                                      .deleted
                                                                  ? false
                                                                  : true
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('Yes')),
                                                    ],
                                                  ),
                                                );
                                              },
                                              textStyle: textStyle(false),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  beverages[index].deleted
                                                      ? Icon(Icons.restore,
                                                          color: ColorConst
                                                              .successAlert)
                                                      : Icon(
                                                          Icons.delete_rounded,
                                                          color: ColorConst
                                                              .errorAlert,
                                                        ),
                                                  Text(
                                                    beverages[index].deleted
                                                        ? 'restore'
                                                        : 'Delete',
                                                    style: textStyle(false),
                                                  )
                                                ],
                                              )),
                                        ];
                                      },
                                      icon: Icon(Icons.more_vert_sharp,
                                          color: ColorConst.textColor)),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  Divider(color: ColorConst.textColor),
                              itemCount: beverages.length),
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => bevarageFields(false, ''));
        },
        child: Container(
          height: h * 0.06,
          width: w * 0.35,
          decoration: BoxDecoration(
              color: ColorConst.buttons,
              borderRadius: BorderRadius.circular(w * 0.03)),
          child: Center(
            child: Text(
              'Add Beverages',
              style: textStyle(false),
            ),
          ),
        ),
      ),
    );
  }
}
