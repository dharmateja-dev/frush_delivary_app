// To parse this JSON data, do
//
//     final stripePayFailedModel = stripePayFailedModelFromJson(jsonString);

import 'dart:convert';

StripePayFailedModel stripePayFailedModelFromJson(String str) => StripePayFailedModel.fromJson(json.decode(str));

String stripePayFailedModelToJson(StripePayFailedModel data) => json.encode(data.toJson());

class StripePayFailedModel {
  StripePayFailedModel({
    required this.error,
  });

  Error error;

  factory StripePayFailedModel.fromJson(Map<String, dynamic> json) => StripePayFailedModel(
        error: Error.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error.toJson(),
      };
}

class Error {
  Error({
    required this.code,
    required this.localizedMessage,
    required this.message,
    required this.stripeErrorCode,
    required this.declineCode,
    required this.type,
  });

  String code;
  String localizedMessage;
  String message;
  dynamic stripeErrorCode;
  dynamic declineCode;
  dynamic type;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        code: json["code"],
        localizedMessage: json["localizedMessage"],
        message: json["message"],
        stripeErrorCode: json["stripeErrorCode"],
        declineCode: json["declineCode"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "localizedMessage": localizedMessage,
        "message": message,
        "stripeErrorCode": stripeErrorCode,
        "declineCode": declineCode,
        "type": type,
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

