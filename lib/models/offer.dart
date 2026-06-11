class Offer {
  final String id;
  final String listingId;
  final String buyerId;
  final double amount;
  final String currency;
  final String status; // pending, accepted, countered, declined
  final String? message;
  final DateTime expiresAt;

  const Offer({
    required this.id,
    required this.listingId,
    required this.buyerId,
    required this.amount,
    required this.currency,
    required this.status,
    this.message,
    required this.expiresAt,
  });
}

// Mock offers for demo
final List<Offer> mockOffers = [
  Offer(
    id: 'offer1',
    listingId: 'listing1',
    buyerId: 'buyer123',
    amount: 250.0,
    currency: 'GBP',
    status: 'pending',
    message: 'Can you do £225? Item looks great!',
    expiresAt: DateTime(2024, 10, 1, 12, 0),
  ),
  Offer(
    id: 'offer2',
    listingId: 'listing1',
    buyerId: 'buyer456',
    amount: 300.0,
    currency: 'GBP',
    status: 'accepted',
    expiresAt: DateTime(2024, 10, 1, 10, 0),
  ),
];
