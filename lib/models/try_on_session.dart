import 'dart:typed_data';

import 'package:does_it_fit_me/models/clothing_category.dart';

class TryOnSession {
  TryOnSession();

  Uint8List? userPhotoBytes;
  String? userPhotoMimeType;

  Uint8List? clothingSourceBytes;
  String? clothingSourceMimeType;

  ClothingCategory? category;

  Uint8List? resultBytes;
  String? resultMimeType;

  String? colorVariant;

  bool get hasUserPhoto => userPhotoBytes != null;
  bool get hasClothing => clothingSourceBytes != null;
  bool get hasResult => resultBytes != null;
}
