import 'package:flutter/material.dart';
import 'package:sabo_arena/core/app_export.dart';


class MatchManagementView extends StatefulWidget {
  final String tournamentId;
  final String tournamentStatus;
  final bool canManage;

  const MatchManagementView({
    super.key,
    required this.tournamentId,
    required this.tournamentStatus,
    this.canManage = false,
  });

  @override
  _MatchManagementViewState createState() => _MatchManagementViewState();
}

class _MatchManagementViewState extends State<MatchManagementView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  String _selectedRound = 'all';
  String _selectedStatus = 'all';
  
  List<TournamentMatch> _matches = [];
  List<TournamentMatch> _filteredMatches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _loadMatches();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadMatches() async {
    // Simulate loading
    await Future.delayed(Duration(milliseconds: 1000));
    
    setState(() {
      _matches = _generateMockMatches();
      _filteredMatches = _matches;
      _isLoading = false;
    });
    
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          _buildTabBar(),
          Expanded(
            child: _isLoading ? _buildLoadingState() : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.dividerLight)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quản lý trận đấu",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  "${_matches.length} trận đấu",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          
          if (widget.canManage)
            ElevatedButton.icon(
              onPressed: _showCreateMatchDialog,
              icon: Icon(Icons.add, size: 16),
              label: Text("Tạo trận"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryLight,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRound,
                  items: [
                    DropdownMenuItem(value: 'all', child: Text('Tất cả vòng')),
                    DropdownMenuItem(value: 'round_1', child: Text('Vòng 1')),
                    DropdownMenuItem(value: 'quarter', child: Text('Tứ kết')),
                    DropdownMenuItem(value: 'semi', child: Text('Bán kết')),
                    DropdownMenuItem(value: 'final', child: Text('Chung kết')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRound = value ?? 'all';
                      _filterMatches();
                    });
                  },
                  style: TextStyle(color: AppTheme.textSecondaryLight, fontSize: 12),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),
          
          SizedBox(width: 8),
          
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  items: [
                    DropdownMenuItem(value: 'all', child: Text('Tất cả')),
                    DropdownMenuItem(value: 'scheduled', child: Text('Đã lên lịch')),
                    DropdownMenuItem(value: 'ongoing', child: Text('Đang diễn ra')),
                    DropdownMenuItem(value: 'completed', child: Text('Hoàn thành')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value ?? 'all';
                      _filterMatches();
                    });
                  },
                  style: TextStyle(color: AppTheme.textSecondaryLight, fontSize: 12),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.dividerLight)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryLight,
        unselectedLabelColor: AppTheme.textSecondaryLight,
        indicatorColor: AppTheme.primaryLight,
        tabs: [
          Tab(text: 'Danh sách'),
          Tab(text: 'Lịch thi đấu'),
          Tab(text: 'Kết quả'),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryLight),
          SizedBox(height: 16),
          Text(
            "Đang tải trận đấu...",
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondaryLight),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _slideAnimation.value)),
          child: Opacity(
            opacity: _slideAnimation.value,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMatchList(),
                _buildScheduleView(),
                _buildResultsView(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMatchList() {
    if (_filteredMatches.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _filteredMatches.length,
      itemBuilder: (context, index) {
        final match = _filteredMatches[index];
        return _buildMatchCard(match);
      },
    );
  }

  Widget _buildMatchCard(TournamentMatch match) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(match.status).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Match header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    match.round,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryLight,
                    ),
                  ),
                ),
                
                Spacer(),
                
                _buildStatusChip(match.status),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Players and scores
            Row(
              children: [
                Expanded(child: _buildPlayerInfo(match.player1, match.score1, match.winner == 1)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "VS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ),
                Expanded(child: _buildPlayerInfo(match.player2, match.score2, match.winner == 2)),
              ],
            ),
            
            if (match.scheduledTime != null || match.table != null) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    if (match.scheduledTime != null) ...[
                      Icon(Icons.schedule, size: 14, color: AppTheme.textSecondaryLight),
                      SizedBox(width: 4),
                      Text(
                        match.scheduledTime!,
                        style: TextStyle(fontSize: 11, color: AppTheme.textSecondaryLight),
                      ),
                    ],
                    
                    if (match.table != null) ...[
                      if (match.scheduledTime != null) ...[
                        SizedBox(width: 12),
                        Container(width: 1, height: 12, color: AppTheme.dividerLight),
                        SizedBox(width: 12),
                      ],
                      Icon(Icons.table_restaurant, size: 14, color: AppTheme.textSecondaryLight),
                      SizedBox(width: 4),
                      Text(
                        match.table!,
                        style: TextStyle(fontSize: 11, color: AppTheme.textSecondaryLight),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            
            if (widget.canManage) ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      "Cập nhật KQ",
                      Icons.edit,
                      AppTheme.successLight,
                      () => _updateMatchResult(match),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      "Chỉnh sửa",
                      Icons.settings,
                      AppTheme.primaryLight,
                      () => _editMatch(match),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerInfo(String playerName, int? score, bool isWinner) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-${1580000000000 + playerName.hashCode.abs() % 1000}?w=100&h=100&fit=crop&crop=face'
          ),
          backgroundColor: AppTheme.dividerLight,
        ),
        
        SizedBox(height: 6),
        
        Text(
          playerName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
            color: isWinner ? AppTheme.successLight : AppTheme.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        
        if (score != null)
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isWinner ? AppTheme.successLight : AppTheme.textDisabledLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              score.toString(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _getStatusColor(status);
    final label = _getStatusLabel(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleView() {
    // Group matches by date
    final matchesByDate = <String, List<TournamentMatch>>{};
    
    for (final match in _filteredMatches) {
      if (match.scheduledTime != null) {
        final date = "Hôm nay"; // Simplified for demo
        if (!matchesByDate.containsKey(date)) {
          matchesByDate[date] = [];
        }
        matchesByDate[date]!.add(match);
      }
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: matchesByDate.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entry.key,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              ...entry.value.map((match) => Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      match.scheduledTime ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                    SizedBox(width: 12),
                    
                    Expanded(
                      child: Text(
                        "${match.player1} vs ${match.player2}",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textPrimaryLight,
                        ),
                      ),
                    ),
                    
                    if (match.table != null)
                      Text(
                        match.table!,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                  ],
                ),
              )),
              
              SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultsView() {
    final completedMatches = _filteredMatches.where((m) => m.status == 'completed').toList();
    
    if (completedMatches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_score, size: 64, color: AppTheme.textDisabledLight),
            SizedBox(height: 16),
            Text("Chưa có kết quả", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: completedMatches.length,
      itemBuilder: (context, index) {
        final match = completedMatches[index];
        return _buildResultCard(match);
      },
    );
  }

  Widget _buildResultCard(TournamentMatch match) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.successLight.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${match.player1} ${match.score1} - ${match.score2} ${match.player2}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
            ),
          ),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.successLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              match.round,
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.successLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_tennis, size: 64, color: AppTheme.textDisabledLight),
          SizedBox(height: 16),
          Text("Chưa có trận đấu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text("Hãy tạo trận đấu đầu tiên", style: TextStyle(color: AppTheme.textSecondaryLight)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled': return AppTheme.primaryLight;
      case 'ongoing': return AppTheme.warningLight;
      case 'completed': return AppTheme.successLight;
      default: return AppTheme.textSecondaryLight;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'scheduled': return 'Đã lên lịch';
      case 'ongoing': return 'Đang diễn ra';
      case 'completed': return 'Hoàn thành';
      default: return 'Không rõ';
    }
  }

  void _filterMatches() {
    setState(() {
      _filteredMatches = _matches.where((match) {
        final roundMatch = _selectedRound == 'all' || match.round.toLowerCase().contains(_selectedRound);
        final statusMatch = _selectedStatus == 'all' || match.status == _selectedStatus;
        
        return roundMatch && statusMatch;
      }).toList();
    });
  }

  void _showCreateMatchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tạo trận đấu mới"),
        content: Text("Tính năng đang được phát triển"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Đóng"),
          ),
        ],
      ),
    );
  }

  void _updateMatchResult(TournamentMatch match) {
    // Implementation for updating match results
  }

  void _editMatch(TournamentMatch match) {
    // Implementation for editing match
  }

  List<TournamentMatch> _generateMockMatches() {
    return [
      TournamentMatch(
        id: 'match_1',
        player1: 'Nguyễn Văn A',
        player2: 'Lê Văn B',
        score1: 3,
        score2: 1,
        winner: 1,
        status: 'completed',
        round: 'Vòng 1',
        scheduledTime: '09:00',
        table: 'Bàn 1',
      ),
      TournamentMatch(
        id: 'match_2',
        player1: 'Trần Văn C',
        player2: 'Phạm Văn D',
        score1: null,
        score2: null,
        winner: null,
        status: 'ongoing',
        round: 'Vòng 1',
        scheduledTime: '09:30',
        table: 'Bàn 2',
      ),
      TournamentMatch(
        id: 'match_3',
        player1: 'Hoàng Văn E',
        player2: 'Vũ Văn F',
        score1: null,
        score2: null,
        winner: null,
        status: 'scheduled',
        round: 'Vòng 1',
        scheduledTime: '10:00',
        table: 'Bàn 1',
      ),
      TournamentMatch(
        id: 'match_4',
        player1: 'Đinh Văn G',
        player2: 'Bùi Văn H',
        score1: 2,
        score2: 3,
        winner: 2,
        status: 'completed',
        round: 'Vòng 1',
        scheduledTime: '10:30',
        table: 'Bàn 2',
      ),
    ];
  }
}

class TournamentMatch {
  final String id;
  final String player1;
  final String player2;
  final int? score1;
  final int? score2;
  final int? winner; // 1 for player1, 2 for player2
  final String status; // scheduled, ongoing, completed
  final String round;
  final String? scheduledTime;
  final String? table;

  TournamentMatch({
    required this.id,
    required this.player1,
    required this.player2,
    this.score1,
    this.score2,
    this.winner,
    required this.status,
    required this.round,
    this.scheduledTime,
    this.table,
  });
}
