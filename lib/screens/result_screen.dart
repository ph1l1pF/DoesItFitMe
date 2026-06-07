import 'dart:io';
import 'dart:typed_data';

import 'package:does_it_fit_me/models/try_on_session.dart';
import 'package:does_it_fit_me/screens/generation_screen.dart';
import 'package:does_it_fit_me/screens/welcome_screen.dart';
import 'package:does_it_fit_me/widgets/before_after_slider.dart';
import 'package:does_it_fit_me/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.session});

  final TryOnSession session;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showSlider = true;

  Uint8List get _before => widget.session.userPhotoBytes!;
  Uint8List get _after => widget.session.resultBytes!;

  Future<void> _saveImage() async {
    try {
      await Gal.putImageBytes(_after);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bild in Galerie gespeichert')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speichern fehlgeschlagen: $e')),
      );
    }
  }

  Rect _sharePositionOrigin(BuildContext shareContext) {
    final box = shareContext.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      final origin = box.localToGlobal(Offset.zero) & box.size;
      if (origin.width > 0 && origin.height > 0) {
        return origin;
      }
    }

    final screen = MediaQuery.sizeOf(context);
    return Rect.fromLTWH(screen.width / 2, screen.height - 48, 1, 1);
  }

  Future<void> _shareImage(BuildContext shareContext) async {
    final shareOrigin = _sharePositionOrigin(shareContext);

    try {
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/anprobe_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await file.writeAsBytes(_after);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Meine virtuelle Anprobe mit Does It Fit Me',
        sharePositionOrigin: shareOrigin,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teilen fehlgeschlagen: $e')),
      );
    }
  }

  Future<void> _tryOtherColor() async {
    final color = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        const colors = [
          ('Schwarz', 'black'),
          ('Weiß', 'white'),
          ('Navy', 'navy blue'),
          ('Beige', 'beige'),
          ('Rot', 'red'),
          ('Grün', 'green'),
        ];

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Andere Farbe ausprobieren',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              ...colors.map(
                (entry) => ListTile(
                  title: Text(entry.$1),
                  trailing: const Icon(Icons.palette_outlined),
                  onTap: () => Navigator.pop(context, entry.$2),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (color == null || !mounted) return;

    widget.session.colorVariant = color;
    widget.session.resultBytes = null;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => GenerationScreen(session: widget.session),
      ),
    );
  }

  void _openZoomView() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ZoomScreen(imageBytes: _after),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ergebnis'),
        actions: [
          IconButton(
            onPressed: _openZoomView,
            icon: const Icon(Icons.zoom_in),
            tooltip: 'Zoomen',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Vorher/Nachher'),
                    selected: _showSlider,
                    onSelected: (selected) {
                      if (selected) setState(() => _showSlider = true);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Ergebnis'),
                    selected: !_showSlider,
                    onSelected: (selected) {
                      if (selected) setState(() => _showSlider = false);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _showSlider
                    ? BeforeAfterSlider(
                        beforeBytes: _before,
                        afterBytes: _after,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ColoredBox(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.12),
                          child: GestureDetector(
                            onTap: _openZoomView,
                            child: Image.memory(
                              _after,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _saveImage,
                          icon: const Icon(Icons.download_outlined),
                          label: const Text('Speichern'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Builder(
                          builder: (shareContext) => OutlinedButton.icon(
                            onPressed: () => _shareImage(shareContext),
                            icon: const Icon(Icons.share_outlined),
                            label: const Text('Teilen'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Andere Farbe ausprobieren',
                    icon: Icons.palette_outlined,
                    onPressed: _tryOtherColor,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<void>(
                          builder: (_) => const WelcomeScreen(),
                        ),
                        (_) => false,
                      );
                    },
                    child: const Text('Neue Anprobe starten'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomScreen extends StatelessWidget {
  const _ZoomScreen({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Zoom'),
      ),
      body: PhotoView(
        imageProvider: MemoryImage(imageBytes),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 4,
      ),
    );
  }
}
