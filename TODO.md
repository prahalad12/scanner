# YWC Crew Marketplace Flutter UI Implementation Plan

## Status: In Progress

### 1. Update pubspec.yaml ✅ (google_fonts, carousel_slider added)
- Add google_fonts (^6.2.1)
- Add carousel_slider (^5.0.0)

### 2. Update lib/main.dart ✅
- Added YwcTheme
- Home now BottomNavWrapper

### 3. Create lib/widgets/bottom_nav_bar.dart ✅
- 5-tab bottom nav (Home/Search/Sell/Msg/Profile)
- Placeholder screens

### 4. Update lib/screens/home_screen.dart ✅
- CustomScrollView w/ navy gradient header (greeting/avatar/notif/search)
- Stats pills row
- Horizontal category chips
- Trending horizontal cards
- 2-col listings grid

### 5. Enhance lib/widgets/listing_card.dart ✅
- Match HTML design (img/title/price/condition/location)

### 6. Update lib/screens/listing_detail_screen.dart ✅
- Hero image carousel
- Seller card, analytics, sticky CTA

### 7. Extend lib/data/mock_data.dart [PENDING]
- Add users, reviews, chats, more listings

### 8. Create new screens [PENDING]
- create_listing_screen.dart
- dashboard_screen.dart
- messages_screen.dart
- profile_screen.dart
- search_screen.dart

### 9. Add supporting widgets [PENDING]
- category_chip.dart, stat_pill.dart, etc.

### 10. Test & Polish [PENDING]
- flutter pub get
- flutter run
- SafeArea everywhere
- Responsive checks

**Next step: Test app (`flutter run`), then update detail screen (step 6)**

