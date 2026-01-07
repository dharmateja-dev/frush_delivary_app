import 'package:driver/models/on_boarding_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  var selectedPageIndex = 0.obs;

  bool get isLastPage => selectedPageIndex.value == onBoardingList.length - 1;
  var pageController = PageController();

  @override
  void onInit() {
    getOnBoardingData();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  RxList<OnBoardingModel> onBoardingList = <OnBoardingModel>[].obs;

  getOnBoardingData() async {
    await FireStoreUtils.getOnBoardingList().then((value) {
      onBoardingList.value = value;
    });
    // onBoardingList.add(OnBoardingModel(id: "",title: "Welcome to Frush Driver App",description: "Join our community of drivers and start earning by delivering delicious meals.",image: "assets/images/image_1.png"));
    // onBoardingList.add(OnBoardingModel(id: "",title: "Manage Your Deliveries",description: "Stay on top of your deliveries with real-time updates and easy navigation.",image: "assets/images/image_2.png"));
    // onBoardingList.add(OnBoardingModel(id: "",title: "Earn More with Incentives",description: "Boost your earnings with our driver incentives and rewards program.",image: "assets/images/image_3.png"));

    isLoading.value = false;
    update();
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
