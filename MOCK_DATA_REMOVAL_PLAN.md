# MOCK DATA REMOVAL PLAN 🚨
**Date:** September 17, 2025  
**Objective:** Replace ALL mock data with real Supabase data

---

## 🔍 CURRENT STATUS

✅ **ALREADY USING REAL SUPABASE DATA:**
- `lib/services/post_repository.dart` ✅ 
- `lib/repositories/comment_repository.dart` ✅
- `lib/services/supabase_service.dart` ✅ 

⚠️ **STILL USING MOCK DATA:**

### 🏆 TOURNAMENT SYSTEM
1. **`lib/repositories/tournament_repository.dart`** - **CRITICAL**
   - Returns hardcoded tournament list
   - Need to connect to `tournaments` table

### 🏛️ CLUB SYSTEM  
2. **`lib/presentation/club_dashboard_screen/club_dashboard_screen.dart`**
   - Mock club stats, activities, tournaments
   - Lines: 875, 892, 1051, 1060

### 👥 MEMBER MANAGEMENT
3. **`lib/presentation/member_management_screen/member_management_screen.dart`**
   - Mock member data (line 42)
   
4. **`lib/presentation/member_management_screen/widgets/add_member_dialog.dart`**
   - Creates mock members (lines 600, 601, 624)

5. **`lib/presentation/membership_request_screen/membership_request_screen.dart`**
   - Mock membership requests (lines 557-560, 694-695)

### 🎯 MATCH MANAGEMENT
6. **`lib/presentation/match_management_screen/match_management_screen_simple.dart`**
   - Mock matches and analytics (lines 31, 59, 63, 72, 567)

### 👤 MEMBER DETAILS
7. **`lib/presentation/member_detail_screen/widgets/member_activity_tab.dart`**
   - Mock activities (lines 32, 33, 186, 428)

8. **`lib/presentation/member_detail_screen/widgets/member_matches_tab.dart`**
   - Mock match records (lines 32, 200, 547)

9. **`lib/presentation/member_detail_screen/widgets/member_tournaments_tab.dart`**
   - Mock tournament participation (lines 32, 587)

### 💬 COMMUNICATION
10. **`lib/presentation/member_communication_screen/member_communication_screen.dart`**
    - Mock chat rooms, announcements, notifications (lines 830-832, 958-1058)

### 🏆 TOURNAMENT DETAILS
11. **`lib/presentation/tournament_detail_screen/widgets/enhanced_bracket_management_tab.dart`**
    - Mock participants (lines 597, 598, 638, 720)

12. **`lib/presentation/tournament_detail_screen/widgets/tournament_management_panel.dart`**
    - Mock activities and matches (lines 416, 469, 521, 585)

13. **`lib/presentation/tournament_detail_screen/widgets/tournament_stats_view.dart`**
    - Mock statistics (lines 63, 793)

14. **`lib/presentation/tournament_creation_wizard/tournament_creation_wizard.dart`**
    - Creates dummy participants (line 808)

---

## 🎯 PRIORITY ACTION PLAN

### 🚨 **PHASE 1: CRITICAL SYSTEMS (Week 1)**
1. **Tournament Repository** - Replace with real Supabase queries
2. **Club Dashboard** - Connect to real club data
3. **Member Management** - Use real user profiles

### ⚡ **PHASE 2: DETAIL SCREENS (Week 2)**  
4. **Match Management** - Real match data
5. **Member Details** - Real activity/match history
6. **Membership Requests** - Real approval workflow

### 🚀 **PHASE 3: ADVANCED FEATURES (Week 3)**
7. **Communication System** - Real chat/notifications
8. **Tournament Management** - Real bracket/stats
9. **Testing & Validation** - Ensure all real data works

---

## 🛠️ IMPLEMENTATION STRATEGY

### 1. Create Missing Supabase Tables
```sql
-- If not exist, create required tables
CREATE TABLE IF NOT EXISTS tournaments (...);
CREATE TABLE IF NOT EXISTS clubs (...);
CREATE TABLE IF NOT EXISTS matches (...);
CREATE TABLE IF NOT EXISTS member_activities (...);
```

### 2. Update Repository Pattern
```dart
// Replace mock data with Supabase calls
Future<List<Tournament>> getTournaments() async {
  final response = await _supabase
    .from('tournaments')
    .select('*')
    .order('created_at', ascending: false);
  return response.map((json) => Tournament.fromJson(json)).toList();
}
```

### 3. Add Error Handling
```dart
try {
  return await fetchRealData();
} catch (e) {
  // Fallback or error state
  throw RepositoryException('Failed to fetch data: $e');
}
```

---

## 🎯 NEXT STEPS

**IMMEDIATE ACTION REQUIRED:**
1. **Start with Tournament Repository** (highest impact)
2. **Remove mock data from Club Dashboard** 
3. **Test each replacement thoroughly**

Bạn muốn tôi bắt đầu từ đâu trước? Tournament Repository hay Club Dashboard?