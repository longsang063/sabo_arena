/// Utility class for role-based access control and navigation
/// Supports the role-based presentation architecture
class RoleUtils {
  // Role constants
  static const String ADMIN = 'admin';
  static const String CLUB_OWNER = 'club_owner';
  static const String CLUB_MANAGER = 'club_manager';
  static const String PLAYER = 'player';

  // Role groups for easier checking
  static const List<String> CLUB_ROLES = [CLUB_OWNER, CLUB_MANAGER];
  static const List<String> ADMIN_ROLES = [ADMIN];
  static const List<String> ALL_ROLES = [ADMIN, CLUB_OWNER, CLUB_MANAGER, PLAYER];

  /// Check if user has admin privileges
  static bool isAdmin(String? role) {
    return role == ADMIN;
  }

  /// Check if user has club management privileges
  static bool isClubRole(String? role) {
    return CLUB_ROLES.contains(role);
  }

  /// Check if user is a regular player
  static bool isPlayer(String? role) {
    return role == PLAYER || role == null; // Default to player if role is null
  }

  /// Check if user has elevated privileges (admin or club)
  static bool hasElevatedRole(String? role) {
    return isAdmin(role) || isClubRole(role);
  }

  /// Get user-friendly role display name
  static String getRoleDisplayName(String? role) {
    switch (role) {
      case ADMIN:
        return 'Quản trị viên';
      case CLUB_OWNER:
        return 'Chủ câu lạc bộ';
      case CLUB_MANAGER:
        return 'Quản lý câu lạc bộ';
      case PLAYER:
        return 'Người chơi';
      default:
        return 'Người chơi';
    }
  }

  /// Get appropriate home route based on role
  static String getHomeRoute(String? role) {
    if (isAdmin(role)) {
      return '/admin_dashboard';
    } else if (isClubRole(role)) {
      return '/club_main';
    } else {
      return '/home_feed';
    }
  }

  /// Check if role can access specific feature
  static bool canAccessFeature(String? role, String feature) {
    switch (feature) {
      case 'tournament_creation':
        return isClubRole(role) || isAdmin(role);
      case 'member_management':
        return isClubRole(role) || isAdmin(role);
      case 'club_approval':
        return isAdmin(role);
      case 'user_management':
        return isAdmin(role);
      case 'club_reports':
        return isClubRole(role) || isAdmin(role);
      case 'ranking_system':
        return true; // Available to all
      case 'find_opponents':
        return true; // Available to all
      default:
        return isPlayer(role); // Default player features
    }
  }

  /// Get list of accessible routes based on role
  static List<String> getAccessibleRoutes(String? role) {
    List<String> routes = [
      '/home_feed',
      '/tournament_list',
      '/tournament_detail',
      '/user_profile',
      '/my_clubs',
      '/vietnamese_ranking',
      '/find_opponents',
    ];

    if (isClubRole(role)) {
      routes.addAll([
        '/club_main',
        '/club_dashboard',
        '/club_profile',
        '/club_settings',
        '/member_management',
        '/tournament_creation_wizard',
        '/club_reports',
        '/club_notifications',
      ]);
    }

    if (isAdmin(role)) {
      routes.addAll([
        '/admin_dashboard',
        '/club_approval',
        '/user_management',
      ]);
    }

    return routes;
  }

  /// Validate if user can navigate to route
  static bool canNavigateToRoute(String? userRole, String route) {
    return getAccessibleRoutes(userRole).contains(route);
  }

  /// Get appropriate FAB actions based on role and screen
  static List<String> getFABActions(String? role, String screenName) {
    switch (screenName) {
      case 'tournament_list':
        if (isClubRole(role)) {
          return ['create_tournament', 'filter'];
        }
        return ['filter'];
      case 'member_management':
        if (isClubRole(role)) {
          return ['add_member', 'bulk_actions'];
        }
        return [];
      case 'club_dashboard':
        if (isClubRole(role)) {
          return ['create_tournament', 'add_member', 'reports'];
        }
        return [];
      default:
        return [];
    }
  }

  /// Get role-based theme or styling hints
  static Map<String, dynamic> getRoleTheme(String? role) {
    switch (role) {
      case ADMIN:
        return {
          'primaryColor': 'red',
          'accentColor': 'orange',
          'iconSet': 'admin',
        };
      case CLUB_OWNER:
      case CLUB_MANAGER:
        return {
          'primaryColor': 'blue',
          'accentColor': 'lightBlue',
          'iconSet': 'club',
        };
      default:
        return {
          'primaryColor': 'green',
          'accentColor': 'lightGreen',
          'iconSet': 'player',
        };
    }
  }
}