class MidTrans {
  bool? enable;
  String? name;
  bool? isSandbox;
  String? serverKey;
  String? image;

  MidTrans({
    this.name,
    this.enable,
    this.serverKey,
    this.isSandbox,
    this.image,
  });

  MidTrans.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    isSandbox = json['isSandbox'];
    serverKey = json['serverKey'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['enable'] = enable;
    data['name'] = name;
    data['isSandbox'] = isSandbox;
    data['serverKey'] = serverKey;
    data['image'] = image;
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

