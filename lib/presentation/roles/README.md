# Role-Based Presentation Architecture

## Tổng quan

Hệ thống barrel files này tổ chức lại cấu trúc presentation layer theo vai trò người dùng, giúp:
- ✅ Dễ quản lý code theo role (Admin / Club / Player)
- ✅ Không phá vỡ navigation và import hiện tại
- ✅ Chuẩn bị cho việc migrate thư mục vật lý trong tương lai
- ✅ Giảm import lặp và tăng tính rõ ràng code

## Cấu trúc Barrel Files

### 📁 Admin Screens (`admin/admin_screens.dart`)
```dart
// Export: Màn hình dành cho Admin
- AdminDashboardScreen      // Trang chủ admin
- ClubApprovalScreen        // Duyệt câu lạc bộ
- UserManagementScreen      // Quản lý người dùng
```

### 📁 Club Screens (`club/club_screens.dart`)
```dart
// Export: Màn hình dành cho Club Owner/Manager
- ClubMainScreen            // Trang chủ club
- ClubDashboardScreen       // Dashboard quản lý
- ClubProfileScreen/Edit/View // Hồ sơ club
- ClubSettingsScreen        // Cài đặt club
- ClubRegistrationScreen    // Đăng ký club
- ClubSelectionScreen       // Chọn club
- ClubNotificationScreen    // Thông báo club
- ClubReportsScreen         // Báo cáo club
- MemberManagementScreen    // Quản lý thành viên
- TournamentCreationWizard  // Tạo giải đấu
```

### 📁 Player Screens (`player/player_screens.dart`)
```dart
// Export: Màn hình dành cho Player/General User
- HomeFeedScreen            // Trang chủ
- FindOpponentsScreen       // Tìm đối thủ
- TournamentListScreen      // Danh sách giải đấu
- TournamentDetailScreen    // Chi tiết giải đấu
- MyClubsScreen            // Câu lạc bộ của tôi
- VietnameseRankingScreen   // Bảng xếp hạng
- UserProfileScreen         // Hồ sơ cá nhân
```

### 📁 Main Export (`roles.dart`)
```dart
// Re-export tất cả role screens
export 'admin/admin_screens.dart';
export 'club/club_screens.dart';
export 'player/player_screens.dart';
```

## Cách sử dụng

### Import theo Role cụ thể
```dart
// Chỉ import màn hình Admin
import 'package:sabo_arena/presentation/roles/admin/admin_screens.dart';

// Chỉ import màn hình Club
import 'package:sabo_arena/presentation/roles/club/club_screens.dart';

// Chỉ import màn hình Player
import 'package:sabo_arena/presentation/roles/player/player_screens.dart';
```

### Import tất cả roles
```dart
// Import tất cả (khi cần nhiều role)
import 'package:sabo_arena/presentation/roles/roles.dart';
```

### So sánh với cách cũ
```dart
// ❌ Cách cũ - Import nhiều file rời rạc
import '../admin_dashboard_screen/admin_dashboard_screen.dart';
import '../club_approval_screen/club_approval_screen.dart';
import '../user_management_screen/user_management_screen.dart';

// ✅ Cách mới - Import theo role
import 'package:sabo_arena/presentation/roles/admin/admin_screens.dart';
```

## Lộ trình Migration

### Giai đoạn 1: Hiện tại ✅
- [x] Tạo barrel files theo role
- [x] Không đổi import cũ để tránh conflict
- [x] Team có thể bắt đầu dùng barrel trong code mới

### Giai đoạn 2: Chuẩn hóa Import (Tùy chọn)
```bash
# Cập nhật import trong các file mới/được chỉnh sửa
# Ví dụ:
- tournament_list_screen.dart: Dùng player/player_screens.dart
- member_management_screen.dart: Dùng club/club_screens.dart
```

### Giai đoạn 3: Di chuyển thư mục vật lý (Tùy chọn)
```
lib/presentation/
├── admin/
│   ├── admin_dashboard_screen/
│   ├── club_approval_screen/
│   └── user_management_screen/
├── club/
│   ├── club_main_screen/
│   ├── member_management_screen/
│   └── tournament_creation_wizard/
└── player/
    ├── home_feed_screen/
    ├── tournament_list_screen/
    └── user_profile_screen/
```

### Giai đoạn 4: Route Protection
```dart
// Thêm guard điều hướng theo role
class RoleGuard {
  static bool canAccess(UserRole role, String route) {
    // Logic kiểm tra quyền truy cập
  }
}
```

## Convention cho Team

### 1. Import trong file mới
```dart
// ✅ Ưu tiên dùng barrel theo role
import 'package:sabo_arena/presentation/roles/club/club_screens.dart';

// ❌ Tránh import trực tiếp từ thư mục cũ
import '../member_management_screen/member_management_screen.dart';
```

### 2. Khi thêm màn hình mới
1. Tạo màn hình ở vị trí hiện tại
2. **Nhớ thêm export vào barrel file tương ứng**
3. Sử dụng barrel import trong navigation

### 3. Khi refactor file cũ
- Có thể cập nhật import sang barrel
- Không bắt buộc nếu không chỉnh sửa logic chính

## Role Detection

```dart
// Sử dụng UserService để xác định role
final userProfile = await UserService.getCurrentUserProfile();
final userRole = userProfile?.role ?? 'player';

switch (userRole) {
  case 'admin':
    // Navigate to admin screens
    break;
  case 'club_owner':
    // Navigate to club screens
    break;
  default:
    // Navigate to player screens
    break;
}
```

## Lợi ích

### Cho Developer
- 🎯 **Rõ ràng**: Biết ngay màn hình thuộc role nào
- 🔄 **Dễ import**: 1 dòng thay vì nhiều dòng
- 🛡️ **An toàn**: Không phá vỡ code hiện tại

### Cho Team
- 📋 **Dễ review**: Code có cấu trúc rõ ràng
- 🚀 **Dễ scale**: Thêm màn hình mới theo role
- 🔧 **Dễ maintain**: Logic theo role được tách biệt

### Cho Project
- 🏗️ **Kiến trúc tốt**: Chuẩn bị cho growth
- 🔒 **Bảo mật**: Dễ implement role-based access
- 📈 **Performance**: Import có chủ đích, ít conflict

---

*Tạo bởi: GitHub Copilot - September 2025*
*Version: 1.0 - Role-based Presentation Architecture*