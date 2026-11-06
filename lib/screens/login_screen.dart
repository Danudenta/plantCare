import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app/router.dart';
import '../app/theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_text_field.dart';

/// Login dummy. Isi field bertahan lewat restoration.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with RestorationMixin {
  final RestorableTextEditingController _username =
      RestorableTextEditingController();
  final RestorableTextEditingController _password =
      RestorableTextEditingController();
  final RestorableBool _obscurePassword = RestorableBool(true);
  final FocusNode _passwordFocus = FocusNode();

  @override
  String? get restorationId => 'login-screen';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_username, 'username');
    registerForRestoration(_password, 'password');
    registerForRestoration(_obscurePassword, 'obscure-password');
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _obscurePassword.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthViewModel>();
    final success = await auth.login(
      _username.value.text,
      _password.value.text,
    );
    if (!success || !mounted) return;
    context.go(Routes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) SystemNavigator.pop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: AppLogo(size: 88)),
                    const SizedBox(height: 16),
                    Text(
                      'Selamat Datang',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      controller: _username.value,
                      label: 'Username',
                      errorText: auth.usernameError,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.person_outline),
                      onChanged: (_) => auth.clearUsernameError(),
                      onSubmitted: (_) => _passwordFocus.requestFocus(),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _password.value,
                      focusNode: _passwordFocus,
                      label: 'Password',
                      errorText: auth.passwordError,
                      obscureText: _obscurePassword.value,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword.value
                            ? 'Tampilkan password'
                            : 'Sembunyikan password',
                        onPressed: () {
                          setState(() {
                            _obscurePassword.value = !_obscurePassword.value;
                          });
                        },
                        icon: Icon(
                          _obscurePassword.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      onChanged: (_) => auth.clearPasswordError(),
                      onSubmitted: (_) => _submit(),
                    ),
                    if (auth.credentialsError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        auth.credentialsError!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: auth.isLoading ? null : _submit,
                      child: auth.isLoading
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : const Text('Masuk'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Akun demo: admin / 123456',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.muted,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
