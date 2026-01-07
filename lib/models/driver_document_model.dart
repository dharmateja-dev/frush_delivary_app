
class DriverDocumentModel {
  List<Documents>? documents;
  String? id;
  String? type;

  DriverDocumentModel({this.documents, this.id});

  DriverDocumentModel.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}

class Documents {
  String? frontImage;
  String? status;
  String? documentId;
  String? backImage;

  Documents({this.frontImage, this.status, this.documentId, this.backImage});

  Documents.fromJson(Map<String, dynamic> json) {
    frontImage = json['frontImage'];
    status = json['status'];
    documentId = json['documentId'];
    backImage = json['backImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['frontImage'] = frontImage;
    data['status'] = status;
    data['documentId'] = documentId;
    data['backImage'] = backImage;
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

