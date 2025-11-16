import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/gig.dart';
import '../../core/constants/app_constants.dart';
import 'package:intl/intl.dart';

/// Card widget to display a gig in a list
class GigCard extends StatelessWidget {
  final Gig gig;
  final VoidCallback onTap;

  const GigCard({
    super.key,
    required this.gig,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(
      symbol: '${AppConstants.currencySymbol} ',
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: gig.userAvatarUrl != null
                        ? CachedNetworkImageProvider(gig.userAvatarUrl!)
                        : null,
                    child: gig.userAvatarUrl == null
                        ? Text(
                            gig.userFullName?.substring(0, 1).toUpperCase() ??
                                'U',
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gig.userFullName ?? 'Unknown',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          _formatDate(gig.createdAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  // Price chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      numberFormat.format(gig.price),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                gig.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                gig.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Location
              if (gig.locationName != null)
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        gig.locationName!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(
          begin: 0.2,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minit pase';
      }
      return '${difference.inHours} è pase';
    } else if (difference.inDays == 1) {
      return 'Yè';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} jou pase';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }
}
