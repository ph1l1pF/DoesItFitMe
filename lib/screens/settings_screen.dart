import 'package:does_it_fit_me/config/legal_placeholders.dart';
import 'package:does_it_fit_me/screens/legal_text_screen.dart';
import 'package:does_it_fit_me/screens/welcome_screen.dart';
import 'package:does_it_fit_me/services/privacy_consent_service.dart';
import 'package:does_it_fit_me/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PrivacyConsentService? _consentService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConsent();
  }

  Future<void> _loadConsent() async {
    final service = await PrivacyConsentService.create();
    if (!mounted) return;
    setState(() {
      _consentService = service;
      _isLoading = false;
    });
  }

  Future<void> _revokeConsent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw consent?'),
        content: const Text(
          'Without consent, you cannot start new try-ons. '
          'Photos already saved on your device are not affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );

    if (confirmed != true || _consentService == null) return;

    await _consentService!.revokeConsent();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Consent withdrawn')),
    );
    setState(() {});
  }

  void _clearLocalSessionData() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session data cleared. Consent remains saved.'),
      ),
    );
  }

  String _formatConsentDate(DateTime? date) {
    if (date == null) return '–';
    final local = date.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$month/$day/${local.year}, $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Privacy',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _consentService!.hasPhotoProcessingConsent
                              ? 'Consent granted'
                              : 'No consent granted',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: _consentService!
                                            .hasPhotoProcessingConsent
                                        ? AppColors.success
                                        : AppColors.textSecondary,
                                  ),
                        ),
                        if (_consentService!.hasPhotoProcessingConsent) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Granted on: '
                            '${_formatConsentDate(_consentService!.consentGrantedAt)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          Text(
                            'Privacy policy version: '
                            '${_consentService!.consentPolicyVersion ?? '–'}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_consentService!.hasPhotoProcessingConsent)
                  OutlinedButton.icon(
                    onPressed: _revokeConsent,
                    icon: const Icon(Icons.block),
                    label: const Text('Withdraw consent'),
                  ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _clearLocalSessionData,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear session data'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LegalTextScreen.privacy(),
                        ),
                      ),
                      child: const Text('Privacy Policy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LegalTextScreen.impressum(),
                        ),
                      ),
                      child: const Text('Legal Notice'),
                    ),
                  ],
                ),
                Text(
                  'Privacy policy version: '
                  '${LegalPlaceholders.privacyPolicyVersion} '
                  '(${LegalPlaceholders.privacyPolicyDate})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
    );
  }
}
