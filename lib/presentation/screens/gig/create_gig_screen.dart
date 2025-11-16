import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../providers/gig_provider.dart';
import '../../providers/location_provider.dart';
import '../../router/app_router.dart';

/// Screen for creating a new gig
class CreateGigScreen extends ConsumerStatefulWidget {
  const CreateGigScreen({super.key});

  @override
  ConsumerState<CreateGigScreen> createState() => _CreateGigScreenState();
}

class _CreateGigScreenState extends ConsumerState<CreateGigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  bool _useCurrentLocation = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _useCurrentLocation = true);

    final locationNotifier = ref.read(locationProvider.notifier);
    await locationNotifier.getCurrentLocation();

    final locationState = ref.read(locationProvider);
    locationState.whenData((location) {
      if (location != null) {
        setState(() {
          _latitude = location.latitude;
          _longitude = location.longitude;
          _locationController.text = location.address ?? 'Pozisyon aktyèl';
        });
      }
    });

    setState(() => _useCurrentLocation = false);
  }

  Future<void> _selectLocationOnMap() async {
    final result = await showDialog<LatLng>(
      context: context,
      builder: (context) => _LocationPickerDialog(
        initialPosition: _latitude != null && _longitude != null
            ? LatLng(_latitude!, _longitude!)
            : null,
      ),
    );

    if (result != null) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
      });

      // Get address for selected location
      final locationNotifier = ref.read(locationProvider.notifier);
      final address = await locationNotifier.getAddress(
        result.latitude,
        result.longitude,
      );
      if (address != null) {
        _locationController.text = address;
      }
    }
  }

  Future<void> _createGig() async {
    if (!_formKey.currentState!.validate()) return;

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanpri chwazi yon lokalizasyon'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final gigFormNotifier = ref.read(gigFormProvider.notifier);
    final success = await gigFormNotifier.createGig(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text),
      latitude: _latitude!,
      longitude: _longitude!,
      locationName: _locationController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      // Refresh gigs list
      ref.read(gigsProvider.notifier).loadGigs();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Travay kreye avèk siksè!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go(AppRoutes.home);
    } else {
      final error = ref.read(gigFormProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error?.toString() ?? 'Erè nan kreye travay'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvo travay'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Tit travay',
                prefixIcon: Icon(Icons.title_outlined),
              ),
              validator: Validators.gigTitle,
              enabled: !_isLoading,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsyon',
                prefixIcon: Icon(Icons.description_outlined),
                alignLabelWithHint: true,
              ),
              validator: Validators.gigDescription,
              enabled: !_isLoading,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Price field
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Pri (${AppConstants.currency})',
                prefixIcon: const Icon(Icons.attach_money_outlined),
              ),
              validator: Validators.price,
              enabled: !_isLoading,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Location section
            Text(
              'Lokalizasyon',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            // Location display
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Adrès',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanpri chwazi yon lokalizasyon';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Location buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading || _useCurrentLocation
                        ? null
                        : _getCurrentLocation,
                    icon: _useCurrentLocation
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                    label: const Text('Kounye a'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _selectLocationOnMap,
                    icon: const Icon(Icons.map),
                    label: const Text('Sou kat'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Create button
            FilledButton(
              onPressed: _isLoading ? null : _createGig,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Kreye travay'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog for picking location on map
class _LocationPickerDialog extends StatefulWidget {
  final LatLng? initialPosition;

  const _LocationPickerDialog({this.initialPosition});

  @override
  State<_LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<_LocationPickerDialog> {
  late LatLng _selectedPosition;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition ??
        const LatLng(
          AppConstants.defaultLatitude,
          AppConstants.defaultLongitude,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Chwazi lokalizasyon',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedPosition,
                  zoom: 14,
                ),
                onTap: (position) {
                  setState(() => _selectedPosition = position);
                },
                markers: {
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: _selectedPosition,
                  ),
                },
                onMapCreated: (controller) => _controller = controller,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Anile'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, _selectedPosition),
                    child: const Text('Konfime'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
