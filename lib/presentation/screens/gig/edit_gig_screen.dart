import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/gig_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/loading_widget.dart';

/// Screen for editing an existing gig
class EditGigScreen extends ConsumerStatefulWidget {
  final String gigId;

  const EditGigScreen({super.key, required this.gigId});

  @override
  ConsumerState<EditGigScreen> createState() => _EditGigScreenState();
}

class _EditGigScreenState extends ConsumerState<EditGigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _updateGig() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final gigFormNotifier = ref.read(gigFormProvider.notifier);
    final success = await gigFormNotifier.updateGig(
      gigId: widget.gigId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ref.refresh(gigByIdProvider(widget.gigId));
      ref.read(gigsProvider.notifier).loadGigs();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Travay modifye!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go(AppRoutes.home);
    } else {
      final error = ref.read(gigFormProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error?.toString() ?? 'Erè nan modifye travay'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gigAsync = ref.watch(gigByIdProvider(widget.gigId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifye travay'),
      ),
      body: gigAsync.when(
        data: (gig) {
          if (!_isInitialized) {
            _titleController.text = gig.title;
            _descriptionController.text = gig.description;
            _priceController.text = gig.price.toStringAsFixed(0);
            _isInitialized = true;
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tit travay',
                    prefixIcon: Icon(Icons.title_outlined),
                  ),
                  validator: Validators.gigTitle,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
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
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _isLoading ? null : _updateGig,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Anrejistre chanjman'),
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => Center(
          child: Text('Erè: $error'),
        ),
      ),
    );
  }
}
