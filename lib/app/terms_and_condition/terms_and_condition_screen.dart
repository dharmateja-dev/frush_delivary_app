import 'package:driver/constant/constant.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsAndConditionScreen extends StatelessWidget {
  final String? type;

  const TermsAndConditionScreen({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    // final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: AppThemeData.grey50,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          child: Html(
            shrinkWrap: true,
            data: type == "privacy" ? Constant.privacyPolicy : Constant.termsAndConditions,
          ),
        ),
      ),
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

