import 'package:does_it_fit_me/models/try_on_session.dart';
import 'package:does_it_fit_me/screens/clothing_selection_screen.dart';
import 'package:does_it_fit_me/screens/consent_screen.dart';
import 'package:does_it_fit_me/services/privacy_consent_service.dart';
import 'package:does_it_fit_me/theme/app_theme.dart';
import 'package:does_it_fit_me/widgets/common_widgets.dart';
import 'package:does_it_fit_me/widgets/legal_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPhotoScreen extends StatefulWidget {
  const UserPhotoScreen({super.key, required this.session});

  final TryOnSession session;

  @override
  State<UserPhotoScreen> createState() => _UserPhotoScreenState();
}

class _UserPhotoScreenState extends State<UserPhotoScreen> {
  final _picker = ImagePicker();
  bool _isLoading = false;
  bool _showTips = false;

  Future<void> _pickImage(ImageSource source) async {
    final consentService = await PrivacyConsentService.create();
    if (!consentService.hasPhotoProcessingConsent) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ConsentScreen(session: widget.session),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );
      if (file == null || !mounted) return;

      final bytes = await file.readAsBytes();
      widget.session.userPhotoBytes = bytes;
      widget.session.userPhotoMimeType = _mimeTypeFromPath(file.path);

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ClothingSelectionScreen(session: widget.session),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
      appBar: AppBar(title: const Text('Your photo')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StepHeader(
                step: 1,
                totalSteps: 5,
                title: 'Upload your photo',
                subtitle:
                    'Choose a full-body or upper-body photo for the most realistic try-on.',
              ),
              const SizedBox(height: 16),
              const PrivacyInfoBanner(
                message:
                    'Your photo is sent to an AI provider in the United States for '
                    'try-on processing. It is used only for this session.',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 72,
                        color: AppColors.primary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No photo selected yet',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Open camera',
                icon: Icons.camera_alt_outlined,
                isLoading: _isLoading,
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Choose from gallery'),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => setState(() => _showTips = !_showTips),
                icon: Icon(_showTips ? Icons.expand_less : Icons.expand_more),
                label: Text(
                  _showTips ? 'Hide tips' : 'Tips for a great photo',
                ),
              ),
              if (_showTips) ...[
                const SizedBox(height: 8),
                const TipCard(
                  tips: [
                    'Full body or at least upper body visible',
                    'Good, even lighting — daylight works best',
                    'Stand straight with arms relaxed at your sides',
                    'Simple background without distractions',
                    'Avoid heavy filters or blur',
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
