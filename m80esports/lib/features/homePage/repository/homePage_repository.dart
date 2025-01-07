import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m80_esports/core/firebaseProvider.dart';
import 'package:m80_esports/core/globalVariables.dart';
import 'package:m80_esports/models/beverages_model.dart';
import 'package:m80_esports/models/deviceCategory_model.dart';
import 'package:m80_esports/models/devices_model.dart';
import 'package:m80_esports/models/invoice_model.dart';

final HomepageRepositoryProvider = Provider<HomepageRepository>((ref) {
  return HomepageRepository(firestore: ref.watch(firestoreProvider));
});

class HomepageRepository {
  final FirebaseFirestore _firestore;
  HomepageRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _cafe => _firestore
      .collection('Organisations')
      .doc('m80Esports')
      .collection('cafes');
  Stream<List<InvoiceModel>> getinvoices(DateTime selectedDate) {
    DateTime startOfDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));
    return _cafe
        .doc(selectedCafe)
        .collection('invoice')
        .where('endTime', isNull: false)
        .where('endTime', isGreaterThanOrEqualTo: startOfDay)
        .where('endTime', isLessThan: endOfDay)
        .orderBy('endTime', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => InvoiceModel.fromJson(e.data())).toList());
  }

  Stream<List<DeviceModel>> getDevices(String deviceType) {
    return FirebaseFirestore.instance
        .collection('Organisations')
        .doc('m80Esports')
        .collection('cafes')
        .doc(selectedCafe)
        .collection('devices')
        .doc(deviceType)
        .collection(deviceType)
        .where('deleted', isEqualTo: false)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => DeviceModel.fromJson(e.data())).toList());
  }

  Stream<List<DeviceModel>> getAllDevices(String deviceType) {
    return FirebaseFirestore.instance
        .collection('Organisations')
        .doc('m80Esports')
        .collection('cafes')
        .doc(selectedCafe)
        .collection('devices')
        .doc(deviceType)
        .collection(deviceType)
        .orderBy('totalMinutesPlayed', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => DeviceModel.fromJson(e.data())).toList());
  }

  Stream<List<BeveragesModel>> getAllBeverages() {
    return _cafe.doc(selectedCafe).collection('beverages').snapshots().map(
        (event) =>
            event.docs.map((e) => BeveragesModel.fromJson(e.data())).toList());
  }

  Stream<List<DeviceCategoryModel>> getDeviceCategory() {
    return FirebaseFirestore.instance
        .collection('Organisations')
        .doc('m80Esports')
        .collection('cafes')
        .doc(selectedCafe)
        .collection('devices')
        .where('deleted', isEqualTo: false)
        .snapshots()
        .map((event) => event.docs
            .map((e) => DeviceCategoryModel.fromJson(e.data()))
            .toList());
  }
}
