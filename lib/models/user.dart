import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String role;
  final String avatarColor; // gradient start
  final double rating;
  final int reviews;
  final String location;
  final bool isVerified;
  final bool isOnline;
  final int activeListings;

  const User({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarColor,
    this.rating = 0.0,
    this.reviews = 0,
    required this.location,
    this.isVerified = false,
    this.isOnline = false,
    this.activeListings = 0,
  });

  Color get avatarGradientStart =>
      Color(int.parse('FF$avatarColor', radix: 16));

  List<Color> get avatarGradient => [
    avatarGradientStart,
    avatarGradientStart.withValues(alpha: 0.8),
  ];

  Widget avatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: avatarGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Demo users matching HTML
const List<User> mockUsers = [
  User(
    id: 'seller123',
    name: 'Sarah E.',
    role: 'Chief Stewardess',
    avatarColor: '0FA9A0',
    rating: 4.9,
    reviews: 23,
    location: 'Antibes, France',
    isVerified: true,
    activeListings: 8,
  ),
  User(
    id: 'buyer456',
    name: 'Marcus T.',
    role: 'Deckhand',
    avatarColor: '132D52',
    rating: 4.8,
    reviews: 12,
    location: 'Palma, Spain',
    isOnline: true,
  ),
  User(
    id: 'seller789',
    name: 'Elena L.',
    role: 'Interior Crew',
    avatarColor: 'A0529A',
    rating: 4.7,
    reviews: 15,
    location: 'Monaco',
  ),
];
