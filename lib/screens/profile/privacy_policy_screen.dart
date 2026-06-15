import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color adminPrimary = Color(0xFF1B4FD8);

// ═══════════════════════════════════════════════════════════════
// Privacy Policy Screen
// ═══════════════════════════════════════════════════════════════

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  int? _expandedIndex;

  final List<_PolicySection> _sections = const [
    _PolicySection(
      icon: Icons.info_outline_rounded,
      iconBg: Color(0xFFEEF2FF),
      iconColor: adminPrimary,
      title: 'Introduction',
      content:
          'Welcome to MyTherapio. We are committed to protecting your personal information and your right to privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our platform.\n\nPlease read this policy carefully. If you disagree with its terms, please discontinue use of our app.',
    ),
    _PolicySection(
      icon: Icons.person_outline_rounded,
      iconBg: Color(0xFFEAF3DE),
      iconColor: Color(0xFF3B6D11),
      title: 'Information We Collect',
      content:
          'We may collect the following types of information:\n\n'
          '• Personal Identification: Name, email address, phone number, date of birth.\n\n'
          '• Professional Information: Qualifications, certifications, specialty details (for professionals).\n\n'
          '• Session Data: Meeting records, call durations, session notes (admin-only access).\n\n'
          '• Usage Data: App interactions, device type, IP address, browser type.\n\n'
          '• Payment Information: Transaction records, payout details. We do not store card numbers directly.',
    ),
    _PolicySection(
      icon: Icons.settings_suggest_outlined,
      iconBg: Color(0xFFFAEEDA),
      iconColor: Color(0xFF854F0B),
      title: 'How We Use Your Information',
      content:
          'We use the information we collect to:\n\n'
          '• Provide, operate, and maintain our platform.\n\n'
          '• Match clients with appropriate professionals.\n\n'
          '• Process transactions and send related information.\n\n'
          '• Send administrative information, updates, and support messages.\n\n'
          '• Monitor usage patterns to improve user experience.\n\n'
          '• Comply with legal obligations and enforce our terms.',
    ),
    _PolicySection(
      icon: Icons.lock_outline_rounded,
      iconBg: Color(0xFFEEEDFE),
      iconColor: Color(0xFF534AB7),
      title: 'Data Security',
      content:
          'We implement industry-standard security measures to protect your data:\n\n'
          '• All data is encrypted in transit using TLS/SSL.\n\n'
          '• Sensitive information is encrypted at rest using AES-256.\n\n'
          '• Access to personal data is restricted to authorised personnel only.\n\n'
          '• Regular security audits and vulnerability assessments are conducted.\n\n'
          'However, no method of transmission over the internet is 100% secure. We cannot guarantee absolute security.',
    ),
    _PolicySection(
      icon: Icons.share_outlined,
      iconBg: Color(0xFFFAECE7),
      iconColor: Color(0xFF993C1D),
      title: 'Sharing Your Information',
      content:
          'We do not sell or rent your personal data. We may share it in the following situations:\n\n'
          '• With service providers who assist us in operating our platform (e.g. payment processors, cloud storage).\n\n'
          '• With your explicit consent (e.g. sharing session summaries with your chosen professional).\n\n'
          '• To comply with legal requirements, court orders, or government requests.\n\n'
          '• To protect the rights, property, or safety of MyTherapio, our users, or others.',
    ),
    _PolicySection(
      icon: Icons.history_rounded,
      iconBg: Color(0xFFE6F1FB),
      iconColor: Color(0xFF185FA5),
      title: 'Data Retention',
      content:
          'We retain your personal information for as long as your account is active or as needed to provide our services.\n\n'
          'Session and meeting records are retained for a minimum of 3 years to comply with professional standards and legal requirements.\n\n'
          'You may request deletion of your account and associated data at any time, subject to legal retention obligations.',
    ),
    _PolicySection(
      icon: Icons.tune_rounded,
      iconBg: Color(0xFFEAF3DE),
      iconColor: Color(0xFF3B6D11),
      title: 'Your Rights',
      content:
          'Depending on your location, you may have the following rights:\n\n'
          '• Right to Access: Request a copy of the personal data we hold about you.\n\n'
          '• Right to Rectification: Request correction of inaccurate or incomplete data.\n\n'
          '• Right to Erasure: Request deletion of your personal data ("right to be forgotten").\n\n'
          '• Right to Object: Object to processing of your data for certain purposes.\n\n'
          '• Right to Portability: Request transfer of your data to another service.\n\n'
          'To exercise any of these rights, contact us at privacy@mytherapio.com.',
    ),
    _PolicySection(
      icon: Icons.child_care_rounded,
      iconBg: Color(0xFFFFEDED),
      iconColor: Color(0xFFE24B4A),
      title: "Children's Privacy",
      content:
          'Our platform is not intended for individuals under the age of 18. We do not knowingly collect personal information from minors.\n\n'
          'If you believe a minor has provided us with personal data, please contact us immediately at privacy@mytherapio.com and we will take steps to delete such information.',
    ),
    _PolicySection(
      icon: Icons.cookie_outlined,
      iconBg: Color(0xFFFAEEDA),
      iconColor: Color(0xFF854F0B),
      title: 'Cookies & Tracking',
      content:
          'We use cookies and similar tracking technologies to:\n\n'
          '• Keep you logged in across sessions.\n\n'
          '• Understand how you interact with our platform.\n\n'
          '• Improve performance and personalise your experience.\n\n'
          'You can instruct your browser to refuse all cookies. However, some features of our service may not function properly without them.',
    ),
    _PolicySection(
      icon: Icons.update_rounded,
      iconBg: Color(0xFFEEF2FF),
      iconColor: adminPrimary,
      title: 'Changes to This Policy',
      content:
          'We may update this Privacy Policy from time to time. We will notify you of any significant changes by:\n\n'
          '• Posting the new policy on this page with an updated "Last Updated" date.\n\n'
          '• Sending you an in-app notification or email for material changes.\n\n'
          'Your continued use of the platform after changes constitutes your acceptance of the revised policy.',
    ),
    _PolicySection(
      icon: Icons.mail_outline_rounded,
      iconBg: Color(0xFFE6F1FB),
      iconColor: Color(0xFF185FA5),
      title: 'Contact Us',
      content:
          'If you have any questions, concerns, or requests regarding this Privacy Policy or our data practices, please contact us:\n\n'
          '📧 Email: privacy@mytherapio.com\n\n'
          '📍 Address: MyTherapio Pvt. Ltd., Kollam, Kerala, India – 691001\n\n'
          '📞 Phone: +91 98765 43210\n\n'
          'We aim to respond to all privacy-related inquiries within 7 business days.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: adminPrimary,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                _buildIntroCard(),
                const SizedBox(height: 16),
                ...List.generate(_sections.length, (i) {
                  final section = _sections[i];
                  final isExpanded = _expandedIndex == i;
                  return _buildSectionTile(section, i, isExpanded);
                }),
                const SizedBox(height: 16),
                _buildLastUpdatedCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: adminPrimary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('MyTherapio',
                    //     style: TextStyle(
                    //         fontSize: 11,
                    //         color: Colors.white.withOpacity(0.7))),
                    const Text('Privacy Policy',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3)),
                  ],
                ),
              ),
              // Container(
              //   width: 40,
              //   height: 40,
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.18),
              //     shape: BoxShape.circle,
              //   ),
              //   child: const Icon(Icons.privacy_tip_outlined,
              //       color: Colors.white, size: 20),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Intro banner ───────────────────────────────────────────────
  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B4FD8), Color(0xFF3B72F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shield_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your privacy matters',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  'Tap any section below to read our full policy. We keep your data safe and transparent.',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Expandable section tile ────────────────────────────────────
  Widget _buildSectionTile(
      _PolicySection section, int index, bool isExpanded) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded ? adminPrimary.withOpacity(0.4) : const Color(0xFFE5E7EB),
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: isExpanded
            ? [
                BoxShadow(
                  color: adminPrimary.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            // Title row
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _expandedIndex = isExpanded ? null : index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: section.iconBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(section.icon,
                          color: section.iconColor, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        section.title,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isExpanded
                                ? adminPrimary
                                : const Color(0xFF111827)),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isExpanded
                            ? adminPrimary
                            : const Color(0xFF9CA3AF),
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expanded content
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Column(
                      children: [
                        const Divider(
                            height: 1, color: Color(0xFFF3F4F6)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                          child: Text(
                            section.content,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF4B5563),
                                height: 1.6),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Last updated footer ────────────────────────────────────────
  Widget _buildLastUpdatedCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_today_rounded,
                color: adminPrimary, size: 16),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Last updated',
                  style: TextStyle(
                      fontSize: 11, color: Color(0xFF9CA3AF))),
              SizedBox(height: 2),
              Text('30 May 2026',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827))),
            ],
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE1F5EE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('v2.1',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D9E75))),
          ),
        ],
      ),
    );
  }
}

// ─── Data class ───────────────────────────────────────────────

class _PolicySection {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String content;

  const _PolicySection({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.content,
  });
}