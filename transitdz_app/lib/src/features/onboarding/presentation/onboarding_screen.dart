import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/theme_notifier.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  List<_OnboardingSlide> _buildSlides(AppLocalizations l10n) {
    return [
      _OnboardingSlide(
        title: l10n.translate('onboarding.slide1_title'),
        subtitle: l10n.translate('onboarding.slide1_subtitle'),
        icon: Icons.public,
      ),
      _OnboardingSlide(
        title: l10n.translate('onboarding.slide2_title'),
        subtitle: l10n.translate('onboarding.slide2_subtitle'),
        icon: Icons.bolt,
      ),
      _OnboardingSlide(
        title: l10n.translate('onboarding.slide3_title'),
        subtitle: l10n.translate('onboarding.slide3_subtitle'),
        icon: Icons.route,
      ),
    ];
  }

  void _next(AppLocalizations l10n) {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      ref.read(onboardingCompletedProvider.notifier).complete();
      if (!mounted) return;
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slides = _buildSlides(l10n);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.dark_mode_outlined),
                  onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 240,
                          width: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                Theme.of(context).colorScheme.primary.withOpacity(0.05),
                              ],
                            ),
                          ),
                          child: Icon(
                            slide.icon,
                            size: 124,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slides.length, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: isActive ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primary.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _next(l10n),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Text(l10n.translate('onboarding.cta')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
