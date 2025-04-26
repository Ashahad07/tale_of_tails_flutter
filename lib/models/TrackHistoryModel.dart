import 'package:hive/hive.dart';

part 'TrackHistoryModel.g.dart'; // important

@HiveType(typeId: 1)
class TrackHistory extends HiveObject {
  @HiveField(0)
  final double startLatitude;

  @HiveField(1)
  final double startLongitude;

  @HiveField(2)
  final double endLatitude;

  @HiveField(3)
  final double endLongitude;

  @HiveField(4)
  final String startTime;

  @HiveField(5)
  final String endTime;

  @HiveField(6)
  final double totalDistance; // in meters

  @HiveField(7)
  final String totalTime; // Total time in hh:mm:ss format

  TrackHistory({
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
    required this.startTime,
    required this.endTime,
    required this.totalDistance,
    required this.totalTime, 
  });

  // Method to calculate total time taken in "hh:mm:ss" format
  static String calculateTotalTime(String startTime, String endTime) {
    final start = DateTime.parse(startTime);
    final end = DateTime.parse(endTime);
    final duration = end.difference(start);

    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60);
    final seconds = (duration.inSeconds % 60);

    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  // Helper function to ensure two digits in time format
  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
