import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../models/user_profile.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/map_view_widget.dart';
import './widgets/player_card_widget.dart';

class FindOpponentsScreen extends StatefulWidget {
  const FindOpponentsScreen({super.key});

  @override
  State<FindOpponentsScreen> createState() => _FindOpponentsScreenState();
}

class _FindOpponentsScreenState extends State<FindOpponentsScreen> {
  final UserService _userService = UserService.instance;
  List<UserProfile> _players = [];
  bool _isLoading = true;
  bool _isMapView = false;
  String _selectedSkillLevel = 'all';
  double _radiusKm = 10.0;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    try {
      setState(() => _isLoading = true);

      // For now, get top ranked players
      // In production, you'd implement location-based search
      final players = await _userService.getTopRankedPlayers(limit: 50);

      // Filter by skill level if selected
      final filteredPlayers = _selectedSkillLevel == 'all'
          ? players
          : players.where((p) => p.skillLevel == _selectedSkillLevel).toList();

      setState(() {
        _players = filteredPlayers;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải danh sách đối thủ: $error')),
      );
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(
        currentFilters: {
          'skillLevel': _selectedSkillLevel,
          'distance': _radiusKm,
        },
        onFiltersChanged: (filters) {
          setState(() {
            _selectedSkillLevel = filters['skillLevel'] ?? 'all';
            _radiusKm = filters['distance'] ?? 10.0;
          });
          _loadPlayers();
        },
      ),
    );
  }

  void _showQRScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Quét mã QR'),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          body: MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã quét: ${barcode.rawValue}'),
                    ),
                  );
                  break;
                }
              }
            },
          ),
        ),
      ),
    );
  }

  void _viewProfile(Map<String, dynamic> player) {
    Navigator.pushNamed(context, '/user-profile-screen');
  }

  void _sendMessage(Map<String, dynamic> player) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã mở cuộc trò chuyện với ${player["name"]}'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _addFriend(Map<String, dynamic> player) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã gửi lời mời kết bạn đến ${player["name"]}'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  Future<void> _refreshPlayers() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Simulate refreshing data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tìm đối thủ',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            icon: const Icon(Icons.tune),
          ),
          IconButton(
            onPressed: () => setState(() => _isMapView = !_isMapView),
            icon: Icon(_isMapView ? Icons.list : Icons.map),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPlayers,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _isMapView
                ? MapViewWidget(players: _players.map((p) => p.toJson()).toList())
                : _players.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.only(top: 8.h, bottom: 80.h),
                        itemCount: _players.length,
                        itemBuilder: (context, index) {
                          return PlayerCardWidget(
                            player: _players[index],
                          );
                        },
                      ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'Không tìm thấy đối thủ',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Thử thay đổi bộ lọc để tìm thêm người chơi',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _loadPlayers,
              child: Text('Tải lại'),
            ),
          ],
        ),
      ),
    );
  }
}