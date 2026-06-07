import 'package:does_it_fit_me/config/legal_placeholders.dart';
import 'package:does_it_fit_me/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum LegalDocumentType { privacy, impressum }

class LegalTextScreen extends StatelessWidget {
  const LegalTextScreen._({required this.type});

  const LegalTextScreen.privacy() : this._(type: LegalDocumentType.privacy);

  const LegalTextScreen.impressum() : this._(type: LegalDocumentType.impressum);

  final LegalDocumentType type;

  @override
  Widget build(BuildContext context) {
    final sections = switch (type) {
      LegalDocumentType.privacy => LegalPlaceholders.privacySections,
      LegalDocumentType.impressum => LegalPlaceholders.impressumSections,
    };

    final title = switch (type) {
      LegalDocumentType.privacy => 'Privacy Policy',
      LegalDocumentType.impressum => 'Legal Notice',
    };

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: sections.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Text(
                'This policy is written for U.S. users. Our company is registered '
                'in Cyprus. Have legal counsel review before publication.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.amber.shade900,
                      height: 1.4,
                    ),
              ),
            );
          }

          final section = sections[index - 1];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                section.body,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}
