class Listing {
  final String id;
  final String title;
  final String description;
  final double priceAmount;
  final String priceCurrency;
  final String condition; // new, like_new, good, fair, for_parts
  final List<String> imageUrls;
  final String locationPort;
  final String locationCity;
  final String sellerId;
  final double sellerRating;
  final int sellerReviews;
  final String status; // draft, active, pending, sold, expired
  final DateTime createdAt;
  final List<String> tags;
  final bool deliveryLocal;
  final bool deliveryDomestic;
  final bool deliveryInternational;

  const Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.priceAmount,
    required this.priceCurrency,
    required this.condition,
    required this.imageUrls,
    required this.locationPort,
    required this.locationCity,
    required this.sellerId,
    required this.sellerRating,
    required this.sellerReviews,
    required this.status,
    required this.createdAt,
    this.tags = const [],
    this.deliveryLocal = false,
    this.deliveryDomestic = false,
    this.deliveryInternational = false,
  });

  String get formattedPrice {
    String symbol = priceCurrency == 'GBP'
        ? '£'
        : priceCurrency == 'USD'
        ? '\$'
        : '€';
    return '$symbol${priceAmount.toStringAsFixed(0)}';
  }

  String get conditionBadge {
    switch (condition) {
      case 'new':
        return 'New';
      case 'like_new':
        return 'Like New';
      case 'good':
        return 'Good';
      case 'fair':
        return 'Fair';
      default:
        return 'For Parts';
    }
  }
}
