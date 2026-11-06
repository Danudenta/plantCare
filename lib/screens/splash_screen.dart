import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../app/router.dart';
import '../widgets/app_logo.dart';

/// Layar pembuka. Pindah ke login sekali setelah sekitar 2 detik.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _hasNavigated = false;
  var _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
    Future<void>.delayed(const Duration(seconds: 2), _openLogin);
  }

  void _openLogin() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: const Duration(milliseconds: 600),
            child: SizedBox.expand(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AppLogo(size: 112, onPrimary: true),
                      const SizedBox(height: 20),
                      Text(
                        'PlantCare',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rawat tanamanmu dengan mudah',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: onPrimary,
                            ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: CircularProgressIndicator(
                        color: onPrimary,
                        semanticsLabel: 'Memuat',
                      ),
                    ),
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
