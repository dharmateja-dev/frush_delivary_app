import 'package:cloud_firestore/cloud_firestore.dart';

class InboxModel {
  String? customerId;
  String? customerName;
  String? customerProfileImage;
  String? lastMessage;
  String? orderId;
  String? restaurantId;
  String? restaurantName;
  String? restaurantProfileImage;
  String? lastSenderId;
  String? chatType;
  Timestamp? createdAt;

  InboxModel({
    this.customerId,
    this.customerName,
    this.customerProfileImage,
    this.lastMessage,
    this.orderId,
    this.restaurantId,
    this.restaurantName,
    this.restaurantProfileImage,
    this.lastSenderId,
    this.chatType,
    this.createdAt,
  });

  factory InboxModel.fromJson(Map<String, dynamic> parsedJson) {
    return InboxModel(
      customerId: parsedJson['customerId'] ?? '',
      customerName: parsedJson['customerName'] ?? '',
      customerProfileImage: parsedJson['customerProfileImage'] ?? '',
      lastMessage: parsedJson['lastMessage'],
      orderId: parsedJson['orderId'],
      restaurantId: parsedJson['restaurantId'] ?? '',
      restaurantName: parsedJson['restaurantName'] ?? '',
      lastSenderId: parsedJson['lastSenderId'] ?? '',
      chatType: parsedJson['chatType'] ?? '',
      restaurantProfileImage: parsedJson['restaurantProfileImage'] ?? '',
      createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerProfileImage': customerProfileImage,
      'lastMessage': lastMessage,
      'orderId': orderId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantProfileImage': restaurantProfileImage,
      'lastSenderId': lastSenderId,
      'chatType': chatType,
      'createdAt': createdAt,
    };
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

