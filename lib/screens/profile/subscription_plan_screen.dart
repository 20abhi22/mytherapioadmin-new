import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ═══════════════════════════════════════════════════════════════
// Theme Constants
// ═══════════════════════════════════════════════════════════════
const Color adminPrimary = Color(0xFF2563EB);
const Color adminDeep = Color(0xFF1E3A8A);
const Color adminAccent = Color(0xFF60A5FA);
const Color pageBg = Color(0xFFF1F5F9);
const Color cardBg = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF0F172A);
const Color textMid = Color(0xFF475569);
const Color textLight = Color(0xFF94A3B8);
const Color successGreen = Color(0xFF10B981);
const Color dangerRed = Color(0xFFEF4444);
const Color warningAmber = Color(0xFFF59E0B);

// ═══════════════════════════════════════════════════════════════
// Subscription Plans Screen
// ═══════════════════════════════════════════════════════════════

class SubscriptionPlansScreen extends StatefulWidget {
  final String currentPlan; // 'free', 'monthly', 'yearly'

  const SubscriptionPlansScreen({
    Key? key,
    this.currentPlan = 'free',
  }) : super(key: key);

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen>
    with SingleTickerProviderStateMixin {
  late String _selectedPlan;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _selectedPlan = widget.currentPlan;
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: adminDeep,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Plan Data ─────────────────────────────────────────────────
  static const List<_PlanData> _plans = [
    _PlanData(
      id: 'free',
      name: 'Free',
      subtitle: 'Basic platform access',
      price: '₹0',
      originalPrice: null,
      period: 'forever',
      savingTag: null,
      badge: null,
      badgeColor: null,
      gradientColors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
      accentColor: adminPrimary,
      features: [
        _FeatureItem('Up to 3 active cases', true),
        _FeatureItem('Basic client profiles', true),
        _FeatureItem('1 lawyer / consultant slot', true),
        _FeatureItem('Document vault', false),
        _FeatureItem('Hearing schedule & reminders', false),
        _FeatureItem('Revenue & commission reports', false),
        _FeatureItem('Priority support', false),
        _FeatureItem('Advanced analytics', false),
      ],
    ),
    _PlanData(
      id: 'monthly',
      name: 'Monthly',
      subtitle: 'Billed every month · Cancel anytime',
      price: '₹799',
      originalPrice: null,
      period: '/month',
      savingTag: null,
      badge: null,
      badgeColor: null,
      gradientColors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
      accentColor: adminPrimary,
      features: [
        _FeatureItem('Unlimited active cases', true),
        _FeatureItem('Full client & spouse profiles', true),
        _FeatureItem('Up to 10 lawyer / consultant slots', true),
        _FeatureItem('Document vault (5 GB)', true),
        _FeatureItem('Hearing schedule & reminders', true),
        _FeatureItem('Revenue & commission reports', false),
        _FeatureItem('Priority support', false),
        _FeatureItem('Advanced analytics', false),
      ],
    ),
    _PlanData(
      id: 'yearly',
      name: 'Yearly',
      subtitle: 'Billed once a year · Best value',
      price: '₹6,399',
      originalPrice: '₹9,588',
      period: '/year',
      savingTag: 'Save 33%',
      badge: 'Most Popular',
      badgeColor: adminPrimary,
      gradientColors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
      accentColor: adminPrimary,
      features: [
        _FeatureItem('Unlimited active cases', true),
        _FeatureItem('Full client & spouse profiles', true),
        _FeatureItem('Unlimited lawyer / consultant slots', true),
        _FeatureItem('Document vault (50 GB)', true),
        _FeatureItem('Hearing schedule & reminders', true),
        _FeatureItem('Revenue & commission reports', true),
        _FeatureItem('Priority support', true),
        _FeatureItem('Advanced analytics', true),
      ],
    ),
  ];

  _PlanData get _currentPlanData =>
      _plans.firstWhere((p) => p.id == _selectedPlan);

  bool get _isUpgrade =>
      _selectedPlan != widget.currentPlan && _selectedPlan != 'free';

  bool get _isDowngrade =>
      _selectedPlan == 'free' && widget.currentPlan != 'free';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                child: Column(
                  children: [
                    _buildCurrentPlanBanner(),
                    const SizedBox(height: 20),
                    _buildCompareBadge(),
                    const SizedBox(height: 14),
                    ..._plans.map((plan) => _buildPlanCard(plan)),
                    const SizedBox(height: 8),
                    _buildFaqSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  // ── Header ─────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [adminDeep, adminPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text('MyTherapio',
                            //     style: TextStyle(
                            //         fontSize: 11,
                            //         color:
                            //             Colors.white.withOpacity(0.6))),
                            const Text('Subscription Plans',
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.3)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.workspace_premium_rounded,
                                size: 13, color: warningAmber),
                            const SizedBox(width: 5),
                            Text(
                              widget.currentPlan == 'free'
                                  ? 'Free'
                                  : widget.currentPlan == 'monthly'
                                      ? 'Monthly'
                                      : 'Yearly',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Feature highlights row
                  Row(
                    children: [
                      _headerPerk(Icons.bolt_rounded, 'Instant\nactivation'),
                      _headerPerk(Icons.cancel_outlined, 'Cancel\nanytime'),
                      _headerPerk(
                          Icons.lock_outline_rounded, 'Secure\npayment'),
                      _headerPerk(Icons.headset_mic_rounded, '24/7\nSupport'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerPerk(IconData icon, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.7), size: 18),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 9,
                  color: Colors.white.withOpacity(0.6),
                  height: 1.3)),
        ],
      ),
    );
  }

  // ── Current Plan Banner ────────────────────────────────────────
  Widget _buildCurrentPlanBanner() {
    final plan = _plans.firstWhere((p) => p.id == widget.currentPlan);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: plan.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: plan.accentColor.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.workspace_premium_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Plan: ${plan.name}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 2),
                Text(
                  widget.currentPlan == 'free'
                      ? 'Upgrade to unlock powerful features'
                      : 'Active · Renews automatically',
                  style: TextStyle(
                      fontSize: 11, color: Colors.white.withOpacity(0.75)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              plan.price,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Compare Badge ──────────────────────────────────────────────
  Widget _buildCompareBadge() {
    return Row(
      children: [
        const Text('Choose a Plan',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: textDark)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: successGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: const [
              Icon(Icons.verified_rounded, size: 11, color: successGreen),
              SizedBox(width: 4),
              Text('No hidden charges',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: successGreen)),
            ],
          ),
        ),
      ],
    );
  }

  // ── Plan Card ──────────────────────────────────────────────────
  Widget _buildPlanCard(_PlanData plan) {
    final isSelected = _selectedPlan == plan.id;
    final isCurrent = widget.currentPlan == plan.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = plan.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? plan.accentColor : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? plan.accentColor.withOpacity(0.12)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isSelected ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Card top gradient strip ──
            // if (isSelected)
            //   Container(
            //     height: 4,
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //           colors: plan.gradientColors),
            //       borderRadius: const BorderRadius.vertical(
            //           top: Radius.circular(19)),
            //     ),
            //   ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan header row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Radio
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? plan.accentColor
                                : const Color(0xFFCBD5E1),
                            width: 2,
                          ),
                          color: isSelected
                              ? plan.accentColor
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 13)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(plan.name,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: isSelected
                                            ? plan.accentColor
                                            : textDark)),
                                if (plan.badge != null) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: plan.gradientColors),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(plan.badge!,
                                        style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white)),
                                  ),
                                ],
                                if (isCurrent) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: successGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text('Active',
                                        style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: successGreen)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(plan.subtitle,
                                style: const TextStyle(
                                    fontSize: 11, color: textLight)),
                          ],
                        ),
                      ),
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(plan.price,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: isSelected
                                          ? plan.accentColor
                                          : textDark,
                                      letterSpacing: -0.5)),
                            ],
                          ),
                          Text(plan.period,
                              style: const TextStyle(
                                  fontSize: 10, color: textLight)),
                          if (plan.originalPrice != null)
                            Text(plan.originalPrice!,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: textLight,
                                    decoration: TextDecoration.lineThrough)),
                          if (plan.savingTag != null)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(plan.savingTag!,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF92400E))),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.transparent,
                        isSelected
                            ? plan.accentColor.withOpacity(0.2)
                            : const Color(0xFFE2E8F0),
                        Colors.transparent,
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Features
                  ...plan.features.map((f) => _buildFeatureRow(
                      f, isSelected ? plan.accentColor : null)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(_FeatureItem f, Color? accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: f.enabled
                  ? (accentColor ?? successGreen).withOpacity(0.12)
                  : const Color(0xFFF1F5F9),
            ),
            child: Icon(
              f.enabled ? Icons.check_rounded : Icons.close_rounded,
              size: 11,
              color: f.enabled ? (accentColor ?? successGreen) : textLight,
            ),
          ),
          const SizedBox(width: 10),
          Text(f.label,
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: f.enabled ? FontWeight.w500 : FontWeight.w400,
                  color: f.enabled ? textDark : textLight)),
        ],
      ),
    );
  }

  // ── FAQ Section ────────────────────────────────────────────────
  Widget _buildFaqSection() {
    const faqs = [
      (
        'Can I cancel my subscription anytime?',
        'Yes, you can cancel anytime. Your access continues until the end of the billing period.'
      ),
      (
        'What happens to my data if I downgrade?',
        'Your data is preserved. However access to premium features will be restricted until you upgrade again.'
      ),
      (
        'Is payment secure?',
        'All payments are processed through Razorpay with 256-bit SSL encryption. We never store your card details.'
      ),
      (
        'Can I switch between Monthly and Yearly?',
        'Yes! You can upgrade to Yearly at any time and we will prorate the difference automatically.'
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        const Text('Frequently Asked Questions',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: textDark)),
        const SizedBox(height: 12),
        ...faqs.map((faq) => _FaqTile(question: faq.$1, answer: faq.$2)),
      ],
    );
  }

  // ── Bottom Bar ─────────────────────────────────────────────────
  Widget _buildBottomBar(BuildContext context) {
    final isSamePlan = _selectedPlan == widget.currentPlan;
    final plan = _currentPlanData;

    return Container(
      decoration: const BoxDecoration(
        color: cardBg,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isSamePlan) ...[
                // What you're switching to
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: _isDowngrade
                        ? dangerRed.withOpacity(0.06)
                        : plan.accentColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isDowngrade
                          ? dangerRed.withOpacity(0.2)
                          : plan.accentColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isDowngrade
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        size: 16,
                        color: _isDowngrade ? dangerRed : plan.accentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _isDowngrade
                              ? 'Switching to Free plan · Features will be limited'
                              : 'Upgrading to ${plan.name} · ${plan.price}${plan.period}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  _isDowngrade ? dangerRed : plan.accentColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // CTA button
              GestureDetector(
                onTap: isSamePlan ? null : () => _onPlanConfirm(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: isSamePlan
                        ? const LinearGradient(
                            colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)])
                        : _isDowngrade
                            ? const LinearGradient(
                                colors: [Color(0xFFEF4444), Color(0xFFDC2626)])
                            : LinearGradient(colors: plan.gradientColors),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSamePlan
                        ? []
                        : [
                            BoxShadow(
                              color: plan.accentColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSamePlan
                            ? Icons.check_circle_rounded
                            : _isDowngrade
                                ? Icons.arrow_downward_rounded
                                : Icons.bolt_rounded,
                        color: isSamePlan ? textLight : Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isSamePlan
                            ? 'Current Plan'
                            : _isDowngrade
                                ? 'Switch to Free'
                                : _selectedPlan == 'yearly'
                                    ? 'Upgrade to Yearly · ₹6,399/yr'
                                    : 'Upgrade to Monthly · ₹799/mo',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isSamePlan ? textLight : Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPlanConfirm(BuildContext context) {
    if (_isDowngrade) {
      _showDowngradeConfirm(context);
    } else {
      _showUpgradeSheet(context);
    }
  }

  void _showUpgradeSheet(BuildContext context) {
    final plan = _currentPlanData;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            // Plan icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: plan.gradientColors),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: plan.accentColor.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.workspace_premium_rounded,
                  color: Colors.white, size: 28),
            ),
            const SizedBox(height: 14),
            Text('Upgrade to ${plan.name}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textDark)),
            const SizedBox(height: 4),
            Text(
              '${plan.price}${plan.period}',
              style: TextStyle(
                  fontSize: 14,
                  color: plan.accentColor,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            // Order summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _orderRow('Plan', plan.name, bold: false),
                  const SizedBox(height: 10),
                  _orderRow('Billing', plan.period, bold: false),
                  if (plan.savingTag != null) ...[
                    const SizedBox(height: 10),
                    _orderRow('Savings', plan.savingTag!,
                        valueColor: successGreen, bold: false),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                  ),
                  _orderRow('Total', plan.price,
                      bold: true, valueColor: plan.accentColor),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Pay button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _showSnack(context, '${plan.name} plan activated! 🎉');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: plan.gradientColors),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: plan.accentColor.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.payment_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Proceed to Payment',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.lock_rounded, size: 12, color: textLight),
                SizedBox(width: 4),
                Text('Secured by Razorpay',
                    style: TextStyle(fontSize: 11, color: textLight)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderRow(String label, String value,
      {bool bold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: textMid)),
        Text(value,
            style: TextStyle(
                fontSize: bold ? 15 : 12,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                color: valueColor ?? textDark)),
      ],
    );
  }

  void _showDowngradeConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Downgrade to Free?',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: textDark)),
        content: const Text(
          'You will lose access to premium features at the end of your current billing period.',
          style: TextStyle(fontSize: 12, color: textMid, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Plan',
                style: TextStyle(
                    color: adminPrimary, fontWeight: FontWeight.w700)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
              _showSnack(context, 'Downgrade scheduled');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: dangerRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Downgrade',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        backgroundColor: adminPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FAQ Tile
// ═══════════════════════════════════════════════════════════════

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _open ? adminPrimary.withOpacity(0.3) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _open = !_open),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(widget.question,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _open ? adminPrimary : textDark)),
                    ),
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.keyboard_arrow_down_rounded,
                          size: 20, color: _open ? adminPrimary : textLight),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _open
                  ? Container(
                      color: const Color(0xFFF8FAFC),
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Text(widget.answer,
                          style: const TextStyle(
                              fontSize: 12, color: textMid, height: 1.5)),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Data Classes
// ═══════════════════════════════════════════════════════════════

class _PlanData {
  final String id;
  final String name;
  final String subtitle;
  final String price;
  final String? originalPrice;
  final String period;
  final String? savingTag;
  final String? badge;
  final Color? badgeColor;
  final List<Color> gradientColors;
  final Color accentColor;
  final List<_FeatureItem> features;

  const _PlanData({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.originalPrice,
    required this.period,
    required this.savingTag,
    required this.badge,
    required this.badgeColor,
    required this.gradientColors,
    required this.accentColor,
    required this.features,
  });
}

class _FeatureItem {
  final String label;
  final bool enabled;
  const _FeatureItem(this.label, this.enabled);
}
