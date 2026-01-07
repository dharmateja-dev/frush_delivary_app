import 'dart:developer';

import 'package:driver/constant/constant.dart';
import 'package:driver/models/currency_model.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../constant/collection_name.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    notificationInit();
    getCurrentCurrency();

    super.onInit();
  }

  getCurrentCurrency() async {
    FireStoreUtils.fireStore.collection(CollectionName.currencies).where("isActive", isEqualTo: true).snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        Constant.currencyModel = CurrencyModel.fromJson(event.docs.first.data());
      } else {
        Constant.currencyModel = CurrencyModel(id: "", code: "USD", decimalDigits: 2, enable: true, name: "US Dollar", symbol: "\$", symbolAtRight: false);
      }
    });
    await FireStoreUtils().getSettings();
  }

  NotificationService notificationService = NotificationService();

  notificationInit() {
    notificationService.initInfo().then((value) async {
      String token = await NotificationService.getToken();
      log(":::::::TOKEN:::::: $token");
      if (FirebaseAuth.instance.currentUser != null) {
        await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
          if (value != null) {
            UserModel driverUserModel = value;
            driverUserModel.fcmToken = token;
            FireStoreUtils.updateUser(driverUserModel);
          }
        });
      }
    });
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

