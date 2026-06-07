import 'dart:typed_data';

import 'package:does_it_fit_me/models/clothing_category.dart';

class TryOnSession {
  TryOnSession();

  Uint8List? userPhotoBytes;
  String? userPhotoMimeType;

  Uint8List? clothingSourceBytes;
  String? clothingSourceMimeType;
  Uint8List? processedClothingBytes;
  String? processedClothingMimeType;

  ClothingCategory? category;

  Uint8List? resultBytes;
  String? resultMimeType;

  String? colorVariant;

  bool get hasUserPhoto => userPhotoBytes != null;
  bool get hasClothing => processedClothingBytes != null || clothingSourceBytes != null;
  bool get hasResult => resultBytes != null;

  Uint8List get effectiveClothingBytes =>
      processedClothingBytes ?? clothingSourceBytes!;

  String get effectiveClothingMimeType =>
      processedClothingMimeType ?? clothingSourceMimeType ?? 'image/jpeg';
}
