import 'dart:developer';

import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class OrderListController extends GetxController{

  RxBool isLoading  = true.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    getOrder();
    super.onInit();
  }

  RxList<OrderModel> orderList = <OrderModel>[].obs;


  getOrder() async {
    await FireStoreUtils.fireStore
        .collection(CollectionName.restaurantOrders)
        .where('driverID', isEqualTo: Constant.userModel!.id.toString())
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        OrderModel dailyEarningModel = OrderModel.fromJson(element.data());
        orderList.add(dailyEarningModel);
      }
    }).catchError((error) {
      log(error.toString());
    });

    isLoading.value = false;
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

