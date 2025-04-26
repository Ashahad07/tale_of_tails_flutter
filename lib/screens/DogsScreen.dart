import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tot_app/controllers/DogController.dart';
import 'package:tot_app/screens/SavedDogsScreen.dart';
import 'package:tot_app/widgets/DogCard.dart';
import 'package:tot_app/screens/DogDetailScreen.dart';

class DogsScreen extends StatelessWidget {
  final DogController controller = Get.put(DogController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Text(
            "Discover Dogs",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0, // remove shadow for flat modern look
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed:
                  () => Get.to(
                    () => const SavedDogsScreen(),
                    transition:
                        Transition.rightToLeft, // smooth and fading effect
                  ),

              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green.shade800.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
              icon: const Icon(Icons.bookmark_outline, size: 20),
              label: const Text("Saved"),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.green.shade50,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or breed...',
                hintStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                controller.searchText.value = value;
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredDogs.isEmpty) {
                return const Center(
                  child: Text(
                    'No Dogs Found 🐶',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.filteredDogs.length,
                itemBuilder: (context, index) {
                  final dog = controller.filteredDogs[index];

                  final imageUrl =
                      (index < controller.dogImageUrls.length)
                          ? controller.dogImageUrls[index]
                          : '';

                  return DogCard(
                    dog: dog,
                    imageUrl: imageUrl,
                    onTap:
                        () => Get.to(
                          () => DogDetailScreen(dog: dog, imageUrl: imageUrl),
                          transition: Transition.cupertino,
                        ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
