// To parse this JSON data, do
//
//     final createRazorPayOrderModel = createRazorPayOrderModelFromJson(jsonString);

import 'dart:convert';

CreateRazorPayOrderModel createRazorPayOrderModelFromJson(String str) => CreateRazorPayOrderModel.fromJson(json.decode(str));

String createRazorPayOrderModelToJson(CreateRazorPayOrderModel data) => json.encode(data.toJson());

class CreateRazorPayOrderModel {
  CreateRazorPayOrderModel({
    required this.id,
    required this.entity,
    required this.amount,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
    required this.receipt,
    required this.offerId,
    required this.status,
    required this.attempts,
    required this.notes,
    required this.createdAt,
  });

  String id;
  String entity;
  int amount;
  int amountPaid;
  int amountDue;
  String currency;
  String receipt;
  dynamic offerId;
  String status;
  int attempts;
  Notes notes;
  int createdAt;

  factory CreateRazorPayOrderModel.fromJson(Map<String, dynamic> json) => CreateRazorPayOrderModel(
        id: json["id"],
        entity: json["entity"],
        amount: json["amount"],
        amountPaid: json["amount_paid"],
        amountDue: json["amount_due"],
        currency: json["currency"],
        receipt: json["receipt"] ?? "",
        offerId: json["offer_id"],
        status: json["status"],
        attempts: json["attempts"],
        notes: Notes.fromJson(json["notes"]),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "amount": amount,
        "amount_paid": amountPaid,
        "amount_due": amountDue,
        "currency": currency,
        "receipt": receipt,
        "offer_id": offerId,
        "status": status,
        "attempts": attempts,
        "notes": notes.toJson(),
        "created_at": createdAt,
      };
}

class Notes {
  Notes();

  factory Notes.fromJson(Map<String, dynamic> json) => Notes();

  Map<String, dynamic> toJson() => {};
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

