import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 👈 important

class JourneySummaryScreen extends StatefulWidget {
  final dynamic journey; // Ideally strongly type it!

  const JourneySummaryScreen({super.key, required this.journey});

  @override
  State<JourneySummaryScreen> createState() => _JourneySummaryScreenState();
}

class _JourneySummaryScreenState extends State<JourneySummaryScreen> {
  late String formattedStartTime;
  late String formattedEndTime;

  @override
  void initState() {
    super.initState();
    formatTimes();
  }

  void formatTimes() {
    try {
      final start = DateTime.parse(widget.journey.startTime);
      final end = DateTime.parse(widget.journey.endTime);
      final formatter = DateFormat('dd MMM yyyy, hh:mm a');
      formattedStartTime = formatter.format(start);
      formattedEndTime = formatter.format(end);
    } catch (e) {
      formattedStartTime = widget.journey.startTime.toString();
      formattedEndTime = widget.journey.endTime.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Journey Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Start Location"),
                _buildSectionContent(
                  "Lat: ${widget.journey.startLatitude}, Lng: ${widget.journey.startLongitude}",
                ),

                const SizedBox(height: 16),

                _buildSectionTitle("End Location"),
                _buildSectionContent(
                  "Lat: ${widget.journey.endLatitude}, Lng: ${widget.journey.endLongitude}",
                ),

                const SizedBox(height: 16),

                _buildSectionTitle("Start Time"),
                _buildSectionContent(formattedStartTime),

                const SizedBox(height: 16),

                _buildSectionTitle("End Time"),
                _buildSectionContent(formattedEndTime),

                const SizedBox(height: 16),

                _buildSectionTitle("Total Distance"),
                _buildSectionContent(
                  "${(widget.journey.totalDistance / 1000).toStringAsFixed(2)} km",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }
}
