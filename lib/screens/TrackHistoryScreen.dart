import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tot_app/models/TrackHistoryModel.dart';
import 'package:tot_app/screens/JourneySummaryScreen.dart';

class TrackHistoryScreen extends StatelessWidget {
  const TrackHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final journeyBox = Hive.box<TrackHistory>('journeys');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: ValueListenableBuilder(
        valueListenable: journeyBox.listenable(),
        builder: (context, Box<TrackHistory> box, _) {
          final journeys = box.values.toList().reversed.toList();

          print('Journeys count: ${journeys.length}'); // Debugging log

          return Column(
            children: [
              Expanded(
                child:
                    journeys.isEmpty
                        ? const Center(
                          child: Text(
                            "No journeys yet.",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: journeys.length,
                          itemBuilder: (context, index) {
                            final journey = journeys[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => JourneySummaryScreen(journey: journey),
                                );
                              },
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.green.shade600,
                                    child: const Icon(
                                      Icons.directions_walk,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    "Start: ${journey.startTime.split(' ').first}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      "Distance: ${(journey.totalDistance / 1000).toStringAsFixed(2)} km",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),

              if (journeys.isNotEmpty) // Only show if there are journeys
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      label: const Text(
                        "Clear All Journeys",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                  "Are you sure you want to clear all journeys?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text(
                                      "Clear",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );

                        if (confirm ?? false) {
                          await journeyBox.clear();
                        }
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
