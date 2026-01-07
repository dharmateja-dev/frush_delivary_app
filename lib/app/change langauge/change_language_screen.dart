import 'dart:convert';

import 'package:driver/constant/constant.dart';
import 'package:driver/controllers/change_language_controller.dart';
import 'package:driver/services/localization_service.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/network_image_widget.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChangeLanguageScreen extends StatelessWidget {
  const ChangeLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ChangeLanguageController(),
        builder: (controller) {
          return Scaffold(
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: (1.1 / 1),
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1,
                            children: controller.languageList
                                .map(
                                  (data) => Obx(
                                    () => GestureDetector(
                                      onTap: () {
                                        LocalizationService().changeLocale(data.slug.toString());
                                        Preferences.setString(Preferences.languageCodeKey, jsonEncode(data));
                                        controller.selectedLanguage.value = data;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            NetworkImageWidget(
                                              imageUrl: data.image.toString(),
                                              height: 80,
                                              width: 80,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${data.title}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: controller.selectedLanguage.value.slug == data.slug
                                                    ? AppThemeData.primary300
                                                    : themeChange.getThem()
                                                        ? AppThemeData.grey400
                                                        : AppThemeData.grey500,
                                                fontFamily: AppThemeData.medium,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
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

