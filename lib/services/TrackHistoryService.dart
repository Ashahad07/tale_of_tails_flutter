import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:tot_app/models/TrackHistoryModel.dart';

class TrackHistoryService {
  static const String boxName = 'journeys';

  Future<void> saveJourney(List<LatLng> path) async {
    final box = await Hive.openBox<TrackHistory>(boxName);

    if (path.isEmpty) return;

    final start = path.first;
    final end = path.last;

    double totalDistance = 0;
    final distance = Distance();
    for (int i = 1; i < path.length; i++) {
      totalDistance += distance(
        path[i - 1],
        path[i],
      );
    }

    final now = DateTime.now();
    final startTime = DateTime.now().subtract(Duration(seconds: path.length * 2)); // Approximation
    final endTime = now;

    // Calculate total time as the difference between start and end time
    final duration = endTime.difference(startTime);
    final totalTime = _formatDuration(duration); // Format duration into a readable format

    final journey = TrackHistory(
      startLatitude: start.latitude,
      startLongitude: start.longitude,
      endLatitude: end.latitude,
      endLongitude: end.longitude,
      startTime: startTime.toString(),
      endTime: endTime.toString(),
      totalDistance: totalDistance,
      totalTime: totalTime, // Pass the total time to the constructor
    );

    await box.add(journey);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<List<TrackHistory>> getJourneys() async {
    final box = await Hive.openBox<TrackHistory>(boxName);
    return box.values.toList();
  }

  Future<void> clearOldTrackHistory() async {
    final box = await Hive.openBox<TrackHistory>(boxName);
    await box.clear();
    print("Old TrackHistory data cleared ✅");
  }
}
