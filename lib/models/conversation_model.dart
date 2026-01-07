import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  String? id;
  String? senderId;
  String? receiverId;
  String? orderId;
  String? message;
  String? messageType;
  String? videoThumbnail;
  Url? url;
  Timestamp? createdAt;

  ConversationModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.orderId,
    this.message,
    this.messageType,
    this.videoThumbnail,
    this.url,
    this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConversationModel(
      id: parsedJson['id'] ?? '',
      senderId: parsedJson['senderId'] ?? '',
      receiverId: parsedJson['receiverId'] ?? '',
      orderId: parsedJson['orderId'] ?? '',
      message: parsedJson['message'] ?? '',
      messageType: parsedJson['messageType'] ?? '',
      videoThumbnail: parsedJson['videoThumbnail'] ?? '',
      url: parsedJson.containsKey('url')
          ? parsedJson['url'] != null
              ? Url.fromJson(parsedJson['url'])
              : null
          : Url(),
      createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'orderId': orderId,
      'message': message,
      'messageType': messageType,
      'videoThumbnail': videoThumbnail,
      'url': url?.toJson(),
      'createdAt': createdAt,
    };
  }
}

class Url {
  String mime;

  String url;

  String? videoThumbnail;

  Url({this.mime = '', this.url = '', this.videoThumbnail});

  factory Url.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Url(url: parsedJson['url'] ?? '', videoThumbnail: parsedJson['videoThumbnail'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'mime': mime, 'url': url, 'videoThumbnail': videoThumbnail};
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

