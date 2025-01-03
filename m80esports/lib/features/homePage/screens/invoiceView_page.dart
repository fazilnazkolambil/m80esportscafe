import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/core/globalVariables.dart';
import 'package:m80_esports/models/invoice_model.dart';

class InvoiceView extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceView({
    required this.invoice,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController paidbyCash = TextEditingController(text: '0');
    final TextEditingController paidbyBank = TextEditingController(text: '0');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          invoice.deviceName,
          style: textStyle(true),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, color: ColorConst.textColor)),
        backgroundColor: ColorConst.backgroundColor.withOpacity(0),
      ),
      body: Container(
        margin: EdgeInsets.all(w * 0.05),
        padding: EdgeInsets.all(w * 0.03),
        decoration: BoxDecoration(
            color: ColorConst.backgroundColor,
            borderRadius: BorderRadius.circular(w * 0.03)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Play time',
              style: textStyle(false),
            ),
            Text(
              '${DateFormat.jm().format(invoice.startTime)} - ${DateFormat.jm().format(invoice.endTime!)} = ${invoice.playTime} minutes',
              style: textStyle(true),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Text(
              'Play cost',
              style: textStyle(false),
            ),
            Text('${invoice.playCost.toStringAsFixed(2)}/-',
                style: textStyle(true)),
            SizedBox(
              height: h * 0.01,
            ),
            if (invoice.extras.isNotEmpty)
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  useInkWell: false,
                  iconColor: ColorConst.textColor,
                  iconSize: 20,
                ),
                header: Container(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    'Extras',
                    style: textStyle(false),
                  ),
                ),
                collapsed: const SizedBox(),
                expanded: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: invoice.extras.length,
                    itemBuilder: (context, index) {
                      var item = invoice.extras[index];
                      return SizedBox(
                        height: 100,
                        child: ListTile(
                          leading:
                              Text('${index + 1}', style: textStyle(false)),
                          title: Text(
                            "${item['quantity']} * ${item['name']}",
                            style: textStyle(false),
                          ),
                          trailing: Text(
                            "${item['quantity'] * item['price']}.00",
                            style: textStyle(false),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (invoice.deviceName.contains('PS5'))
              Text(
                'Total Controllers : ${invoice.totalCapacity - invoice.remainingCapacity}',
                style: textStyle(false),
              ),
            Text(
              'Extra amount',
              style: textStyle(false),
            ),
            Text('${invoice.extraAmount + invoice.capacityPrice}/-',
                style: textStyle(true)),
            Divider(),
            Text(
              'Total to Pay',
              style: textStyle(true),
            ),
            Text(
                '${(invoice.playCost + invoice.extraAmount + invoice.capacityPrice).toStringAsFixed(2)}/-',
                style: textStyle(true)),
            SizedBox(
              height: h * 0.01,
            ),
            invoice.paid
                ? Container(
                    width: double.maxFinite,
                    height: h * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w * 0.03),
                        border: Border.all(color: ColorConst.successAlert)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            "Paid by bank : ${invoice.paidbyBank.toStringAsFixed(2)}",
                            style: textStyle(false)),
                        Text(
                            "Paid by cash : ${invoice.paidbyCash.toStringAsFixed(2)}",
                            style: textStyle(false)),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: ColorConst.backgroundColor,
                                title: Text('Enter the amount',
                                    style: textStyle(true)),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: paidbyBank,
                                          style: textStyle(false),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: InputDecoration(
                                            hintText: 'Amount paid to bank',
                                            hintStyle: textStyle(false),
                                            labelText: 'To bank',
                                            labelStyle: textStyle(false),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.03),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.03),
                                                borderSide: const BorderSide(
                                                    color:
                                                        ColorConst.textColor)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.03),
                                                borderSide: const BorderSide(
                                                    color:
                                                        ColorConst.textColor)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: h * 0.03,
                                        ),
                                        TextFormField(
                                          controller: paidbyCash,
                                          style: textStyle(false),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: InputDecoration(
                                            hintText: 'Amount paid by cash',
                                            hintStyle: textStyle(false),
                                            labelText: 'By cash',
                                            labelStyle: textStyle(false),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.03),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.03),
                                                borderSide: const BorderSide(
                                                    color:
                                                        ColorConst.textColor)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.03),
                                                borderSide: const BorderSide(
                                                    color:
                                                        ColorConst.textColor)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel')),
                                  TextButton(
                                      onPressed: () async {
                                        if (paidbyBank.text.isNotEmpty &&
                                            paidbyCash.text.isNotEmpty) {
                                          if ((int.parse(paidbyBank.text) > 0 ||
                                              int.parse(paidbyCash.text) > 0)) {
                                            await FirebaseFirestore.instance
                                                .collection('Organisations')
                                                .doc('m80Esports')
                                                .collection('cafes')
                                                .doc(selectedCafe)
                                                .collection('invoice')
                                                .doc(invoice.id)
                                                .update({
                                              'paidbyCash':
                                                  int.parse(paidbyCash.text),
                                              'paidbyBank':
                                                  int.parse(paidbyBank.text),
                                              'paid': true
                                            });
                                            toastMessage(
                                                context: context,
                                                label: 'Payment completed',
                                                isSuccess: true);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          } else {
                                            toastMessage(
                                                context: context,
                                                label: 'Enter the amount',
                                                isSuccess: false);
                                          }
                                        } else {
                                          toastMessage(
                                              context: context,
                                              label: 'Fields cannot be empty!',
                                              isSuccess: false);
                                        }
                                      },
                                      child: Text('Done'))
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          height: h * 0.05,
                          width: w * 0.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(w * 0.04),
                              border: Border.all(color: ColorConst.successAlert)
                              //color: ColorConst.successAlert
                              ),
                          child: Center(
                              child: Text('Pay now', style: textStyle(false))),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          height: h * 0.05,
                          width: w * 0.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(w * 0.04),
                              border: Border.all(color: ColorConst.errorAlert)
                              // color: ColorConst.errorAlert,
                              ),
                          child: Center(
                              child: Text('Khata', style: textStyle(false))),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
