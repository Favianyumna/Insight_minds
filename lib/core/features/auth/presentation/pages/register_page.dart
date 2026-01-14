import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
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

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedGender;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    HapticFeedbackHelper.medium();

    try {
      await ref.read(currentUserProvider.notifier).register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fullName: _fullNameController.text.trim(),
            phoneNumber: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
            age: _ageController.text.trim().isEmpty
                ? null
                : int.tryParse(_ageController.text.trim()),
            gender: _selectedGender,
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            HapticFeedbackHelper.selection();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: AnimatedAuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.padding2XL),
            child: FadeSlideTransition(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
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
                      Icons.person_add_alt_1,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing2XL),

                  const Text(
                    'Buat Akun Baru',
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
                    'Daftar untuk memulai perjalanan kesehatan mental Anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeSM,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing3XL),

                  // Register form card
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
                            // Full Name
                            CustomTextField(
                              label: AppStrings.fullName,
                              hint: 'Masukkan nama lengkap',
                              controller: _fullNameController,
                              validator: Validators.validateFullName,
                              prefixIcon: Icons.person_outlined,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSizes.spacingLG),

                            // Email
                            CustomTextField(
                              label: AppStrings.email,
                              hint: 'nama@email.com',
                              controller: _emailController,
                              validator: Validators.validateEmail,
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSizes.spacingLG),

                            // Phone (optional)
                            CustomTextField(
                              label: '${AppStrings.phoneNumber} (Opsional)',
                              hint: '08xxxxxxxxxx',
                              controller: _phoneController,
                              validator: Validators.validatePhone,
                              prefixIcon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSizes.spacingLG),

                            // Age and Gender row
                            Row(
                              children: [
                                // Age
                                Expanded(
                                  child: CustomTextField(
                                    label: '${AppStrings.age} (Opsional)',
                                    hint: '25',
                                    controller: _ageController,
                                    validator: Validators.validateAge,
                                    prefixIcon: Icons.calendar_today,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSizes.spacingMD),

                                // Gender
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _selectedGender,
                                    decoration: InputDecoration(
                                      labelText: AppStrings.gender,
                                      prefixIcon:
                                          const Icon(Icons.people_outline),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.radiusLG),
                                      ),
                                      filled: true,
                                      fillColor: theme.cardColor,
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Laki-laki',
                                        child: Text('Laki-laki'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Perempuan',
                                        child: Text('Perempuan'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Lainnya',
                                        child: Text('Lainnya'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                      HapticFeedbackHelper.selection();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.spacingLG),

                            // Password
                            PasswordField(
                              label: AppStrings.password,
                              hint: 'Minimal 6 karakter',
                              controller: _passwordController,
                              validator: Validators.validatePassword,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSizes.spacingLG),

                            // Confirm Password
                            PasswordField(
                              label: AppStrings.confirmPassword,
                              hint: 'Ulangi password',
                              controller: _confirmPasswordController,
                              validator: (value) =>
                                  Validators.validateConfirmPassword(
                                value,
                                _passwordController.text,
                              ),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleRegister(),
                            ),
                            const SizedBox(height: AppSizes.spacingXL),

                            // Error message
                            if (_errorMessage != null) ...[
                              AuthErrorMessage(message: _errorMessage!),
                              const SizedBox(height: AppSizes.spacing2XL),
                            ],

                            // Register button
                            AuthSubmitButton(
                              text: AppStrings.register,
                              onPressed: _handleRegister,
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing2XL),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticFeedbackHelper.selection();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Masuk',
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
