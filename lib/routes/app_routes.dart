import 'package:flutter/material.dart';

// ✅ Role-based barrel imports
import '../presentation/roles/roles.dart';

// ✅ Role utilities and guards
import '../guards/role_guard.dart';

// Core screens (non-role specific)
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_screen/onboarding_screen.dart';
import '../presentation/login_screen.dart';
import '../presentation/register_screen.dart';
import '../presentation/forgot_password_screen.dart';

class AppRoutes {
  // Core routes (no auth required)
  static const String splashScreen = '/splash';
  static const String onboardingScreen = '/onboarding';
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String forgotPasswordScreen = '/forgot-password';

  // Player routes
  static const String homeFeedScreen = '/home_feed';
  static const String tournamentListScreen = '/tournament_list';
  static const String findOpponentsScreen = '/find_opponents';
  static const String userProfileScreen = '/user_profile';
  static const String tournamentDetailScreen = '/tournament_detail';
  static const String myClubsScreen = '/my_clubs';

  // Club routes (club_owner, club_manager)
  static const String clubMainScreen = '/club_main';
  static const String clubProfileScreen = '/club_profile';
  static const String clubRegistrationScreen = '/club_registration';
  static const String clubDashboardScreen = '/club_dashboard';
  static const String clubSelectionScreen = '/club_selection';
  static const String memberManagementScreen = '/member_management';
  static const String tournamentCreationScreen = '/tournament_creation';

  // Admin routes (admin only)
  static const String adminDashboardScreen = '/admin_dashboard';
  static const String clubApprovalScreen = '/admin_club_approval';
  static const String userManagementScreen = '/admin_user_management';

  static const String initial = splashScreen;

  /// ✅ Role-based route generator with protection
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '/';
    
    // Core routes (no auth required)
    switch (routeName) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPasswordScreen:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
    }

    // ✅ Role-protected routes with async checking
    return MaterialPageRoute(
      builder: (context) => _RoleProtectedScreen(targetRoute: routeName),
      settings: settings,
    );
  }

  /// Get screen widget for route name
  static Widget _getScreenForRoute(String routeName) {
    switch (routeName) {
      // Player routes
      case homeFeedScreen:
        return const HomeFeedScreen();
      case tournamentListScreen:
        return const TournamentListScreen();
      case findOpponentsScreen:
        return const FindOpponentsScreen();
      case userProfileScreen:
        return const UserProfileScreen();
      case tournamentDetailScreen:
        return const TournamentDetailScreen();
      case myClubsScreen:
        return const MyClubsScreen();

      // Club routes
      case clubMainScreen:
        return const ClubMainScreen();
      case clubProfileScreen:
        return const ClubProfileScreen();
      case clubRegistrationScreen:
        return const ClubRegistrationScreen();
      case clubSelectionScreen:
        return const ClubSelectionScreen();
      case memberManagementScreen:
        return const MemberManagementScreen(clubId: ''); // TODO: Pass actual clubId
      case tournamentCreationScreen:
        return const TournamentCreationWizard();

      // Admin routes
      case adminDashboardScreen:
        return const AdminDashboardScreen();
      case clubApprovalScreen:
        return const ClubApprovalScreen();
      case userManagementScreen:
        return const UserManagementScreen();

      // Default fallback
      default:
        return const HomeFeedScreen();
    }
  }

  /// Legacy routes map for backward compatibility
  static Map<String, WidgetBuilder> get routes => {
        splashScreen: (context) => const SplashScreen(),
        onboardingScreen: (context) => const OnboardingScreen(),
        loginScreen: (context) => const LoginScreen(),
        registerScreen: (context) => const RegisterScreen(),
        forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
        homeFeedScreen: (context) => const HomeFeedScreen(),
      };
}

/// Role-protected screen wrapper with async role checking
class _RoleProtectedScreen extends StatelessWidget {
  final String targetRoute;

  const _RoleProtectedScreen({required this.targetRoute});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: RoleGuard.guardWithRedirect(targetRoute),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final redirectRoute = snapshot.data;
        if (redirectRoute != null) {
          // User doesn't have access, redirect
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(redirectRoute);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User has access, show the target screen
        return AppRoutes._getScreenForRoute(targetRoute);
      },
    );
  }
}
