import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget child;

  const SplashScreen({
    super.key,
    required this.child,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _showSplash = true;
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    // Animation: fade in (→ stay → fade out)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // total 5 detik
    );

    _opacity = TweenSequence<double>([
      // Fade in → 0s - 2s
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40, // 2 detik
      ),

      // Stay full opacity → 2s - 3s
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 20, // 1 detik
      ),

      // Fade out → 3s - 5s
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40, // 2 detik
      ),
    ]).animate(_controller);

    _controller.forward();

    // Setelah animasi selesai → masuk ke halaman berikutnya
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) return _buildSplash();
    return widget.child;
  }

  Widget _buildSplash() {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: FadeTransition(
          opacity: _opacity,
          child: Image.asset(
            'assets/logo_manpay.png',
            width: 200,   // DIBESARKAN
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
