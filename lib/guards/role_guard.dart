import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../utils/role_utils.dart';

/// Navigation guard that protects routes based on user roles
/// Integrates with the role-based presentation architecture
class RoleGuard {
  static final UserService _userService = UserService.instance;

  /// Main guard function - checks if current user can access the route
  static Future<bool> canAccess(String route) async {
    try {
      final userProfile = await _userService.getCurrentUserProfile();
      final userRole = userProfile?.role;
      
      return RoleUtils.canNavigateToRoute(userRole, route);
    } catch (e) {
      // If error getting user profile, default to player access
      return RoleUtils.canNavigateToRoute('player', route);
    }
  }

  /// Guard with redirect on failure
  static Future<String?> guardWithRedirect(String route) async {
    final canAccess = await RoleGuard.canAccess(route);
    
    if (!canAccess) {
      // Get user role for appropriate redirect
      try {
        final userProfile = await _userService.getCurrentUserProfile();
        final userRole = userProfile?.role;
        return RoleUtils.getHomeRoute(userRole);
      } catch (e) {
        return '/home_feed'; // Default redirect
      }
    }
    
    return null; // No redirect needed
  }

  /// Widget wrapper that shows content based on role
  static Widget roleBasedWidget({
    required String? userRole,
    Widget? adminWidget,
    Widget? clubWidget,
    Widget? playerWidget,
    Widget? fallbackWidget,
  }) {
    if (RoleUtils.isAdmin(userRole) && adminWidget != null) {
      return adminWidget;
    } else if (RoleUtils.isClubRole(userRole) && clubWidget != null) {
      return clubWidget;
    } else if (RoleUtils.isPlayer(userRole) && playerWidget != null) {
      return playerWidget;
    } else if (fallbackWidget != null) {
      return fallbackWidget;
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Future builder for role-based widgets
  static Widget futureRoleWidget({
    Widget? adminWidget,
    Widget? clubWidget,
    Widget? playerWidget,
    Widget? loadingWidget,
    Widget? errorWidget,
  }) {
    return FutureBuilder(
      future: _userService.getCurrentUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ?? const CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return errorWidget ?? const Text('Lỗi tải thông tin người dùng');
        }
        
        final userRole = snapshot.data?.role;
        
        return roleBasedWidget(
          userRole: userRole,
          adminWidget: adminWidget,
          clubWidget: clubWidget,
          playerWidget: playerWidget,
          fallbackWidget: playerWidget, // Default to player widget
        );
      },
    );
  }

  /// Check specific feature access
  static Future<bool> canAccessFeature(String feature) async {
    try {
      final userProfile = await _userService.getCurrentUserProfile();
      final userRole = userProfile?.role;
      
      return RoleUtils.canAccessFeature(userRole, feature);
    } catch (e) {
      return false; // Deny access on error
    }
  }

  /// Get FAB actions for current user and screen
  static Future<List<String>> getFABActions(String screenName) async {
    try {
      final userProfile = await _userService.getCurrentUserProfile();
      final userRole = userProfile?.role;
      
      return RoleUtils.getFABActions(userRole, screenName);
    } catch (e) {
      return []; // No actions on error
    }
  }

  /// Middleware for route navigation
  static Future<Route?> onGenerateRoute(RouteSettings settings) async {
    final routeName = settings.name ?? '/';
    
    // Check if user can access this route
    final redirectRoute = await guardWithRedirect(routeName);
    
    if (redirectRoute != null) {
      // User cannot access, redirect to appropriate home
      return MaterialPageRoute(
        builder: (context) => _buildUnauthorizedScreen(routeName, redirectRoute),
        settings: RouteSettings(name: redirectRoute),
      );
    }
    
    return null; // Allow normal navigation
  }

  /// Build unauthorized access screen
  static Widget _buildUnauthorizedScreen(String attemptedRoute, String redirectRoute) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Không có quyền truy cập'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Bạn không có quyền truy cập trang này',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Đang chuyển hướng về trang chủ...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  // Navigate to appropriate home
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    redirectRoute,
                    (route) => false,
                  );
                },
                child: const Text('Về trang chủ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Global navigator key for route protection
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

/// Custom route observer for role-based analytics
class RoleRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRouteAccess(route.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logRouteAccess(newRoute?.settings.name);
  }

  void _logRouteAccess(String? routeName) async {
    if (routeName == null) return;
    
    try {
      final userProfile = await UserService.instance.getCurrentUserProfile();
      final userRole = userProfile?.role ?? 'unknown';
      
      // Log route access for analytics
      print('Route Access: $routeName by role: $userRole');
      
      // Could send to analytics service here
      // AnalyticsService.trackRouteAccess(routeName, userRole);
    } catch (e) {
      print('Error logging route access: $e');
    }
  }
}