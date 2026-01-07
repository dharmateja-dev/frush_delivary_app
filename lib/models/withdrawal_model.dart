import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawalModel {
  String? amount;
  String? adminNote;
  String? note;
  String? id;
  Timestamp? paidDate;
  String? paymentStatus;
  String? vendorID;
  String? driverID;
  String? withdrawMethod;

  WithdrawalModel({this.amount, this.adminNote, this.note, this.id, this.paidDate,this.driverID ,this.paymentStatus, this.vendorID, this.withdrawMethod});

  WithdrawalModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] == null ? "0.0" : json['amount'].toString();
    adminNote = json['adminNote'];
    note = json['note'];
    id = json['id'];
    paidDate = json['paidDate'];
    paymentStatus = json['paymentStatus'];
    vendorID = json['vendorID'];
    withdrawMethod = json['withdrawMethod'];
    driverID = json['driverID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['adminNote'] = adminNote;
    data['note'] = note;
    data['id'] = id;
    data['paidDate'] = paidDate;
    data['paymentStatus'] = paymentStatus;
    data['vendorID'] = vendorID;
    data['driverID'] = driverID;
    data['withdrawMethod'] = withdrawMethod;
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

