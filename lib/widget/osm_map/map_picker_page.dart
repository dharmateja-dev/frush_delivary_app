import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/round_button_fill.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/widget/osm_map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapPickerPage extends StatelessWidget {
  final OSMMapController controller = Get.put(OSMMapController());
  final TextEditingController searchController = TextEditingController();
  final mapController = MapController();

  MapPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Future<LatLng> getCurrentLocation() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      // Request permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied");
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LatLng(position.latitude, position.longitude);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeChange.getThem()
            ? AppThemeData.surfaceDark
            : AppThemeData.surface,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "PickUp Location".tr,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: AppThemeData.medium,
            fontSize: 16,
            color: themeChange.getThem()
                ? AppThemeData.grey50
                : AppThemeData.grey900,
          ),
        ),
      ),
      body: Stack(
        children: [
          Obx(
            () => FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: controller.pickedPlace.value?.coordinates ??
                    LatLng(20.5937, 78.9629), // Default India center
                initialZoom: 13,
                onTap: (tapPos, latlng) {
                  controller.addLatLngOnly(latlng);
                  mapController.move(latlng, mapController.camera.zoom);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  maxZoom: 20,
                ),
                MarkerLayer(
                  markers: controller.pickedPlace.value != null
                      ? [
                          Marker(
                            point: controller.pickedPlace.value!.coordinates,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_pin,
                              size: 36,
                              color: Colors.red,
                            ),
                          ),
                        ]
                      : [],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 120,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: AppThemeData.primary300,
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
              ),
              onPressed: () async {
                try {
                  LatLng current = await getCurrentLocation();
                  controller.addLatLngOnly(current);
                  mapController.move(current, 15);
                } catch (e) {
                  Get.snackbar("Location Error", e.toString());
                }
              },
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search location...',
                      contentPadding: EdgeInsets.all(12),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: controller.searchPlace,
                  ),
                ),
                Obx(() {
                  if (controller.searchResults.isEmpty)
                    return const SizedBox.shrink();

                  return Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) {
                        final place = controller.searchResults[index];
                        return ListTile(
                          title: Text(place['display_name']),
                          onTap: () {
                            controller.selectSearchResult(place);
                            final lat = double.parse(place['lat']);
                            final lon = double.parse(place['lon']);
                            final pos = LatLng(lat, lon);
                            mapController.move(pos, 15);
                            searchController.text = place['display_name'];
                          },
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.pickedPlace.value != null
                    ? "Picked Location:"
                    : "No Location Picked",
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.primary300
                      : AppThemeData.primary300,
                  fontFamily: AppThemeData.semiBold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              if (controller.pickedPlace.value != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    "${controller.pickedPlace.value!.address}\n(${controller.pickedPlace.value!.coordinates.latitude.toStringAsFixed(5)}, ${controller.pickedPlace.value!.coordinates.longitude.toStringAsFixed(5)})",
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RoundedButtonFill(
                      title: "Conform Location".tr,
                      color: AppThemeData.primary300,
                      textColor: AppThemeData.grey50,
                      height: 5,
                      onPress: () async {
                        final selected = controller.pickedPlace.value;
                        if (selected != null) {
                          Get.back(
                              result: selected); // ✅ Return the selected place
                          print("Selected location: $selected");
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    onPressed: controller.clearAll,
                  )
                ],
              ),
            ],
          ),
        );
      }),
    );
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

