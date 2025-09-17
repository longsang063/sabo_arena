import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:sabo_arena/guards/role_guard.dart';

import 'package:sabo_arena/core/app_export.dart';
import 'package:sabo_arena/theme/theme_extensions.dart';
import 'package:sabo_arena/utils/size_extensions.dart';
import '../../services/bracket_generator_service.dart';
import '../../core/constants/tournament_constants.dart';

class TournamentCreationWizard extends StatefulWidget {
  final String? clubId;

  const TournamentCreationWizard({
    super.key,
    this.clubId,
  });

  @override
  _TournamentCreationWizardState createState() => _TournamentCreationWizardState();
}

class _TournamentCreationWizardState extends State<TournamentCreationWizard>
    with TickerProviderStateMixin {
  
  late PageController _pageController;
  int _currentStep = 0;
  
  // Tournament data with comprehensive fields
  final Map<String, dynamic> _tournamentData = {
    // Basic Info
    'name': '',
    'description': '',
    'gameType': '8-ball', // 8-ball, 9-ball, 10-ball, straight-pool
    'format': 'single_elimination', // single_elimination, double_elimination, round_robin, swiss
    'maxParticipants': 16, // 4,6,8,12,16,24,32,64
    'hasThirdPlaceMatch': true,
    
    // Schedule & Venue  
    'registrationStartDate': null,
    'registrationEndDate': null,
    'tournamentStartDate': null,
    'tournamentEndDate': null,
    'venue': '', // Auto-fill from club or custom
    
    // Financial & Requirements
    'entryFee': 0.0,
    'prizePool': 0.0,
    'minRank': '', // K, J, I, H, G, F, E, D, C, B, A, E+
    'maxRank': '', // Empty = no limit
    
    // Additional Info
    'rules': '',
    'contactInfo': '', // Auto-fill from club
    'bannerUrl': '',
    
    // System fields (auto-filled)
    'clubId': '',
    'creatorId': '',
    'status': 'registration_open',
    'currentParticipants': 0,
    'isClubVerified': false,
  };

  final List<String> _stepTitles = [
    'Thông tin cơ bản',
    'Thời gian & Địa điểm',
    'Tài chính & Điều kiện', 
    'Quy định & Xem lại',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _initializeTournamentData();
  }

  void _initializeTournamentData() {
    // Auto-fill club information
    if (widget.clubId != null) {
      _tournamentData['clubId'] = widget.clubId!;
      // TODO: Load club data and auto-fill venue, contact info
      _loadClubData();
    }
    
    // Set default dates (registration starts tomorrow, tournament in 7 days)
    final now = DateTime.now();
    _tournamentData['registrationStartDate'] = now.add(Duration(days: 1));
    _tournamentData['registrationEndDate'] = now.add(Duration(days: 6));
    _tournamentData['tournamentStartDate'] = now.add(Duration(days: 7));
    _tournamentData['tournamentEndDate'] = now.add(Duration(days: 8));
  }

  void _loadClubData() async {
    // TODO: Load club data from service
    // _tournamentData['venue'] = club.address;
    // _tournamentData['contactInfo'] = club.phone;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onDataChanged(Map<String, dynamic> data) {
    setState(() {
      _tournamentData.addAll(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Tạo giải đấu',
        onBackPressed: () {
          if (_currentStep > 0) {
            _previousStep();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: StepIndicator(
              stepTitles: _stepTitles,
              currentStep: _currentStep,
              onStepTapped: _onStepTapped,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stepTitles.length,
              itemBuilder: (context, index) {
                return _buildStepContent(index);
              },
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 12.h,
      blur: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentStep > 0)
              SizedBox(
                width: 40.w,
                child: ElevatedButton(
                  onPressed: _previousStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  child: const Text('Quay lại'),
                ),
              ),
            if (_currentStep > 0) SizedBox(width: 4.w),
            Expanded(
              child: GradientButton(
                text: _currentStep < _stepTitles.length - 1
                    ? 'Tiếp theo'
                    : 'Hoàn thành',
                onPressed: _currentStep < _stepTitles.length - 1
                    ? _nextStep
                    : _submitTournament,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitTournament() async {
    if (!_validateAllSteps()) {
      return;
    }

    // ✅ Role-based feature gating
    final canCreate = await RoleGuard.canAccessFeature('tournament_creation');
    if (!canCreate) {
      CustomSnackbar.show(context, 'Bạn không có quyền tạo giải đấu.');
      return;
    }

    CustomLoadingDialog.show(context, 'Đang tạo giải đấu...');

    try {
      // Create participants for bracket generator
      final participants = <TournamentParticipant>[];
      
      // Convert participants to TournamentParticipant objects
      final participantsList = _tournamentData['participants'] as List<dynamic>? ?? [];
      for (int i = 0; i < participantsList.length; i++) {
        final participant = participantsList[i] as Map<String, dynamic>;
        participants.add(
          TournamentParticipant(
            id: participant['id']?.toString() ?? 'participant_$i',
            name: participant['name']?.toString() ?? 'Player ${i + 1}',
            elo: (participant['elo'] as num?)?.toInt() ?? 1000,
            rank: participant['rank']?.toString() ?? 'K',
            seed: i + 1,
          ),
        );
      }

      // If no participants, create dummy participants for testing
      if (participants.isEmpty) {
        final maxParticipants = _tournamentData['maxParticipants'] as int;
        for (int i = 0; i < maxParticipants; i++) {
          participants.add(
            TournamentParticipant(
              id: 'participant_$i',
              name: 'Player ${i + 1}',
              elo: 1000 + (i * 50), // Varied ELO for testing
              rank: 'K',
              seed: i + 1,
            ),
          );
        }
      }

      // Generate bracket with Tournament Core Logic System
      final tournamentId = 'tournament_${DateTime.now().millisecondsSinceEpoch}';
      final bracket = await BracketGeneratorService.generateBracket(
        tournamentId: tournamentId,
        format: _mapFormatToString(_tournamentData['format'] as String),
        participants: participants,
        seedingMethod: 'rank_based', // Use rank-based seeding for Vietnamese ranking
        options: {
          'enableVietnameseRanking': true,
          'tournamentName': _tournamentData['name'],
        },
      );

      Navigator.pop(context); // Close progress dialog

      // Return both tournament data and generated bracket
      Navigator.of(context).pop({
        'tournament': _tournamentData,
        'bracket': bracket,
        'participants': participants,
        'success': true,
      });

    } catch (e) {
      Navigator.pop(context); // Close progress dialog
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lỗi tạo giải đấu'),
          content: Text('Không thể tạo giải đấu: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Helper method to map UI format string to TournamentFormats constant
  String _mapFormatToString(String format) {
    switch (format.toLowerCase()) {
      case 'single elimination':
        return TournamentFormats.singleElimination;
      case 'double elimination':
        return TournamentFormats.doubleElimination;
      case 'round robin':
        return TournamentFormats.roundRobin;
      case 'swiss':
        return TournamentFormats.swiss;
      case 'parallel groups':
        return TournamentFormats.parallelGroups;
      case 'winner takes all':
        return TournamentFormats.winnerTakesAll;
      default:
        return TournamentFormats.singleElimination;
    }
  }

}