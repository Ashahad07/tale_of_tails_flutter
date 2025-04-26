import 'package:hive/hive.dart';
part 'DogModel.g.dart';

@HiveType(typeId: 0)
class DogModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String breed;


  @HiveField(2)
  final String? breedGroup;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String image;
  DogModel({
    required this.name,
    required this.breed,
    required this.image,
    this.breedGroup,
    this.description,
  });

  factory DogModel.fromJson(Map<String, dynamic> json) {
    return DogModel(
      name: json['name'] ?? '',
      breed: json['breed'] ?? '',
      image: json['image'] ?? '',
      breedGroup: json['breed_group'],
      description: json['description'],
    );
  }
}