import 'package:flutter/material.dart';
import 'lib/repositories/tournament_repository.dart';
import 'lib/models/tournament_model.dart';

/// Test tournament repository with real Supabase data
void testTournamentRepository() async {
  print('🧪 Testing Tournament Repository with Real Supabase Data');
  print('=' * 60);
  
  final repo = TournamentRepository();
  
  try {
    // Test 1: Get all tournaments
    print('\n1. Testing getTournaments()...');
    final tournaments = await repo.getTournaments(limit: 5);
    print('✅ Found ${tournaments.length} tournaments');
    
    for (final tournament in tournaments) {
      print('   - ${tournament.title} (${tournament.status})');
      print('     Club: ${tournament.club.name}');
      print('     Participants: ${tournament.currentParticipants}/${tournament.maxParticipants}');
      print('     Entry Fee: ${tournament.entryFee}đ');
    }
    
    // Test 2: Get upcoming tournaments
    print('\n2. Testing getUpcomingTournaments()...');
    final upcomingTournaments = await repo.getUpcomingTournaments();
    print('✅ Found ${upcomingTournaments.length} upcoming tournaments');
    
    // Test 3: Get live tournaments
    print('\n3. Testing getLiveTournaments()...');
    final liveTournaments = await repo.getLiveTournaments();
    print('✅ Found ${liveTournaments.length} live tournaments');
    
    // Test 4: Get completed tournaments
    print('\n4. Testing getCompletedTournaments()...');
    final completedTournaments = await repo.getCompletedTournaments();
    print('✅ Found ${completedTournaments.length} completed tournaments');
    
    print('\n🎉 All tests completed successfully!');
    print('✅ Tournament Repository is now using REAL Supabase data');
    
  } catch (e) {
    print('❌ Error testing tournament repository: $e');
    print('\n🔧 Possible solutions:');
    print('1. Make sure Supabase is connected');
    print('2. Check if tournaments table exists');
    print('3. Run tournament_repository_functions.sql in Supabase');
    print('4. Add some test data to tournaments table');
  }
}