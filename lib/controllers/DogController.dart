import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tot_app/models/DogModel.dart';
import 'package:tot_app/services/DogService.dart';

class DogController extends GetxController {
  var dogs = <DogModel>[].obs;
  var isLoading = false.obs;
  var dogImageUrls = <String>[].obs;

  var searchText = ''.obs;

  @override
  void onInit() {
    fetchDogData();
    fetchDogImages();
    super.onInit();
  }

  List<DogModel> get filteredDogs {
    if (searchText.value.isEmpty) {
      return dogs;
    } else {
      return dogs
          .where(
            (dog) =>
                dog.name.toLowerCase().contains(
                  searchText.value.toLowerCase(),
                ) ||
                dog.breedGroup!.toLowerCase().contains(
                  searchText.value.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  void fetchDogData() async {
    isLoading.value = true;
    try {
      dogs.value = await DogService.fetchDogs();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void fetchDogImages() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await FirebaseFirestore.instance
              .collection('dog_images')
              .doc('image_urls')
              .get();

      if (doc.exists) {
        List<dynamic> urls = doc.data()?['urls'] ?? [];
        dogImageUrls.value = List<String>.from(urls);
      }
    } catch (e) {
      print("Error fetching dog images: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
