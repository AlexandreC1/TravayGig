import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/gig_provider.dart';
import '../../providers/auth_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

/// Screen to display gig details
class GigDetailScreen extends ConsumerWidget {
  final String gigId;

  const GigDetailScreen({super.key, required this.gigId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gigAsync = ref.watch(gigByIdProvider(gigId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detay travay'),
      ),
      body: gigAsync.when(
        data: (gig) {
          final isOwner = currentUser?.id == gig.userId;
          final numberFormat = NumberFormat.currency(
            symbol: '${AppConstants.currencySymbol} ',
            decimalDigits: 0,
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Map preview
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(gig.latitude, gig.longitude),
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(gig.id),
                        position: LatLng(gig.latitude, gig.longitude),
                      ),
                    },
                    zoomControlsEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        gig.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          numberFormat.format(gig.price),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'Deskripsyon',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        gig.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),

                      // Location
                      Text(
                        'Lokalizasyon',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              gig.locationName ?? 'Okenn adrès',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // User info
                      Text(
                        'Poste pa',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: gig.userAvatarUrl != null
                                ? CachedNetworkImageProvider(gig.userAvatarUrl!)
                                : null,
                            child: gig.userAvatarUrl == null
                                ? Text(
                                    gig.userFullName?.substring(0, 1).toUpperCase() ?? 'U',
                                    style: const TextStyle(fontSize: 20),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            gig.userFullName ?? 'Unknown',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Created date
                      Text(
                        'Dat: ${DateFormat('MMMM d, y').format(gig.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      // Edit/Delete buttons for owner
                      if (isOwner) ...[
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => context.push(
                                  '${AppRoutes.editGig}/${gig.id}',
                                ),
                                icon: const Icon(Icons.edit),
                                label: const Text('Modifye'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => _confirmDelete(context, ref),
                                icon: const Icon(Icons.delete),
                                label: const Text('Efase'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorDisplayWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(gigByIdProvider(gigId)),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Efase travay'),
        content: const Text('Ou sèten ou vle efase travay sa a?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Anile'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Efase'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final gigFormNotifier = ref.read(gigFormProvider.notifier);
      final success = await gigFormNotifier.deleteGig(gigId);

      if (context.mounted) {
        if (success) {
          ref.read(gigsProvider.notifier).loadGigs();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Travay efase'),
              backgroundColor: Colors.green,
            ),
          );
          context.go(AppRoutes.home);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erè nan efase travay'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
