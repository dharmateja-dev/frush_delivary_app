class StripeModel {
  String? stripeSecret;
  String? clientpublishableKey;
  bool? isWithdrawEnabled;
  bool? isEnabled;
  bool? isSandboxEnabled;
  String? stripeKey;

  StripeModel(
      {this.stripeSecret,
        this.clientpublishableKey,
        this.isWithdrawEnabled,
        this.isEnabled,
        this.isSandboxEnabled,
        this.stripeKey});

  StripeModel.fromJson(Map<String, dynamic> json) {
    stripeSecret = json['stripeSecret'];
    clientpublishableKey = json['clientpublishableKey'];
    isWithdrawEnabled = json['isWithdrawEnabled'];
    isEnabled = json['isEnabled'];
    isSandboxEnabled = json['isSandboxEnabled'];
    stripeKey = json['stripeKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stripeSecret'] = stripeSecret;
    data['clientpublishableKey'] = clientpublishableKey;
    data['isWithdrawEnabled'] = isWithdrawEnabled;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['stripeKey'] = stripeKey;
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

