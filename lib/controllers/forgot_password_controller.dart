import 'package:driver/constant/show_toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  Rx<TextEditingController> emailEditingController =
      TextEditingController().obs;

  forgotPassword() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailEditingController.value.text,
      );
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(
          '${'Reset Password link sent your'.tr} ${emailEditingController.value.text} ${'email'.tr}');
      Get.back();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ShowToastDialog.showToast('No user found for that email.'.tr);
      }
    }
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

