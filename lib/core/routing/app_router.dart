import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/onboarding_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/nutrition/presentation/diet_chart_screen.dart';
import '../../features/workout/workout_screen.dart';
import '../../features/ai_coach/ai_coach_screen.dart';
import '../../features/subscription/subscription_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/organizer/organizer_screen.dart';

/// Top-level navigator keys
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

/// Declarative Routing Specification for MANI FIT
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithBottomNav(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/diet-charts',
          builder: (context, state) => const DietChartScreen(),
        ),
        GoRoute(
          path: '/workouts',
          builder: (context, state) => const WorkoutScreen(),
        ),
        GoRoute(
          path: '/ai-coach',
          builder: (context, state) => const AiCoachScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
    ),
    GoRoute(
      path: '/organizer',
      builder: (context, state) => const OrganizerScreen(),
    ),
  ],
);

/// Scaffolding with MANI FIT styled Bottom Navigation Bar
class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNav({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/diet-charts')) return 1;
    if (location.startsWith('/workouts')) return 2;
    if (location.startsWith('/ai-coach')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/diet-charts');
        break;
      case 2:
        context.go('/workouts');
        break;
      case 3:
        context.go('/ai-coach');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu),
            label: 'Diet Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            activeIcon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_outlined),
            activeIcon: Icon(Icons.psychology),
            label: 'AI Coach',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
