import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tot_app/models/DogModel.dart';

class SavedDogsScreen extends StatelessWidget {
  const SavedDogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dogBox = Hive.box<DogModel>('savedDogs');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Dogs'),
        backgroundColor: Colors.green[700],
      ),
      body: ValueListenableBuilder(
        valueListenable: dogBox.listenable(),
        builder: (context, Box<DogModel> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No saved dogs.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final dog = box.getAt(index);
              if (dog == null) return const SizedBox();

              return Dismissible(
                key: Key(dog.name + index.toString()),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  return await showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Remove Dog'),
                          content: Text(
                            'Are you sure you want to remove "${dog.name}" from saved dogs?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Remove',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                },
                onDismissed: (_) {
                  DelightToastBar(
                    autoDismiss: true,
                    position: DelightSnackbarPosition.top,
                    snackbarDuration: const Duration(seconds: 3),
                    builder:
                        (context) => ToastCard(
                          leading: const Icon(Icons.flutter_dash, size: 28),
                          title: Text(
                            "${dog.name} removed from saved dogs!",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed:
                                () =>
                                    DelightToastBar.removeAll(), // ❌ Correct here
                          ),
                        ),
                  ).show(context);

                  box.deleteAt(index); // ✅ Call delete without await (or after)
                },

                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        dog.image,
                        width: 80,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dog.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          dog.breedGroup ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    subtitle: Text(dog.breed),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
