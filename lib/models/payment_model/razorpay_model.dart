class RazorPayModel {
  String? razorpaySecret;
  bool? isWithdrawEnabled;
  bool? isSandboxEnabled;
  bool? isEnabled;
  String? razorpayKey;

  RazorPayModel(
      {this.razorpaySecret,
        this.isWithdrawEnabled,
        this.isSandboxEnabled,
        this.isEnabled,
        this.razorpayKey});

  RazorPayModel.fromJson(Map<String, dynamic> json) {
    razorpaySecret = json['razorpaySecret'];
    isWithdrawEnabled = json['isWithdrawEnabled'];
    isSandboxEnabled = json['isSandboxEnabled'];
    isEnabled = json['isEnabled'];
    razorpayKey = json['razorpayKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['razorpaySecret'] = razorpaySecret;
    data['isWithdrawEnabled'] = isWithdrawEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['isEnabled'] = isEnabled;
    data['razorpayKey'] = razorpayKey;
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

