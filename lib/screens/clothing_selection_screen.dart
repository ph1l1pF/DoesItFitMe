import 'package:does_it_fit_me/models/try_on_session.dart';
import 'package:does_it_fit_me/screens/category_screen.dart';
import 'package:does_it_fit_me/services/gemini_service.dart';
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
  final _gemini = GeminiService();

  bool _isProcessing = false;
  String? _error;

  @override
  void dispose() {
    _gemini.dispose();
    super.dispose();
  }

  Future<void> _pickClothingImage(ImageSource source) async {
    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 92,
      );
      if (file == null || !mounted) return;

      final bytes = await file.readAsBytes();
      final mimeType = _mimeTypeFromPath(file.path);

      widget.session.clothingSourceBytes = bytes;
      widget.session.clothingSourceMimeType = mimeType;

      final extracted = await _gemini.extractClothingItem(
        imageBytes: bytes,
        mimeType: mimeType,
      );

      widget.session.processedClothingBytes = extracted.bytes;
      widget.session.processedClothingMimeType = extracted.mimeType;

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CategoryScreen(session: widget.session),
        ),
      );
    } on GeminiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Processing failed: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
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
                    'Upload a product photo or screenshot from Instagram, Zalando, Amazon, etc. '
                    'We detect the item and remove the background.',
              ),
              const SizedBox(height: 24),
              if (widget.session.userPhotoBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(
                    widget.session.userPhotoBytes!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
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
                          Icons.auto_awesome,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'We automatically detect the relevant clothing item and remove the background.',
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
              if (_isProcessing) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 12),
                Text(
                  'Detecting clothing item…',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 20),
              ],
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              PrimaryButton(
                label: 'Upload photo',
                icon: Icons.upload_outlined,
                isLoading: _isProcessing,
                onPressed: _isProcessing
                    ? null
                    : () => _pickClothingImage(ImageSource.gallery),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isProcessing
                    ? null
                    : () => _pickClothingImage(ImageSource.camera),
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
