import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/listing.dart';
import '../models/offer.dart';
import '../models/user.dart';
import '../theme.dart';

class ListingDetailScreen extends StatefulWidget {
  final Listing listing;

  const ListingDetailScreen({super.key, required this.listing});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  int _currentImage = 0;
  bool _isFavorited = false;
  late final List<Offer> _offers;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _offers = mockOffers
        .where((o) => o.listingId == widget.listing.id)
        .toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seller = mockUsers.firstWhere(
      (u) => u.id == widget.listing.sellerId,
      orElse: () => mockUsers[0],
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: YwcTheme.navy,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white70,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() => _isFavorited = !_isFavorited);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentImage = index),
                    itemCount: widget.listing.imageUrls.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: double.infinity,
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: widget.listing.imageUrls[index],
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.image,
                                color: Colors.white70,
                                size: 64,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Container(
                height: 30,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.listing.imageUrls.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: _currentImage == index ? 14 : 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: _currentImage == index
                            ? Colors.white
                            : Colors.white38,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: YwcTheme.surface2,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.listing.title,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 17,
                              color: YwcTheme.navy,
                              height: 1.35,
                            ),
                          ),
                        ),
                        Text(
                          widget.listing.formattedPrice,
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    // Tags
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _TagChip(
                          label: widget.listing.conditionBadge,
                          color: YwcTheme.teal,
                        ),
                        _TagChip(label: 'Size 10 UK', color: YwcTheme.gold),
                        _TagChip(
                          label:
                              '${widget.listing.locationPort}, ${widget.listing.locationCity}',
                          color: YwcTheme.navy,
                        ),
                        if (widget.listing.deliveryDomestic)
                          _TagChip(label: 'Ships EU', color: YwcTheme.green),
                      ],
                    ),
                    // Divider
                    Container(
                      height: 1,
                      color: YwcTheme.borderColor,
                      margin: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    // Description
                    Text(
                      'About this item',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.listing.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(color: YwcTheme.text2),
                    ),
                    // Divider
                    Container(
                      height: 1,
                      color: YwcTheme.borderColor,
                      margin: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    // Seller
                    Text(
                      'Seller',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: YwcTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          seller.avatar(20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  seller.name,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          Icons.star,
                                          size: 11,
                                          color: i < seller.rating
                                              ? YwcTheme.gold
                                              : YwcTheme.text3,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' ${seller.reviews} sales',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F5FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Verified Crew',
                              style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(color: const Color(0xFF1A5A9B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Analytics
                    Container(
                      height: 1,
                      color: YwcTheme.borderColor,
                      margin: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    Text(
                      'Analytics',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _AnalyticsChip(value: '142', label: 'Views'),
                        const SizedBox(width: 6),
                        _AnalyticsChip(value: '18', label: 'Watchers'),
                        const SizedBox(width: 6),
                        _AnalyticsChip(
                          value: '${_offers.length}',
                          label: 'Offers',
                        ),
                      ],
                    ),
                    // Divider
                    Container(
                      height: 1,
                      color: YwcTheme.borderColor,
                      margin: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    // Delivery
                    Text(
                      'Delivery options',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        _DeliveryOption(
                          icon: Icons.local_shipping,
                          label:
                              'Local pickup (${widget.listing.locationPort})',
                        ),
                        if (widget.listing.deliveryDomestic)
                          _DeliveryOption(
                            icon: Icons.local_shipping,
                            label: 'Domestic Shipping',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: YwcTheme.surface2,
            boxShadow: [
              BoxShadow(
                color: YwcTheme.borderColor.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: YwcTheme.navy, width: 1.5),
                  ),
                  onPressed: () {},
                  child: const Text('Message'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _makeOffer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: YwcTheme.navy,
                  ),
                  child: const Text('Make Offer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _makeOffer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => OfferModal(listing: widget.listing),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TagChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _AnalyticsChip extends StatelessWidget {
  final String value;
  final String label;

  const _AnalyticsChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: YwcTheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: YwcTheme.navy,
              ),
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: YwcTheme.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DeliveryOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: YwcTheme.teal),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

// Keep existing OfferModal
class OfferModal extends StatefulWidget {
  final Listing listing;

  const OfferModal({super.key, required this.listing});

  @override
  State<OfferModal> createState() => _OfferModalState();
}

class _OfferModalState extends State<OfferModal> {
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Make Offer', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Your offer (${widget.listing.priceCurrency})',
              prefix: Text(widget.listing.priceCurrency),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Message to seller (optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Offer sent! (Mock)')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Send Offer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
