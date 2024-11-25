import 'package:flutter/material.dart';
import 'package:m80_esports/core/const_page.dart';
import 'package:m80_esports/core/globalVariables.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  Map a = {
    "Items": [
      {
        "device_description": "ps511",
        "device_capacity": "1",
        "device_type_id": "234567898765432q345tf",
        "device_type_name": "ps5"
      },
      {
        "device_description": "New Ps9",
        "device_capacity": "1",
        "device_type_id": "9de9a15d-0fcf-484d-b8d9-de622ba0a64f",
        "device_type_name": "New Ps5"
      },
      {
        "device_description": "Testing Projecters123728838383",
        "device_capacity": "3",
        "device_type_id": "4f6009d7-11ef-4931-ac26-57321f210666",
        "device_type_name": "Projecter"
      },
      {
        "device_description": "Test1123432",
        "device_capacity": "2",
        "device_type_id": "f801b84f-4815-4d77-a6fd-788a67d1f049",
        "device_type_name": "X-box"
      }
    ]
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Image(image: AssetImage(ImageConst.logo))],
      ),
    );
  }
}
