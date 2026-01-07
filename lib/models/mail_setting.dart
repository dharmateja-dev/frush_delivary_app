class MailSettings {
  String? emailSetting;
  String? fromName;
  String? host;
  String? mailEncryptionType;
  String? mailMethod;
  String? password;
  String? port;
  String? userName;

  MailSettings({this.emailSetting, this.fromName, this.host, this.mailEncryptionType, this.mailMethod, this.password, this.port, this.userName});

  MailSettings.fromJson(Map<String, dynamic> json) {
    emailSetting = json['emailSetting'];
    fromName = json['fromName'];
    host = json['host'];
    mailEncryptionType = json['mailEncryptionType'];
    mailMethod = json['mailMethod'];
    password = json['password'];
    port = json['port'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emailSetting'] = emailSetting;
    data['fromName'] = fromName;
    data['host'] = host;
    data['mailEncryptionType'] = mailEncryptionType;
    data['mailMethod'] = mailMethod;
    data['password'] = password;
    data['port'] = port;
    data['userName'] = userName;
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

