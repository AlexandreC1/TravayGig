import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/auth_provider.dart';
import '../../providers/gig_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/gig_card.dart';

/// User profile screen
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userGigsAsync = ref.watch(userGigsProvider);

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Pa gen itilizatè konekte')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pwofil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmSignOut(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: currentUser.avatarUrl != null
                        ? CachedNetworkImageProvider(currentUser.avatarUrl!)
                        : null,
                    child: currentUser.avatarUrl == null
                        ? Text(
                            currentUser.fullName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontSize: 40),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentUser.fullName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentUser.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // User's gigs section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Travay mwen yo',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: () => context.push(AppRoutes.createGig),
                    icon: const Icon(Icons.add),
                    label: const Text('Ajoute'),
                  ),
                ],
              ),
            ),

            // Gigs list
            userGigsAsync.when(
              data: (gigs) {
                if (gigs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.work_off_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ou poko kreye okenn travay',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => context.push(AppRoutes.createGig),
                          icon: const Icon(Icons.add),
                          label: const Text('Kreye premye travay ou'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: gigs.length,
                  itemBuilder: (context, index) {
                    final gig = gigs[index];
                    return GigCard(
                      gig: gig,
                      onTap: () => context.push('${AppRoutes.gigDetail}/${gig.id}'),
                    );
                  },
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(32),
                child: Text('Erè: $error'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dekonekte'),
        content: const Text('Ou sèten ou vle dekonekte?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Anile'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Dekonekte'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).signOut();
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    }
  }
}
