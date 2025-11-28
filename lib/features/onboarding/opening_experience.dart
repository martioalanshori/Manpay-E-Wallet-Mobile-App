import 'package:flutter/material.dart';
import 'package:manpay_ewallet_app/app/auth/auth_controller.dart';

// ====================================================
// OPENING EXPERIENCE + SIGN UP
// ====================================================

class OpeningSlide {
  final String title;
  final String description;
  final IconData icon;

  const OpeningSlide({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OpeningExperience extends StatefulWidget {
  const OpeningExperience({super.key});

  @override
  State<OpeningExperience> createState() => _OpeningExperienceState();
}

class _OpeningExperienceState extends State<OpeningExperience> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<OpeningSlide> _slides = [
    OpeningSlide(
      title: 'Kontrol penuh, satu dompet',
      description:
          'Pantau saldo, tagihan, dan arus kas harian tanpa UI berwarna-warni yang melelahkan.',
      icon: Icons.dashboard_customize_rounded,
    ),
    OpeningSlide(
      title: 'Transfer lebih cepat',
      description:
          'QR bawaan dan daftar tujuan favorit bikin kirim dana ke mana pun tetap simpel.',
      icon: Icons.qr_code_2_rounded,
    ),
    OpeningSlide(
      title: 'Privasi jadi standar',
      description:
          'Semua data hanya tersimpan di perangkat. Kamu yang pegang kendali penuh.',
      icon: Icons.verified_user_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleAction() {
    if (_currentPage == _slides.length - 1) {
      AuthScope.of(context).completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => AuthScope.of(context).completeOnboarding(),
                  child: const Text('Lewati'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) => setState(() {
                    _currentPage = index;
                  }),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ===========================
                        // LOGO MANPAY
                        // ===========================
                        Image.asset(
                          'assets/logo_manpay.png',
                          width: 300,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 1),

                        // ===========================
                        // ICON SLIDE
                        // ===========================
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Icon(
                            slide.icon,
                            size: 90,
                            color: Colors.grey[800],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ===========================
                        // TITLE
                        // ===========================
                        Text(
                          slide.title,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        // ===========================
                        // DESCRIPTION
                        // ===========================
                        Text(
                          slide.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // ===========================
              // INDICATOR DOTS
              // ===========================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    width: isActive ? 32 : 10,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.black : Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // ===========================
              // BUTTON
              // ===========================
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: _handleAction,
                  child: Text(
                    _currentPage == _slides.length - 1
                        ? 'Mulai gunakan Manpay'
                        : 'Lanjut',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
