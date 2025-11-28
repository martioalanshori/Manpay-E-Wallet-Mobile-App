import 'package:flutter/material.dart';
import 'package:manpay_ewallet_app/app/auth/auth_controller.dart';
import 'package:manpay_ewallet_app/features/auth/sign_in_page.dart';
import 'package:manpay_ewallet_app/features/onboarding/opening_experience.dart';
import 'package:manpay_ewallet_app/features/shell/main_shell.dart';
import 'package:manpay_ewallet_app/features/splash/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      controller: _authController,
      child: MaterialApp(
        title: 'Manpay E-Wallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        // PENTING: wrapper ini bikin SEMUA halaman lebarnya seperti HP
        builder: (context, child) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430, // lebar "mobile"
              ),
              child: child!,
            ),
          );
        },
        home: const SplashScreen(
          child: LaunchGate(),
        ),
      ),
    );
  }
}


class LaunchGate extends StatelessWidget {
  const LaunchGate({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthScope.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (!controller.hasCompletedOnboarding) {
          return const OpeningExperience();
        }
        if (!controller.isLoggedIn) {
          return const SignInPage();
        }
        return const MainShell();
      },
    );
  }
}

