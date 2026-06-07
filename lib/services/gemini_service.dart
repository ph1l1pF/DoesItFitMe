import 'dart:convert';
import 'dart:typed_data';

import 'package:does_it_fit_me/models/clothing_category.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiException implements Exception {
  GeminiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class GeminiImageResult {
  GeminiImageResult({
    required this.bytes,
    required this.mimeType,
    this.text,
  });

  final Uint8List bytes;
  final String mimeType;
  final String? text;
}

class GeminiService {
  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  static const _model = 'gemini-3.1-flash-image';
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  final http.Client _client;

  String get _apiKey {
    final key = dotenv.env['GEMINI_API_KEY']?.trim();
    if (key == null || key.isEmpty) {
      throw GeminiException(
        'API key missing. Please add it to the .env file.',
      );
    }
    return key;
  }

  Future<GeminiImageResult> generateTryOn({
    required Uint8List personBytes,
    required String personMimeType,
    required Uint8List clothingBytes,
    required String clothingMimeType,
    required ClothingCategory category,
    String? colorVariant,
  }) {
    final colorInstruction = colorVariant != null
        ? ' Change the clothing color to $colorVariant while keeping style and fit identical.'
        : '';

    final prompt = '''
You are a professional virtual try-on AI. Create a photorealistic result.

Image 1: A photo of a person (reference for identity, pose, and scene).
Image 2: A photo of a ${category.promptName} clothing item (reference for the garment; may include background, screenshots, or UI — use only the relevant garment).

Task: Generate a highly realistic photo of the SAME person from Image 1 now wearing the clothing from Image 2 as a ${category.label}.
$colorInstruction

Strict requirements:
- Identify the correct ${category.label} in Image 2 and ignore backgrounds, text, watermarks, and unrelated items.
- Preserve the person's face, hair, skin tone, body shape, pose, and background from Image 1.
- The ${category.label} must look naturally worn with realistic folds, shadows, lighting, and fit.
- Match the lighting and perspective of the original person photo.
- No visible artifacts, distortions, or extra limbs.
- Output must look like a real photograph, not an illustration.
''';

    return _generateImage(
      prompt: prompt,
      referenceImages: [
        (bytes: personBytes, mimeType: personMimeType),
        (bytes: clothingBytes, mimeType: clothingMimeType),
      ],
      aspectRatio: '3:4',
      imageSize: '2K',
    );
  }

  Future<GeminiImageResult> _generateImage({
    required String prompt,
    required List<({Uint8List bytes, String mimeType})> referenceImages,
    required String aspectRatio,
    String imageSize = '1K',
  }) async {
    final parts = <Map<String, dynamic>>[
      {'text': prompt},
      ...referenceImages.map(
        (image) => {
          'inline_data': {
            'mime_type': image.mimeType,
            'data': base64Encode(image.bytes),
          },
        },
      ),
    ];

    final body = {
      'contents': [
        {'parts': parts},
      ],
      'generationConfig': {
        'responseModalities': ['TEXT', 'IMAGE'],
        'imageConfig': {
          'aspectRatio': aspectRatio,
          'imageSize': imageSize,
        },
      },
    };

    final uri = Uri.parse('$_baseUrl/$_model:generateContent');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': _apiKey,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw GeminiException(_parseApiError(response.statusCode, response.body));
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = json['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw GeminiException('No response from the AI service.');
    }

    final content = candidates.first['content'] as Map<String, dynamic>?;
    final responseParts = content?['parts'] as List<dynamic>?;
    if (responseParts == null || responseParts.isEmpty) {
      throw GeminiException('Empty AI response.');
    }

    String? text;
    Uint8List? imageBytes;
    String? imageMimeType;

    for (final part in responseParts) {
      final partMap = part as Map<String, dynamic>;
      if (partMap.containsKey('text')) {
        text = partMap['text'] as String?;
      }
      final inlineData = partMap['inline_data'] ?? partMap['inlineData'];
      if (inlineData != null) {
        final data = inlineData as Map<String, dynamic>;
        final base64Data = data['data'] as String?;
        if (base64Data != null) {
          imageBytes = base64Decode(base64Data);
          imageMimeType =
              data['mime_type'] as String? ?? data['mimeType'] as String?;
        }
      }
    }

    if (imageBytes == null) {
      throw GeminiException(
        text ?? 'The AI did not generate an image. Please try again.',
      );
    }

    return GeminiImageResult(
      bytes: imageBytes,
      mimeType: imageMimeType ?? 'image/png',
      text: text,
    );
  }

  String _parseApiError(int statusCode, String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final error = json['error'] as Map<String, dynamic>?;
      final message = error?['message'] as String?;
      if (message != null && message.isNotEmpty) {
        return 'Image generation failed ($statusCode): $message';
      }
    } catch (_) {}
    return 'Image generation failed ($statusCode).';
  }

  void dispose() => _client.close();
}
