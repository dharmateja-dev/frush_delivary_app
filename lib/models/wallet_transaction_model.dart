import 'package:cloud_firestore/cloud_firestore.dart';

class WalletTransactionModel {
  String? userId;
  String? paymentMethod;
  double? amount;
  bool? isTopup;
  String? orderId;
  String? paymentStatus;
  Timestamp? date;
  String? id;
  String? transactionUser;
  String? note;

  WalletTransactionModel({
    this.userId,
    this.paymentMethod,
    this.amount,
    this.isTopup,
    this.orderId,
    this.paymentStatus,
    this.date,
    this.id,
    this.transactionUser,
    this.note,
  });

  WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    paymentMethod = json['payment_method'];
    amount = double.parse("${json['amount'] ?? 0.0}");
    isTopup = json['isTopUp'];
    orderId = json['order_id'];
    paymentStatus = json['payment_status'];
    date = json['date'];
    transactionUser = json['transactionUser'] ?? 'customer';
    note = json['note'] ?? 'Wallet Top-up';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['payment_method'] = paymentMethod;
    data['amount'] = amount;
    data['isTopUp'] = isTopup;
    data['order_id'] = orderId;
    data['payment_status'] = paymentStatus;
    data['date'] = date;
    data['transactionUser'] = transactionUser;
    data['note'] = note;
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

