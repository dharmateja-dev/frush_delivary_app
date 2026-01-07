import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/services/audio_player_service.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class DeliverOrderController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool conformPickup = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Rx<OrderModel> orderModel = OrderModel().obs;

  RxInt totalQuantity = 0.obs;

  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
      for (var element in orderModel.value.products!) {
        totalQuantity.value += (element.quantity ?? 0);
      }
    }
    isLoading.value = false;
  }

 completedOrder() async {
  ShowToastDialog.showLoader("Please wait".tr);
  await AudioPlayerService.playSound(false);

  orderModel.value.status = Constant.orderCompleted;

  await FireStoreUtils.updateWallateAmount(orderModel.value);
  await FireStoreUtils.setOrder(orderModel.value);

  Constant.userModel?.orderRequestData?.remove(orderModel.value.id);
  Constant.userModel?.inProgressOrderID?.remove(orderModel.value.id);

  if (Constant.userModel != null) {
    await FireStoreUtils.updateUser(Constant.userModel!);
  }

  await FireStoreUtils.getFirestOrderOrNOt(orderModel.value).then((value) async {
    if (value == true) {
      await FireStoreUtils.updateReferralAmount(orderModel.value);
    }
  });

  await SendNotification.sendFcmMessage(
    Constant.driverCompleted,
    orderModel.value.author?.fcmToken ?? '',
    {},
  );

  ShowToastDialog.closeLoader();
  Get.back(result: true);
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

