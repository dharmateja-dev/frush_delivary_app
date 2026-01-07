import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionPlanModel {
  Timestamp? createdAt;
  String? description;
  String? expiryDay;
  Features? features;
  String? id;
  bool? isEnable;
  String? itemLimit;
  String? orderLimit;
  String? name;
  String? price;
  String? place;
  String? image;
  String? type;
  List<String>? planPoints;

  SubscriptionPlanModel(
      {this.createdAt,
      this.description,
      this.expiryDay,
      this.features,
      this.id,
      this.isEnable,
      this.itemLimit,
      this.orderLimit,
      this.name,
      this.price,
      this.place,
      this.image,
      this.type,
      this.planPoints});

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      createdAt: json['createdAt'],
      description: json['description'],
      expiryDay: json['expiryDay'],
      features: json['features'] == null ? null : Features.fromJson(json['features']),
      id: json['id'],
      isEnable: json['isEnable'],
      itemLimit: json['itemLimit'],
      orderLimit: json['orderLimit'],
      name: json['name'],
      price: json['price'],
      place: json['place'],
      image: json['image'],
      type: json['type'],
      planPoints: json['plan_points'] == null ? [] : List<String>.from(json['plan_points']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'description': description,
      'expiryDay': expiryDay.toString(),
      'features': features?.toJson(),
      'id': id,
      'isEnable': isEnable,
      'itemLimit': itemLimit.toString(),
      'orderLimit': orderLimit.toString(),
      'name': name,
      'price': price.toString(),
      'place': place.toString(),
      'image': image.toString(),
      'type': type,
      'plan_points': planPoints
    };
  }
}

class Features {
  bool? chat;
  bool? dineIn;
  bool? qrCodeGenerate;
  bool? restaurantMobileApp;

  Features({
    this.chat,
    this.dineIn,
    this.qrCodeGenerate,
    this.restaurantMobileApp,
  });

  // Factory constructor to create an instance from JSON
  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      chat: json['chat'] ?? false,
      dineIn: json['dineIn'] ?? false,
      qrCodeGenerate: json['qrCodeGenerate'] ?? false,
      restaurantMobileApp: json['restaurantMobileApp'] ?? false,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'chat': chat,
      'dineIn': dineIn,
      'qrCodeGenerate': qrCodeGenerate,
      'restaurantMobileApp': restaurantMobileApp,
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

