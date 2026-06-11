import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/listing_card.dart';
import 'listing_detail_screen.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  // Pre-seed a few saved items for demo
  final _saved = mockListings.take(3).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YwcTheme.surface,
      body: Column(
        children: [
          _buildHeader(),
          if (_saved.isEmpty)
            Expanded(child: _buildEmpty())
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.74,
                ),
                itemCount: _saved.length,
                itemBuilder: (context, i) => ListingCard(
                  listing: _saved[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ListingDetailScreen(listing: _saved[i]),
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
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white),
              ),
              Expanded(
                child: Text(
                  'Saved Items',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (_saved.isNotEmpty)
                TextButton(
                  onPressed: () =>
                      setState(() => _saved.clear()),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Colors.white.withValues(alpha: 0.7),
                  ),
                  child: const Text('Clear all',
                      style: TextStyle(fontSize: 13)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline_rounded,
              size: 64, color: YwcTheme.text3),
          const SizedBox(height: 14),
          Text(
            'No saved items',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: YwcTheme.text2,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap the heart icon on any listing to save it',
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