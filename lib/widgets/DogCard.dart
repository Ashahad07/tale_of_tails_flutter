import 'package:flutter/material.dart';
import 'package:tot_app/models/DogModel.dart';

class DogCard extends StatelessWidget {
  final DogModel dog;
  final VoidCallback onTap;
  final String imageUrl;

  const DogCard({
    super.key,
    required this.dog,
    required this.onTap,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth * 0.28;
    final cardHeight = screenWidth * 0.32;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: cardHeight,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                child: Image.network(
                  imageUrl,
                  width: imageWidth,
                  height: cardHeight,

                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => const Icon(Icons.broken_image, size: 60),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dog.name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: screenWidth * 0.01),
                      Text(
                        dog.breed,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: screenWidth * 0.035,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (dog.breedGroup != null)
                        Text(
                          dog.breedGroup!,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
