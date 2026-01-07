class PayPalModel {
  String? paypalSecret;
  bool? isWithdrawEnabled;
  String? paypalAppId;
  bool? isEnabled;
  bool? isLive;
  String? paypalClient;

  PayPalModel(
      {this.paypalSecret,
        this.isWithdrawEnabled,
        this.paypalAppId,
        this.isEnabled,
        this.isLive,
        this.paypalClient});

  PayPalModel.fromJson(Map<String, dynamic> json) {
    paypalSecret = json['paypalSecret'];
    isWithdrawEnabled = json['isWithdrawEnabled'];
    paypalAppId = json['paypalAppId'];
    isEnabled = json['isEnabled'];
    isLive = json['isLive'];
    paypalClient = json['paypalClient'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paypalSecret'] = paypalSecret;
    data['isWithdrawEnabled'] = isWithdrawEnabled;
    data['paypalAppId'] = paypalAppId;
    data['isEnabled'] = isEnabled;
    data['isLive'] = isLive;
    data['paypalClient'] = paypalClient;
    return data;
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

