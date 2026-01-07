import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/app/auth_screen/login_screen.dart';
import 'package:driver/app/auth_screen/signup_screen.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controllers/phone_number_controller.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/themes/text_field_widget.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PhoneNumberController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : AppThemeData.surface,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Log In Using Your Mobile Number".tr,
                    style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontSize: 22,
                        fontFamily: AppThemeData.semiBold),
                  ),
                  Text(
                    "Enter your mobile number to quickly access your account and start managing your deliveries."
                        .tr,
                    style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey500,
                        fontFamily: AppThemeData.regular),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: 'Didn’t Have an account?'.tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontFamily: AppThemeData.medium,
                              fontWeight: FontWeight.w500,
                            )),
                        const WidgetSpan(
                            child: SizedBox(
                          width: 10,
                        )),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(const SignupScreen());
                              },
                            text: 'Sign up'.tr,
                            style: const TextStyle(
                                color: AppThemeData.primary300,
                                fontFamily: AppThemeData.medium,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: AppThemeData.secondary300)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFieldWidget(
                    title: 'Phone Number'.tr,
                    controller: controller.phoneNUmberEditingController.value,
                    hintText: 'Enter Phone Number'.tr,
                    textInputType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      LengthLimitingTextInputFormatter(10)
                    ],
                    prefix: CountryCodePicker(
                      onChanged: (value) {
                        controller.countryCodeEditingController.value.text =
                            value.dialCode.toString();
                      },
                      dialogTextStyle: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppThemeData.medium),
                      dialogBackgroundColor: themeChange.getThem()
                          ? AppThemeData.grey800
                          : AppThemeData.grey100,
                      initialSelection:
                          controller.countryCodeEditingController.value.text,
                      comparator: (a, b) =>
                          b.name!.compareTo(a.name.toString()),
                      textStyle: TextStyle(
                          fontSize: 14,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.medium),
                      searchDecoration: InputDecoration(
                          iconColor: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900),
                      searchStyle: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppThemeData.medium),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Platform.isAndroid ? 10 : 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Log in with'.tr,
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontFamily: AppThemeData.medium,
                                  fontWeight: FontWeight.w500,
                                )),
                            const WidgetSpan(
                                child: SizedBox(
                              width: 10,
                            )),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.offAll(const LoginScreen());
                                  },
                                text: 'E-mail'.tr,
                                style: const TextStyle(
                                    color: AppThemeData.secondary300,
                                    fontFamily: AppThemeData.medium,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        AppThemeData.secondary300)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (controller
                        .phoneNUmberEditingController.value.text.isEmpty) {
                      ShowToastDialog.showToast(
                          "Please enter mobile number".tr);
                    } else {
                      controller.sendCode();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppThemeData.driverApp300,
                      ),
                      width: Responsive.width(100, context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Send Code".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey50,
                            fontSize: 16,
                            fontFamily: AppThemeData.medium,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
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

