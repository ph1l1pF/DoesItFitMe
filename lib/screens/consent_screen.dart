import 'package:does_it_fit_me/config/legal_placeholders.dart';
import 'package:does_it_fit_me/models/try_on_session.dart';
import 'package:does_it_fit_me/screens/legal_text_screen.dart';
import 'package:does_it_fit_me/screens/user_photo_screen.dart';
import 'package:does_it_fit_me/services/privacy_consent_service.dart';
import 'package:does_it_fit_me/theme/app_theme.dart';
import 'package:does_it_fit_me/widgets/common_widgets.dart';
import 'package:does_it_fit_me/widgets/legal_widgets.dart';
import 'package:flutter/material.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key, required this.session});

  final TryOnSession session;

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _accepted = false;
  bool _isSaving = false;

  Future<void> _submitConsent() async {
    setState(() => _isSaving = true);
    try {
      final service = await PrivacyConsentService.create();
      await service.grantConsent(
        policyVersion: LegalPlaceholders.privacyPolicyVersion,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => UserPhotoScreen(session: widget.session),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consent')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Processing your photos',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'To provide virtual try-on, we need your consent to process photos.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 20),
                      const PrivacyInfoBanner(
                        message:
                            'Your photos are sent to an external AI provider in the '
                            'United States for processing. The App is operated by '
                            'Philip Frerk Software Development Ltd (Cyprus). '
                            'Consent is required to continue.',
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'We process:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 10),
                      ...const [
                        'Your photo (camera or gallery)',
                        'Your clothing image / screenshot',
                        'The generated try-on result during your session',
                      ].map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('•  ',
                                  style: TextStyle(color: AppColors.primary)),
                              Expanded(child: Text(item)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const LegalTextScreen.privacy(),
                          ),
                        ),
                        child: const Text('Read full privacy policy'),
                      ),
                    ],
                  ),
                ),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _accepted,
                onChanged: _isSaving
                    ? null
                    : (value) => setState(() => _accepted = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  'I consent to my photos being processed for virtual try-on, '
                  'including transfer to an AI service provider in the United States. '
                  'I have read the Privacy Policy and understand that Philip Frerk '
                  'Software Development Ltd (Cyprus) operates this App for U.S. users.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Agree and continue',
                icon: Icons.check,
                isLoading: _isSaving,
                onPressed: _accepted && !_isSaving ? _submitConsent : null,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                child: const Text('Decline'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
