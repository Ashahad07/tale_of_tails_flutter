import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:latlong2/latlong.dart';
import 'package:tot_app/models/TrackHistoryModel.dart';

class LocationController extends GetxController {
  final isTracking = false.obs;
  final startPoint = Rxn<LatLng>(); // Starting point
  final endPoint = Rxn<LatLng>();
  final path = <LatLng>[].obs;
  final mapController = MapController();
  final isLoading = false.obs;

  Timer? _timer;
  late DateTime startTime;

  // Check location permissions before starting tracking
  Future<void> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }
  }

  Future<void> startTracking() async {
    isLoading.value = true;

    try {
      await _checkPermission();

      // Reset previous journey
      path.clear();
      startPoint.value = null;
      endPoint.value = null;

      final position = await Geolocator.getCurrentPosition();
      final current = LatLng(position.latitude, position.longitude);
      startPoint.value = current; // Store the start point
      path.add(current);
      startTime = DateTime.now(); // Capture start time
      isTracking.value = true;

      Future.delayed(const Duration(milliseconds: 200), () {
        mapController.move(current, 17);
      });

      // Periodically update the location
      _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
        final pos = await Geolocator.getCurrentPosition();
        final latlng = LatLng(pos.latitude, pos.longitude);
        path.add(latlng);
        mapController.move(latlng, 16);
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void stopTracking() async {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }

    endPoint.value = path.isNotEmpty ? path.last : null;
    isTracking.value = false;

    double totalDistance = 0;
    for (int i = 1; i < path.length; i++) {
      totalDistance += Geolocator.distanceBetween(
        path[i - 1].latitude,
        path[i - 1].longitude,
        path[i].latitude,
        path[i].longitude,
      );
    }

    final endTime = DateTime.now(); // Capture end time
    final totalTime = TrackHistory.calculateTotalTime(
      startTime.toString(),
      endTime.toString(),
    );

    var journey = TrackHistory(
      startLatitude: startPoint.value!.latitude,
      startLongitude: startPoint.value!.longitude,
      endLatitude: endPoint.value!.latitude,
      endLongitude: endPoint.value!.longitude,
      startTime: startTime.toString(),
      endTime: endTime.toString(),
      totalDistance: totalDistance,
      totalTime: totalTime, // Calculate and store total time in hh:mm:ss format
    );

    var box = await Hive.openBox<TrackHistory>('journeys');
    await box.add(journey);

    print("Journey saved ✅");

    // Show the dialog with track details
    _showTrackDetailsDialog(journey);
  }

  // Function to show the track details in a dialog
  void _showTrackDetailsDialog(TrackHistory journey) {
    Get.defaultDialog(
      title: "Journey Completed",
      titleStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      radius: 12.0,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            icon: Icons.location_on,
            label: "Start Point",
            value:
                "Lat: ${journey.startLatitude}, Lng: ${journey.startLongitude}",
          ),
          _buildDetailRow(
            icon: Icons.flag_rounded,
            label: "End Point",
            value: "Lat: ${journey.endLatitude}, Lng: ${journey.endLongitude}",
          ),
          _buildDetailRow(
            icon: Icons.access_time,
            label: "Start Time",
            value: journey.startTime.substring(
              11,
              19,
            ), // Display time in hh:mm:ss
          ),
          _buildDetailRow(
            icon: Icons.access_time,
            label: "End Time",
            value: journey.endTime.substring(
              11,
              19,
            ), // Display time in hh:mm:ss
          ),
          _buildDetailRow(
            icon: Icons.timer,
            label: "Total Time",
            value: journey.totalTime, // Display total time
          ),
          _buildDetailRow(
            icon: Icons.directions_walk,
            label: "Total Distance",
            value: "${journey.totalDistance.toStringAsFixed(2)} meters",
          ),
        ],
      ),
      confirm: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 14),
            backgroundColor: Colors.blueAccent,
          ),
          child: const Text(
            "Close",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
