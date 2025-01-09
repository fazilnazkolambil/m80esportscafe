import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m80_esports/core/globalVariables.dart';
import 'package:m80_esports/features/homePage/repository/homePage_repository.dart';
import 'package:m80_esports/models/beverages_model.dart';
import 'package:m80_esports/models/cafe_model.dart';
import 'package:m80_esports/models/deviceCategory_model.dart';
import 'package:m80_esports/models/devices_model.dart';
import 'package:m80_esports/models/invoice_model.dart';

final HomepageControllerProvider =
    NotifierProvider<HomepageController, bool>(() {
  return HomepageController();
});

final getCafeprovider = FutureProvider<List<CafeModel>>((ref) {
  return ref.watch(HomepageControllerProvider.notifier).getCafes();
});

final deviceProvider =
    StreamProvider.family<List<DeviceModel>, String>((ref, jsonData) {
  return ref.watch(HomepageControllerProvider.notifier).getDevices(jsonData);
});
final allDevicesProvider =
    StreamProvider.family<List<DeviceModel>, String>((ref, deviceType) {
  return ref
      .watch(HomepageControllerProvider.notifier)
      .getAllDevices(deviceType);
});
final invoiceProvider =
    StreamProvider.family<List<InvoiceModel>, DateTime>((ref, selectedDate) {
  return ref
      .watch(HomepageControllerProvider.notifier)
      .getInvoice(selectedDate);
});

final getAllBeverages = StreamProvider<List<BeveragesModel>>((ref) {
  return ref.watch(HomepageControllerProvider.notifier).getAllBeverages();
});
final getDeviceCategoryProvider =
    StreamProvider<List<DeviceCategoryModel>>((ref) {
  return ref.watch(HomepageControllerProvider.notifier).getDeviceCategory();
});

class HomepageController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<List<CafeModel>> getCafes() async {
    return ref.watch(HomepageRepositoryProvider).getCafes();
  }

  Stream<List<InvoiceModel>> getInvoice(DateTime selectedDate) {
    return ref.watch(HomepageRepositoryProvider).getinvoices(selectedDate);
  }

  Stream<List<DeviceModel>> getDevices(jsonData) {
    Map data = json.decode(jsonData);
    return ref
        .watch(HomepageRepositoryProvider)
        .getDevices(data['deviceType'], data['cafe']);
  }

  Stream<List<DeviceModel>> getAllDevices(String deviceType) {
    return ref.watch(HomepageRepositoryProvider).getAllDevices(deviceType);
  }

  Stream<List<BeveragesModel>> getAllBeverages() {
    return ref.watch(HomepageRepositoryProvider).getAllBeverages();
  }

  Stream<List<DeviceCategoryModel>> getDeviceCategory() {
    return ref.watch(HomepageRepositoryProvider).getDeviceCategory();
  }
}
