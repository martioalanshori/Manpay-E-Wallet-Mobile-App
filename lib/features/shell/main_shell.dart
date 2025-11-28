import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:manpay_ewallet_app/app/auth/auth_controller.dart';

// ====================================================
// SHELL UTAMA + BOTTOM NAV
// ====================================================

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C3CFF);
    const Color primaryPurpleDark = Color(0xFF4015D8);
    const Color neonYellow = Color(0xFFF8FF35);

    final pages = [
      HomeTab(
        primaryPurple: primaryPurple,
        primaryPurpleDark: primaryPurpleDark,
      ),
      const InsightsPage(),
      const MyCardsPage(),
      ProfilePage(
        primaryPurple: primaryPurple,
        primaryPurpleDark: primaryPurpleDark,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: Offset(0, -4),
              color: Color(0x1A000000),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => setState(() => _currentIndex = 0),
              child: _BottomNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: _currentIndex == 0,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _currentIndex = 1),
              child: _BottomNavItem(
                icon: Icons.insights_rounded,
                label: 'Insights',
                isActive: _currentIndex == 1,
              ),
            ),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QrScannerPage(),
                  ),
                );
                if (!context.mounted) return;
                if (result == null) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('QR detected: $result'),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.only(
                      bottom: 100,
                      left: 20,
                      right: 20,
                    ),
                  ),
                );
              },
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: neonYellow,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                      color: Colors.black.withValues(alpha: 0.20),
                    ),
                  ],
                ),
                child: const Icon(Icons.qr_code_scanner_rounded),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _currentIndex = 2),
              child: _BottomNavItem(
                icon: Icons.credit_card_rounded,
                label: 'My Cards',
                isActive: _currentIndex == 2,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _currentIndex = 3),
              child: _BottomNavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                isActive: _currentIndex == 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ProfilePage extends StatelessWidget {
  final Color primaryPurple;
  final Color primaryPurpleDark;

  const ProfilePage({
    super.key,
    required this.primaryPurple,
    required this.primaryPurpleDark,
  });

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final user = auth.user;
    final displayName = user?.fullName ?? 'Pengguna Manpay';
    final maskedAccount = user?.maskedAccountId ?? '*****022329';
    final contactEmail = user?.email ?? 'Belum ada email terdaftar';
    final contactPhone = user?.phoneNumber ?? 'Nomor ponsel belum diisi';
    final joinedInfo = user != null
        ? 'Aktif sejak ${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}'
        : 'Mode demo aktif';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryPurple,
                    primaryPurpleDark,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                  maskedAccount,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          letterSpacing: 1.2,
                        ),
                  ),
                const SizedBox(height: 2),
                Text(
                  joinedInfo,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 12), // <<< tambahin ini
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                            color: Colors.black.withValues(alpha: 0.06),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Akun Utama',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6F4FF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'AM',
                                  style: TextStyle(
                                    color: primaryPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Manpay Wallet',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      user != null
                                          ? 'ID ${user.accountNumber}'
                                          : 'ID *****022329',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MyCardsPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Ubah',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: primaryPurple,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: primaryPurple,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MyCardsPage(),
                                  ),
                                );
                              },
                              child: const Text('+ Tambah Kartu'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                            color: Colors.black.withValues(alpha: 0.03),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Lainnya',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(height: 1),
                          _ProfileMenuTile(
                            icon: Icons.person_outline_rounded,
                            label: 'Data Pribadi',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PersonalPage(user: user),
                                ),
                              );
                            },
                          ),
                          _ProfileMenuTile(
                            icon: Icons.lock_outline_rounded,
                            label: 'Privasi & Keamanan',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PrivacySecurityPage(),
                                ),
                              );
                            },
                          ),
                          _ProfileMenuTile(
                            icon: Icons.savings_outlined,
                            label: 'Tujuan Menabung',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SavingsGoalsPage(),
                                ),
                              );
                            },
                          ),
                          _ProfileMenuTile(
                            icon: Icons.help_outline_rounded,
                            label: 'Bantuan & Dukungan',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HelpSupportPage(),
                                ),
                              );
                            },
                          ),
                          if (user != null)
                          _ProfileMenuTile(
                            icon: Icons.logout_rounded,
                              label: 'Keluar',
                            isDestructive: true,
                              onTap: auth.logout,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _ProfileMenuTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        isDestructive ? Colors.red[600]! : Colors.black87;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F4FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? Colors.red[600] : const Color(0xFF6C3CFF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// TAB HOME
// ====================================================

class HomeTab extends StatefulWidget {
  final Color primaryPurple;
  final Color primaryPurpleDark;

  const HomeTab({
    super.key,
    required this.primaryPurple,
    required this.primaryPurpleDark,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isBalanceVisible = true;
  final PageController _promoPageController = PageController();
  int _currentPromoIndex = 0;

  @override
  void dispose() {
    _promoPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryPurple = widget.primaryPurple;
    final primaryPurpleDark = widget.primaryPurpleDark;

    return SingleChildScrollView(
      child: Column(
        children: [
          // HEADER BALANCE BARU
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryPurple,
                      primaryPurpleDark,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
 // TOP BAR
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // LOGO MANPAY PUTIH
    Image.asset(
      'assets/logo_manpay_putih.png',
      height: 48,   // Sesuaikan jika mau lebih besar
    ),

    // Bagian kanan tetap sama (no change)
    Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: const [
              Text(
                '*2324',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationsPage(),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.16),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ],
),


                    const SizedBox(height: 24),

                    // PROFIL + SAPAAN
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Text(
                            'M',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C3CFF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, Muhammad Martio Al Anshori',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Text(
                              'Selamat Pagi!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // TOTAL BALANCE
                    Row(
                      children: [
                        Text(
                          'Total Balance',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _isBalanceVisible = !_isBalanceVisible;
                            });
                          },
                          icon: Icon(
                            _isBalanceVisible
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isBalanceVisible ? 'Rp 512.000.000,00' : '•••••••••••',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Updated 2 mins ago',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // QUICK ACTIONS
              Positioned(
                left: 20,
                right: 20,
                bottom: -40,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                        color: Colors.black.withValues(alpha: 0.06),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _QuickActionIcon(
                        icon: Icons.add,
                        label: 'Top Up',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TopUpPage(),
                            ),
                          );
                        },
                      ),
                      _QuickActionIcon(
                        icon: Icons.send,
                        label: 'Transfer',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TransferPage(),
                            ),
                          );
                        },
                      ),
                      _QuickActionIcon(
                        icon: Icons.receipt_long,
                        label: 'History',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HistoryPage(),
                            ),
                          );
                        },
                      ),
                      _QuickActionIcon(
                        icon: Icons.atm,
                        label: 'ATM',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ATMPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 64),

          // HISTORY SINGKAT (RUPIAH)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const _HomeHistoryHeader(),
                const SizedBox(height: 16),

                _TransactionTile(
                  iconBg: const Color(0xFFF5F5F5),
                  icon: Icons.shopping_bag,
                  title: 'Tokopedia',
                  subtitle: 'Shopping',
                  amount: '-Rp 420.000',
                  isIncome: false,
                  date: '23 Nov',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransactionDetailPage(
                          title: 'Tokopedia',
                          category: 'Shopping',
                          amount: '-Rp 420.000',
                          isIncome: false,
                          date: '23 Nov 2024 • 14:32',
                          status: 'Completed',
                          reference: 'TXN-982374623',
                          paymentMethod: 'BCA •••• 1234',
                          icon: Icons.shopping_bag,
                          iconBg: Color(0xFFF5F5F5),
                          location: 'Tokopedia Marketplace',
                          notes: 'Order #INV-2024-001',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),

                _TransactionTile(
                  iconBg: const Color(0xFFEAFBF0),
                  icon: Icons.arrow_downward,
                  title: 'Transfer dari Leo',
                  subtitle: 'Incoming',
                  amount: 'Rp 1.650.000',
                  isIncome: true,
                  date: '16 Nov',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransactionDetailPage(
                          title: 'Transfer dari Leo',
                          category: 'Incoming Transfer',
                          amount: 'Rp 1.650.000',
                          isIncome: true,
                          date: '16 Nov 2024 • 09:15',
                          status: 'Completed',
                          reference: 'TXN-556712390',
                          paymentMethod: 'Bank Transfer',
                          icon: Icons.arrow_downward,
                          iconBg: Color(0xFFEAFBF0),
                          location: 'Manpay Wallet',
                          notes: 'Bayar hutang bulan lalu',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),

                _TransactionTile(
                  iconBg: const Color(0xFFF1E8FF),
                  icon: Icons.local_grocery_store,
                  title: "Alfamart",
                  subtitle: 'Groceries',
                  amount: '-Rp 85.700',
                  isIncome: false,
                  date: '15 Nov',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransactionDetailPage(
                          title: "Alfamart",
                          category: 'Groceries',
                          amount: '-Rp 85.700',
                          isIncome: false,
                          date: '15 Nov 2024 • 18:47',
                          status: 'Completed',
                          reference: 'TXN-880012339',
                          paymentMethod: 'BNI •••• 0987',
                          icon: Icons.local_grocery_store,
                          iconBg: Color(0xFFF1E8FF),
                          location: 'Alfamart Jakarta',
                          notes: 'Belanja mingguan',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // PROMO MANPAY SECTION
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Promo ManPay',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _promoPageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPromoIndex = index;
                          });
                        },
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final promos = [
                            {
                              'title': 'Cashback 10%',
                              'description': 'Untuk setiap transaksi di merchant partner ManPay',
                              'badge': 'PROMO SPESIAL',
                              'gradientColors': [primaryPurple, primaryPurpleDark],
                              'icon': Icons.local_offer_rounded,
                            },
                            {
                              'title': 'Diskon Gojek',
                              'description': 'Dapatkan cashback hingga Rp 15.000 untuk setiap order Gojek',
                              'badge': 'TRANSPORTASI',
                              'gradientColors': [const Color(0xFF00AA13), const Color(0xFF007A0E)],
                              'icon': Icons.motorcycle_rounded,
                            },
                            {
                              'title': 'Tiket Bioskop',
                              'description': 'Diskon 20% untuk pembelian tiket bioskop di CGV & XXI',
                              'badge': 'HIBURAN',
                              'gradientColors': [const Color(0xFFFF6B6B), const Color(0xFFE63946)],
                              'icon': Icons.movie_rounded,
                            },
                            {
                              'title': 'Paket Data',
                              'description': 'Cashback 5% untuk pembelian paket data Telkomsel, XL, Indosat',
                              'badge': 'INTERNET',
                              'gradientColors': [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
                              'icon': Icons.signal_cellular_alt_rounded,
                            },
                            {
                              'title': 'Wahana Hiburan',
                              'description': 'Diskon 25% untuk tiket Dufan, Ancol, dan wahana lainnya',
                              'badge': 'WISATA',
                              'gradientColors': [const Color(0xFFFFB347), const Color(0xFFFF8C00)],
                              'icon': Icons.attractions_rounded,
                            },
                          ];
                          final promo = promos[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: _PromoCard(
                              title: promo['title'] as String,
                              description: promo['description'] as String,
                              badge: promo['badge'] as String,
                              gradientColors: promo['gradientColors'] as List<Color>,
                              icon: promo['icon'] as IconData,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PromoDetailPage(
                                      title: promo['title'] as String,
                                      description: promo['description'] as String,
                                      badge: promo['badge'] as String,
                                      gradientColors: promo['gradientColors'] as List<Color>,
                                      icon: promo['icon'] as IconData,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    // Left arrow button
                    if (_currentPromoIndex > 0)
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              _promoPageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.chevron_left_rounded,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Right arrow button
                    if (_currentPromoIndex < 4)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              _promoPageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Page indicators
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPromoIndex == index
                            ? primaryPurple
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // TOP UP GAME & HIBURAN SECTION
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Top up Game & Hiburan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: [
                    _TopUpItem(
                      title: 'Mobile Legend',
                      icon: Icons.sports_esports_rounded,
                      color: const Color(0xFF1E88E5),
                    ),
                    _TopUpItem(
                      title: 'XXI',
                      icon: Icons.movie_rounded,
                      color: const Color(0xFFE53935),
                    ),
                    _TopUpItem(
                      title: 'CODM',
                      icon: Icons.videogame_asset_rounded,
                      color: const Color(0xFF4CAF50),
                    ),
                    _TopUpItem(
                      title: 'Free Fire',
                      icon: Icons.sports_esports_rounded,
                      color: const Color(0xFFFF9800),
                    ),
                    _TopUpItem(
                      title: 'PUBG Mobile',
                      icon: Icons.videogame_asset_rounded,
                      color: const Color(0xFF9C27B0),
                    ),
                    _TopUpItem(
                      title: 'Valorant',
                      icon: Icons.sports_esports_rounded,
                      color: const Color(0xFFFF5722),
                    ),
                    _TopUpItem(
                      title: 'Steam',
                      icon: Icons.games_rounded,
                      color: const Color(0xFF171A21),
                    ),
                    _TopUpItem(
                      title: 'Spotify',
                      icon: Icons.music_note_rounded,
                      color: const Color(0xFF1DB954),
                    ),
                    _TopUpItem(
                      title: 'Netflix',
                      icon: Icons.play_circle_rounded,
                      color: const Color(0xFFE50914),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _HomeHistoryHeader extends StatelessWidget {
  const _HomeHistoryHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Histori Transaksi',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoryPage(),
                  ),
                );
              },
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFF6C3CFF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Kamu mengeluarkan Rp 12.500.640 lebih banyak dari bulan lalu',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  final String title;
  final String description;
  final String badge;
  final List<Color> gradientColors;
  final IconData icon;
  final VoidCallback? onTap;

  _PromoCard({
    required this.title,
    required this.description,
    required this.badge,
    required this.gradientColors,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Icon decoration
          Positioned(
            top: 10,
            right: 10,
            child: Icon(
              icon,
              size: 60,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Klaim Sekarang',
                      style: TextStyle(
                        color: gradientColors[0],
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _TopUpItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _TopUpItem({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameTopUpPage(
              title: title,
              icon: icon,
              color: color,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// HALAMAN DETAIL PROMO
// ====================================================

class PromoDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String badge;
  final List<Color> gradientColors;
  final IconData icon;

  const PromoDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.badge,
    required this.gradientColors,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Promo',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Promo Card Header
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    left: -80,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          icon,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Detail Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deskripsi Promo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Syarat & Ketentuan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TermItem(text: 'Promo berlaku untuk semua pengguna ManPay'),
                  _TermItem(text: 'Maksimal cashback Rp 100.000 per transaksi'),
                  _TermItem(text: 'Promo tidak dapat digabungkan dengan promo lainnya'),
                  _TermItem(text: 'Promo berlaku hingga 31 Desember 2024'),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Promo berhasil diklaim!'),
                            backgroundColor: const Color(0xFF6C3CFF),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.only(
                              bottom: 100,
                              left: 20,
                              right: 20,
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gradientColors[0],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Klaim Promo Sekarang',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermItem extends StatelessWidget {
  final String text;

  const _TermItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF6C3CFF),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================
// HALAMAN TOP UP GAME & HIBURAN
// ====================================================

class GameTopUpPage extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;

  const GameTopUpPage({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  State<GameTopUpPage> createState() => _GameTopUpPageState();
}

class _GameTopUpPageState extends State<GameTopUpPage> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = 'ManPay Balance';

  String _formatCurrency(int amount) {
    final amountStr = amount.toString();
    String formatted = '';
    int count = 0;
    for (int i = amountStr.length - 1; i >= 0; i--) {
      if (count == 3) {
        formatted = '.$formatted';
        count = 0;
      }
      formatted = amountStr[i] + formatted;
      count++;
    }
    return 'Rp $formatted';
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year} • ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  String _generateReference() {
    return 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Top Up',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Amount Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jumlah Top Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Masukkan jumlah',
                        prefixText: 'Rp ',
                        prefixStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QuickAmountButton(
                        amount: '50.000',
                        onTap: () => _amountController.text = '50000',
                      ),
                      const SizedBox(width: 8),
                      _QuickAmountButton(
                        amount: '100.000',
                        onTap: () => _amountController.text = '100000',
                      ),
                      const SizedBox(width: 8),
                      _QuickAmountButton(
                        amount: '200.000',
                        onTap: () => _amountController.text = '200000',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PaymentMethodTile(
                    title: 'ManPay Balance',
                    subtitle: 'Saldo tersedia: Rp 2.500.000',
                    icon: Icons.account_balance_wallet_rounded,
                    isSelected: _selectedPaymentMethod == 'ManPay Balance',
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'ManPay Balance';
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _PaymentMethodTile(
                    title: 'Bank Transfer',
                    subtitle: 'BCA, BNI, Mandiri, BRI',
                    icon: Icons.account_balance_rounded,
                    isSelected: _selectedPaymentMethod == 'Bank Transfer',
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'Bank Transfer';
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_amountController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Masukkan jumlah top up terlebih dahulu'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.only(
                                bottom: 100,
                                left: 20,
                                right: 20,
                              ),
                            ),
                          );
                          return;
                        }
                        final amount = _amountController.text;
                        final formattedAmount = _formatCurrency(int.parse(amount));
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TopUpTransactionDetailPage(
                              title: widget.title,
                              amount: formattedAmount,
                              date: _getCurrentDateTime(),
                              reference: _generateReference(),
                              paymentMethod: _selectedPaymentMethod,
                              icon: widget.icon,
                              iconBg: widget.color.withValues(alpha: 0.1),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Lanjutkan Top Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _QuickAmountButton extends StatelessWidget {
  final String amount;
  final VoidCallback onTap;

  const _QuickAmountButton({
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              'Rp $amount',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C3CFF) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF6C3CFF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF6C3CFF),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF6C3CFF),
              ),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// HALAMAN DETAIL TRANSAKSI TOP UP
// ====================================================

class TopUpTransactionDetailPage extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final String reference;
  final String paymentMethod;
  final IconData icon;
  final Color iconBg;

  const TopUpTransactionDetailPage({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
    required this.reference,
    required this.paymentMethod,
    required this.icon,
    required this.iconBg,
  });

  String _formatDateTime(String dateStr) {
    // Convert date format from "16 Nov 2024 • 09:15" to "16-11-2024, 09:15:00"
    try {
      final parts = dateStr.split(' • ');
      if (parts.length == 2) {
        final datePart = parts[0].trim();
        final timePart = parts[1].trim();
        
        // Parse date part (e.g., "16 Nov 2024")
        final dateParts = datePart.split(' ');
        if (dateParts.length == 3) {
          final day = dateParts[0].padLeft(2, '0');
          final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
          final monthIndex = monthNames.indexOf(dateParts[1]);
          final month = monthIndex >= 0 ? (monthIndex + 1).toString().padLeft(2, '0') : '01';
          final year = dateParts[2];
          
          // Format time part (add seconds if not present)
          final formattedTime = timePart.length == 5 ? '$timePart:00' : timePart;
          
          return '$day-$month-$year, $formattedTime';
        }
      }
    } catch (e) {
      // If parsing fails, return original
    }
    return dateStr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Green checkmark circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8F5E9),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 48,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 24),

                // Success message
                Text(
                  'Pembayaran Berhasil!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF424242),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Amount
                Text(
                  amount,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF424242),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Divider
                const Divider(color: Color(0xFFE0E0E0)),
                const SizedBox(height: 16),

                // Payment details
                _DetailRow(
                  label: 'Durasi Pengiriman',
                  value: 'Instan',
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Payment Time',
                  value: _formatDateTime(date),
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Metode Pembayaran',
                  value: paymentMethod,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Tujuan',
                  value: title,
                ),

                // Dashed divider
                const SizedBox(height: 16),
                CustomPaint(
                  painter: DashedLinePainter(),
                  child: const SizedBox(height: 1, width: double.infinity),
                ),
                const SizedBox(height: 16),

                // Financial breakdown
                _DetailRow(
                  label: 'Nominal',
                  value: amount,
                ),

                const SizedBox(height: 32),

                // Selesai button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Pop sampai kembali ke halaman pertama (MainShell)
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ====================================================
// HALAMAN DETAIL TRANSAKSI
// ====================================================

class TransactionDetailPage extends StatelessWidget {
  final String title;
  final String category;
  final String amount;
  final bool isIncome;
  final String date;
  final String status;
  final String reference;
  final String paymentMethod;
  final IconData icon;
  final Color iconBg;
  final String? location;
  final String? notes;

  const TransactionDetailPage({
    super.key,
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.status,
    required this.reference,
    required this.paymentMethod,
    required this.icon,
    required this.iconBg,
    this.location,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C3CFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: Column(
        children: [
          // KARTU UTAMA
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  color: Colors.black.withValues(alpha: 0.06),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(icon, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Text(
                  amount,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isIncome ? Colors.green[600] : Colors.red[600],
                      ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: (status == 'Completed'
                            ? Colors.green[50]
                            : Colors.orange[50]) ??
                        Colors.green[50],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        status == 'Completed'
                            ? Icons.check_circle
                            : Icons.timelapse,
                        size: 16,
                        color: status == 'Completed'
                            ? Colors.green[600]
                            : Colors.orange[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: status == 'Completed'
                              ? Colors.green[600]
                              : Colors.orange[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // DETAIL LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _DetailRow(label: 'Tanggal & Waktu', value: date),
                _DetailRow(label: 'ID Referensi', value: reference),
                _DetailRow(label: 'Metode Pembayaran', value: paymentMethod),
                if (location != null)
                  _DetailRow(label: 'Lokasi', value: location!),
                if (notes != null) _DetailRow(label: 'Catatan', value: notes!),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isIncome ? 'Total Diterima' : 'Total Dibayar',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      amount,
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isIncome
                                    ? Colors.green[600]
                                    : Colors.red[600],
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Unduh Struk'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_rounded),
                        label: const Text('Bagikan'),
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryPurple,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================
// TOP UP
// ====================================================

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleScaffoldContent(
      title: 'Top Up',
      subtitle: 'Pilih sumber dana untuk isi saldo ke Manpay.',
      children: [
        _SimpleOptionTile(
          icon: Icons.account_balance_rounded,
          title: 'Bank Transfer (ATM / Teller)',
          subtitle: 'Dari rekening bank apa pun',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TopUpInstructionPage(
                  methodName: 'Bank Transfer (ATM / Teller)',
                  icon: Icons.account_balance_rounded,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _SimpleOptionTile(
          icon: Icons.phone_iphone_rounded,
          title: 'Mobile Banking',
          subtitle: 'BCA, BRI, Mandiri, dll',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TopUpInstructionPage(
                  methodName: 'Mobile Banking',
                  icon: Icons.phone_iphone_rounded,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _SimpleOptionTile(
          icon: Icons.store_mall_directory_rounded,
          title: 'Minimarket (Alfamart / Indomaret)',
          subtitle: 'Bayar tunai di kasir',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TopUpInstructionPage(
                  methodName: 'Minimarket',
                  icon: Icons.store_mall_directory_rounded,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _SimpleOptionTile(
          icon: Icons.language_rounded,
          title: 'Internet Banking',
          subtitle: 'Top up via website bank',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TopUpInstructionPage(
                  methodName: 'Internet Banking',
                  icon: Icons.language_rounded,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class TopUpInstructionPage extends StatelessWidget {
  final String methodName;
  final IconData icon;

  const TopUpInstructionPage({
    super.key,
    required this.methodName,
    required this.icon,
  });

  List<String> _getSteps() {
    switch (methodName) {
      case 'Bank Transfer (ATM / Teller)':
        return [
          'Kunjungi ATM atau teller bank terdekat.',
          'Pilih menu Transfer > Virtual Account.',
          'Masukkan nomor VA Manpay: 8810 1234 5678 9012.',
          'Masukkan nominal top up yang diinginkan.',
          'Konfirmasi transaksi dan simpan bukti transfer.',
        ];
      case 'Mobile Banking':
        return [
          'Buka aplikasi m-banking kamu.',
          'Pilih menu Transfer > Virtual Account / Rekening tujuan baru.',
          'Masukkan VA Manpay: 8810 1234 5678 9012.',
          'Masukkan nominal top up lalu konfirmasi.',
          'Saldo akan masuk ke wallet Manpay dalam beberapa menit.',
        ];
      case 'Minimarket':
        return [
          'Datang ke kasir Alfamart / Indomaret terdekat.',
          'Beritahu kasir ingin top up Manpay.',
          'Tunjukkan kode bayar: 9988 1122 3344.',
          'Bayar sesuai nominal yang diinginkan + admin.',
          'Saldo akan otomatis masuk ke wallet Manpay.',
        ];
      case 'Internet Banking':
      default:
        return [
          'Login ke akun internet banking kamu.',
          'Pilih menu Transfer > Virtual Account / Rekening tujuan baru.',
          'Masukkan VA Manpay: 8810 1234 5678 9012.',
          'Masukkan nominal top up lalu konfirmasi.',
          'Cek saldo wallet Manpay untuk memastikan top up berhasil.',
        ];
    }
  }

  String _getExtraInfo() {
    switch (methodName) {
      case 'Minimarket':
        return 'Minimal top up Rp20.000. Biaya admin mengikuti kebijakan minimarket.';
      case 'Mobile Banking':
        return 'Pastikan limit harian transfer kamu masih mencukupi.';
      default:
        return 'Nomor Virtual Account ini hanya contoh (dummy) untuk desain UI.';
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C3CFF);
    final steps = _getSteps();
    final extraInfo = _getExtraInfo();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: Text('Top Up - $methodName'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  color: Colors.black.withValues(alpha: 0.03),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F4FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 22, color: primaryPurple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        methodName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gunakan instruksi di bawah ini untuk mengisi saldo Manpay kamu.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  color: Colors.black.withValues(alpha: 0.03),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  methodName == 'Minimarket'
                      ? 'Kode Pembayaran'
                      : 'Nomor Virtual Account',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  methodName == 'Minimarket'
                      ? '9988 1122 3344'
                      : '8810 1234 5678 9012',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Langkah-langkah Top Up',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...steps.asMap().entries.map((e) {
            final index = e.key + 1;
            final text = e.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryPurple.withValues(alpha: 0.1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$index',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: primaryPurple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEBFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 18, color: primaryPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    extraInfo,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================
// TRANSFER
// ====================================================

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleScaffoldContent(
      title: 'Transfer',
      subtitle: 'Kirim saldo Manpay ke rekening atau e-wallet lain.',
      children: [
        _SimpleOptionTile(
          icon: Icons.account_balance_rounded,
          title: 'Ke Rekening Bank',
          subtitle: 'Transfer ke rekening bank apa pun',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TransferFormPage(
                  transferType: 'Rekening Bank',
                  icon: Icons.account_balance_rounded,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _SimpleOptionTile(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Ke E-Wallet',
          subtitle: 'Dana, OVO, Gopay, dll (dummy)',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TransferFormPage(
                  transferType: 'E-Wallet',
                  icon: Icons.account_balance_wallet_rounded,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _SimpleOptionTile(
          icon: Icons.qr_code_2_rounded,
          title: 'Scan QR',
          subtitle: 'Kirim ke merchant / teman',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const QrScannerPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class TransferFormPage extends StatefulWidget {
  final String transferType;
  final IconData icon;

  const TransferFormPage({
    super.key,
    required this.transferType,
    required this.icon,
  });

  @override
  State<TransferFormPage> createState() => _TransferFormPageState();
}

class _TransferFormPageState extends State<TransferFormPage> {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int? _selectedQuickAmount;
  final List<int> _quickAmounts = [50000, 100000, 200000, 500000];

  @override
  void dispose() {
    _destinationController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onQuickAmountTap(int value) {
    setState(() {
      _selectedQuickAmount = value;
      _amountController.text = value.toString();
    });
  }

  void _onSubmit() {
    if (_destinationController.text.isEmpty ||
        _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Isi nomor tujuan dan nominal dulu ya.'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(
            bottom: 100,
            left: 20,
            right: 20,
          ),
        ),
      );
      return;
    }

    // Format amount
    final amountValue = int.parse(_amountController.text);
    String formattedAmount = '';
    final amountStr = amountValue.toString();
    int count = 0;
    for (int i = amountStr.length - 1; i >= 0; i--) {
      if (count == 3 && i > 0) {
        formattedAmount = '.$formattedAmount';
        count = 0;
      }
      formattedAmount = amountStr[i] + formattedAmount;
      count++;
    }
    final finalAmount = 'IDR $formattedAmount,00';
    
    // Calculate transfer fee (3% or minimum 3000)
    final transferFeeAmount = (amountValue * 0.03).round();
    final fee = transferFeeAmount < 3000 ? 3000 : transferFeeAmount;
    String formattedFee = '';
    final feeStr = fee.toString();
    count = 0;
    for (int i = feeStr.length - 1; i >= 0; i--) {
      if (count == 3 && i > 0) {
        formattedFee = '.$formattedFee';
        count = 0;
      }
      formattedFee = feeStr[i] + formattedFee;
      count++;
    }
    final finalFee = 'Rp$formattedFee';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionSuccessPage(
          destination: _destinationController.text,
          amount: finalAmount,
          paymentMethod: widget.transferType == 'Rekening Bank' ? 'BCA' : 'E-Wallet',
          deliveryDuration: 'Instan',
          transferFee: finalFee,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C3CFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: Text('Transfer - ${widget.transferType}'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kartu jenis transfer
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                              color: Colors.black.withValues(alpha: 0.03),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F4FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                widget.icon,
                                size: 22,
                                color: primaryPurple,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transfer ke ${widget.transferType}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Saldo akan dipotong dari wallet Manpay kamu.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Nomor tujuan',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _destinationController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: widget.transferType == 'E-Wallet'
                              ? 'Contoh: 08xxxxxxxxxx'
                              : 'Contoh: 1234567890',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nominal transfer',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          prefixText: 'Rp ',
                          hintText: '0',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _quickAmounts.map((amount) {
                          final bool isSelected = _selectedQuickAmount == amount;
                          return GestureDetector(
                            onTap: () => _onQuickAmountTap(amount),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryPurple
                                    : const Color(0xFFEDEBFF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Rp $amount',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : primaryPurple,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Catatan (opsional)',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _noteController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Contoh: Bayar makan siang',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _onSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Kirim Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================
// HISTORY PAGE
// ====================================================

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleScaffoldContent(
      title: 'History',
      subtitle: 'Riwayat transaksi lengkap',
      children: [
        _TransactionTile(
          iconBg: const Color(0xFFF5F5F5),
          icon: Icons.shopping_bag,
          title: 'Tokopedia',
          subtitle: 'Shopping',
          amount: '-Rp 420.000',
          isIncome: false,
          date: '23 Nov',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TransactionDetailPage(
                  title: 'Tokopedia',
                  category: 'Shopping',
                  amount: '-Rp 420.000',
                  isIncome: false,
                  date: '23 Nov 2024 • 14:32',
                  status: 'Completed',
                  reference: 'TXN-982374623',
                  paymentMethod: 'BCA •••• 1234',
                  icon: Icons.shopping_bag,
                  iconBg: Color(0xFFF5F5F5),
                  location: 'Tokopedia Marketplace',
                  notes: 'Order #INV-2024-001',
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _TransactionTile(
          iconBg: const Color(0xFFEAFBF0),
          icon: Icons.arrow_downward,
          title: 'Transfer dari Leo',
          subtitle: 'Incoming',
          amount: 'Rp 1.650.000',
          isIncome: true,
          date: '16 Nov',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TransactionDetailPage(
                  title: 'Transfer dari Leo',
                  category: 'Incoming Transfer',
                  amount: 'Rp 1.650.000',
                  isIncome: true,
                  date: '16 Nov 2024 • 09:15',
                  status: 'Completed',
                  reference: 'TXN-556712390',
                  paymentMethod: 'Bank Transfer',
                  icon: Icons.arrow_downward,
                  iconBg: Color(0xFFEAFBF0),
                  location: 'Manpay Wallet',
                  notes: 'Bayar hutang bulan lalu',
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _TransactionTile(
          iconBg: const Color(0xFFF1E8FF),
          icon: Icons.local_grocery_store,
          title: "Alfamart",
          subtitle: 'Groceries',
          amount: '-Rp 85.700',
          isIncome: false,
          date: '15 Nov',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TransactionDetailPage(
                  title: "Alfamart",
                  category: 'Groceries',
                  amount: '-Rp 85.700',
                  isIncome: false,
                  date: '15 Nov 2024 • 18:47',
                  status: 'Completed',
                  reference: 'TXN-880012339',
                  paymentMethod: 'BNI •••• 0987',
                  icon: Icons.local_grocery_store,
                  iconBg: Color(0xFFF1E8FF),
                  location: 'Alfamart Jakarta',
                  notes: 'Belanja mingguan',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}


class ATMPage extends StatelessWidget {
  const ATMPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleScaffoldContent(
      title: 'Find ATM',
      subtitle: 'ATM terdekat dari lokasi kamu',
      children: const [
        _LocationTile(
          name: 'ATM BCA - City Mall',
          distance: '350 m',
          address: 'Lantai 1, dekat escalator',
        ),
        SizedBox(height: 8),
        _LocationTile(
          name: 'ATM Mandiri - Main Street',
          distance: '650 m',
          address: 'Jl. Utama No. 21',
        ),
        SizedBox(height: 8),
        _LocationTile(
          name: 'ATM Bersama - Gas Station',
          distance: '1.2 km',
          address: 'SPBU 24 Jam, Jl. Raya',
        ),
      ],
    );
  }
}

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController _controller =
      MobileScannerController(returnImage: false);
  bool _isClosing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_isClosing) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value == null) continue;
      _isClosing = true;
      _controller.stop();
      if (mounted) {
        Navigator.pop(context, value);
      }
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Scan QR',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleDetection,
            errorBuilder: (_, error, __) => Center(
              child: Text(
                'Camera error: $error',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const _ScannerOverlay(),
          Positioned(
            bottom: 120,
            left: 24,
            right: 24,
            child: Column(
              children: const [
                Text(
                  'Arahkan kamera ke kode QR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6),
                Text(
                  'Pindai untuk melakukan pembayaran atau menambahkan kontak secara cepat.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ScannerActionButton(
            icon: Icons.flash_on_rounded,
            label: 'Toggle Flash',
            onTap: () => _controller.toggleTorch(),
          ),
          const SizedBox(width: 12),
          _ScannerActionButton(
            icon: Icons.cameraswitch_rounded,
            label: 'Ganti Kamera',
            onTap: () => _controller.switchCamera(),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ScannerOverlayPainter(
          borderColor: Colors.white.withValues(alpha: 0.9),
          overlayColor: Colors.black.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  _ScannerOverlayPainter({
    required this.borderColor,
    required this.overlayColor,
  });

  final Color borderColor;
  final Color overlayColor;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = overlayColor;
    final cutOutRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * 0.7,
      height: size.width * 0.7,
    );

    final overlayPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    overlayPath.addRRect(RRect.fromRectXY(cutOutRect, 24, 24));
    canvas.drawPath(
      Path.combine(PathOperation.difference, overlayPath, Path()..addRRect(RRect.fromRectXY(cutOutRect, 24, 24))),
      overlayPaint,
    );

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(RRect.fromRectXY(cutOutRect, 24, 24), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScannerActionButton extends StatelessWidget {
  const _ScannerActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.15),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }
}
// ====================================================
// MY CARDS
// ====================================================

class MyCardData {
  final String id;
  final String holderName;
  final String number;
  final String exp;
  final String brand; // VISA, MasterCard, dll
  final String balanceText; // contoh: "Rp 12.765.000,00"
  final Color background;
  final bool isPersonal;

  const MyCardData({
    required this.id,
    required this.holderName,
    required this.number,
    required this.exp,
    required this.brand,
    required this.balanceText,
    required this.background,
    required this.isPersonal,
  });
}

class MyCardsPage extends StatefulWidget {
  const MyCardsPage({super.key});

  @override
  State<MyCardsPage> createState() => _MyCardsPageState();
}

class _MyCardsPageState extends State<MyCardsPage> {
  int _selectedTab = 0; // 0 = Personal, 1 = Business

  late List<MyCardData> _personalCards;
  late List<MyCardData> _businessCards;

  @override
  void initState() {
    super.initState();
    _personalCards = [
      const MyCardData(
        id: "p1",
        holderName: "Muhammad Martio A",
        number: "1123 7890 3281 7865",
        exp: "03/28",
        brand: "VISA",
        balanceText: "Rp 12.765.000,00",
        background: Color(0xFF000000), // hitam
        isPersonal: true,
      ),
      const MyCardData(
        id: "p2",
        holderName: "Muhammad Martio A",
        number: "7774 1234 5581 14223",
        exp: "03/28",
        brand: "VISA",
        balanceText: "Rp 8.250.000,00",
        background: Color(0xFF6C3CFF), // ungu
        isPersonal: true,
      ),
    ];

    _businessCards = [
      const MyCardData(
        id: "b1",
        holderName: "Manpay Studio",
        number: "4455 8899 2211 6677",
        exp: "11/27",
        brand: "VISA",
        balanceText: "Rp 55.000.000,00",
        background: Color(0xFF111827),
        isPersonal: false,
      ),
    ];
  }

  List<MyCardData> get _currentCards =>
      _selectedTab == 0 ? _personalCards : _businessCards;

  void _onAddCard() async {
    final result = await Navigator.push<MyCardData>(
      context,
      MaterialPageRoute(
        builder: (_) => AddCardPage(
          isPersonalDefault: _selectedTab == 0,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (result.isPersonal) {
          _personalCards = [..._personalCards, result];
        } else {
          _businessCards = [..._businessCards, result];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color neonYellow = Color(0xFFF5FF4A);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Cards",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _onAddCard,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: neonYellow,
                ),
                child: const Icon(
                  Icons.add,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // segmented control Personal / Business
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedTab == 0
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            "Personal",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _selectedTab == 0
                                  ? Colors.black
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            "Business",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _selectedTab == 1
                                  ? Colors.black
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                itemCount: _currentCards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final card = _currentCards[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CardDetailPage(card: card),
                        ),
                      );
                    },
                    child: CreditCardItem(card: card),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// KARTU + DETAIL
// ====================================================

class CreditCardItem extends StatelessWidget {
  final MyCardData card;

  const CreditCardItem({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: card.background,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // chip + contactless
          Row(
            children: [
              Container(
                width: 32,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.wifi,
                size: 20,
                color: Colors.white,
              ),
            ],
          ),
          const Spacer(),
          Text(
            card.number,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.holderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Exp ${card.exp}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                card.brand,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CardDetailPage extends StatelessWidget {
  final MyCardData card;

  const CardDetailPage({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final String title = card.isPersonal ? "Personal" : "Business";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Balance",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              card.balanceText,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            CreditCardItem(card: card),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  CardActionTile(
                    icon: Icons.ac_unit_rounded,
                    title: "Freeze card",
                    subtitle: "Blokir kartu sementara",
                  ),
                  Divider(height: 1),
                  CardActionTile(
                    icon: Icons.lock_rounded,
                    title: "PIN & Security",
                    subtitle: "Atur PIN, CVV, dan keamanan",
                  ),
                  Divider(height: 1),
                  CardActionTile(
                    icon: Icons.settings_rounded,
                    title: "Settings",
                    subtitle: "Ubah nama atau hapus kartu",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddCardPage extends StatefulWidget {
  final bool isPersonalDefault;

  const AddCardPage({super.key, required this.isPersonalDefault});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController _holderController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  bool _isPersonal = true;

  @override
  void initState() {
    super.initState();
    _isPersonal = widget.isPersonalDefault;
  }

  @override
  void dispose() {
    _holderController.dispose();
    _numberController.dispose();
    _expController.dispose();
    _brandController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _saveCard() {
    if (_holderController.text.isEmpty ||
        _numberController.text.isEmpty ||
        _expController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lengkapi data kartu terlebih dahulu.'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(
            bottom: 100,
            left: 20,
            right: 20,
          ),
        ),
      );
      return;
    }

    final newCard = MyCardData(
      id: 'new-${DateTime.now().millisecondsSinceEpoch}',
      holderName: _holderController.text,
      number: _numberController.text,
      exp: _expController.text,
      brand: _brandController.text.isEmpty ? 'VISA' : _brandController.text,
      balanceText: _balanceController.text.isEmpty
          ? 'Rp 0'
          : 'Rp ${_balanceController.text}',
      background: _isPersonal
          ? const Color(0xFF6C3CFF)
          : const Color(0xFF111827),
      isPersonal: _isPersonal,
    );

    Navigator.pop(context, newCard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text('Add Card'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          TextField(
            controller: _holderController,
            decoration: const InputDecoration(
              labelText: 'Card holder name',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _numberController,
            decoration: const InputDecoration(
              labelText: 'Card number',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _expController,
            decoration: const InputDecoration(
              labelText: 'Exp (MM/YY)',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _brandController,
            decoration: const InputDecoration(
              labelText: 'Brand',
              hintText: 'VISA / MasterCard / etc',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _balanceController,
            decoration: const InputDecoration(
              labelText: 'Balance text',
              hintText: 'Contoh: 12.000.000,00',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Tipe kartu'),
              const SizedBox(width: 12),
              ChoiceChip(
                label: const Text('Personal'),
                selected: _isPersonal,
                onSelected: (value) {
                  if (value) {
                    setState(() => _isPersonal = true);
                  }
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Business'),
                selected: !_isPersonal,
                onSelected: (value) {
                  if (value) {
                    setState(() => _isPersonal = false);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saveCard,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text('Simpan Kartu'),
          ),
        ],
      ),
    );
  }
}

class CardActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const CardActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C3CFF);

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFEDEBFF),
        ),
        child: const Icon(
          Icons.settings,
          size: 20,
          color: primaryPurple,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey,
      ),
    );
  }
}

// ====================================================
// PLACEHOLDER TAB
// ====================================================

class SimplePlaceholderPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const SimplePlaceholderPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: const Color(0xFF6C3CFF)),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================
// WIDGET BANTUAN
// ====================================================

class _QuickActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F4FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF6C3CFF)),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isIncome;
  final String date;
  final VoidCallback? onTap;

  const _TransactionTile({
    required this.iconBg,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.03),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isIncome
                              ? Colors.green[600]
                              : Colors.red[600],
                        ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) return tile;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: tile,
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF6C3CFF);
    final Color inactiveColor = Colors.grey[500]!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 22,
          color: isActive ? activeColor : inactiveColor,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive ? activeColor : inactiveColor,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ],
    );
  }
}

class _SimpleScaffoldContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _SimpleScaffoldContent({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SimpleOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.03),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F4FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 22, color: const Color(0xFF6C3CFF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: content,
    );
  }
}

class _LocationTile extends StatelessWidget {
  final String name;
  final String distance;
  final String address;

  const _LocationTile({
    required this.name,
    required this.distance,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.03),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEAFBF0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.atm, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style:
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                ),
                const SizedBox(height: 2),
                Text(
                  address,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                distance,
                style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
              ),
              const SizedBox(height: 2),
              Text(
                'away',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
class TransactionSuccessPage extends StatelessWidget {
  final String destination;
  final String amount;
  final String paymentMethod;
  final String? deliveryDuration;
  final String? transferFee;

  const TransactionSuccessPage({
    super.key,
    required this.destination,
    required this.amount,
    required this.paymentMethod,
    this.deliveryDuration,
    this.transferFee,
  });

  String _getCurrentDateTime() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${now.day.toString().padLeft(2, '0')}-${(now.month).toString().padLeft(2, '0')}-${now.year}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  String _formatCurrency(int amount) {
    final amountStr = amount.toString();
    String formatted = '';
    int count = 0;
    for (int i = amountStr.length - 1; i >= 0; i--) {
      if (count == 3 && i > 0) {
        formatted = '.$formatted';
        count = 0;
      }
      formatted = amountStr[i] + formatted;
      count++;
    }
    return 'IDR $formatted,00';
  }

  String _calculateFinalAmount() {
    if (transferFee != null) {
      // Extract numbers from amount and fee
      final amountNum = int.parse(amount.replaceAll(RegExp(r'[^\d]'), ''));
      final feeNum = int.parse(transferFee!.replaceAll(RegExp(r'[^\d]'), ''));
      final finalAmount = amountNum - feeNum;
      return _formatCurrency(finalAmount);
    }
    // If no fee, format the amount directly
    final amountNum = int.parse(amount.replaceAll(RegExp(r'[^\d]'), ''));
    return _formatCurrency(amountNum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Green checkmark circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8F5E9),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 48,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 24),

                // Success message
                Text(
                  'Pembayaran Berhasil!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF424242),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Amount
                Text(
                  _calculateFinalAmount(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF424242),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Divider
                const Divider(color: Color(0xFFE0E0E0)),
                const SizedBox(height: 16),

                // Payment details
                _DetailRow(
                  label: 'Durasi Pengiriman',
                  value: deliveryDuration ?? 'Instan',
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Payment Time',
                  value: _getCurrentDateTime(),
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Metode Pembayaran',
                  value: paymentMethod,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'Tujuan',
                  value: destination,
                ),

                // Dashed divider
                const SizedBox(height: 16),
                CustomPaint(
                  painter: DashedLinePainter(),
                  child: const SizedBox(height: 1, width: double.infinity),
                ),
                const SizedBox(height: 16),

                // Financial breakdown
                if (transferFee != null) ...[
                  _DetailRow(
                    label: 'Nominal',
                    value: amount,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Biaya Transfer Instan',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: const Color(0xFF424242)),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.bolt,
                            size: 16,
                            color: Color(0xFFFFC107),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            transferFee!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF424242),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 32),

                // Selesai button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Pop sampai kembali ke halaman pertama (MainShell)
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Dashed line painter
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  // 0 = January ... 11 = December
  int currentMonthIndex = 10; // start di November

  final List<String> monthNames = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];

  final Map<String, int> daysPerMonth = {
    "Januari": 31,
    "Februari": 28,
    "Maret": 31,
    "April": 30,
    "Mei": 31,
    "Juni": 30,
    "Juli": 31,
    "Agustus": 31,
    "September": 30,
    "Oktober": 31,
    "November": 30,
    "Desember": 31,
  };

  // Dummy data per bulan
  final Map<String, Map<String, dynamic>> dummyData = {
    "Oktober": {
      "income": 5203200,
      "expenses": 21002200,
      "trend": [0.7, 0.5, 0.55, 0.48, 0.6, 0.35, 0.25],
      "highest": {
        "title": "Airbnb",
        "amount": 8900000,
        "location": "Tokyo, Japan",
        "date": "12 Okt",
        "tag": "Perjalanan"
      },
      "frequent": {
        "title": "Starbucks",
        "amount": 1205800,
        "times": "8 kali",
        "tag": "Makanan & Minuman"
      }
    },
    "November": {
      "income": 6289200,
      "expenses": 23897600,
      "trend": [0.75, 0.7, 0.6, 0.65, 0.5, 0.35, 0.25],
      "highest": {
        "title": "Apple Store",
        "amount": 16994800,
        "location": "California, USA",
        "date": "26 Nov",
        "tag": "Belanja"
      },
      "frequent": {
        "title": "McDonalds",
        "amount": 4802900,
        "times": "5 kali",
        "tag": "Makanan & Minuman"
      }
    },
    "Desember": {
      "income": 1501000,
      "expenses": 9005000,
      "trend": [0.4, 0.45, 0.5, 0.55, 0.42, 0.3, 0.2],
      "highest": {
        "title": "Toko Hadiah",
        "amount": 2402000,
        "location": "New York, USA",
        "date": "21 Des",
        "tag": "Liburan"
      },
      "frequent": {
        "title": "Grab",
        "amount": 2103000,
        "times": "12 kali",
        "tag": "Transportasi"
      }
    }
  };

  void _previousMonth() {
    setState(() {
      currentMonthIndex =
          (currentMonthIndex - 1) < 0 ? 11 : currentMonthIndex - 1;
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonthIndex =
          (currentMonthIndex + 1) > 11 ? 0 : currentMonthIndex + 1;
    });
  }

  String _formatCurrency(double amount) {
    // Format dengan titik sebagai pemisah ribuan dan koma untuk desimal
    final parts = amount.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];
    
    // Tambahkan titik sebagai pemisah ribuan
    String formattedInteger = '';
    for (int i = integerPart.length - 1; i >= 0; i--) {
      formattedInteger = integerPart[i] + formattedInteger;
      if ((integerPart.length - i) % 3 == 0 && i > 0) {
        formattedInteger = '.' + formattedInteger;
      }
    }
    
    return 'Rp $formattedInteger,$decimalPart';
  }

  @override
  Widget build(BuildContext context) {
    final String currentMonth = monthNames[currentMonthIndex];
    final String monthAbbrev = currentMonth.substring(0, 3);
    final int lastDay = daysPerMonth[currentMonth] ?? 30;

    final Map<String, dynamic>? data = dummyData[currentMonth];

    final double income = (data?["income"] as num?)?.toDouble() ?? 0.0;
    final double expenses = (data?["expenses"] as num?)?.toDouble() ?? 0.0;
    final List<double> trend =
        (data?["trend"] as List?)?.map((e) => (e as num).toDouble()).toList() ??
            [0.7, 0.6, 0.55, 0.5, 0.45, 0.35, 0.3];

    final highest = (data?["highest"] as Map?) ?? {
      "title": "No Data",
      "amount": 0.0,
      "location": "-",
      "date": "-",
      "tag": "-"
    };

    final frequent = (data?["frequent"] as Map?) ?? {
      "title": "No Data",
      "amount": 0.0,
      "times": "-",
      "tag": "-"
    };

    final String rangeText =
        "1 $currentMonth 2024 – $lastDay $currentMonth 2024";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text("Insight"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======= FILTER PERIOD =======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Text(
                      "Bulanan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                  ],
                ),
                Text(
                  "$currentMonth 2024",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ======= MONTH CARD (NAV LEFT/RIGHT) =======
            _MonthSelectorCard(
              month: currentMonth,
              rangeText: rangeText,
              onPrev: _previousMonth,
              onNext: _nextMonth,
            ),

            const SizedBox(height: 16),

            // ======= INCOME / EXPENSE CARDS =======
            _SummaryCard(
              amount: _formatCurrency(income),
              label: "Pemasukan",
              isIncome: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TransactionHistoryPage(
                      title: 'Riwayat Pemasukan',
                      isIncome: true,
                      currentMonth: currentMonth,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _SummaryCard(
              amount: _formatCurrency(expenses),
              label: "Pengeluaran",
              isIncome: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TransactionHistoryPage(
                      title: 'Riwayat Pengeluaran',
                      isIncome: false,
                      currentMonth: currentMonth,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 18),

            // ======= EXPENSES TREND =======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                    color: Colors.black.withValues(alpha: 0.03),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tren Pengeluaran",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rangeText,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: _TrendChartDummy(points: trend),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$monthAbbrev 1", style: const TextStyle(fontSize: 10)),
                      Text("$monthAbbrev 8", style: const TextStyle(fontSize: 10)),
                      Text("$monthAbbrev 15", style: const TextStyle(fontSize: 10)),
                      Text("$monthAbbrev 23", style: const TextStyle(fontSize: 10)),
                      Text("$monthAbbrev $lastDay",
                          style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ======= HIGHEST EXPENSES =======
            _InsightInfoTile(
              title: "Pengeluaran Tertinggi",
              subtitle: highest["title"].toString(),
              amount: _formatCurrency((highest["amount"] as num).toDouble()),
              icon: Icons.flash_on_rounded,
              iconBg: const Color(0xFFEDEBFF),
              date: highest["date"].toString(),
              tag: highest["tag"].toString(),
              extraLine: highest["location"].toString(),
            ),
            const SizedBox(height: 10),

            // ======= MOST FREQUENT SPEND =======
            _InsightInfoTile(
              title: "Pengeluaran Paling Sering",
              subtitle: frequent["title"].toString(),
              amount: "Total ${_formatCurrency((frequent["amount"] as num).toDouble())}",
              icon: Icons.repeat_rounded,
              iconBg: const Color(0xFFEAFBF0),
              date: frequent["times"].toString(),
              tag: frequent["tag"].toString(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// =======================================================
//  HELPER WIDGETS UNTUK INSIGHTS
// =======================================================

class _MonthSelectorCard extends StatelessWidget {
  final String month;
  final String rangeText;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthSelectorCard({
    required this.month,
    required this.rangeText,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C3CFF);
    const Color primaryPurpleDark = Color(0xFF4015D8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryPurple,
            primaryPurpleDark,
          ],
        ),
      ),
      child: Row(
        children: [
          // arrow kiri
          GestureDetector(
            onTap: onPrev,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.18),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // bulan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rangeText,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // arrow kanan
          GestureDetector(
            onTap: onNext,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.18),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String amount;
  final String label;
  final bool isIncome;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.amount,
    required this.label,
    required this.isIncome,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isIncome ? Colors.green : Colors.red;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: 0.03),
            ),
          ],
        ),
        child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                amount,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
      ),
    );
  }
}

class _TrendChartDummy extends StatelessWidget {
  final List<double> points;

  const _TrendChartDummy({required this.points});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TrendChartPainter(points),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<double> points;

  _TrendChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final axisPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1;

    final gridPaint = Paint()
      ..color = const Color(0xFFF2F2F2)
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = const Color(0xFF6C3CFF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final highlightPaint = Paint()
      ..color = const Color(0xFF6C3CFF)
      ..style = PaintingStyle.fill;

    final double left = 0;
    final double right = size.width;
    final double bottom = size.height;
    final double top = 0;

    // axis
    canvas.drawLine(Offset(left, top), Offset(left, bottom), axisPaint);
    canvas.drawLine(Offset(left, bottom), Offset(right, bottom), axisPaint);

    // beberapa garis horizontal halus
    for (int i = 1; i <= 3; i++) {
      final y = bottom - (bottom - top) * i / 4;
      canvas.drawLine(Offset(left, y), Offset(right, y), gridPaint);
    }

    // mapping points (0..1) ke koordinat
    final stepX = size.width / (points.length + 1);
    final List<Offset> offsets = [];

    for (int i = 0; i < points.length; i++) {
      final x = stepX * (i + 1);
      final value = points[i].clamp(0.0, 1.0);
      final y = value * size.height; // 0 = top, 1 = bottom
      offsets.add(Offset(x, y));
    }

    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 1; i < offsets.length; i++) {
      path.lineTo(offsets[i].dx, offsets[i].dy);
    }

    canvas.drawPath(path, linePaint);

    // vertical line & highlight at last point
    final last = offsets.last;

    final verticalPaint = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(last.dx, top),
      Offset(last.dx, bottom),
      verticalPaint,
    );

    canvas.drawCircle(last, 6, highlightPaint);
    canvas.drawCircle(
      last,
      10,
      highlightPaint..color = const Color(0x336C3CFF),
    );
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _InsightInfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final Color iconBg;
  final String date;
  final String tag;
  final String? extraLine;

  const _InsightInfoTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.iconBg,
    required this.date,
    required this.tag,
    this.extraLine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.03),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (extraLine != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        extraLine!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      amount,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.label_rounded,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          tag,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ====================================================
// NOTIFICATIONS PAGE
// ====================================================

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _NotificationTile(
            title: 'Transfer Berhasil',
            subtitle: 'Transfer ke rekening BCA berhasil dilakukan',
            time: '2 jam yang lalu',
            isRead: false,
          ),
          const SizedBox(height: 12),
          _NotificationTile(
            title: 'Top Up Berhasil',
            subtitle: 'Saldo berhasil ditambahkan sebesar Rp 500.000',
            time: '5 jam yang lalu',
            isRead: false,
          ),
          const SizedBox(height: 12),
          _NotificationTile(
            title: 'Pembayaran Berhasil',
            subtitle: 'Pembayaran ke Tokopedia berhasil dilakukan',
            time: '1 hari yang lalu',
            isRead: true,
          ),
          const SizedBox(height: 12),
          _NotificationTile(
            title: 'Promo Spesial',
            subtitle: 'Dapatkan cashback 10% untuk setiap transaksi',
            time: '2 hari yang lalu',
            isRead: true,
          ),
          const SizedBox(height: 12),
          _NotificationTile(
            title: 'Update Aplikasi',
            subtitle: 'Versi baru Manpay tersedia, update sekarang?',
            time: '3 hari yang lalu',
            isRead: true,
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;

  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.time,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: Color(0xFF6C3CFF),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isRead ? Colors.grey[700] : Colors.black,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF6C3CFF),
              ),
            ),
        ],
      ),
    );
  }
}

// ====================================================
// PERSONAL PAGE
// ====================================================

class PersonalPage extends StatelessWidget {
  final UserAccount? user;

  const PersonalPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final contactEmail = user?.email ?? 'Belum ada email terdaftar';
    final contactPhone = user?.phoneNumber ?? 'Nomor ponsel belum diisi';
    final displayName = user?.fullName ?? 'Nama belum diisi';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text('Data Pribadi'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  color: Colors.black.withValues(alpha: 0.05),
                ),
              ],
            ),
            child: Column(
              children: [
                _EditableProfileRow(
                  label: 'Nama Lengkap',
                  value: displayName,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileFieldPage(
                          title: 'Edit Nama Lengkap',
                          initialValue: displayName,
                          fieldType: 'name',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _EditableProfileRow(
                  label: 'Email',
                  value: contactEmail,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileFieldPage(
                          title: 'Edit Email',
                          initialValue: contactEmail,
                          fieldType: 'email',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _EditableProfileRow(
                  label: 'Nomor ponsel',
                  value: contactPhone,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileFieldPage(
                          title: 'Edit Nomor Ponsel',
                          initialValue: contactPhone,
                          fieldType: 'phone',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditableProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _EditableProfileRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.edit_outlined,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileFieldPage extends StatefulWidget {
  final String title;
  final String initialValue;
  final String fieldType; // 'name', 'email', 'phone'

  const EditProfileFieldPage({
    super.key,
    required this.title,
    required this.initialValue,
    required this.fieldType,
  });

  @override
  State<EditProfileFieldPage> createState() => _EditProfileFieldPageState();
}

class _EditProfileFieldPageState extends State<EditProfileFieldPage> {
  late final TextEditingController _controller;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Field tidak boleh kosong'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(
            bottom: 100,
            left: 20,
            right: 20,
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final auth = AuthScope.of(context);
    final newValue = _controller.text.trim();

    if (widget.fieldType == 'name') {
      auth.updateProfile(fullName: newValue);
    } else if (widget.fieldType == 'email') {
      auth.updateProfile(email: newValue);
    } else if (widget.fieldType == 'phone') {
      auth.updateProfile(phoneNumber: newValue);
    }

    setState(() => _isSubmitting = false);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Data berhasil diperbarui'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          bottom: 100,
          left: 20,
          right: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.fieldType == 'name'
                  ? 'Nama Lengkap'
                  : widget.fieldType == 'email'
                      ? 'Email'
                      : 'Nomor Ponsel',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              keyboardType: widget.fieldType == 'phone'
                  ? TextInputType.phone
                  : widget.fieldType == 'email'
                      ? TextInputType.emailAddress
                      : TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _handleSave,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C3CFF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// PRIVACY & SECURITY PAGE
// ====================================================

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text('Privasi & Keamanan'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SimpleOptionTile(
            icon: Icons.lock_rounded,
            title: 'Ubah PIN',
            subtitle: 'Ganti PIN transaksi Anda',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _SimpleOptionTile(
            icon: Icons.fingerprint_rounded,
            title: 'Biometric',
            subtitle: 'Aktifkan login dengan sidik jari',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _SimpleOptionTile(
            icon: Icons.shield_rounded,
            title: 'Keamanan Akun',
            subtitle: 'Kelola keamanan akun Anda',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ====================================================
// SAVINGS GOALS PAGE
// ====================================================

class SavingsGoalsPage extends StatelessWidget {
  const SavingsGoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text('Tujuan Menabung'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.savings_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Belum Ada Tujuan Menabung',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Buat tujuan menabung pertama Anda\ndan mulai merencanakan masa depan',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================
// HELP & SUPPORT PAGE
// ====================================================

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text('Bantuan & Dukungan'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SimpleOptionTile(
            icon: Icons.help_outline_rounded,
            title: 'Pertanyaan Umum',
            subtitle: 'Jawaban untuk pertanyaan yang sering diajukan',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _SimpleOptionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Hubungi Kami',
            subtitle: 'Chat langsung dengan tim dukungan',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _SimpleOptionTile(
            icon: Icons.email_outlined,
            title: 'Email Dukungan',
            subtitle: 'support@manpay.com',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _SimpleOptionTile(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Aplikasi',
            subtitle: 'Manpay E-Wallet v1.0.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ====================================================
// TRANSACTION HISTORY PAGE
// ====================================================

class TransactionHistoryPage extends StatelessWidget {
  final String title;
  final bool isIncome;
  final String currentMonth;

  const TransactionHistoryPage({
    super.key,
    required this.title,
    required this.isIncome,
    required this.currentMonth,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy data transaksi
    final transactions = isIncome
        ? [
            {
              'title': 'Transfer Masuk',
              'subtitle': 'Dari rekening BCA',
              'amount': 'Rp 5.200.000,00',
              'date': '15 $currentMonth 2024',
              'icon': Icons.arrow_downward_rounded,
              'iconBg': Colors.green[50],
            },
            {
              'title': 'Gaji Bulanan',
              'subtitle': 'PT. Manpay Studio',
              'amount': 'Rp 10.000.000,00',
              'date': '1 $currentMonth 2024',
              'icon': Icons.account_balance_wallet_rounded,
              'iconBg': Colors.blue[50],
            },
            {
              'title': 'Refund Tokopedia',
              'subtitle': 'Pengembalian dana',
              'amount': 'Rp 420.000,00',
              'date': '23 ${currentMonth.substring(0, 3)} 2024',
              'icon': Icons.shopping_bag_rounded,
              'iconBg': Colors.orange[50],
            },
          ]
        : [
            {
              'title': 'Tokopedia',
              'subtitle': 'Belanja online',
              'amount': 'Rp 420.000,00',
              'date': '23 ${currentMonth.substring(0, 3)} 2024',
              'icon': Icons.shopping_bag_rounded,
              'iconBg': Colors.orange[50],
            },
            {
              'title': 'Starbucks',
              'subtitle': 'Kopi & makanan',
              'amount': 'Rp 120.000,00',
              'date': '20 ${currentMonth.substring(0, 3)} 2024',
              'icon': Icons.local_cafe_rounded,
              'iconBg': Colors.brown[50],
            },
            {
              'title': 'Grab',
              'subtitle': 'Transportasi',
              'amount': 'Rp 85.000,00',
              'date': '18 ${currentMonth.substring(0, 3)} 2024',
              'icon': Icons.directions_car_rounded,
              'iconBg': Colors.green[50],
            },
            {
              'title': 'Alfamart',
              'subtitle': 'Belanja kebutuhan',
              'amount': 'Rp 250.000,00',
              'date': '12 ${currentMonth.substring(0, 3)} 2024',
              'icon': Icons.shopping_cart_rounded,
              'iconBg': Colors.purple[50],
            },
          ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F6F8),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            currentMonth,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          ...transactions.map((tx) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                        color: Colors.black.withValues(alpha: 0.05),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (tx['iconBg'] as Color?) ?? Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          tx['icon'] as IconData,
                          color: isIncome ? Colors.green[700] : Colors.red[700],
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx['title'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tx['subtitle'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tx['date'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        tx['amount'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isIncome
                                  ? Colors.green[700]
                                  : Colors.red[700],
                            ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
