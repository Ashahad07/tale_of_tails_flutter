import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveJourney(List<LatLng> path, LatLng startPoint, LatLng endPoint, double totalDistance) async {
    try {
      await _firestore.collection('journeys').add({
        'startPoint': {'latitude': startPoint.latitude, 'longitude': startPoint.longitude},
        'endPoint': {'latitude': endPoint.latitude, 'longitude': endPoint.longitude},
        'path': path.map((latLng) => {'latitude': latLng.latitude, 'longitude': latLng.longitude}).toList(),
        'totalDistance': totalDistance,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Journey saved successfully');
    } catch (e) {
      print('Error saving journey: $e');
    }
  }
}
