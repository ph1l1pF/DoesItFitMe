import 'package:does_it_fit_me/models/clothing_category.dart';
import 'package:does_it_fit_me/models/try_on_session.dart';
import 'package:does_it_fit_me/screens/generation_screen.dart';
import 'package:does_it_fit_me/theme/app_theme.dart';
import 'package:does_it_fit_me/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.session});

  final TryOnSession session;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  ClothingCategory? _selected;

  @override
  Widget build(BuildContext context) {
    final clothingBytes = widget.session.effectiveClothingBytes;

    return Scaffold(
      appBar: AppBar(title: const Text('Category')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StepHeader(
                step: 3,
                totalSteps: 5,
                title: 'Confirm category',
                subtitle:
                    'Pick the right category so the item is placed correctly on you.',
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(
                  clothingBytes,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: ClothingCategory.values.map((category) {
                    final isSelected = _selected == category;
                    return Material(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => setState(() => _selected = category),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                category.emoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category.label,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Start try-on',
                icon: Icons.auto_fix_high,
                onPressed: _selected == null
                    ? null
                    : () {
                        widget.session.category = _selected;
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                GenerationScreen(session: widget.session),
                          ),
                        );
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
