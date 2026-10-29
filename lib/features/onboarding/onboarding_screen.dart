import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<({String title, String description, IconData icon})> _slides = [
    (
      title: 'Precision Nutrition Engine',
      description: 'Generate authentic, culturally tailored diet charts with exact macronutrients and portion scaling.',
      icon: Icons.restaurant_menu,
    ),
    (
      title: 'Progressive Workouts',
      description: 'Home and gym training programs built for muscle building, endurance, and fat loss.',
      icon: Icons.fitness_center,
    ),
    (
      title: 'AI Coaching & Habit Support',
      description: 'Evidence-based guidance, daily hydration reminders, and recovery insights tailored to your biometrics.',
      icon: Icons.psychology,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // Top Brand Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBurgundy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppConstants.appName, style: AppTypography.headingLarge(color: AppColors.deepBurgundy)),
                      Text(AppConstants.appTagline, style: AppTypography.bodySmall(color: AppColors.slateGrey)),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              // Slides Carousel
              SizedBox(
                height: 320,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: AppColors.lightPink,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.roseChampagne, width: 2),
                          ),
                          child: Icon(slide.icon, size: 54, color: AppColors.primaryBurgundy),
                        ),
                        const SizedBox(height: 28),
                        Text(slide.title, style: AppTypography.displayMedium(), textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        Text(
                          slide.description,
                          style: AppTypography.bodyLarge(color: AppColors.slateGrey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? AppColors.primaryBurgundy : AppColors.borderLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // Actions: Get Started & Guest Exploration
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Explore as Guest'),
              ),
              const SizedBox(height: 16),

              Text(
                'By continuing, you agree to MANI FIT Terms & Privacy Policy.',
                style: AppTypography.bodySmall().copyWith(fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
