import 'dart:async';

import 'package:does_it_fit_me/models/try_on_session.dart';
import 'package:does_it_fit_me/screens/result_screen.dart';
import 'package:does_it_fit_me/services/gemini_service.dart';
import 'package:does_it_fit_me/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GenerationScreen extends StatefulWidget {
  const GenerationScreen({super.key, required this.session});

  final TryOnSession session;

  @override
  State<GenerationScreen> createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen>
    with SingleTickerProviderStateMixin {
  final _gemini = GeminiService();
  late final AnimationController _pulseController;

  double _progress = 0;
  int _stepIndex = 0;
  String? _error;

  static const _steps = [
    'Kleidungsstück analysieren…',
    'Passform berechnen…',
    'Beleuchtung anpassen…',
    'Realistische Anprobe generieren…',
    'Feinabstimmung…',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _startGeneration();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _gemini.dispose();
    super.dispose();
  }

  Future<void> _startGeneration() async {
    final progressTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (!mounted || _progress >= 0.92) return;
      setState(() {
        _progress = (_progress + 0.04).clamp(0, 0.92);
        _stepIndex = (_progress * _steps.length).floor().clamp(0, _steps.length - 1);
      });
    });

    try {
      final result = await _gemini.generateTryOn(
        personBytes: widget.session.userPhotoBytes!,
        personMimeType: widget.session.userPhotoMimeType ?? 'image/jpeg',
        clothingBytes: widget.session.effectiveClothingBytes,
        clothingMimeType: widget.session.effectiveClothingMimeType,
        category: widget.session.category!,
        colorVariant: widget.session.colorVariant,
      );

      widget.session.resultBytes = result.bytes;
      widget.session.resultMimeType = result.mimeType;

      if (!mounted) return;
      setState(() => _progress = 1);

      await Future<void>.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ResultScreen(session: widget.session),
        ),
      );
    } on GeminiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Anprobe fehlgeschlagen: $e');
    } finally {
      progressTimer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Anprobe'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _error != null ? _buildError() : _buildLoading(),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
        const SizedBox(height: 16),
        Text(
          _error!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zurück'),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.05).animate(
            CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
          ),
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.accent.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.checkroom,
              size: 72,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'KI generiert deine Anprobe',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Das dauert etwa 5–15 Sekunden',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 32),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 8,
            backgroundColor: AppColors.border,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${(_progress * 100).round()} %',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
        ),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _steps[_stepIndex],
            key: ValueKey(_stepIndex),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
