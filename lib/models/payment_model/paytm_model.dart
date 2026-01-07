class PaytmModel {
  String? paytmMID;
  String? pAYTMMERCHANTKEY;
  bool? isEnabled;
  bool? isSandboxEnabled;

  PaytmModel(
      {this.paytmMID,
        this.pAYTMMERCHANTKEY,
        this.isEnabled,
        this.isSandboxEnabled});

  PaytmModel.fromJson(Map<String, dynamic> json) {
    paytmMID = json['PaytmMID'];
    pAYTMMERCHANTKEY = json['PAYTM_MERCHANT_KEY'];
    isEnabled = json['isEnabled'];
    isSandboxEnabled = json['isSandboxEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PaytmMID'] = paytmMID;
    data['PAYTM_MERCHANT_KEY'] = pAYTMMERCHANTKEY;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
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

