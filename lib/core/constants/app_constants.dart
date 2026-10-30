/// MANI FIT Core App Constants & Business Boundaries
/// Aligned with official MANI FIT Brand Kit specifications
class AppConstants {
  AppConstants._();

  static const String appName = 'MANI FIT';
  static const String appTagline = 'STRONGER • HEALTHIER • HAPPIER';
  static const String brandMessage = 'YOUR HEALTH. YOUR GOALS.';
  static const String appSubtitle = 'HEALTH • FITNESS • BETTER YOU';
  static const String appMotto = "Fitness isn't a destination. It's a lifestyle.";
  static const String appVersion = '1.0.0';

  // Subscription Details
  static const String premiumMonthlyPriceInr = '₹100';
  static const int premiumMonthlyAmountInr = 100;
  static const String configuredUpiDestination = 'yuvrajsoni95555-1@okaxis';

  // Safety & Medical Boundary Constants
  static const double minSafeCaloriesFemale = 1200.0;
  static const double minSafeCaloriesMale = 1500.0;
  static const double minSafeBmi = 14.0;
  static const double maxSensibleBmi = 65.0;

  // Disclaimers
  static const String medicalDisclaimer =
      'MANI FIT provides fitness, nutrition, and wellness guidance for educational '
      'and informational purposes only. It is not a substitute for clinical diagnosis, '
      'professional medical advice, or personalized healthcare treatment. Always consult '
      'a qualified physician or licensed dietitian before beginning any new training or nutrition regimen.';

  static const String calorieEstimationDisclaimer =
      'Photo-based food recognition provides an algorithmic estimate based on visible cues. '
      'It cannot detect hidden cooking oils, exact sodium, or precise serving grams without scale measurement.';

  // Storage Keys
  static const String keyAuthToken = 'mani_fit_auth_token';
  static const String keyUserRole = 'mani_fit_user_role';
  static const String keyIsGuest = 'mani_fit_is_guest';
  static const String keyUserProfile = 'mani_fit_user_profile';
  static const String keySubscriptionStatus = 'mani_fit_sub_status';
  static const String keyThemeMode = 'mani_fit_theme_mode';
}
