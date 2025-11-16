import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/gig.dart';
import '../../providers/gig_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/auth_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/gig_card.dart';

/// Home screen with map and gigs list
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedTab = _tabController.index);
    });
    _requestLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _requestLocation() async {
    final locationNotifier = ref.read(locationProvider.notifier);
    await locationNotifier.getCurrentLocation();
  }

  void _createMarkers(List<Gig> gigs) {
    _markers.clear();
    for (final gig in gigs) {
      _markers.add(
        Marker(
          markerId: MarkerId(gig.id),
          position: LatLng(gig.latitude, gig.longitude),
          infoWindow: InfoWindow(
            title: gig.title,
            snippet: '${AppConstants.currencySymbol} ${gig.price.toStringAsFixed(0)}',
            onTap: () => context.push('${AppRoutes.gigDetail}/${gig.id}'),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gigsAsync = ref.watch(gigsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.map_outlined), text: 'Kat'),
            Tab(icon: Icon(Icons.list_outlined), text: 'Lis'),
          ],
        ),
      ),
      body: gigsAsync.when(
        data: (gigs) {
          if (_selectedTab == 0) {
            _createMarkers(gigs);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Map view
              _buildMapView(gigs),
              // List view
              _buildListView(gigs),
            ],
          );
        },
        loading: () => const LoadingWidget(message: 'Chaje travay yo...'),
        error: (error, stack) => ErrorDisplayWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(gigsProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createGig),
        icon: const Icon(Icons.add),
        label: const Text('Ajoute travay'),
      ),
    );
  }

  Widget _buildMapView(List<Gig> gigs) {
    final locationAsync = ref.watch(locationProvider);

    final initialPosition = locationAsync.value != null
        ? LatLng(
            locationAsync.value!.latitude,
            locationAsync.value!.longitude,
          )
        : const LatLng(
            AppConstants.defaultLatitude,
            AppConstants.defaultLongitude,
          );

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: AppConstants.defaultZoom,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapToolbarEnabled: false,
      onMapCreated: (controller) {
        _mapController = controller;
      },
    );
  }

  Widget _buildListView(List<Gig> gigs) {
    if (gigs.isEmpty) {
      return const Center(
        child: Text('Pa gen travay pou kounye a'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(gigsProvider.notifier).loadGigs();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: gigs.length,
        itemBuilder: (context, index) {
          final gig = gigs[index];
          return GigCard(
            gig: gig,
            onTap: () => context.push('${AppRoutes.gigDetail}/${gig.id}'),
          );
        },
      ),
    );
  }
}
