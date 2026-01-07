import 'package:cloud_firestore/cloud_firestore.dart';

class ZoneModel {
  List<GeoPoint>? area;
  bool? publish;
  double? latitude;
  String? name;
  String? id;
  double? longitude;

  ZoneModel(
      {this.area,
        this.publish,
        this.latitude,
        this.name,
        this.id,
        this.longitude});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    if (json['area'] != null) {
      area = <GeoPoint>[];
      json['area'].forEach((v) {
        area!.add(v);
      });
    }

    publish = json['publish'];
    latitude = json['latitude'];
    name = json['name'];
    id = json['id'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (area != null) {
      data['area'] = area!.map((v) => v).toList();
    }
    data['publish'] = publish;
    data['latitude'] = latitude;
    data['name'] = name;
    data['id'] = id;
    data['longitude'] = longitude;
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

