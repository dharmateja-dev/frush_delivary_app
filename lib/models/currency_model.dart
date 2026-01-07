import 'package:cloud_firestore/cloud_firestore.dart';

class CurrencyModel {
  Timestamp? createdAt;
  String? symbol;
  String? code;
  bool? enable;
  bool? symbolAtRight;
  String? name;
  int? decimalDigits;
  String? id;
  Timestamp? updatedAt;

  CurrencyModel({this.createdAt, this.symbol, this.code, this.enable, this.symbolAtRight, this.name, this.decimalDigits, this.id, this.updatedAt});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    symbol = json['symbol'];
    code = json['code'];
    enable = json['enable'];
    symbolAtRight = json['symbolAtRight'];
    name = json['name'];
    decimalDigits = json['decimalDigits'] != null ? int.parse(json['decimalDigits'].toString()) : 2;
    id = json['id'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['symbol'] = symbol;
    data['code'] = code;
    data['enable'] = enable;
    data['symbolAtRight'] = symbolAtRight;
    data['name'] = name;
    data['decimalDigits'] = decimalDigits;
    data['id'] = id;
    data['updatedAt'] = updatedAt;
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

