// To parse this JSON data, do
//
//     final payStackUrlModel = payStackUrlModelFromJson(jsonString);

import 'dart:convert';

PayStackUrlModel payStackUrlModelFromJson(String str) => PayStackUrlModel.fromJson(json.decode(str));

String payStackUrlModelToJson(PayStackUrlModel data) => json.encode(data.toJson());

class PayStackUrlModel {
  PayStackUrlModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory PayStackUrlModel.fromJson(Map<String, dynamic> json) => PayStackUrlModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  String authorizationUrl;
  String accessCode;
  String reference;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        authorizationUrl: json["authorization_url"],
        accessCode: json["access_code"],
        reference: json["reference"],
      );

  Map<String, dynamic> toJson() => {
        "authorization_url": authorizationUrl,
        "access_code": accessCode,
        "reference": reference,
      };
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

