import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/utils/fire_store_utils.dart';

class BankDetailsController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<TextEditingController> bankNameController = TextEditingController().obs;
  Rx<TextEditingController> branchNameController = TextEditingController().obs;
  Rx<TextEditingController> holderNameController = TextEditingController().obs;
  Rx<TextEditingController> accountNoController = TextEditingController().obs;
  Rx<TextEditingController> otherInfoController = TextEditingController().obs;

  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getCurrentUser();
    super.onInit();
  }

  saveBank() async {
    ShowToastDialog.showLoader("Please wait".tr);
    userModel.value.userBankDetails ??= UserBankDetails();
    userModel.value.userBankDetails!.accountNumber =
        accountNoController.value.text;
    userModel.value.userBankDetails!.bankName = bankNameController.value.text;
    userModel.value.userBankDetails!.branchName =
        branchNameController.value.text;
    userModel.value.userBankDetails!.holderName =
        holderNameController.value.text;
    userModel.value.userBankDetails!.otherDetails =
        otherInfoController.value.text;

    await FireStoreUtils.updateUser(userModel.value).then(
      (value) {
        ShowToastDialog.closeLoader();
        Get.back();
      },
    );
  }

  getCurrentUser() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then(
      (value) {
        if (value != null) {
          userModel.value = value;
          if (userModel.value.userBankDetails != null) {
            bankNameController.value.text =
                userModel.value.userBankDetails!.bankName.toString();
            branchNameController.value.text =
                userModel.value.userBankDetails!.branchName.toString();
            holderNameController.value.text =
                userModel.value.userBankDetails!.holderName.toString();
            accountNoController.value.text =
                userModel.value.userBankDetails!.accountNumber.toString();
            otherInfoController.value.text =
                userModel.value.userBankDetails!.otherDetails.toString();
          }
        }
      },
    );
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

