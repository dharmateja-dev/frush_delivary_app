import 'package:driver/app/auth_screen/login_screen.dart';
import 'package:driver/controllers/on_boarding_controller.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/round_button_fill.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
   return GetX<OnBoardingController>(
      init: OnBoardingController(),
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading.value
              ? Constant.loader()
              : Container(
                  decoration: BoxDecoration(
                    
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5), 
        BlendMode.darken,              
      ),
                          image:
                              AssetImage(controller.selectedPageIndex.value == 0
                                  ? "assets/images/image_1.jpg"
                                  : controller.selectedPageIndex.value == 1
                                      ? "assets/images/image_2.jpg"
                                      : "assets/images/image_3.jpg"),
                          fit: BoxFit.cover)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30,),
                         Align(
                                        alignment: Alignment.topCenter,
                                        child:  
                                      Text(
                                        "Frush".tr,
                                        style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey50,
                                            fontSize: 30,
                                            fontFamily: AppThemeData.bold),
                                      ),),
                        Expanded(
                          child: PageView.builder(
                              controller: controller.pageController,
                              onPageChanged: controller.selectedPageIndex.call,
                              itemCount: controller.onBoardingList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                     
                                      Text(
                                        controller.onBoardingList[index].title
                                            .toString()
                                            .tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey50,
                                          fontSize: 28,
                                          fontFamily: AppThemeData.bold,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        controller
                                            .onBoardingList[index].description
                                            .toString()
                                            .tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey600
                                              : AppThemeData.grey300,
                                          fontSize: 16,
                                          fontFamily: AppThemeData.regular,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RoundedButtonFill(
                          title: "Get Started".tr,
                          color: AppThemeData.primary300,
                          textColor: AppThemeData.grey50,
                          onPress: () {
                            if (controller.selectedPageIndex.value == 2) {
                              Preferences.setBoolean(
                                  Preferences.isFinishOnBoardingKey, true);
                              Get.offAll(const LoginScreen());
                            } else {
                              controller.pageController.jumpToPage(
                                  controller.selectedPageIndex.value + 1);
                            }
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
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

