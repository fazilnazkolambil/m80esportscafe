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
        "device_income": 208,
        "created_at": 1731579525081,
        "center_code": "1122",
        "device_code": "1122",
        "total_sessions": 14,
        "device_id": "7ec29f1e-5473-4462-9190-bce8df735c3e",
        "device_name": "M80-Pc-001",
        "device_provisioned_on": 20241123,
        "device_capacity": "1",
        "center_name": "New center",
        "device_status": "ACTIVE",
        "discount": 10,
        "total_minutes_played": 2363,
        "device_pricing": [
          {
            "min_75": 120,
            "min_150": 250,
            "min_180": 300,
            "min_105": 180,
            "min_300": 500,
            "min_120": 200,
            "min_60": 90,
            "min_240": 400,
            "min_90": 150
          }
        ],
        "device_price": 100000,
        "base_price": 100,
        "recoverd_percentage": 0.208,
        "device_type": "PC",
        "organisation_id": "9b623a09-fe07-4371-859d-2c7bb77ba904",
        "availability_status": "AVAILABLE",
        "center_id": "2ee6fda2-6941-4a78-80b9-927fedde11c6"
      },
      {
        "device_income": 0,
        "created_at": 1732535152501,
        "center_code": "1122",
        "device_code": "1122",
        "device_id": "840fd56d-daa4-44a1-8681-f683c19bc2da",
        "device_provisioned_on": 20241123,
        "device_name": "22",
        "device_capacity": "3",
        "center_name": "New center",
        "device_status": "ACTIVE",
        "discount": 22,
        "device_pricing": [
          {
            "min_75": 120,
            "min_150": 250,
            "min_180": 300,
            "min_105": 180,
            "min_300": 500,
            "min_60": 100,
            "min_120": 200,
            "min_90": 150,
            "min_240": 400
          }
        ],
        "device_price": 2222,
        "recoverd_percentage": 0,
        "device_type": "PROJECTOR",
        "organisation_id": "9b623a09-fe07-4371-859d-2c7bb77ba904",
        "availability_status": "UNAVAILABLE",
        "center_id": "2ee6fda2-6941-4a78-80b9-927fedde11c6"
      },
      {
        "device_income": 0,
        "created_at": 1732538137378,
        "center_code": "1122",
        "device_code": "1122",
        "device_id": "8489fea3-92ee-4dcb-bdb2-47b8ff91cc43",
        "device_provisioned_on": 20241123,
        "device_name": "111",
        "device_capacity": "3",
        "center_name": "New center",
        "device_status": "ACTIVE",
        "discount": 22,
        "device_pricing": [
          {
            "min_75": 120,
            "min_150": 250,
            "min_180": 300,
            "min_105": 180,
            "min_300": 500,
            "min_60": 100,
            "min_120": 200,
            "min_90": 150,
            "min_240": 400
          }
        ],
        "device_price": 222,
        "recoverd_percentage": 0,
        "device_type": "PROJECTOR",
        "organisation_id": "9b623a09-fe07-4371-859d-2c7bb77ba904",
        "availability_status": "AVAILABLE",
        "center_id": "2ee6fda2-6941-4a78-80b9-927fedde11c6"
      },
      {
        "device_income": 335,
        "created_at": 1732010418380,
        "center_code": "1122",
        "device_code": "108",
        "total_sessions": 7,
        "device_id": "84685a9c-80c6-4e0c-9487-ea244ad585a1",
        "device_name": "M80-Pc-003",
        "device_provisioned_on": 20241123,
        "device_capacity": "4",
        "center_name": "New center",
        "device_status": "ACTIVE",
        "discount": 10,
        "total_minutes_played": 4387,
        "device_pricing": [
          {
            "min_75": 120,
            "min_150": 250,
            "min_180": 300,
            "min_105": 180,
            "min_300": 500,
            "min_120": 200,
            "min_60": 100,
            "min_240": 400,
            "min_90": 150
          }
        ],
        "device_price": 20000,
        "base_price": 100,
        "recoverd_percentage": 1.675,
        "device_type": "PROJECTOR",
        "organisation_id": "9b623a09-fe07-4371-859d-2c7bb77ba904",
        "availability_status": "IN_USE",
        "center_id": "2ee6fda2-6941-4a78-80b9-927fedde11c6"
      },
      {
        "device_income": 100,
        "created_at": 1731591054893,
        "center_code": "1122",
        "device_code": "3344",
        "total_sessions": 12,
        "device_id": "64228c0b-2672-461d-9763-5b4188e6df9d",
        "device_name": "M80-Pc_002",
        "device_provisioned_on": 20241123,
        "device_capacity": "4",
        "center_name": "New center",
        "device_status": "ACTIVE",
        "discount": 10,
        "total_minutes_played": 30060,
        "device_pricing": [
          {
            "min_75": 220,
            "min_150": 350,
            "min_180": 400,
            "min_105": 280,
            "min_300": 500,
            "min_120": 300,
            "min_60": 200,
            "min_240": 450,
            "min_90": 250
          }
        ],
        "device_price": 100000,
        "base_price": 100,
        "recoverd_percentage": 0,
        "device_type": "XBOX",
        "organisation_id": "9b623a09-fe07-4371-859d-2c7bb77ba904",
        "availability_status": "AVAILABLE",
        "center_id": "2ee6fda2-6941-4a78-80b9-927fedde11c6"
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
