import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/services/audio_player_service.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as location;
import '../models/order_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  RxBool isLoading = true.obs;
  flutterMap.MapController osmMapController = flutterMap.MapController();
  RxList<flutterMap.Marker> osmMarkers = <flutterMap.Marker>[].obs;

  @override
  void onInit() {
    getArgument();
    setIcons();
    getDriver();
    checkForStaleOrders();
    super.onInit();
  }

  Rx<OrderModel> orderModel = OrderModel().obs;
  Rx<OrderModel> currentOrder = OrderModel().obs;
  Rx<UserModel> driverModel = UserModel().obs;

  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
    }
  }

//  acceptOrder() async {
//   await AudioPlayerService.playSound(true);
//   ShowToastDialog.showLoader("Please wait".tr);
//
//   driverModel.value.inProgressOrderID = [];
//
//   driverModel.value.orderRequestData?.remove(currentOrder.value.id);
//
//   driverModel.value.inProgressOrderID!.add(currentOrder.value.id);
//
//   await FireStoreUtils.updateUser(driverModel.value);
//
//   currentOrder.value.status = Constant.driverAccepted;
//   currentOrder.value.driverID = driverModel.value.id;
//   currentOrder.value.driver = driverModel.value;
//
//   await FireStoreUtils.setOrder(currentOrder.value);
//   ShowToastDialog.closeLoader();
//
//   await SendNotification.sendFcmMessage(
//     Constant.driverAcceptedNotification,
//     currentOrder.value.author?.fcmToken ?? '',
//     {},
//   );
//   await SendNotification.sendFcmMessage(
//     Constant.driverAcceptedNotification,
//     currentOrder.value.vendor?.fcmToken ?? '',
//     {},
//   );
// }
  acceptOrder() async {
    try {
      await AudioPlayerService.playSound(true);
      ShowToastDialog.showLoader("Please wait".tr);

      final orderId = currentOrder.value.id;
      final driverId = driverModel.value.id;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final orderRef = FirebaseFirestore.instance
            .collection(CollectionName.restaurantOrders)
            .doc(orderId);

        final orderSnap = await transaction.get(orderRef);

        if (!orderSnap.exists ||
            orderSnap['status'] != Constant.driverPending) {
          throw Exception("Order already taken");
        }

        transaction.update(orderRef, {
          'status': Constant.driverAccepted,
          'driverID': driverId,
          'driver': driverModel.value.toJson(),
        });

        final driverRef = FirebaseFirestore.instance
            .collection(CollectionName.users)
            .doc(driverId);

        transaction.update(driverRef, {
          'orderRequestData': FieldValue.arrayRemove([orderId]),
          'inProgressOrderID': [orderId],
        });
      });

      // Remove the order from ALL other drivers' orderRequestData
      // This ensures the order notification is removed from all other delivery guys
      await _removeOrderFromAllOtherDrivers(orderId!, driverId!);

      ShowToastDialog.closeLoader();

      await SendNotification.sendFcmMessage(
        Constant.driverAcceptedNotification,
        currentOrder.value.author?.fcmToken ?? '',
        {},
      );

      await SendNotification.sendFcmMessage(
        Constant.driverAcceptedNotification,
        currentOrder.value.vendor?.fcmToken ?? '',
        {},
      );
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Order already accepted by another driver".tr);
    }
  }

  /// Removes the order from all other drivers' orderRequestData lists
  /// This is called after a driver accepts an order to ensure other drivers
  /// no longer see this order in their pending requests
  Future<void> _removeOrderFromAllOtherDrivers(
      String orderId, String acceptingDriverId) async {
    try {
      // Query all drivers who have this order in their orderRequestData
      final driversSnapshot = await FirebaseFirestore.instance
          .collection(CollectionName.users)
          .where('role', isEqualTo: Constant.userRoleDriver)
          .where('orderRequestData', arrayContains: orderId)
          .get();

      // Create a batch to update all drivers at once
      final batch = FirebaseFirestore.instance.batch();

      for (var doc in driversSnapshot.docs) {
        // Skip the driver who accepted the order (already updated in transaction)
        if (doc.id == acceptingDriverId) continue;

        batch.update(doc.reference, {
          'orderRequestData': FieldValue.arrayRemove([orderId]),
        });
      }

      // Commit all updates
      await batch.commit();

      print(
          'Removed order $orderId from ${driversSnapshot.docs.length - 1} other drivers');
    } catch (e) {
      print('Error removing order from other drivers: $e');
      // Don't throw - this is a cleanup operation, shouldn't block the main flow
    }
  }

  rejectOrder() async {
    await AudioPlayerService.playSound(true);

    currentOrder.value.rejectedByDrivers ??= [];
    currentOrder.value.rejectedByDrivers!.add(driverModel.value.id);

    currentOrder.value.status = Constant.orderPlaced;

    currentOrder.value.driverID = null;
    currentOrder.value.driver = null;

    driverModel.value.orderRequestData?.remove(currentOrder.value.id);
    driverModel.value.inProgressOrderID?.remove(currentOrder.value.id);

    await FireStoreUtils.setOrder(currentOrder.value);
    await FireStoreUtils.updateUser(driverModel.value);

    currentOrder.value = OrderModel();
    clearMap();

    if (Constant.singleOrderReceive == false) {
      Get.back();
    }
  }

  clearMap() async {
    await AudioPlayerService.playSound(false);
    if (Constant.selectedMapType != 'osm') {
      markers.clear();
      polyLines.clear();
    } else {
      osmMarkers.clear();
      routePoints.clear();
      // osmMapController = flutterMap.MapController();
    }
    update();
  }

  getCurrentOrder() async {
    if (currentOrder.value.id != null &&
        !driverModel.value.orderRequestData!.contains(currentOrder.value.id) &&
        !driverModel.value.inProgressOrderID!.contains(currentOrder.value.id)) {
      currentOrder.value = OrderModel();
      await clearMap();
      await AudioPlayerService.playSound(false);
    } else if (Constant.singleOrderReceive == true) {
      if (driverModel.value.inProgressOrderID != null &&
          driverModel.value.inProgressOrderID!.isNotEmpty) {
        FireStoreUtils.fireStore
            .collection(CollectionName.restaurantOrders)
            .where('status', whereNotIn: [
              Constant.orderCancelled,
              Constant.driverRejected,
              "Order Completed" // Keep this only for in-progress orders
            ])
            .where('id',
                isEqualTo:
                    driverModel.value.inProgressOrderID!.first.toString())
            .where('driverID', isEqualTo: driverModel.value.id)
            .snapshots()
            .listen(
              (event) async {
                if (event.docs.isNotEmpty) {
                  currentOrder.value =
                      OrderModel.fromJson(event.docs.first.data());
                  changeData();
                } else {
                  currentOrder.value = OrderModel();
                  await AudioPlayerService.playSound(false);
                }
              },
            );
      } else if (driverModel.value.orderRequestData != null &&
          driverModel.value.orderRequestData!.isNotEmpty) {
        FireStoreUtils.fireStore
            .collection(CollectionName.restaurantOrders)
            .where('status', whereNotIn: [
              Constant.orderCancelled,
              Constant.driverRejected
              // REMOVED "Order Completed" - new order requests should be visible
            ])
            .where('id',
                isEqualTo: driverModel.value.orderRequestData!.first.toString())
            .where('driverID', isEqualTo: driverModel.value.id)
            .snapshots()
            .listen(
              (event) async {
                if (event.docs.isNotEmpty) {
                  currentOrder.value =
                      OrderModel.fromJson(event.docs.first.data());
                  if (driverModel.value.orderRequestData
                          ?.contains(currentOrder.value.id) ==
                      true) {
                    changeData();
                  } else {
                    currentOrder.value = OrderModel();
                    update();
                  }
                } else {
                  currentOrder.value = OrderModel();
                  await AudioPlayerService.playSound(false);
                }
              },
            );
      }
    } else if (orderModel.value.id != null) {
      FireStoreUtils.fireStore
          .collection(CollectionName.restaurantOrders)
          .where('status', whereNotIn: [
            Constant.orderCancelled,
            Constant.driverRejected
            // REMOVED "Order Completed" - general order tracking should see all statuses
          ])
          .where('id', isEqualTo: orderModel.value.id.toString())
          .where('driverID', isEqualTo: driverModel.value.id)
          .snapshots()
          .listen(
            (event) async {
              if (event.docs.isNotEmpty) {
                currentOrder.value =
                    OrderModel.fromJson(event.docs.first.data());
                changeData();
              } else {
                currentOrder.value = OrderModel();
                await AudioPlayerService.playSound(false);
              }
            },
          );
    }
  }

  RxBool isChange = false.obs;

  changeData() async {
    print(
        "currentOrder.value.status :: ${currentOrder.value.id} :: ${currentOrder.value.status} :: ( ${orderModel.value.driver?.vendorID != null} :: ${orderModel.value.status})");

    if (Constant.mapType == "inappmap") {
      if (Constant.selectedMapType == "osm") {
        getOSMPolyline();
      } else {
        getDirections();
      }
    }
    if (currentOrder.value.status == Constant.driverPending) {
      await AudioPlayerService.playSound(true);
    } else {
      await AudioPlayerService.playSound(false);
    }
  }

  getDriver() {
    FireStoreUtils.fireStore
        .collection(CollectionName.users)
        .doc(FireStoreUtils.getCurrentUid())
        .snapshots()
        .listen(
      (event) async {
        if (event.exists) {
          driverModel.value = UserModel.fromJson(event.data()!);
          if (driverModel.value.id != null) {
            isLoading.value = false;
            update();
            changeData();
            getCurrentOrder();
          }
        }
      },
    );
  }

  GoogleMapController? mapController;

  Rx<PolylinePoints> polylinePoints = PolylinePoints().obs;
  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  RxMap<String, Marker> markers = <String, Marker>{}.obs;

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? taxiIcon;

  setIcons() async {
    if (Constant.selectedMapType == 'google') {
      final Uint8List departure = await Constant()
          .getBytesFromAsset('assets/images/location_black3x.png', 100);
      final Uint8List destination = await Constant()
          .getBytesFromAsset('assets/images/location_orange3x.png', 100);
      final Uint8List driver = await Constant()
          .getBytesFromAsset('assets/images/food_delivery.png', 120);

      departureIcon = BitmapDescriptor.fromBytes(departure);
      destinationIcon = BitmapDescriptor.fromBytes(destination);
      taxiIcon = BitmapDescriptor.fromBytes(driver);
    }
  }

  getDirections() async {
    if (currentOrder.value.id != null) {
      if (currentOrder.value.status != Constant.driverPending) {
        if (currentOrder.value.status == Constant.orderShipped) {
          List<LatLng> polylineCoordinates = [];

          PolylineResult result = await polylinePoints.value
              .getRouteBetweenCoordinates(
                  googleApiKey: Constant.mapAPIKey,
                  request: PolylineRequest(
                      origin: PointLatLng(
                          driverModel.value.location!.latitude ?? 0.0,
                          driverModel.value.location!.longitude ?? 0.0),
                      destination: PointLatLng(
                          currentOrder.value.vendor!.latitude ?? 0.0,
                          currentOrder.value.vendor!.longitude ?? 0.0),
                      mode: TravelMode.driving));
          if (result.points.isNotEmpty) {
            for (var point in result.points) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            }
          }

          markers.remove("Departure");
          markers['Departure'] = Marker(
              markerId: const MarkerId('Departure'),
              infoWindow: const InfoWindow(title: "Departure"),
              position: LatLng(currentOrder.value.vendor!.latitude ?? 0.0,
                  currentOrder.value.vendor!.longitude ?? 0.0),
              icon: departureIcon!);
          // ignore: invalid_use_of_protected_member
          if (markers.value.containsKey("Destination")) {
            markers.remove("Destination");
          }
          // markers['Destination'] = Marker(
          //     markerId: const MarkerId('Destination'),
          //     infoWindow: const InfoWindow(title: "Destination"),
          //     position: LatLng(currentOrder.value.address!.location!.latitude ?? 0.0, currentOrder.value.address!.location!.longitude ?? 0.0),
          //     icon: destinationIcon!);

          markers.remove("Driver");
          markers['Driver'] = Marker(
              markerId: const MarkerId('Driver'),
              infoWindow: const InfoWindow(title: "Driver"),
              position: LatLng(driverModel.value.location!.latitude ?? 0.0,
                  driverModel.value.location!.longitude ?? 0.0),
              icon: taxiIcon!,
              rotation: double.parse(driverModel.value.rotation.toString()));

          addPolyLine(polylineCoordinates);
        } else if (currentOrder.value.status == Constant.orderInTransit) {
          List<LatLng> polylineCoordinates = [];

          PolylineResult result = await polylinePoints.value
              .getRouteBetweenCoordinates(
                  googleApiKey: Constant.mapAPIKey,
                  request: PolylineRequest(
                      origin: PointLatLng(
                          driverModel.value.location!.latitude ?? 0.0,
                          driverModel.value.location!.longitude ?? 0.0),
                      destination: PointLatLng(
                          currentOrder.value.address!.location!.latitude ?? 0.0,
                          currentOrder.value.address!.location!.longitude ??
                              0.0),
                      mode: TravelMode.driving));

          if (result.points.isNotEmpty) {
            for (var point in result.points) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            }
          }
          // ignore: invalid_use_of_protected_member
          if (markers.value.containsKey("Departure")) {
            markers.remove("Departure");
          }
          // markers['Departure'] = Marker(
          //     markerId: const MarkerId('Departure'),
          //     infoWindow: const InfoWindow(title: "Departure"),
          //     position: LatLng(currentOrder.value.vendor!.latitude ?? 0.0, currentOrder.value.vendor!.longitude ?? 0.0),
          //     icon: departureIcon!);

          markers.remove("Destination");
          markers['Destination'] = Marker(
              markerId: const MarkerId('Destination'),
              infoWindow: const InfoWindow(title: "Destination"),
              position: LatLng(
                  currentOrder.value.address!.location!.latitude ?? 0.0,
                  currentOrder.value.address!.location!.longitude ?? 0.0),
              icon: destinationIcon!);

          markers.remove("Driver");
          markers['Driver'] = Marker(
              markerId: const MarkerId('Driver'),
              infoWindow: const InfoWindow(title: "Driver"),
              position: LatLng(driverModel.value.location!.latitude ?? 0.0,
                  driverModel.value.location!.longitude ?? 0.0),
              icon: taxiIcon!,
              rotation: double.parse(driverModel.value.rotation.toString()));
          addPolyLine(polylineCoordinates);
        }
      } else {
        List<LatLng> polylineCoordinates = [];

        PolylineResult result = await polylinePoints.value
            .getRouteBetweenCoordinates(
                googleApiKey: Constant.mapAPIKey,
                request: PolylineRequest(
                    origin: PointLatLng(
                        currentOrder.value.author!.location!.latitude ?? 0.0,
                        currentOrder.value.author!.location!.longitude ?? 0.0),
                    destination: PointLatLng(
                        currentOrder.value.vendor!.latitude ?? 0.0,
                        currentOrder.value.vendor!.longitude ?? 0.0),
                    mode: TravelMode.driving));

        if (result.points.isNotEmpty) {
          for (var point in result.points) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
        }

        markers.remove("Departure");
        markers['Departure'] = Marker(
            markerId: const MarkerId('Departure'),
            infoWindow: const InfoWindow(title: "Departure"),
            position: LatLng(currentOrder.value.vendor!.latitude ?? 0.0,
                currentOrder.value.vendor!.longitude ?? 0.0),
            icon: departureIcon!);

        markers.remove("Destination");
        markers['Destination'] = Marker(
            markerId: const MarkerId('Destination'),
            infoWindow: const InfoWindow(title: "Destination"),
            position: LatLng(
                currentOrder.value.address!.location!.latitude ?? 0.0,
                currentOrder.value.address!.location!.longitude ?? 0.0),
            icon: destinationIcon!);

        markers.remove("Driver");
        markers['Driver'] = Marker(
            markerId: const MarkerId('Driver'),
            infoWindow: const InfoWindow(title: "Driver"),
            position: LatLng(driverModel.value.location!.latitude ?? 0.0,
                driverModel.value.location!.longitude ?? 0.0),
            icon: taxiIcon!,
            rotation: double.parse(driverModel.value.rotation.toString()));
        addPolyLine(polylineCoordinates);
      }
    }
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    // mapOsmController.clearAllRoads();
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: AppThemeData.secondary300,
      points: polylineCoordinates,
      width: 8,
      geodesic: true,
    );
    polyLines[id] = polyline;
    update();
    updateCameraLocation(polylineCoordinates.first, mapController);
  }

  Future<void> updateCameraLocation(
    LatLng source,
    GoogleMapController? mapController,
  ) async {
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: source,
          zoom: currentOrder.value.id == null ||
                  currentOrder.value.status == Constant.driverPending
              ? 16
              : 20,
          bearing: double.parse(driverModel.value.rotation.toString()),
        ),
      ),
    );
  }

  void animateToSource() {
    osmMapController.move(
        location.LatLng(driverModel.value.location!.latitude ?? 0.0,
            driverModel.value.location!.longitude ?? 0.0),
        16);
  }

  Rx<location.LatLng> source =
      location.LatLng(21.1702, 72.8311).obs; // Start (e.g., Surat)
  Rx<location.LatLng> current =
      location.LatLng(21.1800, 72.8400).obs; // Moving marker
  Rx<location.LatLng> destination =
      location.LatLng(21.2000, 72.8600).obs; // Destination

  setOsmMapMarker() {
    osmMarkers.value = [
      flutterMap.Marker(
        point: current.value,
        width: 45,
        height: 45,
        rotate: true,
        child: Image.asset('assets/images/food_delivery.png'),
      ),
      flutterMap.Marker(
        point: source.value,
        width: 40,
        height: 40,
        child: Image.asset('assets/images/location_black3x.png'),
      ),
      flutterMap.Marker(
        point: destination.value,
        width: 40,
        height: 40,
        child: Image.asset('assets/images/location_orange3x.png'),
      )
    ];
  }

  void getOSMPolyline() async {
    try {
      if (currentOrder.value.id != null) {
        if (currentOrder.value.status != Constant.driverPending) {
          print(
              "Order Status :: ${currentOrder.value.status} :: OrderId :: ${currentOrder.value.id}} ::");
          if (currentOrder.value.status == Constant.orderShipped) {
            current.value = location.LatLng(
                driverModel.value.location!.latitude ?? 0.0,
                driverModel.value.location!.longitude ?? 0.0);
            destination.value = location.LatLng(
              currentOrder.value.vendor!.latitude ?? 0.0,
              currentOrder.value.vendor!.longitude ?? 0.0,
            );
            animateToSource();
            fetchRoute(current.value, destination.value).then((value) {
              setOsmMapMarker();
            });
          } else if (currentOrder.value.status == Constant.orderInTransit) {
            print(
                ":::::::::::::${currentOrder.value.status}::::::::::::::::::44");
            current.value = location.LatLng(
                driverModel.value.location!.latitude ?? 0.0,
                driverModel.value.location!.longitude ?? 0.0);
            destination.value = location.LatLng(
              currentOrder.value.address!.location!.latitude ?? 0.0,
              currentOrder.value.address!.location!.longitude ?? 0.0,
            );
            setOsmMapMarker();
            fetchRoute(current.value, destination.value).then((value) {
              setOsmMapMarker();
            });
            animateToSource();
          }
        } else {
          print("====>5");
          current.value = location.LatLng(
              currentOrder.value.author!.location!.latitude ?? 0.0,
              currentOrder.value.author!.location!.longitude ?? 0.0);

          destination.value = location.LatLng(
              currentOrder.value.vendor!.latitude ?? 0.0,
              currentOrder.value.vendor!.longitude ?? 0.0);
          animateToSource();
          fetchRoute(current.value, destination.value).then((value) {
            setOsmMapMarker();
          });
          animateToSource();
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  RxList<location.LatLng> routePoints = <location.LatLng>[].obs;
  Future<void> fetchRoute(
      location.LatLng source, location.LatLng destination) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final geometry = decoded['routes'][0]['geometry']['coordinates'];

      routePoints.clear();
      for (var coord in geometry) {
        final lon = coord[0];
        final lat = coord[1];
        routePoints.add(location.LatLng(lat, lon));
      }
    } else {
      print("Failed to get route: ${response.body}");
    }
  }

  void checkForStaleOrders() async {
    print('🔍 Checking stale orders...');

    final inProgressIds = driverModel.value.inProgressOrderID;

    // If null or empty, clear any leftover state
    if (inProgressIds == null || inProgressIds.isEmpty) {
      print('✅ No in-progress orders found.');
      currentOrder.value = OrderModel(); //
      update();
      return;
    }

    List<String> validOrderIds = [];
    OrderModel? activeOrder;

    for (String orderId in inProgressIds) {
      final order = await FireStoreUtils.getOrderById(orderId);

      if (order == null) continue;

      print('🧾 Order ${order.id} - Status: ${order.status}');

      if (order.status != Constant.orderCompleted) {
        validOrderIds.add(order.id!);
        activeOrder ??= order;
      } else {
        print(' Removing completed order: ${order.id}');
      }
    }

    // Save cleaned-up list
    driverModel.value.inProgressOrderID = validOrderIds;
    await FireStoreUtils.updateUser(driverModel.value);

    if (activeOrder != null) {
      currentOrder.value = activeOrder;
      print(' Active order set: ${activeOrder.id}');
    } else {
      currentOrder.value = OrderModel();
      print('No valid orders found. Cleared currentOrder.');
    }

    update();
  }

// Method to calculate and draw route
  Future<void> calculateAndDrawRoute() async {
    if (currentOrder.value.id == null) return;

    LatLng? driverLocation;
    LatLng? destinationLocation;

    // Get driver's current location
    if (driverModel.value.location != null) {
      driverLocation = LatLng(
        driverModel.value.location!.latitude ?? 0.0,
        driverModel.value.location!.longitude ?? 0.0,
      );
    }

    // Determine destination based on order status
    if (currentOrder.value.status == Constant.orderShipped ||
        currentOrder.value.status == Constant.driverAccepted) {
      // Route to restaurant
      destinationLocation = LatLng(
        currentOrder.value.vendor!.latitude ?? 0.0,
        currentOrder.value.vendor!.longitude ?? 0.0,
      );
    } else if (currentOrder.value.status == Constant.orderInTransit) {
      // Route to customer
      destinationLocation = LatLng(
        currentOrder.value.address!.location!.latitude ?? 0.0,
        currentOrder.value.address!.location!.longitude ?? 0.0,
      );
    }

    if (driverLocation != null && destinationLocation != null) {
      if (Constant.selectedMapType == "osm") {
        await calculateOSMRoute(driverLocation, destinationLocation);
      } else {}
    }
  }

// For Google Maps - Calculate route using Google Directions API

// For OSM - Calculate route using OSRM
  Future<void> calculateOSMRoute(LatLng origin, LatLng destination) async {
    try {
      final String url = 'https://router.project-osrm.org/route/v1/driving/'
          '${origin.longitude},${origin.latitude};'
          '${destination.longitude},${destination.latitude}'
          '?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final coordinates = route['geometry']['coordinates'] as List;

          // Convert to LatLng points
          routePoints.clear();
          for (var coord in coordinates) {
            routePoints.add(location.LatLng(coord[1], coord[0]));
          }

          update();
        }
      }
    } catch (e) {
      print('Error calculating OSM route: $e');
    }
  }

// Polyline decoder for Google Maps
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng p = LatLng((lat / 1E5), (lng / 1E5));
      polylineCoordinates.add(p);
    }
    return polylineCoordinates;
  }

// Method to clear map data
  void clearMapp() {
    polyLines.clear();
    markers.clear();
    routePoints.clear();
    osmMarkers.clear();
    update();
  }

// Method to update markers based on current order
  void updateMapMarkers() {
    if (currentOrder.value.id == null) return;

    if (Constant.selectedMapType == "osm") {
      updateOSMMarkers();
    } else {
      updateGoogleMapMarkers();
    }
  }

// Update OSM markers
  void updateOSMMarkers() {
    osmMarkers.clear();

    // Driver marker
    if (driverModel.value.location != null) {
      osmMarkers.add(
        flutterMap.Marker(
            point: location.LatLng(
              driverModel.value.location!.latitude!,
              driverModel.value.location!.longitude!,
            ),
            child: Image.asset('assets/images/food_delivery.png')),
      );
    }

    // Destination marker based on order status
    if (currentOrder.value.status == Constant.orderShipped ||
        currentOrder.value.status == Constant.driverAccepted) {
      // Restaurant marker
      osmMarkers.add(
        flutterMap.Marker(
          point: location.LatLng(
            currentOrder.value.vendor!.latitude!,
            currentOrder.value.vendor!.longitude!,
          ),
          child: const Icon(
            Icons.restaurant,
            color: AppThemeData.success400,
            size: 30,
          ),
        ),
      );
    } else if (currentOrder.value.status == Constant.orderInTransit) {
      // Customer marker
      osmMarkers.add(
        flutterMap.Marker(
          point: location.LatLng(
            currentOrder.value.address!.location!.latitude!,
            currentOrder.value.address!.location!.longitude!,
          ),
          child: const Icon(
            Icons.location_pin,
            color: AppThemeData.danger300,
            size: 30,
          ),
        ),
      );
    }
  }

// Update Google Map markers
  void updateGoogleMapMarkers() {
    markers.clear();

    // Driver marker
    if (driverModel.value.location != null) {
      markers['driver'] = Marker(
        markerId: const MarkerId('driver'),
        position: LatLng(
          driverModel.value.location!.latitude!,
          driverModel.value.location!.longitude!,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Driver Location'),
      );
    }

    // Destination marker based on order status
    if (currentOrder.value.status == Constant.orderShipped ||
        currentOrder.value.status == Constant.driverAccepted) {
      // Restaurant marker
      markers['restaurant'] = Marker(
        markerId: const MarkerId('restaurant'),
        position: LatLng(
          currentOrder.value.vendor!.latitude!,
          currentOrder.value.vendor!.longitude!,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: currentOrder.value.vendor!.title),
      );
    } else if (currentOrder.value.status == Constant.orderInTransit) {
      // Customer marker
      markers['customer'] = Marker(
        markerId: const MarkerId('customer'),
        position: LatLng(
          currentOrder.value.address!.location!.latitude!,
          currentOrder.value.address!.location!.longitude!,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Customer Location'),
      );
    }
  }

// Call this method when order status changes or when initializing
  void initializeMapForCurrentOrder() {
    if (currentOrder.value.id != null) {
      updateMapMarkers();
      calculateAndDrawRoute();
    }
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
