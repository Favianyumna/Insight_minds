import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import 'register_page.dart';
import '../../../../utils/haptic_feedback_helper.dart';
import '../../../../shared/widgets/auth/animated_auth_background.dart';
import '../../../../shared/widgets/forms/custom_text_field.dart';
import '../../../../shared/widgets/forms/password_field.dart';
import '../../../../shared/widgets/auth/auth_error_message.dart';
import '../../../../shared/widgets/auth/auth_submit_button.dart';
import '../../../../shared/widgets/animations/fade_slide_transition.dart';
import '../../../../shared/utils/validators.dart';
import '../../../../shared/constants/app_sizes.dart';
import '../../../../shared/constants/app_strings.dart';
import '../../../../shared/constants/app_routes.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    HapticFeedbackHelper.medium();

    try {
      await ref.read(currentUserProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.home,
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
      HapticFeedbackHelper.heavy();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedAuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.padding2XL),
            child: FadeSlideTransition(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Logo and title
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingXL),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology_alt,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing2XL),

                  const Text(
                    'Selamat Datang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSizes.fontSize5XL,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingSM),
                  Text(
                    'Masuk ke akun Anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeLG,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing4XL),

                  // Login form card
                  Card(
                    elevation: AppSizes.elevationLG,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radius2XL),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.padding2XL),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email field
                            CustomTextField(
                              label: AppStrings.email,
                              hint: 'nama@email.com',
                              controller: _emailController,
                              validator: Validators.validateEmail,
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSizes.spacingXL),

                            // Password field
                            PasswordField(
                              label: AppStrings.password,
                              hint: 'Masukkan password',
                              controller: _passwordController,
                              validator: Validators.validatePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleLogin(),
                            ),
                            const SizedBox(height: AppSizes.spacingMD),

                            // Error message
                            if (_errorMessage != null) ...[
                              AuthErrorMessage(message: _errorMessage!),
                              const SizedBox(height: AppSizes.spacing2XL),
                            ],

                            // Login button
                            AuthSubmitButton(
                              text: AppStrings.login,
                              onPressed: _handleLogin,
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing2XL),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun? ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticFeedbackHelper.selection();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
