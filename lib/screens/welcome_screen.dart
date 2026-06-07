import 'package:does_it_fit_me/models/try_on_session.dart';
import 'package:does_it_fit_me/screens/user_photo_screen.dart';
import 'package:does_it_fit_me/theme/app_theme.dart';
import 'package:does_it_fit_me/widgets/common_widgets.dart';
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
                'Virtuell anprobieren\nin 30 Sekunden',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Lade dein Foto und ein Kleidungsstück hoch – unsere KI zeigt dir, wie es an dir aussieht.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                label: 'Loslegen',
                icon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => UserPhotoScreen(
                        session: TryOnSession(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
