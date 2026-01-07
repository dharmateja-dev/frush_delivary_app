import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/app/auth_screen/login_screen.dart';
import 'package:driver/app/dash_board_screen/dash_board_screen.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/models/zone_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  Rx<TextEditingController> firstNameEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> lastNameEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> emailEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> phoneNUmberEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> countryCodeEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> passwordEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> conformPasswordEditingController =
      TextEditingController().obs;

  RxBool passwordVisible = true.obs;
  RxBool conformPasswordVisible = true.obs;

  RxString type = "".obs;

  Rx<UserModel> userModel = UserModel().obs;

  RxList<ZoneModel> zoneList = <ZoneModel>[].obs;
  Rx<ZoneModel> selectedZone = ZoneModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      type.value = argumentData['type'];
      userModel.value = argumentData['userModel'];
      if (type.value == "mobileNumber") {
        phoneNUmberEditingController.value.text =
            userModel.value.phoneNumber ?? "";
        countryCodeEditingController.value.text =
            userModel.value.countryCode ?? "+1";
      } else if (type.value == "google" || type.value == "apple") {
        emailEditingController.value.text = userModel.value.email ?? "";
        firstNameEditingController.value.text = userModel.value.firstName ?? "";
        lastNameEditingController.value.text = userModel.value.lastName ?? "";
      }
    }

    await FireStoreUtils.getZone().then((value) {
      if (value != null) {
        zoneList.value = value;
      }
    });
  }

  signUpWithEmailAndPassword() async {
    signUp();
  }

  signUp() async {
    ShowToastDialog.showLoader("Please wait");
    // Require zone selection
    if (selectedZone.value.id == null || selectedZone.value.id!.isEmpty) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Please select a zone".tr);
      return;
    }
    if (type.value == "google" ||
        type.value == "apple" ||
        type.value == "mobileNumber") {
      userModel.value.firstName =
          firstNameEditingController.value.text.toString();
      userModel.value.lastName =
          lastNameEditingController.value.text.toString();
      userModel.value.email =
          emailEditingController.value.text.toString().toLowerCase();
      userModel.value.phoneNumber =
          phoneNUmberEditingController.value.text.toString();
      userModel.value.role = Constant.userRoleDriver;
      userModel.value.fcmToken = await NotificationService.getToken();
      userModel.value.active =
          Constant.autoApproveDriver == true ? true : false;
      userModel.value.isDocumentVerify =
          Constant.isDriverVerification == true ? false : true;
      userModel.value.countryCode = countryCodeEditingController.value.text;
      userModel.value.createdAt = Timestamp.now();
      userModel.value.zoneId = selectedZone.value.id;
      userModel.value.appIdentifier = Platform.isAndroid ? 'android' : 'ios';
      print("📤 Attempting to create user account...");
      print("User data: ${userModel.value.toJson()}");

      // Check if phone number already exists in users collection
      try {
        final query = await FirebaseFirestore.instance
            .collection(CollectionName.users)
            .where('phoneNumber', isEqualTo: userModel.value.phoneNumber)
            .get();
        if (query.docs.isNotEmpty) {
          bool isSameUser = false;
          for (var doc in query.docs) {
            if (doc.id == userModel.value.id) {
              isSameUser = true;
              break;
            }
          }
          if (!isSameUser) {
            ShowToastDialog.closeLoader();
            ShowToastDialog.showToast("Phone number already registered".tr);
            return;
          }
        }

        final updated = await FireStoreUtils.updateUser(userModel.value);
        if (updated) {
          if (Constant.autoApproveDriver == true) {
            Get.offAll(const DashBoardScreen());
            ShowToastDialog.showToast("Account created successfully".tr);
          } else {
            ShowToastDialog.showToast(
                "Thank you for signing up, your application is under review. Please wait for approval."
                    .tr);
            Get.offAll(const LoginScreen());
          }
        } else {
          ShowToastDialog.showToast("Failed to create account".tr);
        }
      } catch (e) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(e.toString());
        return;
      }
    } else {
      try {
        // Check if phone number already exists before creating auth user
        try {
          final phoneQuery = await FirebaseFirestore.instance
              .collection(CollectionName.users)
              .where('phoneNumber',
                  isEqualTo: phoneNUmberEditingController.value.text.toString())
              .get();
          if (phoneQuery.docs.isNotEmpty) {
            ShowToastDialog.closeLoader();
            ShowToastDialog.showToast("Phone number already registered".tr);
            return;
          }
        } catch (e) {
          // if phone-check fails, continue but log error
          print('Phone check error: $e');
        }

        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailEditingController.value.text.trim(),
          password: passwordEditingController.value.text.trim(),
        );
        if (credential.user != null) {
          // final user = FirebaseAuth.instance.currentUser;
          // if (user != null && !user.emailVerified) {
          //   await user.sendEmailVerification();
          //   print("Verification email sent to ${user.email}");
          // }

          // ShowToastDialog.showToast(
          //     "Verification email sent. Please check your inbox.".tr);
          userModel.value.id = credential.user!.uid;
          userModel.value.firstName =
              firstNameEditingController.value.text.toString();
          userModel.value.lastName =
              lastNameEditingController.value.text.toString();
          userModel.value.email =
              emailEditingController.value.text.toString().toLowerCase();
          userModel.value.phoneNumber =
              phoneNUmberEditingController.value.text.toString();
          userModel.value.role = Constant.userRoleDriver;
          userModel.value.fcmToken = await NotificationService.getToken();
          userModel.value.active =
              Constant.autoApproveDriver == true ? true : false;
          userModel.value.isDocumentVerify =
              Constant.isDriverVerification == true ? false : true;
          userModel.value.countryCode = countryCodeEditingController.value.text;
          userModel.value.createdAt = Timestamp.now();
          userModel.value.zoneId = selectedZone.value.id;
          userModel.value.appIdentifier =
              Platform.isAndroid ? 'android' : 'ios';
          userModel.value.provider = 'email';

          await FireStoreUtils.updateUser(userModel.value).then(
            (value) async {
              await FirebaseAuth.instance.currentUser?.reload();
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                if (Constant.autoApproveDriver == true) {
                  Get.offAll(const DashBoardScreen());
                  ShowToastDialog.showToast("Account created successfully".tr);
                }
              } else {
                ShowToastDialog.showToast(
                    "Thank you for signing up, your application is under review. Please wait for approval."
                        .tr);
                Get.offAll(const LoginScreen());
              }
            },
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ShowToastDialog.showToast("The password provided is too weak.".tr);
        } else if (e.code == 'email-already-in-use') {
          ShowToastDialog.showToast(
              "The account already exists for that email.".tr);
        } else if (e.code == 'invalid-email') {
          ShowToastDialog.showToast("Enter email is Invalid".tr);
        }
      } catch (e) {
        ShowToastDialog.showToast(e.toString());
      }
    }

    ShowToastDialog.closeLoader();
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
