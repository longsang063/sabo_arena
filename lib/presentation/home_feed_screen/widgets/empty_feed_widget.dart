import 'package:flutter/material.dart';
import '../../../core/app_export.dart';




class EmptyFeedWidget extends StatelessWidget {
  final bool isNearbyTab;
  final VoidCallback? onCreatePost;
  final VoidCallback? onFindFriends;

  const EmptyFeedWidget({
    super.key,
    required this.isNearbyTab,
    this.onCreatePost,
    this.onFindFriends,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Billiards themed illustration
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sports_bar,
                color: colorScheme.primary,
                size: 30,
              ),
            ),

            SizedBox(height: 2),

            // Title
            Text(
              isNearbyTab
                  ? 'Chưa có bài viết gần đây'
                  : 'Chưa có bài viết từ bạn bè',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 1),

            // Description
            Text(
              isNearbyTab
                  ? 'Hãy là người đầu tiên chia sẻ trải nghiệm billiards!'
                  : 'Kết nối với những người chơi billiards khác.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 3),

            // Action buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onCreatePost,
                    icon: Icon(
                      Icons.add,
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
                    label: const Text('Tạo bài viết đầu tiên'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                if (!isNearbyTab) ...[
                  SizedBox(height: 2),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onFindFriends,
                      icon: Icon(
                        Icons.people,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      label: const Text('Tìm bạn bè'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
