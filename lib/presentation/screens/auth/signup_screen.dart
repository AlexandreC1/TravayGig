import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../router/app_router.dart';

/// Signup screen for new user registration
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _fullNameController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    final authState = ref.read(authProvider);
    if (authState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanpri konfime modpas ou';
    }
    if (value != _passwordController.text) {
      return 'Modpas yo pa menm';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    'Kreye yon kont',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(),
                  const SizedBox(height: 8),
                  Text(
                    'Enskri pou kòmanse',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 48),

                  // Full name field
                  TextFormField(
                    controller: _fullNameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Non konplè',
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                    validator: Validators.fullName,
                    enabled: !_isLoading,
                  ).animate().slideX(delay: 200.ms),
                  const SizedBox(height: 16),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Imel',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: Validators.email,
                    enabled: !_isLoading,
                  ).animate().slideX(delay: 300.ms),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Modpas',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    validator: Validators.password,
                    enabled: !_isLoading,
                  ).animate().slideX(delay: 400.ms),
                  const SizedBox(height: 16),

                  // Confirm password field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleSignup(),
                    decoration: InputDecoration(
                      labelText: 'Konfime modpas',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() =>
                              _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                      ),
                    ),
                    validator: _validateConfirmPassword,
                    enabled: !_isLoading,
                  ).animate().slideX(delay: 500.ms),
                  const SizedBox(height: 32),

                  // Signup button
                  FilledButton(
                    onPressed: _isLoading ? null : _handleSignup,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Enskri'),
                  ).animate().fadeIn(delay: 600.ms).scale(delay: 600.ms),
                  const SizedBox(height: 16),

                  // Login link
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => context.go(AppRoutes.login),
                    child: const Text('Gen kont deja? Konekte'),
                  ).animate().fadeIn(delay: 700.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
