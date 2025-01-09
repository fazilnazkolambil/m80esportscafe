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

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});
  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Income',
            style: textStyle(true),
          ),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon:
                  Icon(Icons.arrow_back_ios_new, color: ColorConst.textColor)),
          backgroundColor: ColorConst.backgroundColor.withOpacity(0),
        ),
        body: Padding(
          padding: EdgeInsets.all(w * 0.03),
          child: Consumer(builder: (context, ref, child) {
            var invoices = ref.watch(invoiceProvider(selectedDate));
            return invoices.when(
              data: (data) {
                double totalAmount = 0;
                double byBank = 0;
                double byCash = 0;
                for (var a in data) {
                  totalAmount = a.capacityPrice +
                      a.extraAmount +
                      a.playCost +
                      totalAmount -
                      a.discount;
                  byBank = a.paidbyBank + byBank;
                  byCash = a.paidbyCash + byCash;
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                selectedDate =
                                    selectedDate.add(Duration(days: -1));
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
                                selectedDate =
                                    selectedDate.add(Duration(days: 1));
                              });
                            },
                            icon: Icon(Icons.arrow_forward_ios_rounded)),
                      ],
                    ),
                    Container(
                      height: h * 0.2,
                      width: w,
                      padding: EdgeInsets.symmetric(horizontal: w * 0.25),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(w * 0.03),
                          border: Border.all(
                              color: ColorConst.textColor.withOpacity(0.5))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${totalAmount.toStringAsFixed(2)} /-",
                            style: TextStyle(
                                color: ColorConst.textColor,
                                fontSize: w * 0.06),
                          ),
                          statItem('By Bank :', byBank.toStringAsFixed(2)),
                          statItem('By Cash :', byCash.toStringAsFixed(2)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Expanded(
                      child: data.isEmpty
                          ? Center(
                              child: Text(
                              'No bills yet',
                              style: textStyle(false),
                            ))
                          : ListView.separated(
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
                                  child: ListTile(
                                    leading: Text('${index + 1}',
                                        style: textStyle(false)),
                                    title: Text(
                                      data[index].deviceName,
                                      style: textStyle(false),
                                    ),
                                    subtitle: Text(
                                        "Total cost : ${(data[index].playCost + data[index].extraAmount + data[index].capacityPrice - data[index].discount).toStringAsFixed(2)}",
                                        style: textStyle(false)),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        data[index].paidbyBank != 0
                                            ? Text(
                                                'By Bank : ${data[index].paidbyBank.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    color: ColorConst
                                                        .successAlert),
                                              )
                                            : data[index].paidbyCash != 0
                                                ? Text(
                                                    'By Cash : ${data[index].paidbyCash.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                        color: ColorConst
                                                            .successAlert),
                                                  )
                                                : Text(
                                                    'Not Paid',
                                                    style: TextStyle(
                                                        color: ColorConst
                                                            .errorAlert),
                                                  )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                color: ColorConst.textColor.withOpacity(0.5),
                              ),
                            ),
                    )
                  ],
                );
              },
              error: (error, stackTrace) {
                return toastMessage(
                    context: context,
                    label: 'Error : $error',
                    isSuccess: false);
              },
              loading: () =>
                  Center(child: Lottie.asset(Gifs.loadingGif, height: w * 0.2)),
            );
          }),
        ));
  }
}
