/// Example usage patterns for role-based barrel imports
/// This file demonstrates how to use the new architecture
library role_examples;

import 'package:flutter/material.dart';
import 'package:sabo_arena/services/user_service.dart';

// ✅ RECOMMENDED: Role-specific imports
import 'package:sabo_arena/presentation/roles/admin/admin_screens.dart';
import 'package:sabo_arena/presentation/roles/club/club_screens.dart';
import 'package:sabo_arena/presentation/roles/player/player_screens.dart';

// ✅ RECOMMENDED: All-in-one import when needed
import 'package:sabo_arena/presentation/roles/roles.dart';

// ✅ RECOMMENDED: Utilities for role checking
import 'package:sabo_arena/utils/role_utils.dart';
import 'package:sabo_arena/guards/role_guard.dart';

// ❌ OLD PATTERN: Avoid direct imports from screen folders
// import '../admin_dashboard_screen/admin_dashboard_screen.dart';
// import '../club_approval_screen/club_approval_screen.dart';

/// Example 1: Role-based navigation
class ExampleNavigation {
  static void navigateBasedOnRole(String userRole, context) {
    if (RoleUtils.isAdmin(userRole)) {
      Navigator.pushNamed(context, '/admin_dashboard');
    } else if (RoleUtils.isClubRole(userRole)) {
      Navigator.pushNamed(context, '/club_main');
    } else {
      Navigator.pushNamed(context, '/home_feed');
    }
  }
}

/// Example 2: Role-based widget rendering
class ExampleRoleWidget extends StatelessWidget {
  final String? userRole;

  const ExampleRoleWidget({Key? key, this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoleGuard.roleBasedWidget(
      userRole: userRole,
      adminWidget: const AdminDashboardScreen(),
      clubWidget: const ClubMainScreen(), 
      playerWidget: const HomeFeedScreen(),
      fallbackWidget: const HomeFeedScreen(), // Default fallback
    );
  }
}

/// Example 3: Future-based role widget
class ExampleFutureRoleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoleGuard.futureRoleWidget(
      adminWidget: const AdminDashboardScreen(),
      clubWidget: const ClubDashboardScreen(),
      playerWidget: const HomeFeedScreen(),
      loadingWidget: const CircularProgressIndicator(),
      errorWidget: const Text('Lỗi tải thông tin người dùng'),
    );
  }
}

/// Example 4: Feature access checking
class ExampleFeatureAccess {
  static Future<bool> canCreateTournament() async {
    return await RoleGuard.canAccessFeature('tournament_creation');
  }

  static Future<List<Widget>> getTournamentActions() async {
    final actions = await RoleGuard.getFABActions('tournament_list');
    
    return actions.map((action) {
      switch (action) {
        case 'create_tournament':
          return FloatingActionButton(
            heroTag: 'create_tournament',
            onPressed: () {
              // Navigate to TournamentCreationWizard from club barrel
            },
            child: const Icon(Icons.add),
          );
        case 'filter':
          return FloatingActionButton(
            heroTag: 'filter',
            onPressed: () {
              // Show filter bottom sheet
            },
            child: const Icon(Icons.filter_list),
          );
        default:
          return const SizedBox.shrink();
      }
    }).toList();
  }
}

/// Example 5: Conditional screen imports in routes
class ExampleRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/admin_dashboard':
        // Using admin barrel import
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
        );
        
      case '/club_main':
        // Using club barrel import
        return MaterialPageRoute(
          builder: (_) => const ClubMainScreen(),
        );
        
      case '/tournament_creation':
        // Using club barrel import for tournament creation
        return MaterialPageRoute(
          builder: (_) => const TournamentCreationWizard(),
        );
        
      case '/home_feed':
        // Using player barrel import
        return MaterialPageRoute(
          builder: (_) => const HomeFeedScreen(),
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeFeedScreen(),
        );
    }
  }
}

/// Example 6: Team import conventions
class TeamConventions {
  // ✅ GOOD: Clear role-based organization
  void goodImportExample() {
    // When working with admin features
    // import 'package:sabo_arena/presentation/roles/admin/admin_screens.dart';
    
    // When working with club features  
    // import 'package:sabo_arena/presentation/roles/club/club_screens.dart';
    
    // When working with player features
    // import 'package:sabo_arena/presentation/roles/player/player_screens.dart';
    
    // When needing multiple roles
    // import 'package:sabo_arena/presentation/roles/roles.dart';
  }
  
  // ❌ AVOID: Direct folder imports
  void avoidThisPattern() {
    // import '../admin_dashboard_screen/admin_dashboard_screen.dart';
    // import '../club_approval_screen/club_approval_screen.dart';
    // import '../user_management_screen/user_management_screen.dart';
  }
}

/// Example 7: Migration path for existing code
class MigrationExample {
  // Phase 1: Add barrel import alongside existing imports
  void phase1_AddBarrelImport() {
    // Keep existing imports temporarily
    // import '../tournament_list_screen/tournament_list_screen.dart';
    // 
    // Add new barrel import
    // import 'package:sabo_arena/presentation/roles/player/player_screens.dart';
  }
  
  // Phase 2: Remove old imports, use barrel only
  void phase2_UseBarrelOnly() {
    // Remove old import
    // import '../tournament_list_screen/tournament_list_screen.dart';
    //
    // Keep only barrel import
    // import 'package:sabo_arena/presentation/roles/player/player_screens.dart';
  }
}

/// Example 8: Role checking in widgets
class ExampleRoleChecking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserService.instance.getCurrentUserProfile(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        
        final userRole = snapshot.data?.role;
        
        return Column(
          children: [
            // Always show
            const Text('Trang chủ'),
            
            // Role-specific content
            if (RoleUtils.isAdmin(userRole)) 
              const Text('Bảng điều khiển Admin'),
              
            if (RoleUtils.isClubRole(userRole))
              const Text('Quản lý câu lạc bộ'),
              
            if (RoleUtils.isPlayer(userRole))
              const Text('Tìm đối thủ'),
              
            // Feature-based checking
            if (RoleUtils.canAccessFeature(userRole, 'tournament_creation'))
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/tournament_creation');
                },
                child: const Text('Tạo giải đấu'),
              ),
          ],
        );
      },
    );
  }
}