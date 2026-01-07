class PayStackModel {
  bool? isSandbox;
  String? callbackURL;
  String? publicKey;
  String? secretKey;
  bool? isEnable;
  String? webhookURL;

  PayStackModel(
      {this.isSandbox,
        this.callbackURL,
        this.publicKey,
        this.secretKey,
        this.isEnable,
        this.webhookURL});

  PayStackModel.fromJson(Map<String, dynamic> json) {
    isSandbox = json['isSandbox'];
    callbackURL = json['callbackURL'];
    publicKey = json['publicKey'];
    secretKey = json['secretKey'];
    isEnable = json['isEnable'];
    webhookURL = json['webhookURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSandbox'] = isSandbox;
    data['callbackURL'] = callbackURL;
    data['publicKey'] = publicKey;
    data['secretKey'] = secretKey;
    data['isEnable'] = isEnable;
    data['webhookURL'] = webhookURL;
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

