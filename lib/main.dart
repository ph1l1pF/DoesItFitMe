import 'package:does_it_fit_me/screens/welcome_screen.dart';
import 'package:does_it_fit_me/services/privacy_consent_service.dart';
import 'package:does_it_fit_me/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await PrivacyConsentService.initialize();
  runApp(const DoesItFitMeApp());
}

class DoesItFitMeApp extends StatelessWidget {
  const DoesItFitMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Does It Fit Me',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const WelcomeScreen(),
    );
  }
}
