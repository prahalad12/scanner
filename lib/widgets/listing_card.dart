import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/listing.dart';
import '../theme.dart';

class ListingCard extends StatefulWidget {
  final Listing listing;
  final VoidCallback? onTap;

  const ListingCard({super.key, required this.listing, this.onTap});

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  bool _favorited = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: widget.onTap,
        child: Container(
          clipBehavior: Clip.hardEdge,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image section with overlays
              SizedBox(
                height: 112,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14)),
                      child: widget.listing.imageUrls.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.listing.imageUrls.first,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                color:
                                    YwcTheme.teal.withValues(alpha: 0.08),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color:
                                    YwcTheme.teal.withValues(alpha: 0.08),
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 28,
                                  color: YwcTheme.text3,
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    YwcTheme.teal.withValues(alpha: 0.08),
                                    YwcTheme.teal.withValues(alpha: 0.16),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.checkroom_outlined,
                                size: 32,
                                color: YwcTheme.teal,
                              ),
                            ),
                    ),
                    // Condition badge — bottom left
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: _ConditionBadge(
                          condition: widget.listing.condition),
                    ),
                    // Favorite button — top right
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _favorited = !_favorited),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.88),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _favorited
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 16,
                            color: _favorited
                                ? YwcTheme.red
                                : YwcTheme.text3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.listing.title,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                            color: YwcTheme.text1,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.listing.formattedPrice,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(
                            fontWeight: FontWeight.w800,
                            color: YwcTheme.navy,
                            height: 1.2,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 10, color: YwcTheme.text3),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            widget.listing.locationPort,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: YwcTheme.text3,
                                  fontSize: 10,
                                  height: 1.2,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star_rounded,
                            size: 11, color: YwcTheme.gold),
                        const SizedBox(width: 2),
                        Text(
                          widget.listing.sellerRating.toStringAsFixed(1),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                color: YwcTheme.text3,
                                fontSize: 10,
                                height: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConditionBadge extends StatelessWidget {
  final String condition;
  const _ConditionBadge({required this.condition});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    String label;
    switch (condition) {
      case 'new':
        bgColor = YwcTheme.green;
        label = 'New';
        break;
      case 'like_new':
        bgColor = YwcTheme.teal;
        label = 'Like New';
        break;
      case 'good':
        bgColor = YwcTheme.navyLight;
        label = 'Good';
        break;
      case 'fair':
        bgColor = YwcTheme.gold;
        label = 'Fair';
        break;
      default:
        bgColor = YwcTheme.red;
        label = 'For Parts';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }
}