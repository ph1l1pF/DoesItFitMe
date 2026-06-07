import 'package:does_it_fit_me/models/try_on_session.dart';
import 'package:does_it_fit_me/screens/consent_screen.dart';
import 'package:does_it_fit_me/screens/user_photo_screen.dart';
import 'package:does_it_fit_me/services/privacy_consent_service.dart';
import 'package:flutter/material.dart';

Future<void> startTryOnFlow(BuildContext context) async {
  final consentService = await PrivacyConsentService.create();
  if (!context.mounted) return;

  final session = TryOnSession();
  final destination = consentService.hasPhotoProcessingConsent
      ? UserPhotoScreen(session: session)
      : ConsentScreen(session: session);

  await Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => destination),
  );
}
