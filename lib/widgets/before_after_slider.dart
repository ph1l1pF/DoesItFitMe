import 'dart:typed_data';

import 'package:does_it_fit_me/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BeforeAfterSlider extends StatefulWidget {
  const BeforeAfterSlider({
    super.key,
    required this.beforeBytes,
    required this.afterBytes,
  });

  final Uint8List beforeBytes;
  final Uint8List afterBytes;

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  double _position = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final dividerX = width * _position;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.memory(widget.afterBytes, fit: BoxFit.contain),
                ClipRect(
                  clipper: _LeftClipper(dividerX),
                  child: Image.memory(widget.beforeBytes, fit: BoxFit.contain),
                ),
              Positioned(
                left: dividerX - 1,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3,
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.compare_arrows,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: _Badge(label: 'Vorher'),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: _Badge(label: 'Nachher'),
              ),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _position = (_position + details.delta.dx / width)
                          .clamp(0.05, 0.95);
                    });
                  },
                  onTapDown: (details) {
                    setState(() {
                      _position =
                          (details.localPosition.dx / width).clamp(0.05, 0.95);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LeftClipper extends CustomClipper<Rect> {
  _LeftClipper(this.width);

  final double width;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, width, size.height);

  @override
  bool shouldReclip(covariant _LeftClipper oldClipper) =>
      oldClipper.width != width;
}
