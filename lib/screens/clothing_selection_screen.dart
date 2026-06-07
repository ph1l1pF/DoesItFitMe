import 'package:does_it_fit_me/models/try_on_session.dart';
import 'package:does_it_fit_me/screens/category_screen.dart';
import 'package:does_it_fit_me/theme/app_theme.dart';
import 'package:does_it_fit_me/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ClothingSelectionScreen extends StatefulWidget {
  const ClothingSelectionScreen({super.key, required this.session});

  final TryOnSession session;

  @override
  State<ClothingSelectionScreen> createState() =>
      _ClothingSelectionScreenState();
}

class _ClothingSelectionScreenState extends State<ClothingSelectionScreen> {
  final _picker = ImagePicker();

  Future<void> _pickClothingImage(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 92,
    );
    if (file == null || !mounted) return;

    widget.session.clothingSourceBytes = await file.readAsBytes();
    widget.session.clothingSourceMimeType = _mimeTypeFromPath(file.path);

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CategoryScreen(session: widget.session),
      ),
    );
  }

  String _mimeTypeFromPath(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clothing item')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StepHeader(
                step: 2,
                totalSteps: 5,
                title: 'Choose clothing item',
                subtitle:
                    'Upload a product photo or screenshot from Instagram, Zalando, Amazon, etc.',
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.checkroom_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Use a clear photo of the item you want to try on. '
                          'Product shots and shop screenshots both work.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Upload photo',
                icon: Icons.upload_outlined,
                onPressed: () => _pickClothingImage(ImageSource.gallery),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _pickClothingImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Take screenshot photo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
