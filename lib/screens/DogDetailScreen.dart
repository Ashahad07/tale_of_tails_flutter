import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tot_app/models/DogModel.dart';
import 'package:delightful_toast/delight_toast.dart';

class DogDetailScreen extends StatelessWidget {
  final DogModel dog;
  final String imageUrl;

  const DogDetailScreen({super.key, required this.dog, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final imageSize = screen.width * 0.85;

    void _saveDog(BuildContext context, DogModel dog, String imageUrl) async {
      final box = await Hive.openBox<DogModel>('savedDogs');
      final isAlreadySaved = box.values.any((d) => d.name == dog.name);

      if (isAlreadySaved) {
        DelightToastBar(
          autoDismiss: true,
          position: DelightSnackbarPosition.top,
          snackbarDuration: Duration(seconds: 3),
          builder:
              (context) => ToastCard(
                leading: const Icon(Icons.flutter_dash, size: 28),
                title: Text(
                  "${dog.name} is already saved!",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => DelightToastBar.removeAll(),
                ),
              ),
        ).show(context);
      } else {
        final savedDog = DogModel(
          name: dog.name,
          breed: dog.breed,
          image: imageUrl,
          breedGroup: dog.breedGroup,
          description: dog.description,
        );
        await box.add(savedDog);

        DelightToastBar(
          autoDismiss: true,
          position: DelightSnackbarPosition.top,
          snackbarDuration: Duration(seconds: 3),
          builder:
              (context) => ToastCard(
                leading: const Icon(Icons.flutter_dash, size: 28),
                title: Text(
                  "${dog.name} saved successfully!",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => DelightToastBar.removeAll(),
                ),
              ),
        ).show(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(dog.name),
        backgroundColor: Colors.green.shade700,
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: Hive.box<DogModel>('savedDogs').listenable(),
        builder: (context, Box<DogModel> box, _) {
          final isDogAlreadySaved = box.values.any((d) => d.name == dog.name);

          return FloatingActionButton.extended(
            onPressed:
                isDogAlreadySaved
                    ? null
                    : () => _saveDog(context, dog, imageUrl),
            backgroundColor:
                isDogAlreadySaved ? Colors.grey : const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            icon: Icon(
              isDogAlreadySaved
                  ? Icons.bookmark_added
                  : Icons.bookmark_add_outlined,
            ),
            label: Text(isDogAlreadySaved ? "Saved" : "Save Dog"),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screen.width * 0.05,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Dog Name
            Text(
              dog.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Breed
            if (dog.breedGroup != null)
              Text(
                dog.breedGroup!,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),

            const SizedBox(height: 24),

            // Description
            if (dog.description != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      dog.description!,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
