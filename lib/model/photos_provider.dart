import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhotosNotifier extends StateNotifier<List<String>> {
  PhotosNotifier() : super([]);

  void addPhotos(List<String> newPhotos) {
    state = [...state, ...newPhotos];
  }

  void removePhoto(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i]
    ];
  }

  void setPhotos(List<String> photos) {
    state = photos;
  }
}

final photosProvider = StateNotifierProvider<PhotosNotifier, List<String>>(
      (ref) => PhotosNotifier(),
);