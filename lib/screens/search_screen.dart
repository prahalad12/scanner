import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/listing.dart';
import '../theme.dart';
import '../widgets/listing_card.dart';
import 'listing_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  int _selectedCategory = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Listing> get _results {
    return mockListings.where((l) {
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        if (!l.title.toLowerCase().contains(q) &&
            !l.description.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (_selectedCategory > 0) {
        final cats = mockCategories;
        if (_selectedCategory - 1 < cats.length) {
          final slug = cats[_selectedCategory - 1].slug;
          if (!l.tags.any((t) => t.contains(slug) || slug.contains(t))) {
            return false;
          }
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: YwcTheme.surface,
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryChips(),
          Expanded(
            child: results.isEmpty
                ? _buildEmpty()
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.74,
                    ),
                    itemCount: results.length,
                    itemBuilder: (context, i) => ListingCard(
                      listing: results[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ListingDetailScreen(listing: results[i]),
                        ),
                      ),
                    ),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                autofocus: false,
                onChanged: (v) => setState(() => _query = v),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search uniforms, safety gear, books...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon:
                              const Icon(Icons.close_rounded, color: Colors.white),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.11),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
                        color: Colors.white.withValues(alpha: 0.45), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final labels = ['All', ...mockCategories.map((c) => c.name)];
    return Container(
      color: YwcTheme.surface2,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                      color: selected ? YwcTheme.navy : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? YwcTheme.navy : YwcTheme.borderColor,
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
          ),
          const Divider(height: 1, color: YwcTheme.borderColor),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _query.isEmpty
                ? Icons.manage_search_rounded
                : Icons.search_off_rounded,
            size: 72,
            color: YwcTheme.text3,
          ),
          const SizedBox(height: 16),
          Text(
            _query.isEmpty ? 'Start searching' : 'No results found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: YwcTheme.text2,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            _query.isEmpty
                ? 'Type to find uniforms, gear and more'
                : 'Try different keywords or filters',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: YwcTheme.text3),
          ),
        ],
      ),
    );
  }
}