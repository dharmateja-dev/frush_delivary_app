import 'package:driver/app/auth_screen/otp_screen.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumberController extends GetxController {
  Rx<TextEditingController> phoneNUmberEditingController = TextEditingController().obs;
  Rx<TextEditingController> countryCodeEditingController = TextEditingController().obs;

  sendCode() async {
    ShowToastDialog.showLoader("please wait...".tr);
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: countryCodeEditingController.value.text + phoneNUmberEditingController.value.text,
            verificationCompleted: (PhoneAuthCredential credential) {},
            verificationFailed: (FirebaseAuthException e) {
              debugPrint("FirebaseAuthException--->${e.message}");
              ShowToastDialog.closeLoader();
              if (e.code == 'invalid-phone-number') {
                ShowToastDialog.showToast("invalid_phone_number".tr);
              } else {
                ShowToastDialog.showToast(e.message);
              }
            },
            codeSent: (String verificationId, int? resendToken) {
              ShowToastDialog.closeLoader();
              Get.to(const OtpScreen(), arguments: {
                "countryCode": countryCodeEditingController.value.text,
                "phoneNumber": phoneNUmberEditingController.value.text,
                "verificationId": verificationId,
              });
            },
            codeAutoRetrievalTimeout: (String verificationId) {})
        .catchError((error) {
      debugPrint("catchError--->$error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("multiple_time_request".tr);
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

