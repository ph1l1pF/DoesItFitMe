/// Legal texts for U.S. app distribution. Operator is based in Cyprus.
/// Have U.S. and EU counsel review before publication.
class LegalPlaceholders {
  static const privacyPolicyVersion = '1.1';
  static const privacyPolicyDate = 'June 7, 2026';

  static const companyName = 'Philip Frerk Software Development Ltd';
  static const companyRegistration = 'HE 470978';
  static const companyVat = 'CY60135173A';
  static const companyAddress =
      'Faneromenis 148, Floor 3, Office 301\n6035 Larnaca\nCyprus';
  static const privacyEmail = 'hi@philip-frerk.de';
  static const contactEmail = 'hi@philip-frerk.de';

  static const aiProcessorName = 'Google LLC (Gemini API)';
  static const aiProcessorCountry = 'United States';

  static List<LegalSection> get privacySections => [
        LegalSection(
          title: '1. Introduction',
          body:
              'This Privacy Policy explains how $companyName '
              '("we," "us," or "our") handles information when you use the '
              'Does It Fit Me mobile app (the "App").\n\n'
              'The App is intended primarily for users in the United States. '
              'We are a company registered in Cyprus, but we do not operate '
              'physical stores in the U.S. We provide the App as a digital '
              'service to U.S. users.\n\n'
              'Contact:\n'
              '$companyName\n'
              '$companyAddress\n'
              'Email: $privacyEmail',
        ),
        LegalSection(
          title: '2. Information we collect',
          body:
              'We collect only what is needed for virtual try-on:\n\n'
              '• Photos you upload of yourself (camera or photo library)\n'
              '• Clothing images or screenshots you upload\n'
              '• Try-on results generated during your session\n'
              '• Your consent status and the date/version of the privacy policy you accepted\n\n'
              'We do not require an account, and we do not collect your name, '
              'email, or payment information through the App unless you '
              'contact us directly.',
        ),
        LegalSection(
          title: '3. How we use your information',
          body:
              'We use your photos to:\n\n'
              '• Detect and isolate clothing items in uploaded images\n'
              '• Generate a virtual try-on image showing clothing on you\n'
              '• Display results within the App during your session\n\n'
              'We do not use your photos for advertising, profiling, or to '
              'train our own models. Processing is performed to provide the '
              'try-on feature you request.',
        ),
        LegalSection(
          title: '4. How we share information',
          body:
              'To generate try-on results, your uploaded photos are transmitted '
              'to our AI service provider for processing:\n\n'
              '$aiProcessorName\n'
              'Location: $aiProcessorCountry\n\n'
              'We do not sell your personal information. We do not share your '
              'photos with retailers, social networks, or advertising partners.\n\n'
              'We may disclose information if required by law, court order, '
              'or to protect our rights, users, or the public.',
        ),
        LegalSection(
          title: '5. International data transfers',
          body:
              'Because we are located in Cyprus and our AI provider is located '
              'in the United States, your photos may be processed outside your '
              'state of residence, including outside the United States from our '
              'corporate perspective (Cyprus/EU) and within the United States '
              'when processed by our AI provider.\n\n'
              'We use service providers that apply appropriate contractual and '
              'technical safeguards. By using the App and providing consent, '
              'you acknowledge that this cross-border processing is necessary '
              'to provide the service.',
        ),
        LegalSection(
          title: '6. Retention',
          body:
              'Uploaded photos and generated try-on results are kept in memory '
              'only for your active App session. We do not permanently store '
              'your photos on our own servers.\n\n'
              'If you save a result to your device photo library or share it '
              'through your device, you control that copy locally.\n\n'
              'Your consent preference is stored on your device until you '
              'withdraw it in Settings.',
        ),
        LegalSection(
          title: '7. Your choices and consent',
          body:
              'The try-on feature requires your explicit consent before you '
              'upload photos. You may withdraw consent at any time in '
              'Settings. After withdrawal, you cannot start new try-ons, but '
              'photos already saved on your device remain under your control.\n\n'
              'You can decline consent and still view the Privacy Policy and '
              'Legal Notice, but you cannot use photo-based try-on without consent.',
        ),
        LegalSection(
          title: '8. U.S. state privacy rights',
          body:
              'Depending on where you live in the United States, you may have '
              'additional rights under state privacy laws, including:\n\n'
              '• California (CCPA/CPRA): right to know, delete, correct, and '
              'opt out of certain sharing. We do not sell personal information.\n'
              '• Virginia, Colorado, Connecticut, Utah, and other states with '
              'comprehensive privacy laws: rights to access, delete, correct, '
              'and obtain a portable copy in some cases.\n'
              '• Illinois Biometric Information Privacy Act (BIPA) and similar '
              'state laws: where photos may be treated as biometric data, we '
              'obtain consent before collection and limit use to try-on only.\n\n'
              'To exercise your rights, email $privacyEmail with the subject '
              '"Privacy Request." We will verify your request as required by '
              'applicable law and respond within the legally required timeframe.',
        ),
        LegalSection(
          title: '9. Children\'s privacy',
          body:
              'The App is not directed to children under 13 and we do not '
              'knowingly collect personal information from children under 13 '
              'in violation of the U.S. Children\'s Online Privacy Protection '
              'Act (COPPA). If you believe a child under 13 has provided photos '
              'through the App, contact us at $privacyEmail and we will take '
              'appropriate steps to delete associated session data where feasible.',
        ),
        LegalSection(
          title: '10. Security',
          body:
              'We use HTTPS encryption when transmitting photos to our AI '
              'provider. No method of transmission or storage is 100% secure, '
              'but we apply reasonable technical and organizational measures '
              'appropriate to the nature of the data processed.',
        ),
        LegalSection(
          title: '11. Changes to this policy',
          body:
              'We may update this Privacy Policy from time to time. If we make '
              'material changes, we will update the version and effective date '
              'in the App. Continued use after changes may require renewed '
              'consent where required by law.',
        ),
        LegalSection(
          title: '12. Contact us',
          body:
              '$companyName\n'
              '$companyAddress\n'
              'Company registration: $companyRegistration\n'
              'VAT: $companyVat\n'
              'Email: $privacyEmail',
        ),
        LegalSection(
          title: '13. Policy version',
          body:
              'Version $privacyPolicyVersion, effective $privacyPolicyDate.',
        ),
      ];

  static List<LegalSection> get impressumSections => [
        LegalSection(
          title: 'Company',
          body:
              '$companyName\n'
              '$companyAddress\n'
              'Email: $contactEmail',
        ),
        LegalSection(
          title: 'Registration',
          body:
              'Registered company number (Cyprus): $companyRegistration\n'
              'VAT: $companyVat',
        ),
        LegalSection(
          title: 'App operator notice',
          body:
              'Does It Fit Me is operated by $companyName, a company '
              'incorporated in Cyprus. The App is offered to users in the '
              'United States. This notice is provided for transparency and '
              'App Store compliance.',
        ),
        LegalSection(
          title: 'Privacy',
          body:
              'For information about how we handle photos and personal '
              'information, please read our Privacy Policy in the App.',
        ),
      ];
}

class LegalSection {
  const LegalSection({required this.title, required this.body});

  final String title;
  final String body;
}
