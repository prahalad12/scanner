import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/listing.dart';
import '../theme.dart';
import '../widgets/listing_card.dart';
import 'listing_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Listing> get _filtered {
    return mockListings.where((l) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!l.title.toLowerCase().contains(q) &&
            !l.description.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (_selectedCategory > 0) {
        final cats = mockCategories;
        if (_selectedCategory - 1 < cats.length) {
          final slug = cats[_selectedCategory - 1].slug.split('-').first;
          if (!l.tags.any((t) => t.contains(slug) || slug.contains(t))) {
            return false;
          }
        }
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(Listing l) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: l)),
      );

  @override
  Widget build(BuildContext context) {
    final featured = mockListings.take(4).toList();
    final listings = _filtered;

    return Scaffold(
      backgroundColor: YwcTheme.surface,
      body: Column(
        children: [
          // Fixed sticky header
          _buildHeader(),
          // Scrollable content
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildStatsBand()),
                SliverToBoxAdapter(child: _buildCategories()),
                SliverToBoxAdapter(
                  child: _buildSectionHeader('Featured Listings', onTap: () {}),
                ),
                SliverToBoxAdapter(child: _buildFeatured(featured)),
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    _searchQuery.isNotEmpty ? 'Search Results' : 'Recent Listings',
                    onTap: () {},
                  ),
                ),
                if (listings.isEmpty)
                  SliverToBoxAdapter(child: _buildEmpty())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    sliver: SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.74,
                      ),
                      itemCount: listings.length,
                      itemBuilder: (context, index) => ListingCard(
                        listing: listings[index],
                        onTap: () => _openDetail(listings[index]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [YwcTheme.navy, YwcTheme.navyLight],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 12, 0),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          YwcTheme.teal,
                          YwcTheme.teal.withValues(alpha: 0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Hello, Sarah 👋',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        Text(
                          'Chief Stewardess · Antibes',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color:
                                    Colors.white.withValues(alpha: 0.68),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Positioned(
                        right: 9,
                        top: 9,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: YwcTheme.teal,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: const TextStyle(
                    color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search uniforms, safety gear...',
                  hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  suffixIcon: _searchQuery.isEmpty
                      ? Icon(
                          Icons.tune_rounded,
                          color: Colors.white.withValues(alpha: 0.7),
                        )
                      : IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.white),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.11),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.45),
                        width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBand() {
    return Container(
      color: YwcTheme.navy,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: const BoxDecoration(
          color: YwcTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          children: [
            _StatItem(
                value: '1,240',
                label: 'Items Listed',
                icon: Icons.sell_outlined),
            _Divider(),
            _StatItem(
                value: '342',
                label: 'Uniforms',
                icon: Icons.checkroom_outlined),
            _Divider(),
            _StatItem(
                value: '89',
                label: 'Safety Gear',
                icon: Icons.shield_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final labels = ['All', ...mockCategories.map((c) => c.name)];
    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        itemCount: labels.length,
        itemBuilder: (context, i) {
          final selected = _selectedCategory == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selected ? YwcTheme.navy : YwcTheme.surface2,
                borderRadius: BorderRadius.circular(23),
                border: Border.all(
                  color: selected
                      ? YwcTheme.navy
                      : YwcTheme.borderColor,
                ),
              ),
              child: Center(
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color:
                        selected ? Colors.white : YwcTheme.text2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 8, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: YwcTheme.navy,
                ),
          ),
          if (onTap != null)
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                foregroundColor: YwcTheme.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: const Text(
                'See all',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatured(List<Listing> listings) {
    return SizedBox(
      height: 198,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: listings.length,
        itemBuilder: (context, i) {
          final l = listings[i];
          return GestureDetector(
            onTap: () => _openDetail(l),
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: YwcTheme.surface2,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: YwcTheme.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        l.imageUrls.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: l.imageUrls.first,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(
                                  color: YwcTheme.teal
                                      .withValues(alpha: 0.08),
                                  child: const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: YwcTheme.text3),
                                ),
                              )
                            : Container(
                                color: YwcTheme.teal
                                    .withValues(alpha: 0.08)),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: _FeaturedBadge(condition: l.condition),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: YwcTheme.text1,
                                  height: 1.3,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l.formattedPrice,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: YwcTheme.navy,
                                      height: 1.2,
                                    ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 10,
                                    color: YwcTheme.text3,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    l.locationPort,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: YwcTheme.text3,
                                          height: 1.2,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: YwcTheme.text3),
          const SizedBox(height: 14),
          Text(
            'No listings found',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: YwcTheme.text2, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Try a different search or category',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: YwcTheme.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StatItem(
      {required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: YwcTheme.teal),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: YwcTheme.navy,
              height: 1.2,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
                fontSize: 10, color: YwcTheme.text3, height: 1.2),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 36,
        color: YwcTheme.borderColor,
      );
}

class _FeaturedBadge extends StatelessWidget {
  final String condition;
  const _FeaturedBadge({required this.condition});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String label;
    switch (condition) {
      case 'new':
        bg = YwcTheme.green;
        label = 'New';
        break;
      case 'like_new':
        bg = YwcTheme.teal;
        label = 'Like New';
        break;
      case 'good':
        bg = YwcTheme.navyLight;
        label = 'Good';
        break;
      case 'fair':
        bg = YwcTheme.gold;
        label = 'Fair';
        break;
      default:
        bg = YwcTheme.red;
        label = 'For Parts';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }
}