import 'package:does_it_fit_me/navigation/try_on_flow.dart';
import 'package:does_it_fit_me/theme/app_theme.dart';
import 'package:does_it_fit_me/widgets/common_widgets.dart';
import 'package:does_it_fit_me/widgets/legal_widgets.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.checkroom_outlined,
                  size: 44,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Does It Fit Me',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Try it on virtually\nin 30 seconds',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Upload your photo and a clothing item — we\'ll show you how it looks on you.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                label: 'Get started',
                icon: Icons.arrow_forward,
                onPressed: () => startTryOnFlow(context),
              ),
              const SizedBox(height: 16),
              const LegalFooterLinks(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
