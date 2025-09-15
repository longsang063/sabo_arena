import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/participants_list_widget.dart';
import './widgets/prize_pool_widget.dart';
import './widgets/registration_widget.dart';
import './widgets/tournament_bracket_widget.dart';
import './widgets/tournament_header_widget.dart';
import './widgets/tournament_info_widget.dart';
import './widgets/tournament_rules_widget.dart';

class TournamentDetailScreen extends StatefulWidget {
  const TournamentDetailScreen({super.key});

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  bool _isRegistered = false;

  // Mock tournament data
  final Map<String, dynamic> _tournamentData = {
    "id": "tournament_001",
    "title": "Giải Billiards Mùa Thu 2024",
    "format": "9-ball",
    "coverImage":
        "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "location": "Câu lạc bộ Billiards Sài Gòn, Quận 1, TP.HCM",
    "startDate": "15/10/2024",
    "endDate": "20/10/2024",
    "registrationDeadline": "10/10/2024 23:59",
    "currentParticipants": 24,
    "maxParticipants": 32,
    "eliminationType": "Loại trực tiếp",
    "status": "Đang mở đăng ký",
    "entryFee": "500.000 VNĐ",
    "rankRequirement": "Rank C trở lên",
    "description":
        """Giải đấu Billiards 9-ball chuyên nghiệp dành cho các tay cơ có trình độ từ Rank C trở lên. 
    
Giải đấu được tổ chức tại Câu lạc bộ Billiards Sài Gòn với hệ thống bàn cơ chuyên nghiệp và không gian thi đấu rộng rãi, thoáng mát.

Đây là cơ hội tuyệt vời để các tay cơ thể hiện kỹ năng, giao lưu học hỏi và tranh tài giành những phần thưởng hấp dẫn.""",
    "prizePool": {
      "total": "10.000.000 VNĐ",
      "first": "5.000.000 VNĐ",
      "second": "3.000.000 VNĐ",
      "third": "2.000.000 VNĐ"
    }
  };

  // Mock tournament rules
  final List<String> _tournamentRules = [
    "Giải đấu áp dụng luật 9-ball quốc tế WPA",
    "Mỗi trận đấu thi đấu theo thể thức race to 7 (ai thắng trước 7 game)",
    "Thời gian suy nghĩ tối đa 30 giây cho mỗi cú đánh",
    "Không được sử dụng điện thoại trong quá trình thi đấu",
    "Trang phục lịch sự, không mặc áo ba lỗ hoặc quần short",
    "Nghiêm cấm hành vi gian lận, cãi vã với trọng tài",
    "Thí sinh đến muộn quá 15 phút sẽ bị tước quyền thi đấu",
    "Quyết định của trọng tài là quyết định cuối cùng"
  ];

  // Mock participants data
  final List<Map<String, dynamic>> _participantsData = [
    {
      "id": "player_001",
      "name": "Nguyễn Văn Minh",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rank": "A",
      "elo": 1850,
      "registrationDate": "2024-09-10"
    },
    {
      "id": "player_002",
      "name": "Trần Thị Hương",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rank": "B",
      "elo": 1720,
      "registrationDate": "2024-09-11"
    },
    {
      "id": "player_003",
      "name": "Lê Hoàng Nam",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rank": "A",
      "elo": 1890,
      "registrationDate": "2024-09-12"
    },
    {
      "id": "player_004",
      "name": "Phạm Thị Lan",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rank": "B",
      "elo": 1680,
      "registrationDate": "2024-09-12"
    },
    {
      "id": "player_005",
      "name": "Võ Minh Tuấn",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rank": "C",
      "elo": 1520,
      "registrationDate": "2024-09-13"
    },
    {
      "id": "player_006",
      "name": "Đặng Thị Mai",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rank": "B",
      "elo": 1750,
      "registrationDate": "2024-09-13"
    },
    {
      "id": "player_007",
      "name": "Bùi Văn Đức",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rank": "A",
      "elo": 1920,
      "registrationDate": "2024-09-14"
    },
    {
      "id": "player_008",
      "name": "Ngô Thị Linh",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rank": "C",
      "elo": 1480,
      "registrationDate": "2024-09-14"
    }
  ];

  // Mock bracket data
  final List<Map<String, dynamic>> _bracketData = [
    {
      "matchId": "match_001",
      "round": 1,
      "player1": {
        "id": "player_001",
        "name": "Nguyễn Văn Minh",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rank": "A",
        "score": 7
      },
      "player2": {
        "id": "player_008",
        "name": "Ngô Thị Linh",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rank": "C",
        "score": 3
      },
      "winner": "player1",
      "status": "completed"
    },
    {
      "matchId": "match_002",
      "round": 1,
      "player1": {
        "id": "player_002",
        "name": "Trần Thị Hương",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rank": "B",
        "score": 5
      },
      "player2": {
        "id": "player_007",
        "name": "Bùi Văn Đức",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rank": "A",
        "score": 7
      },
      "winner": "player2",
      "status": "completed"
    },
    {
      "matchId": "match_003",
      "round": 1,
      "player1": {
        "id": "player_003",
        "name": "Lê Hoàng Nam",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rank": "A",
        "score": 4
      },
      "player2": {
        "id": "player_006",
        "name": "Đặng Thị Mai",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rank": "B",
        "score": 6
      },
      "winner": null,
      "status": "live"
    },
    {
      "matchId": "match_004",
      "round": 1,
      "player1": {
        "id": "player_004",
        "name": "Phạm Thị Lan",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rank": "B",
        "score": null
      },
      "player2": {
        "id": "player_005",
        "name": "Võ Minh Tuấn",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rank": "C",
        "score": null
      },
      "winner": null,
      "status": "upcoming"
    }
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            TournamentHeaderWidget(
              tournament: _tournamentData,
              scrollController: _scrollController,
              onShareTap: _handleShareTournament,
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Tổng quan'),
                  Tab(text: 'Bảng đấu'),
                  Tab(text: 'Thành viên'),
                  Tab(text: 'Luật thi đấu'),
                ],
                labelColor: AppTheme.lightTheme.colorScheme.primary,
                unselectedLabelColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                indicatorColor: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildBracketTab(),
                  _buildParticipantsTab(),
                  _buildRulesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentRoute: '/tournament-detail-screen',
        onTap: _handleBottomNavTap,
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          TournamentInfoWidget(tournament: _tournamentData),
          SizedBox(height: 2.h),
          PrizePoolWidget(tournament: _tournamentData),
          SizedBox(height: 2.h),
          RegistrationWidget(
            tournament: _tournamentData,
            isRegistered: _isRegistered,
            onRegisterTap: _handleRegistration,
            onWithdrawTap: _handleWithdrawal,
          ),
        ],
      ),
    );
  }

  Widget _buildBracketTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          TournamentBracketWidget(
            tournament: _tournamentData,
            bracketData: _bracketData,
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          ParticipantsListWidget(
            participants: _participantsData,
            onViewAllTap: _handleViewAllParticipants,
          ),
        ],
      ),
    );
  }

  Widget _buildRulesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          TournamentRulesWidget(rules: _tournamentRules),
        ],
      ),
    );
  }

  void _handleShareTournament() {
    // Handle tournament sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã sao chép link giải đấu',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleRegistration() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildRegistrationBottomSheet(),
    );
  }

  void _handleWithdrawal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Xác nhận rút lui',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn rút lui khỏi giải đấu này? Lệ phí đã đóng sẽ được hoàn trả 80%.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isRegistered = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Đã rút lui khỏi giải đấu thành công',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onInverseSurface,
                    ),
                  ),
                  backgroundColor:
                      AppTheme.lightTheme.colorScheme.inverseSurface,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'Rút lui',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Xác nhận đăng ký',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lệ phí tham gia:',
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    Text(
                      _tournamentData["entryFee"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phí xử lý:',
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    Text(
                      '25.000 VNĐ',
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                  ],
                ),
                Divider(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng cộng:',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '525.000 VNĐ',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Hủy'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _isRegistered = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đăng ký thành công! Chúc bạn thi đấu tốt.',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onInverseSurface,
                          ),
                        ),
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.inverseSurface,
                      ),
                    );
                  },
                  child: Text('Thanh toán'),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  void _handleViewAllParticipants() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Container(
                    width: 12.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Danh sách tham gia (${_participantsData.length})',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _participantsData.length,
                itemBuilder: (context, index) {
                  final participant = _participantsData[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.w),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.w),
                            child: CustomImageWidget(
                              imageUrl: participant["avatar"] as String,
                              width: 12.w,
                              height: 12.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                participant["name"] as String,
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Rank ${participant["rank"]} • ${participant["elo"]} ELO',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBottomNavTap(String route) {
    if (route != '/tournament-detail-screen') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
  }
}
