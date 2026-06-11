# YWC Crew Marketplace — Improvement Plan

## Priority Legend
- 🔴 High — blocks production readiness or causes bugs
- 🟡 Medium — affects maintainability and UX quality
- 🟢 Low — polish and future-proofing

---

## 1. Architecture

### 1.1 Add a State Management Library 🔴
**Problem:** Everything uses `setState`. As screens multiply, sharing state (current user, cart, favorites, offers) requires prop-drilling or duplicated logic.

**Fix:** Adopt [Riverpod](https://riverpod.dev/) (recommended for Flutter 3+).
- Create `providers/` directory with `listings_provider.dart`, `auth_provider.dart`, `chat_provider.dart`
- Replace `mockListings` getter calls with `ref.watch(listingsProvider)`

### 1.2 Add a Repository / Service Layer 🔴
**Problem:** Screens call mock data directly (`mockListings`, `mockOffers`, `mockUsers`). Swapping to a real API requires touching every screen.

**Fix:** Introduce `lib/repositories/`:
```
lib/
  repositories/
    listing_repository.dart   # abstract + MockListingRepository
    user_repository.dart
    offer_repository.dart
    chat_repository.dart
```
Each screen depends on the abstract repository, injected via Riverpod. Real API implementations slot in without touching UI.

### 1.3 Add Named Routing (go_router) 🟡
**Problem:** Raw `Navigator.push(MaterialPageRoute(...))` is scattered across screens. Deep linking, back-stack management, and web URL support are impossible.

**Fix:** Add `go_router: ^14.0.0` and a `lib/router.dart`:
```dart
final router = GoRouter(routes: [
  GoRoute(path: '/', builder: (_,__) => const LoginScreen()),
  GoRoute(path: '/home', builder: (_,__) => const BottomNavWrapper()),
  GoRoute(path: '/listing/:id', builder: (_, state) => ...),
  GoRoute(path: '/chat/:id', builder: (_, state) => ...),
]);
```

### 1.4 Move Mock Data Out of Model Files 🟡
**Problem:** `mockUsers` lives in `lib/models/user.dart` and `mockCategories` in `lib/models/category.dart`. Model files should be pure data shapes, not data sources.

**Fix:** Move all `const List<X> mockX = [...]` blocks into `lib/data/mock_data.dart`.

### 1.5 Remove Widget Logic from the `User` Model 🟡
**Problem:** `User.avatar(double size)` returns a `Widget`. Models should not import or build Flutter widgets — it couples the data layer to the UI layer and makes the model untestable in pure Dart.

**Fix:** Delete `avatar()` from `User`. Create `lib/widgets/user_avatar.dart`:
```dart
class UserAvatar extends StatelessWidget {
  final User user;
  final double size;
  ...
}
```

---

## 2. Bugs & Code Quality

### 2.1 Duplicate Condition Label Logic 🔴
**Problem:** `Listing.conditionBadge` (model) and `_ConditionBadge._labelFor()` (widget) both map condition strings to display labels. They will drift out of sync.

**File:** `lib/models/listing.dart:51` and `lib/widgets/listing_card.dart:181`

**Fix:** Delete `_labelFor()` in `_ConditionBadge` and use `listing.conditionBadge` directly.

### 2.2 Hardcoded `'Size 10 UK'` Tag 🔴
**Problem:** `ListingDetailScreen` renders a hardcoded `_TagChip(label: 'Size 10 UK', ...)`. The `Listing` model has no size field — this data is fabricated.

**File:** `lib/screens/listing_detail_screen.dart:188`

**Fix:** Either add a `size` field to `Listing`, or remove the chip until the field exists.

### 2.3 Hardcoded Colors Outside `YwcTheme` 🟡
**Problem:** Several files use raw hex colors that are already defined in `YwcTheme`.

| File | Line | Raw Color | Should Be |
|---|---|---|---|
| `bottom_nav_bar.dart` | 36–38 | `Color(0xFF0FA9A0)` etc. | `YwcTheme.teal` |
| `listing_detail_screen.dart` | 291 | `Color(0xFFE6F5FF)` | (add `YwcTheme.infoLight`) |
| `listing_card.dart` | 145 | `Color(0xFFE3F8F4)` | (add `YwcTheme.tealLight10`) |

**Fix:** Reference `YwcTheme` constants everywhere. Add any missing semantic colors to `YwcTheme`.

### 2.4 Offer Modal Has No Validation 🟡
**Problem:** "Send Offer" can be tapped with an empty amount field or a non-numeric value. The `!` force-unwrap on `_formKey.currentState!.validate()` in `LoginScreen` can also crash if the form is not mounted.

**File:** `lib/screens/listing_detail_screen.dart:567`, `lib/screens/login_screen.dart:26`

**Fix:**
- Wrap `OfferModal` fields in a `Form` with validators
- Replace `!` with null-safe `?? false` in login

### 2.5 Filter Bottom Sheet Is Non-Functional 🟡
**Problem:** The filter sheet in `HomeScreen` shows Location / Condition / Delivery options but selecting them does nothing — they have no state and no callback.

**File:** `lib/screens/home_screen.dart:192`

**Fix:** Either wire up real filter state (pass callbacks into `FilterBottomSheet`) or replace the sheet with a `// TODO` comment to signal it's unimplemented rather than mislead users.

### 2.6 Sell Tab Shows Blank Screen 🟡
**Problem:** `BottomNavWrapper._screens[2]` is `const SizedBox()`. Tapping "Sell" renders an empty white area with no feedback.

**File:** `lib/widgets/bottom_nav_bar.dart:17`

**Fix:** Show a placeholder screen with a "Coming Soon" message, or intercept the tap and open `CreateListingScreen` directly via `showModalBottomSheet`.

---

## 3. Missing Screens (from TODO.md)

| Screen | File | Priority |
|---|---|---|
| Search with filters | `lib/screens/search_screen.dart` | 🔴 |
| Create Listing | `lib/screens/create_listing_screen.dart` | 🔴 |
| Seller Profile / Dashboard | `lib/screens/profile_screen.dart` | 🟡 |
| Seller Analytics Dashboard | `lib/screens/dashboard_screen.dart` | 🟢 |

**Search screen** should accept a `query` parameter so `HomeScreen` can push to it with a prefilled term.

**CreateListingScreen** should use `image_picker` (already in pubspec) to let users attach photos, and pre-select a category via a dropdown.

---

## 4. UX & Visual Polish

### 4.1 Inconsistent SafeArea Usage 🟡
`BottomNavWrapper` wraps `body` in `SafeArea` but individual screens also add their own. `ListingDetailScreen` uses `bottomNavigationBar` for the CTA bar and applies `SafeArea` there — correct. Audit every screen to ensure exactly one `SafeArea` per edge.

### 4.2 `HomeScreen` Still Uses Old AppBar Style 🟡
`HomeScreen.appBar` uses `backgroundColor: Theme.of(context).colorScheme.inversePrimary` instead of `YwcTheme.navy`, inconsistent with every other screen.

**File:** `lib/screens/home_screen.dart:40`

### 4.3 Grid/List Toggle on HomeScreen Is Wired Up But Grid Renders as List 🟡
`_isGridView` is toggled but `SliverList.builder` is always used regardless of the flag.

**File:** `lib/screens/home_screen.dart:148`

**Fix:** Switch between `SliverGrid` (2-column) and `SliverList` based on `_isGridView`.

### 4.4 Pull-to-Refresh 🟢
Add `RefreshIndicator` wrapping `CustomScrollView` in `HomeScreen` and `MessagesScreen`. Even with mock data, this is the expected behavior on a marketplace and will be needed when the API is wired up.

### 4.5 Favorites Persistence 🟢
`_isFavorited` in `ListingDetailScreen` is local widget state and resets on pop. Favorites should live in a global provider so the heart icon reflects state when the user returns to the list.

---

## 5. Performance

### 5.1 `TweenAnimationBuilder` Per Chat Tile Rebuilds on Every `setState` 🟡
**Problem:** In `MessagesScreen._buildChatTile`, each tile is wrapped in `TweenAnimationBuilder`. Every time `_query` changes (on each keystroke), all tiles rebuild and re-animate.

**File:** `lib/screens/messages_screen.dart:262`

**Fix:** Use a `ListView.builder` with `AnimatedList` or trigger the animation once via `initState`, not on every rebuild.

### 5.2 `HomeScreen._filterListings` Does a Full Scan on Every Keystroke 🟢
Fine for mock data, but will be slow with real data. When connected to an API, debounce the search input (300ms) and delegate filtering to the backend.

---

## 6. Accessibility

### 6.1 Missing Semantic Labels 🟡
Most `IconButton`s have no `tooltip` or `semanticLabel`. Screen readers will announce "button" with no context.

**Quick wins:**
```dart
// bottom_nav_bar.dart
IconButton(icon: Icon(Icons.add), tooltip: 'Create listing', ...)

// listing_detail_screen.dart
IconButton(icon: Icon(Icons.favorite_border), tooltip: 'Save to favourites', ...)
```

### 6.2 `_ConditionBadge` Text Is 9px 🟡
The condition and location labels in `ListingCard` use `fontSize: 9`, below the 11px minimum recommended for legibility on small screens.

---

## 7. Testing

### 7.1 Only the Default Widget Test Exists 🟡
`test/widget_test.dart` tests nothing project-specific. Recommended test coverage:

| Test | Type | Target |
|---|---|---|
| `Listing.formattedPrice` for all currencies | Unit | `lib/models/listing.dart` |
| `Listing.conditionBadge` for all conditions | Unit | `lib/models/listing.dart` |
| `HomeScreen` renders listings and category grid | Widget | `lib/screens/home_screen.dart` |
| `HomeScreen` search filters the list | Widget | `lib/screens/home_screen.dart` |
| `LoginScreen` shows error on empty form submit | Widget | `lib/screens/login_screen.dart` |
| `OfferModal` blocks submit with empty amount | Widget | `lib/screens/listing_detail_screen.dart` |

---

## 8. Next Step Sequence

Recommended implementation order to maximize progress without re-work:

```
1. Fix bugs 2.1 – 2.6 (quick wins, no architecture change needed)
2. Build Search screen (unblocks basic app usability)
3. Build CreateListing screen (core marketplace flow)
4. Add Riverpod + repositories (do once, before Profile/Dashboard)
5. Wire favorites to global state
6. Build Profile screen
7. Add go_router
8. Connect to real API (swap mock repositories)
```