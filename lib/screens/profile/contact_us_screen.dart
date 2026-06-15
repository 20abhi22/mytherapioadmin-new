import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mytherapio_admin_app/screens/profile/profile_screen.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  // ── URL launcher helpers ───────────────────────────────────
  Future<void> _launchPhone() async {
    final uri = Uri(scheme: 'tel', path: '+918000100002');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchWhatsApp() async {
    final uri = Uri.parse('https://wa.me/918000100002');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@legaladmin.in',
      queryParameters: {'subject': 'Admin App Support'},
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Reach us directly'),
                  _buildDirectContact(context),
                  const SizedBox(height: 20),
                  _sectionLabel('Support hours'),
                  _buildSupportHours(),
                  const SizedBox(height: 20),
                  _sectionLabel('Send us a message'),
                  _buildMessageButtons(context),
                  const SizedBox(height: 20),
                  _sectionLabel('Follow us'),
                  _buildSocialRow(),
                  const SizedBox(height: 16),
                  const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on_rounded, size: 12, color: textLight),
                        SizedBox(width: 4),
                        Text('Kochi, Kerala · India',
                            style: TextStyle(fontSize: 11, color: textLight)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 195,
      pinned: true,
      backgroundColor: adminDeep,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 16),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Contact Us',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  const SizedBox(height: 2),
                  Text("We're here to help you",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6))),
                  const SizedBox(height: 14),
                  // Support team card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              alignment: Alignment.center,
                              child: const Text('S',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                            ),
                            Positioned(
                              bottom: 1, right: 1,
                              child: Container(
                                width: 12, height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: successGreen,
                                  border: Border.all(
                                      color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Support Team',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              const Text('Legal Admin Platform',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white60)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: successGreen.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: successGreen.withOpacity(0.3)),
                                ),
                                child: const Text('● Online now',
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF6EE7B7))),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Avg. response',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.5))),
                            const SizedBox(height: 2),
                            const Text('~2 hrs',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ],
                        ),
                      ],
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

  // ── Direct Contact ─────────────────────────────────────────
  Widget _buildDirectContact(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _contactRow(
            icon: Icons.phone_rounded,
            label: 'Call us',
            value: '+91 80001 00002',
            tag: 'Fastest',
            tagColor: successGreen,
            iconBg: const Color(0xFFEFF6FF),
            iconColor: adminPrimary,
            onTap: _launchPhone,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _ContactDivider(),
          ),
          _contactRow(
            icon: Icons.chat_rounded,
            label: 'WhatsApp',
            value: '+91 80001 00002',
            tag: 'Quick reply',
            tagColor: successGreen,
            iconBg: const Color(0xFFF0FDF4),
            iconColor: successGreen,
            onTap: _launchWhatsApp,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _ContactDivider(),
          ),
          _contactRow(
            icon: Icons.email_rounded,
            label: 'Email',
            value: 'support@legaladmin.in',
            tag: '24 hr reply',
            tagColor: adminPrimary,
            iconBg: const Color(0xFFF5F3FF),
            iconColor: const Color(0xFF7C3AED),
            onTap: _launchEmail,
          ),
        ],
      ),
    );
  }

  Widget _contactRow({
    required IconData icon,
    required String label,
    required String value,
    required String tag,
    required Color tagColor,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(label,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600,
                              color: textDark)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: tagColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(tag,
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: tagColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 11, color: textLight)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: textLight),
          ],
        ),
      ),
    );
  }

  // ── Support Hours ──────────────────────────────────────────
  Widget _buildSupportHours() {
    return Row(
      children: [
        Expanded(
          child: _hoursCard(
            icon: Icons.access_time_rounded,
            iconColor: adminPrimary,
            iconBg: const Color(0xFFEFF6FF),
            day: 'Weekdays',
            time: '9:00 am – 6:00 pm',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _hoursCard(
            icon: Icons.calendar_today_rounded,
            iconColor: const Color(0xFF7C3AED),
            iconBg: const Color(0xFFF5F3FF),
            day: 'Saturday',
            time: '10:00 am – 2:00 pm',
          ),
        ),
      ],
    );
  }

  Widget _hoursCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String day,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(day,
              style: const TextStyle(fontSize: 11, color: textLight)),
          const SizedBox(height: 2),
          Text(time,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: textDark)),
        ],
      ),
    );
  }

  // ── Message Buttons ────────────────────────────────────────
  Widget _buildMessageButtons(BuildContext context) {
    return Column(
      children: [
        // Send Message button
        GestureDetector(
          onTap: () => _showMessageSheet(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)]),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: adminPrimary.withOpacity(0.3),
                    blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.message_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Send a message',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Raise ticket outlined button
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: adminPrimary, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.confirmation_number_rounded,
                    color: adminPrimary, size: 18),
                SizedBox(width: 8),
                Text('Raise a support ticket',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: adminPrimary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Social Row ─────────────────────────────────────────────
  Widget _buildSocialRow() {
    final socials = [
      _Social(Icons.camera_alt_rounded, 'Instagram',
          const Color(0xFFFCE7F3), const Color(0xFFE1306C),
          'https://instagram.com'),
      _Social(Icons.work_rounded, 'LinkedIn',
          const Color(0xFFEFF6FF), const Color(0xFF0A66C2),
          'https://linkedin.com'),
      _Social(Icons.play_circle_rounded, 'YouTube',
          const Color(0xFFFEF2F2), const Color(0xFFFF0000),
          'https://youtube.com'),
    ];

    return Row(
      children: socials
          .map((s) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: s == socials.last ? 0 : 10),
                  child: GestureDetector(
                    onTap: () => _launchUrl(s.url),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: s.bg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(s.icon,
                                color: s.color, size: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(s.label,
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: textMid)),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  // ── Send Message Sheet ─────────────────────────────────────
  void _showMessageSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final msgCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Send a message',
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800,
                      color: textDark)),
              const SizedBox(height: 18),
              _field(nameCtrl, 'Your name', TextInputType.name),
              const SizedBox(height: 12),
              _field(msgCtrl, 'Your message...', TextInputType.multiline,
                  maxLines: 4),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Message sent! We\'ll get back to you soon.',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      backgroundColor: adminPrimary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [adminPrimary, Color(0xFF3B82F6)]),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: adminPrimary.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.send_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text('Send message',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700,
                              color: Colors.white)),
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

  Widget _field(TextEditingController ctrl, String hint,
      TextInputType type, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      maxLines: maxLines,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: textDark),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(fontSize: 12, color: textLight),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: adminPrimary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: textDark)),
    );
  }
}

// ── Local widgets ──────────────────────────────────────────────
class _ContactDivider extends StatelessWidget {
  const _ContactDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.transparent, Color(0xFFE2E8F0), Colors.transparent
        ]),
      ),
    );
  }
}

class _Social {
  final IconData icon;
  final String label;
  final Color bg;
  final Color color;
  final String url;
  const _Social(this.icon, this.label, this.bg, this.color, this.url);
}