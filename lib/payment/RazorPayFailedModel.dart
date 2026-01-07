// To parse this JSON data, do
//
//     final razorPayFailedModel = razorPayFailedModelFromJson(jsonString);

import 'dart:convert';

RazorPayFailedModel razorPayFailedModelFromJson(String str) => RazorPayFailedModel.fromJson(json.decode(str));

String razorPayFailedModelToJson(RazorPayFailedModel data) => json.encode(data.toJson());

class RazorPayFailedModel {
  RazorPayFailedModel({
    required this.error,
    required this.httpStatusCode,
  });

  Error error;
  int httpStatusCode;

  factory RazorPayFailedModel.fromJson(Map<String, dynamic>? json) => RazorPayFailedModel(
        error: Error.fromJson(json!["error"]),
        httpStatusCode: json["http_status_code"],
      );

  Map<String, dynamic> toJson() => {
        "error": error.toJson(),
        "http_status_code": httpStatusCode,
      };
}

class Error {
  Error({
    required this.code,
    required this.description,
    required this.source,
    required this.step,
    required this.reason,
    required this.metadata,
  });

  String code;
  String description;
  String source;
  String step;
  String reason;
  Metadata metadata;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        code: json["code"] ?? '',
        description: json["description"] ?? "",
        source: json["source"] ?? "",
        step: json["step"] ?? "",
        reason: json["reason"] ?? "",
        metadata: Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "source": source,
        "step": step,
        "reason": reason,
        "metadata": metadata.toJson(),
      };
}

class Metadata {
  Metadata({
    required this.paymentId,
    required this.orderId,
  });

  String paymentId;
  String orderId;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        paymentId: json["payment_id"] ?? "",
        orderId: json["order_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "payment_id": paymentId,
        "order_id": orderId,
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

