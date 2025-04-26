import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tot_app/controllers/LocationController.dart';
import 'package:tot_app/screens/TrackHistoryScreen.dart';

class MapTrackingScreen extends StatelessWidget {
  const MapTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 0,
        title: const Text(
          "Live Tracking",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: () => Get.to(() => TrackHistoryScreen()),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                backgroundColor: Colors.white.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.history, size: 22),
              label: const Text(
                "History",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            return FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter:
                    controller.path.isNotEmpty
                        ? controller.path.last
                        : const LatLng(17.6805, 74.0183),
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.tot_app',
                ),
                if (controller.startPoint.value != null) // Add start marker
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.startPoint.value!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.circle,
                          color: Colors.blueGrey,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                if (controller.path.isNotEmpty)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.path.last,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.green,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                if (controller.endPoint.value != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.endPoint.value!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                if (controller.path.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: controller.path,
                        strokeWidth: 5,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
              ],
            );
          }),

          // Floating Buttons
          Positioned(
            bottom: 40,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "current_location",
                  mini: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 4,
                  onPressed: () async {
                    final pos = await Geolocator.getCurrentPosition();
                    controller.mapController.move(
                      LatLng(pos.latitude, pos.longitude),
                      16,
                    );
                  },
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return FloatingActionButton.extended(
                      heroTag: "tracking_control",
                      backgroundColor:
                          controller.isTracking.value
                              ? Colors.red
                              : Colors.green,
                      elevation: 4,
                      onPressed:
                          controller.isTracking.value
                              ? controller.stopTracking
                              : controller.startTracking,
                      label: Text(
                        controller.isTracking.value ? "Stop" : "Start",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      icon: Icon(
                        controller.isTracking.value
                            ? Icons.stop
                            : Icons.play_arrow,
                        size: 24,
                        color: Colors.white,
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
