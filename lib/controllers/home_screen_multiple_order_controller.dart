import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/services/audio_player_service.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class HomeScreenMultipleOrderController extends GetxController {
  Rx<UserModel> driverModel = Constant.userModel!.obs;
  RxBool isLoading = true.obs;
  RxInt selectedTabIndex = 0.obs;

  RxList<dynamic> newOrder = [].obs;
  RxList<dynamic> activeOrder = [].obs;

  @override
  void onInit() {
    // TODO: implement onInt
    getDriver();
    super.onInit();
  }

  getDriver() async {
    FireStoreUtils.fireStore
        .collection(CollectionName.users)
        .doc(FireStoreUtils.getCurrentUid())
        .snapshots()
        .listen(
      (event) async {
        if (event.exists) {
          driverModel.value = UserModel.fromJson(event.data()!);
          Constant.userModel = driverModel.value;
          newOrder.clear();
          activeOrder.clear();
          if (driverModel.value.orderRequestData != null) {
            for (var element in driverModel.value.orderRequestData!) {
              newOrder.add(element);
            }
          }

          if (driverModel.value.inProgressOrderID != null) {
            for (var element in driverModel.value.inProgressOrderID!) {
              activeOrder.add(element);
            }
          }

          if (newOrder.isEmpty == true) {
            await AudioPlayerService.playSound(false);
          }

          if (newOrder.isNotEmpty) {
            if (driverModel.value.vendorID?.isEmpty == true) {
              await AudioPlayerService.playSound(true);
            }
          }
        }
      },
    );
    isLoading.value = false;
  }

  acceptOrder(OrderModel currentOrder) async {
    try {
      await AudioPlayerService.playSound(false);
      ShowToastDialog.showLoader("Please wait".tr);

      final orderId = currentOrder.id;
      final driverId = driverModel.value.id;

      // Use a transaction to atomically check and update the order
      // This prevents race conditions when multiple drivers try to accept simultaneously
      await FireStoreUtils.fireStore.runTransaction((transaction) async {
        final orderRef = FireStoreUtils.fireStore
            .collection(CollectionName.restaurantOrders)
            .doc(orderId);

        final orderSnap = await transaction.get(orderRef);

        if (!orderSnap.exists ||
            orderSnap['status'] != Constant.driverPending) {
          throw Exception("Order already taken");
        }

        // Update the order with the accepting driver's info
        transaction.update(orderRef, {
          'status': Constant.driverAccepted,
          'driverID': driverId,
          'driver': driverModel.value.toJson(),
        });

        // Update the accepting driver's data
        final driverRef = FireStoreUtils.fireStore
            .collection(CollectionName.users)
            .doc(driverId);

        transaction.update(driverRef, {
          'orderRequestData': FieldValue.arrayRemove([orderId]),
          'inProgressOrderID': FieldValue.arrayUnion([orderId]),
        });
      });

      // Remove the order from ALL other drivers' orderRequestData
      // This ensures the order notification is removed from all other delivery guys
      await _removeOrderFromAllOtherDrivers(orderId!, driverId!);

      ShowToastDialog.closeLoader();

      await SendNotification.sendFcmMessage(Constant.driverAcceptedNotification,
          currentOrder.author!.fcmToken.toString(), {});
      await SendNotification.sendFcmMessage(Constant.driverAcceptedNotification,
          currentOrder.vendor!.fcmToken.toString(), {});
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Order already accepted by another driver".tr);
    }
  }

  /// Removes the order from all other drivers' orderRequestData lists
  /// This is called after a driver accepts an order to ensure other drivers
  /// no longer see this order in their pending requests
  Future<void> _removeOrderFromAllOtherDrivers(
      String orderId, String acceptingDriverId) async {
    try {
      // Query all drivers who have this order in their orderRequestData
      final driversSnapshot = await FireStoreUtils.fireStore
          .collection(CollectionName.users)
          .where('role', isEqualTo: Constant.userRoleDriver)
          .where('orderRequestData', arrayContains: orderId)
          .get();

      // Create a batch to update all drivers at once
      final batch = FireStoreUtils.fireStore.batch();

      for (var doc in driversSnapshot.docs) {
        // Skip the driver who accepted the order (already updated in transaction)
        if (doc.id == acceptingDriverId) continue;

        batch.update(doc.reference, {
          'orderRequestData': FieldValue.arrayRemove([orderId]),
        });
      }

      // Commit all updates
      await batch.commit();

      print(
          'Removed order $orderId from ${driversSnapshot.docs.length - 1} other drivers');
    } catch (e) {
      print('Error removing order from other drivers: $e');
      // Don't throw - this is a cleanup operation, shouldn't block the main flow
    }
  }

  rejectOrder(OrderModel currentOrder) async {
    await AudioPlayerService.playSound(false);
    currentOrder.rejectedByDrivers ??= [];

    currentOrder.rejectedByDrivers!.add(driverModel.value.id);
    currentOrder.status = Constant.driverRejected;
    await FireStoreUtils.setOrder(currentOrder);

    driverModel.value.orderRequestData!.remove(currentOrder.id);
    await FireStoreUtils.updateUser(driverModel.value);
  }
}

/*******************************************************************************************
* Copyright (c) 2025 Movenetics Digital. All rights reserved.
*
* This software and associated documentation files are the property of 
* Movenetics Digital. Unauthorized copying, modification, distribution, or use of this 
* Software, via any medium, is strictly prohibited without prior written permission.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
* LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT 
* OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
* OTHER DEALINGS IN THE SOFTWARE.
*
* Company: Movenetics Digital
* Author: Aman Bhandari 
*******************************************************************************************/
