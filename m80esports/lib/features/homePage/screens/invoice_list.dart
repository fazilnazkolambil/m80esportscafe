import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/core/globalVariables.dart';
import 'package:m80_esports/features/homePage/controller/homePage_controller.dart';
import 'package:m80_esports/features/homePage/screens/invoiceView_page.dart';
import 'package:m80_esports/models/invoice_model.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});
  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Recent bills',
            style: textStyle(true),
          ),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon:
                  Icon(Icons.arrow_back_ios_new, color: ColorConst.textColor)),
          backgroundColor: ColorConst.backgroundColor.withOpacity(0),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        selectedDate = selectedDate.add(Duration(days: -1));
                      });
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded)),
                Text(
                  DateFormat.MMMEd().format(selectedDate),
                  style: textStyle(false),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        selectedDate = selectedDate.add(Duration(days: 1));
                      });
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded)),
              ],
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                var invoices = ref.watch(invoiceProvider(selectedDate));
                return invoices.when(
                  data: (data) {
                    return data.isEmpty
                        ? Center(
                            child: Text(
                            'No bills yet',
                            style: textStyle(false),
                          ))
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InvoiceView(invoice: data[index]),
                                      ));
                                },
                                child: Container(
                                  height: h * 0.1,
                                  width: w,
                                  margin: EdgeInsets.all(w * 0.05),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.circular(w * 0.05),
                                    boxShadow: [
                                      BoxShadow(
                                        color: data[index].paid
                                            ? ColorConst.successAlert
                                                .withOpacity(0.7)
                                            : ColorConst.errorAlert
                                                .withOpacity(0.7),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: Text('${index + 1}',
                                        style: textStyle(false)),
                                    title: Text(
                                      data[index].deviceName,
                                      style: textStyle(true),
                                    ),
                                    subtitle: Text(
                                        "${(data[index].playCost + data[index].extraAmount + data[index].capacityPrice).toStringAsFixed(2)}",
                                        style: textStyle(false)),
                                    trailing: Text(
                                      data[index].paid ? "Paid" : "Not paid",
                                      style: TextStyle(
                                          color: data[index].paid
                                              ? ColorConst.successAlert
                                              : ColorConst.errorAlert),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                  error: (error, stackTrace) {
                    return toastMessage(
                        context: context,
                        label: 'Error : $error',
                        isSuccess: false);
                  },
                  loading: () => Center(
                      child: Lottie.asset(Gifs.loadingGif, height: w * 0.2)),
                );
              }),
            ),
          ],
        ));
  }
}
