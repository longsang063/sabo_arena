import 'package:flutter/material.dart';
import 'package:sabo_arena/core/app_export.dart';
import 'package:sabo_arena/widgets/custom_app_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:sabo_arena/theme/app_theme.dart';
import 'package:sabo_arena/widgets/custom_image_widget.dart';

class ClubDashboardScreen extends StatefulWidget {
  const ClubDashboardScreen({super.key});

  @override
  _ClubDashboardScreenState createState() => _ClubDashboardScreenState();
}

class _ClubDashboardScreenState extends State<ClubDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickStatsSection(),
              SizedBox(height: 24.h),
              _buildQuickActionsSection(),
              SizedBox(height: 24.h),
              _buildRecentActivitySection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget - App Bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.h),
          child: CustomImageWidget(
            imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100&h=100&fit=crop',
            height: 40.sp,
            width: 40.sp,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "SABO Arena Central",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4.h),
              Icon(
                Icons.verified,
                color: AppTheme.primaryLight,
                size: 20.sp,
              ),
            ],
          ),
          Text(
            "@saboarena_central",
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: AppTheme.textPrimaryLight),
              onPressed: () => _onNotificationPressed(),
            ),
            if (_getNotificationCount() > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.errorLight,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16.h,
                    minHeight: 16.h,
                  ),
                  child: Text(
                    '${_getNotificationCount()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.settings_outlined, color: AppTheme.textPrimaryLight),
          onPressed: () => _onSettingsPressed(),
        ),
        SizedBox(width: 8.h),
      ],
    );
  }

  /// Section Widget - Quick Stats
  Widget _buildQuickStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tổng quan CLB",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildStatsCard(
                title: "Thành viên",
                value: "156",
                trend: "up",
                trendValue: "+12",
                icon: Icons.people_outline,
                color: AppTheme.successLight,
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: _buildStatsCard(
                title: "Giải đấu hoạt động",
                value: "3",
                icon: Icons.emoji_events_outlined,
                color: AppTheme.accentLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildStatsCard(
                title: "Doanh thu tháng",
                value: "45.2M",
                trend: "up",
                trendValue: "+8.5%",
                icon: Icons.attach_money_outlined,
                color: AppTheme.primaryLight,
                subtitle: "VND",
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: _buildStatsCard(
                title: "Xếp hạng CLB",
                value: "#12",
                icon: Icons.military_tech_outlined,
                color: AppTheme.primaryLight,
                subtitle: "Khu vực",
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Section Widget - Quick Actions
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Thao tác nhanh",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                title: "Tạo giải đấu",
                subtitle: "Tổ chức giải đấu mới",
                icon: Icons.add_circle_outline,
                color: AppTheme.successLight,
                onPress: () => _onCreateTournament(),
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: _buildQuickActionCard(
                title: "Quản lý thành viên",
                subtitle: "Xem và quản lý thành viên",
                icon: Icons.people_outline,
                color: AppTheme.primaryLight,
                badge: 3,
                onPress: () => _onManageMembers(),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                title: "Cập nhật thông tin",
                subtitle: "Chỉnh sửa thông tin CLB",
                icon: Icons.edit_outlined,
                color: AppTheme.accentLight,
                onPress: () => _onEditProfile(),
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: _buildQuickActionCard(
                title: "Thông báo",
                subtitle: "Gửi thông báo đến thành viên",
                icon: Icons.notifications_outlined,
                color: AppTheme.primaryLight,
                onPress: () => _onSendNotification(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Section Widget - Recent Activity
  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Hoạt động gần đây",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _onViewAllActivity(),
              child: Text(
                "Xem tất cả",
                style: const TextStyle(fontSize: 14).copyWith(
                  color: AppTheme.primaryLight,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.textPrimaryLight.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                type: "member_joined",
                title: "Nguyễn Văn Nam đã tham gia CLB",
                subtitle: "Thành viên mới từ quận 1",
                timestamp: DateTime.now().subtract(Duration(minutes: 15)),
                avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=50&h=50&fit=crop&crop=face",
                color: AppTheme.successLight,
              ),
              _buildDivider(),
              _buildActivityItem(
                type: "tournament_created",
                title: "Giải đấu 'Golden Cup 2025' đã được tạo",
                subtitle: "32 người tham gia • Bắt đầu 25/09",
                timestamp: DateTime.now().subtract(Duration(hours: 2)),
                icon: Icons.emoji_events,
                color: AppTheme.accentLight,
              ),
              _buildDivider(),
              _buildActivityItem(
                type: "match_completed",
                title: "Trận đấu giữa Mai và Long đã kết thúc",
                subtitle: "Mai thắng 8-6 • Thời gian: 45 phút",
                timestamp: DateTime.now().subtract(Duration(hours: 4)),
                icon: Icons.sports_esports,
                color: AppTheme.primaryLight,
              ),
              _buildDivider(),
              _buildActivityItem(
                type: "payment_received",
                title: "Thanh toán từ Trần Thị Hương",
                subtitle: "Phí thành viên tháng 9 • 200,000 VND",
                timestamp: DateTime.now().subtract(Duration(days: 1)),
                icon: Icons.payment,
                color: AppTheme.primaryLight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Component - Stats Card
  Widget _buildStatsCard({
    required String title,
    required String value,
    String? trend,
    String? trendValue,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20.sp,
                ),
              ),
              Spacer(),
              if (trend != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: trend == "up" ? AppTheme.backgroundLight : AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trend == "up" ? Icons.trending_up : Icons.trending_down,
                        color: trend == "up" ? AppTheme.successLight : AppTheme.errorLight,
                        size: 12.sp,
                      ),
                      SizedBox(width: 2.h),
                      Text(
                        trendValue ?? "",
                        style: TextStyle(
                          color: trend == "up" ? AppTheme.successLight : AppTheme.errorLight,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Component - Quick Action Card  
  Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    int? badge,
    required VoidCallback onPress,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.h),
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(12.h),
        child: Container(
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: color, width: 4.h),
            ),
            borderRadius: BorderRadius.circular(12.h),
            boxShadow: [
              BoxShadow(
                color: AppTheme.textPrimaryLight.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.h),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20.sp,
                    ),
                  ),
                  Spacer(),
                  if (badge != null && badge > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.errorLight,
                        borderRadius: BorderRadius.circular(10.h),
                      ),
                      child: Text(
                        badge.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Component - Activity Item
  Widget _buildActivityItem({
    required String type,
    required String title,
    required String subtitle,
    required DateTime timestamp,
    String? avatar,
    IconData? icon,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          // Avatar or Icon
          Container(
            width: 40.sp,
            height: 40.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.h),
              color: avatar != null ? null : color.withOpacity(0.1),
            ),
            child: avatar != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20.h),
                    child: CustomImageWidget(
                      imageUrl: avatar,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    icon,
                    color: color,
                    size: 20.sp,
                  ),
          ),
          SizedBox(width: 12.h),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          // Timestamp
          Text(
            _formatRelativeTime(timestamp),
            style: TextStyle(
              fontSize: 11.sp,
              color: AppTheme.backgroundLight,
            ),
          ),
        ],
      ),
    );
  }

  /// Component - Divider
  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Divider(
        color: AppTheme.dividerLight,
        thickness: 1,
      ),
    );
  }

  // Helper Methods
  String _formatRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else {
      return '${difference.inDays} ngày trước';
    }
  }

  int _getNotificationCount() => 5; // Mock data

  // Event Handlers
  void _onNotificationPressed() {
    // Navigate to notifications screen
    print('Notifications pressed');
  }

  void _onSettingsPressed() {
    // Navigate to settings screen
    print('Settings pressed');
  }

  void _onCreateTournament() {
    // Navigate to create tournament screen
    print('Create tournament pressed');
  }

  void _onManageMembers() {
    // Navigate to manage members screen
    print('Manage members pressed');
  }

  void _onEditProfile() {
    // Navigate to edit profile screen
    print('Edit profile pressed');
  }

  void _onSendNotification() {
    // Navigate to send notification screen
    print('Send notification pressed');
  }

  void _onViewAllActivity() {
    // Navigate to all activity screen
    print('View all activity pressed');
  }
}
