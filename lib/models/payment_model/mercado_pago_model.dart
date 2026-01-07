class MercadoPagoModel {
  bool? isSandboxEnabled;
  bool? isEnabled;
  String? accessToken;
  String? publicKey;

  MercadoPagoModel(
      {this.isSandboxEnabled,
        this.isEnabled,
        this.accessToken,
        this.publicKey});

  MercadoPagoModel.fromJson(Map<String, dynamic> json) {
    isSandboxEnabled = json['isSandboxEnabled'];
    isEnabled = json['isEnabled'];
    accessToken = json['AccessToken'];
    publicKey = json['PublicKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['isEnabled'] = isEnabled;
    data['AccessToken'] = accessToken;
    data['PublicKey'] = publicKey;
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

