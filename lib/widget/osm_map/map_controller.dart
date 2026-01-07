import 'dart:convert';
import 'package:driver/widget/osm_map/place_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OSMMapController extends GetxController {
  // Store only one picked place instead of multiple
  var pickedPlace = Rxn<PlaceModel>(); // Use Rxn to hold a nullable value
  var searchResults = [].obs;

  Future<void> searchPlace(String query) async {
    if (query.length < 3) {
      searchResults.clear();
      return;
    }

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=10');

    final response = await http.get(url, headers: {
      'User-Agent': 'FlutterMapApp/1.0 (menil.siddhiinfosoft@gmail.com)',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      searchResults.value = data;
    }
  }

  void selectSearchResult(Map<String, dynamic> place) {
    final lat = double.parse(place['lat']);
    final lon = double.parse(place['lon']);
    final address = place['display_name'];

    // Store only the selected place
    pickedPlace.value = PlaceModel(
      coordinates: LatLng(lat, lon),
      address: address,
    );
    searchResults.clear();
  }

  void addLatLngOnly(LatLng coords) async {
    final address = await _getAddressFromLatLng(coords);
    pickedPlace.value = PlaceModel(coordinates: coords, address: address);
  }

  Future<String> _getAddressFromLatLng(LatLng coords) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${coords.latitude}&lon=${coords.longitude}&format=json');

    final response = await http.get(url, headers: {
      'User-Agent': 'FlutterMapApp/1.0 (menil.siddhiinfosoft@gmail.com)',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name'] ?? 'Unknown location';
    } else {
      return 'Unknown location';
    }
  }

  void clearAll() {
    pickedPlace.value = null; // Clear the selected place
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

