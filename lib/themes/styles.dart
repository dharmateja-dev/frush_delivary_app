import 'package:driver/themes/app_them_data.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme ? AppThemeData.surfaceDark : AppThemeData.surface,
      primaryColor: isDarkTheme ? AppThemeData.primary300 : AppThemeData.primary300,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      timePickerTheme: TimePickerThemeData(
        backgroundColor: isDarkTheme ? AppThemeData.grey700 : AppThemeData.grey300,
        dialTextStyle: TextStyle(fontWeight: FontWeight.bold, color: isDarkTheme ? AppThemeData.grey800 : AppThemeData.grey800),
        dialTextColor: isDarkTheme ? AppThemeData.grey800 : AppThemeData.grey800,
        hourMinuteTextColor: isDarkTheme ? AppThemeData.grey800 : AppThemeData.grey800,
        dayPeriodTextColor: isDarkTheme ? AppThemeData.grey800 : AppThemeData.grey800,
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

