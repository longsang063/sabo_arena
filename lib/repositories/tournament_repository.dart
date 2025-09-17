import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:postgrest/postgrest.dart';
import '../models/club_model.dart';
import '../models/tournament_model.dart';

class TournamentRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get tournaments from Supabase with real data
  Future<List<TournamentModel>> getTournaments({
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      PostgrestFilterBuilder query = _supabase
          .from('tournaments')
          .select('''
            id,
            title,
            description,
            format,
            entry_fee,
            prize_pool,
            max_participants,
            current_participants,
            start_date,
            end_date,
            registration_deadline,
            status,
            cover_image_url,
            has_live_stream,
            skill_level,
            clubs!tournaments_club_id_fkey(
              id,
              name,
              address
            )
          ''');

      // Filter by status if provided
      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final List<TournamentModel> tournaments = [];
      for (final item in response) {
        final club = item['clubs'];
        
        tournaments.add(TournamentModel(
          id: item['id'],
          title: item['title'] ?? 'Giải đấu',
          club: ClubModel(
            id: club?['id'] ?? '',
            name: club?['name'] ?? 'Câu lạc bộ',
            location: club?['address'] ?? 'Chưa xác định',
          ),
          format: item['format'] ?? '8-Ball',
          entryFee: (item['entry_fee'] as num?)?.toDouble() ?? 0.0,
          prizePool: (item['prize_pool'] as num?)?.toDouble() ?? 0.0,
          currentParticipants: item['current_participants'] ?? 0,
          maxParticipants: item['max_participants'] ?? 32,
          startDate: DateTime.parse(item['start_date']),
          registrationDeadline: item['registration_deadline'] != null 
              ? DateTime.parse(item['registration_deadline']) 
              : null,
          status: item['status'] ?? 'upcoming',
          coverImageUrl: item['cover_image_url'],
          hasLiveStream: item['has_live_stream'] ?? false,
          skillLevelRequired: item['skill_level'] ?? 'Mọi trình độ',
        ));
      }

      return tournaments;
    } catch (e) {
      print('❌ Error fetching tournaments: $e');
      throw Exception('Failed to fetch tournaments: $e');
    }
  }

  /// Get tournaments by status
  Future<List<TournamentModel>> getTournamentsByStatus(String status) async {
    return getTournaments(status: status);
  }

  /// Get upcoming tournaments
  Future<List<TournamentModel>> getUpcomingTournaments() async {
    return getTournaments(status: 'upcoming');
  }

  /// Get live tournaments
  Future<List<TournamentModel>> getLiveTournaments() async {
    return getTournaments(status: 'live');
  }

  /// Get completed tournaments
  Future<List<TournamentModel>> getCompletedTournaments() async {
    return getTournaments(status: 'completed');
  }

  /// Create a new tournament
  Future<TournamentModel?> createTournament(Map<String, dynamic> tournamentData) async {
    try {
      final response = await _supabase
          .from('tournaments')
          .insert(tournamentData)
          .select('''
            id,
            title,
            description,
            format,
            entry_fee,
            prize_pool,
            max_participants,
            current_participants,
            start_date,
            end_date,
            registration_deadline,
            status,
            cover_image_url,
            has_live_stream,
            skill_level,
            clubs!tournaments_club_id_fkey(
              id,
              name,
              address
            )
          ''')
          .single();

      final club = response['clubs'];
      
      return TournamentModel(
        id: response['id'],
        title: response['title'],
        club: ClubModel(
          id: club['id'],
          name: club['name'],
          location: club['address'] ?? 'Chưa xác định',
        ),
        format: response['format'],
        entryFee: (response['entry_fee'] as num).toDouble(),
        prizePool: (response['prize_pool'] as num?)?.toDouble() ?? 0.0,
        currentParticipants: response['current_participants'] ?? 0,
        maxParticipants: response['max_participants'],
        startDate: DateTime.parse(response['start_date']),
        registrationDeadline: response['registration_deadline'] != null 
            ? DateTime.parse(response['registration_deadline']) 
            : null,
        status: response['status'],
        coverImageUrl: response['cover_image_url'],
        hasLiveStream: response['has_live_stream'] ?? false,
        skillLevelRequired: response['skill_level'] ?? 'Mọi trình độ',
      );
    } catch (e) {
      print('❌ Error creating tournament: $e');
      throw Exception('Failed to create tournament: $e');
    }
  }

  /// Update tournament
  Future<bool> updateTournament(String tournamentId, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('tournaments')
          .update(updates)
          .eq('id', tournamentId);
      return true;
    } catch (e) {
      print('❌ Error updating tournament: $e');
      return false;
    }
  }

  /// Delete tournament
  Future<bool> deleteTournament(String tournamentId) async {
    try {
      await _supabase
          .from('tournaments')
          .delete()
          .eq('id', tournamentId);
      return true;
    } catch (e) {
      print('❌ Error deleting tournament: $e');
      return false;
    }
  }

  /// Join tournament
  Future<bool> joinTournament(String tournamentId, String userId) async {
    try {
      // Add participant
      await _supabase
          .from('tournament_participants')
          .insert({
            'tournament_id': tournamentId,
            'user_id': userId,
            'registration_date': DateTime.now().toIso8601String(),
            'payment_status': 'pending',
          });

      // Update participant count
      await _supabase.rpc('increment_tournament_participants', params: {
        'tournament_id': tournamentId,
      });

      return true;
    } catch (e) {
      print('❌ Error joining tournament: $e');
      return false;
    }
  }

  /// Leave tournament
  Future<bool> leaveTournament(String tournamentId, String userId) async {
    try {
      // Remove participant
      await _supabase
          .from('tournament_participants')
          .delete()
          .eq('tournament_id', tournamentId)
          .eq('user_id', userId);

      // Update participant count
      await _supabase.rpc('decrement_tournament_participants', params: {
        'tournament_id': tournamentId,
      });

      return true;
    } catch (e) {
      print('❌ Error leaving tournament: $e');
      return false;
    }
  }
}
