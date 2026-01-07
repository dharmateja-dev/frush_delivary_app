// ignore_for_file: file_names

import 'dart:developer';

import 'package:driver/models/payment_model/pay_fast_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayFastScreen extends StatefulWidget {
  final String htmlData;
  final PayFastModel payFastSettingData;

  const PayFastScreen(
      {super.key, required this.htmlData, required this.payFastSettingData});

  @override
  State<PayFastScreen> createState() => _PayFastScreenState();
}

class _PayFastScreenState extends State<PayFastScreen> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    initController();
    super.initState();
  }

  initController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest navigation) async {
            if (kDebugMode) {
              log("--->2 $navigation");
            }
            if (navigation.url == widget.payFastSettingData.returnUrl) {
              Get.back(result: true);
            } else if (navigation.url == widget.payFastSettingData.notifyUrl) {
              Get.back(result: false);
            } else if (navigation.url == widget.payFastSettingData.cancelUrl) {
              _showMyDialog();
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString((widget.htmlData));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _showMyDialog();
            },
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Payment'.tr),
          content: const SingleChildScrollView(
            child: Text("cancelPayment?"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Exit'.tr,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Get.back();
                Get.back(result: false);
              },
            ),
            TextButton(
              child: Text(
                'Continue Payment'.tr,
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
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

