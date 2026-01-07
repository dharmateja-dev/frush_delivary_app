import 'package:driver/constant/constant.dart';
import 'package:driver/models/language_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/preferences.dart';
import 'package:get/get.dart';

import '../constant/collection_name.dart';

class ChangeLanguageController extends GetxController {
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;
  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getLanguage();

    super.onInit();
  }

  getLanguage() async {
    await FireStoreUtils.fireStore.collection(CollectionName.settings).doc("languages").get().then((event) {
      if (event.exists) {
        List languageListTemp = event.data()!["list"];
        for (var element in languageListTemp) {
            LanguageModel languageModel = LanguageModel.fromJson(element);
            languageList.add(languageModel);
          }

        if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
          LanguageModel pref = Constant.getLanguage();
          for (var element in languageList) {
            if (element.slug == pref.slug) {
              selectedLanguage.value = element;
            }
          }
        }
      }
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

