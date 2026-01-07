class OrangeMoney {
  String? image;
  String? clientId;
  String? auth;
  bool? enable;
  String? name;
  String? notifyUrl;
  String? clientSecret;
  bool? isSandbox;
  String? returnUrl;
  String? merchantKey;
  String? cancelUrl;
  String? notifUrl;

  OrangeMoney(
      {this.image,
        this.clientId,
        this.auth,
        this.enable,
        this.name,
        this.notifyUrl,
        this.clientSecret,
        this.isSandbox,
        this.returnUrl,
        this.cancelUrl,
        this.notifUrl,
        this.merchantKey});

  OrangeMoney.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    clientId = json['clientId'];
    auth = json['auth'];
    enable = json['enable'];
    name = json['name'];
    notifyUrl = json['notifyUrl'];
    clientSecret = json['clientSecret'];
    isSandbox = json['isSandbox'];
    returnUrl = json['returnUrl'];
    merchantKey = json['merchantKey'];
    cancelUrl = json['cancelUrl'];
    notifUrl = json['notifUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['clientId'] = clientId;
    data['auth'] = auth;
    data['enable'] = enable;
    data['name'] = name;
    data['notifyUrl'] = notifyUrl;
    data['clientSecret'] = clientSecret;
    data['isSandbox'] = isSandbox;
    data['returnUrl'] = returnUrl;
    data['merchantKey'] = merchantKey;
    data['cancelUrl'] = cancelUrl;
    data['notifUrl'] = notifUrl;
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

