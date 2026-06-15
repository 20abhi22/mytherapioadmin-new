

// import 'package:flutter/material.dart';
// import 'package:mytherapio_admin_app/screens/profile/profile_screen.dart';

// class HelpSupportScreen extends StatefulWidget {
//   const HelpSupportScreen({Key? key}) : super(key: key);

//   @override
//   State<HelpSupportScreen> createState() => _HelpSupportScreenState();
// }

// class _HelpSupportScreenState extends State<HelpSupportScreen> {
//   final TextEditingController _searchCtrl = TextEditingController();
//   int? _openFaq;

//   final List<_FaqItem> _faqs = [
//     _FaqItem(
//       question: 'How do I add a new divorce case?',
//       answer: 'Go to Cases → tap the + button → fill in client details, assign a lawyer or consultant, and upload relevant documents. The case appears in your active list immediately.',
//     ),
//     _FaqItem(
//       question: 'How do I onboard a new lawyer or consultant?',
//       answer: 'Navigate to Team → Add Member. Enter their name, bar council number (for lawyers), specialisation, and fee structure. They will receive an invite to join the platform.',
//     ),
//     _FaqItem(
//       question: 'How do I withdraw from my admin wallet?',
//       answer: 'Open Profile → Wallet → tap Withdraw. Enter the amount and linked bank account details. Withdrawals are processed within 2–3 business days.',
//     ),
//     _FaqItem(
//       question: 'Can I upload court documents to a case?',
//       answer: 'Yes. Open the case → Documents tab → Upload. Supported: PDF, DOCX, JPG. Free plan: 500 MB; Monthly: 5 GB; Yearly: 50 GB.',
//     ),
//     _FaqItem(
//       question: 'How do hearing reminders work?',
//       answer: 'When you add a hearing date, the system sends push notifications to the assigned lawyer and client — 3 days before, 1 day before, and on the morning of the hearing.',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: pageBg,
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           _buildHeader(context),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildQuickTopics(),
//                   const SizedBox(height: 20),
//                   _buildFaqSection(),
//                   const SizedBox(height: 20),
//                   _buildContactSection(),
//                   const SizedBox(height: 16),
//                   _buildRaiseTicketButton(),
//                   const SizedBox(height: 10),
//                   const Center(
//                     child: Text('Average response time · 2–4 hours',
//                         style: TextStyle(fontSize: 11, color: textLight)),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: 160,
//       pinned: true,
//       backgroundColor: adminDeep,
//       elevation: 0,
//       leading: IconButton(
//         icon: Container(
//           width: 36, height: 36,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.15),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: const Icon(Icons.arrow_back_ios_new_rounded,
//               color: Colors.white, size: 16),
//         ),
//         onPressed: () => Navigator.pop(context),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         collapseMode: CollapseMode.parallax,
//         background: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Help & Support',
//                       style: TextStyle(
//                           fontSize: 20, fontWeight: FontWeight.w800,
//                           color: Colors.white)),
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 14, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.2)),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.search_rounded,
//                             color: Colors.white.withOpacity(0.5), size: 18),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: TextField(
//                             controller: _searchCtrl,
//                             style: const TextStyle(
//                                 fontSize: 13, color: Colors.white),
//                             decoration: InputDecoration(
//                               hintText: 'Search for help topics...',
//                               hintStyle: TextStyle(
//                                   color: Colors.white.withOpacity(0.5),
//                                   fontSize: 13),
//                               border: InputBorder.none,
//                               isDense: true,
//                               contentPadding: EdgeInsets.zero,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickTopics() {
//     final topics = [
//       _QuickTopic(Icons.description_rounded, 'Case management',
//           'Add, update, close cases', const Color(0xFFEFF6FF), adminPrimary),
//       _QuickTopic(Icons.people_rounded, 'Lawyer & consultant',
//           'Onboarding & slots', const Color(0xFFF5F3FF), const Color(0xFF7C3AED)),
//       _QuickTopic(Icons.account_balance_wallet_rounded, 'Wallet & payments',
//           'Withdrawals, history', const Color(0xFFF0FDF4), successGreen),
//       _QuickTopic(Icons.event_rounded, 'Hearing schedule',
//           'Dates & reminders', const Color(0xFFFFF7ED), warningAmber),
//     ];

//     return GridView.count(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisSpacing: 10,
//       mainAxisSpacing: 10,
//       childAspectRatio: 1.55,
//       children: topics.map((t) => _buildQuickCard(t)).toList(),
//     );
//   }

//   Widget _buildQuickCard(_QuickTopic t) {
//     return Container(
//       decoration: BoxDecoration(
//         color: cardBg,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.04),
//               blurRadius: 10, offset: const Offset(0, 3)),
//         ],
//       ),
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 36, height: 36,
//             decoration: BoxDecoration(
//               color: t.iconBg,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(t.icon, color: t.iconColor, size: 18),
//           ),
//           const SizedBox(height: 8),
//           Text(t.label,
//               style: const TextStyle(
//                   fontSize: 12, fontWeight: FontWeight.w700, color: textDark)),
//           Text(t.sub,
//               style: const TextStyle(fontSize: 10, color: textLight)),
//         ],
//       ),
//     );
//   }

//   Widget _buildFaqSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Frequently asked questions',
//             style: TextStyle(
//                 fontSize: 14, fontWeight: FontWeight.w700, color: textDark)),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: cardBg,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withOpacity(0.04),
//                   blurRadius: 12, offset: const Offset(0, 4)),
//             ],
//           ),
//           child: Column(
//             children: _faqs.asMap().entries.map((e) {
//               final i = e.key;
//               final faq = e.value;
//               final isOpen = _openFaq == i;
//               return Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () => setState(
//                         () => _openFaq = isOpen ? null : i),
//                     behavior: HitTestBehavior.opaque,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 14),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(faq.question,
//                                     style: const TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w600,
//                                         color: textDark)),
//                               ),
//                               AnimatedRotation(
//                                 turns: isOpen ? 0.5 : 0,
//                                 duration: const Duration(milliseconds: 200),
//                                 child: const Icon(
//                                     Icons.keyboard_arrow_down_rounded,
//                                     size: 20, color: textLight),
//                               ),
//                             ],
//                           ),
//                           AnimatedCrossFade(
//                             firstChild: const SizedBox.shrink(),
//                             secondChild: Padding(
//                               padding: const EdgeInsets.only(top: 10),
//                               child: Text(faq.answer,
//                                   style: const TextStyle(
//                                       fontSize: 12,
//                                       color: textMid,
//                                       height: 1.6)),
//                             ),
//                             crossFadeState: isOpen
//                                 ? CrossFadeState.showSecond
//                                 : CrossFadeState.showFirst,
//                             duration: const Duration(milliseconds: 200),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (i < _faqs.length - 1)
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Divider(),
//                     ),
//                 ],
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildContactSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Contact us',
//             style: TextStyle(
//                 fontSize: 14, fontWeight: FontWeight.w700, color: textDark)),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: cardBg,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withOpacity(0.04),
//                   blurRadius: 12, offset: const Offset(0, 4)),
//             ],
//           ),
//           child: Column(
//             children: [
//               _contactRow(Icons.email_rounded, 'Email support',
//                   'support@legaladmin.in',
//                   const Color(0xFFEFF6FF), adminPrimary),
//               const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Divider()),
//               _contactRow(Icons.phone_rounded, 'Call us',
//                   '+91 80001 00002 · Mon–Sat, 9am–6pm',
//                   const Color(0xFFF0FDF4), successGreen),
//               const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Divider()),
//               _contactRow(Icons.chat_rounded, 'WhatsApp',
//                   'Quick replies within 1 hour',
//                   const Color(0xFFF5F3FF), const Color(0xFF7C3AED)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _contactRow(IconData icon, String label, String val,
//       Color bg, Color color) {
//     return GestureDetector(
//       onTap: () {},
//       behavior: HitTestBehavior.opaque,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           children: [
//             Container(
//               width: 38, height: 38,
//               decoration: BoxDecoration(
//                 color: bg, borderRadius: BorderRadius.circular(10)),
//               child: Icon(icon, color: color, size: 18),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(label,
//                       style: const TextStyle(
//                           fontSize: 13, fontWeight: FontWeight.w600,
//                           color: textDark)),
//                   Text(val,
//                       style: const TextStyle(
//                           fontSize: 11, color: textLight)),
//                 ],
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios_rounded,
//                 size: 13, color: textLight),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRaiseTicketButton() {
//     return GestureDetector(
//       onTap: () => _showRaiseTicketSheet(context),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//               colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)]),
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(color: adminPrimary.withOpacity(0.3),
//                 blurRadius: 12, offset: const Offset(0, 4)),
//           ],
//         ),
//         alignment: Alignment.center,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             Icon(Icons.confirmation_number_rounded,
//                 color: Colors.white, size: 18),
//             SizedBox(width: 8),
//             Text('Raise a support ticket',
//                 style: TextStyle(
//                     fontSize: 14, fontWeight: FontWeight.w700,
//                     color: Colors.white)),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showRaiseTicketSheet(BuildContext context) {
//     final subjectCtrl = TextEditingController();
//     final msgCtrl = TextEditingController();
//     String _category = 'Case issue';

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => StatefulBuilder(
//         builder: (ctx, setSheet) => _BottomSheetWrapper(
//           title: 'Raise a support ticket',
//           child: Padding(
//             padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Category',
//                     style: TextStyle(fontSize: 12, color: textLight)),
//                 const SizedBox(height: 8),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: ['Case issue', 'Payment', 'Team access',
//                     'Documents', 'Other']
//                       .map((c) => GestureDetector(
//                     onTap: () => setSheet(() => _category = c),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 7),
//                       decoration: BoxDecoration(
//                         color: _category == c
//                             ? adminPrimary
//                             : const Color(0xFFEFF6FF),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(c,
//                           style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: _category == c
//                                   ? Colors.white
//                                   : adminPrimary)),
//                     ),
//                   )).toList(),
//                 ),
//                 const SizedBox(height: 14),
//                 _SheetTextField(
//                     controller: subjectCtrl, label: 'Subject'),
//                 const SizedBox(height: 12),
//                 _SheetTextField(
//                     controller: msgCtrl,
//                     label: 'Describe your issue...',
//                     maxLines: 4),
//                 const SizedBox(height: 20),
//                 _SheetSaveButton(
//                   label: 'Submit ticket',
//                   icon: Icons.send_rounded,
//                   onTap: () {
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: const Text('Ticket submitted! We\'ll respond in 2–4 hours.',
//                             style: TextStyle(
//                                 fontSize: 13, fontWeight: FontWeight.w600)),
//                         backgroundColor: adminPrimary,
//                         behavior: SnackBarBehavior.floating,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         margin: const EdgeInsets.all(16),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Helper models ──────────────────────────────────────────────
// class _FaqItem {
//   final String question;
//   final String answer;
//   const _FaqItem({required this.question, required this.answer});
// }

// class _QuickTopic {
//   final IconData icon;
//   final String label;
//   final String sub;
//   final Color iconBg;
//   final Color iconColor;
//   const _QuickTopic(this.icon, this.label, this.sub, this.iconBg, this.iconColor);
// }

import 'package:flutter/material.dart';
import 'package:mytherapio_admin_app/screens/profile/profile_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  int? _openFaq;

  final List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'How do I add a new divorce case?',
      answer: 'Go to Cases → tap the + button → fill in client details, assign a lawyer or consultant, and upload relevant documents. The case appears in your active list immediately.',
    ),
    _FaqItem(
      question: 'How do I onboard a new lawyer or consultant?',
      answer: 'Navigate to Team → Add Member. Enter their name, bar council number (for lawyers), specialisation, and fee structure. They will receive an invite to join the platform.',
    ),
    _FaqItem(
      question: 'How do I withdraw from my admin wallet?',
      answer: 'Open Profile → Wallet → tap Withdraw. Enter the amount and linked bank account details. Withdrawals are processed within 2–3 business days.',
    ),
    _FaqItem(
      question: 'Can I upload court documents to a case?',
      answer: 'Yes. Open the case → Documents tab → Upload. Supported: PDF, DOCX, JPG. Free plan: 500 MB; Monthly: 5 GB; Yearly: 50 GB.',
    ),
    _FaqItem(
      question: 'How do hearing reminders work?',
      answer: 'When you add a hearing date, the system sends push notifications to the assigned lawyer and client — 3 days before, 1 day before, and on the morning of the hearing.',
    ),
  ];

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
                  _buildQuickTopics(),
                  const SizedBox(height: 20),
                  _buildFaqSection(),
                  const SizedBox(height: 20),
                  _buildContactSection(),
                  const SizedBox(height: 16),
                  _buildRaiseTicketButton(),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text('Average response time · 2–4 hours',
                        style: TextStyle(fontSize: 11, color: textLight)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: adminDeep,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          width: 36,
          height: 36,
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
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Help & Support',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  const SizedBox(height: 12),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 14, vertical: 10),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withOpacity(0.15),
                  //     borderRadius: BorderRadius.circular(12),
                  //     border:
                  //         Border.all(color: Colors.white.withOpacity(0.2)),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Icon(Icons.search_rounded,
                  //           color: Colors.white.withOpacity(0.5), size: 18),
                  //       const SizedBox(width: 10),
                  //       Expanded(
                  //         child: TextField(
                  //           controller: _searchCtrl,
                  //           style: const TextStyle(
                  //               fontSize: 13, color: Colors.blue),
                  //           decoration: InputDecoration(
                  //             hintText: 'Search for help topics...',
                  //             hintStyle: TextStyle(
                  //                 color: Colors.white.withOpacity(0.5),
                  //                 fontSize: 13),
                  //             border: InputBorder.none,
                  //             isDense: true,
                  //             contentPadding: EdgeInsets.zero,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTopics() {
    final topics = [
      _QuickTopic(Icons.description_rounded, 'Case management',
          'Add, update, close cases', const Color(0xFFEFF6FF), adminPrimary),
      _QuickTopic(Icons.people_rounded, 'Lawyer & consultant',
          'Onboarding & slots', const Color(0xFFF5F3FF),
          const Color(0xFF7C3AED)),
      _QuickTopic(Icons.account_balance_wallet_rounded, 'Wallet & payments',
          'Withdrawals, history', const Color(0xFFF0FDF4), successGreen),
      _QuickTopic(Icons.event_rounded, 'Hearing schedule',
          'Dates & reminders', const Color(0xFFFFF7ED), warningAmber),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.55,
      children: topics.map((t) => _buildQuickCard(t)).toList(),
    );
  }

  Widget _buildQuickCard(_QuickTopic t) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: t.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(t.icon, color: t.iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(t.label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: textDark)),
          Text(t.sub,
              style: const TextStyle(fontSize: 10, color: textLight)),
        ],
      ),
    );
  }

  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Frequently asked questions',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textDark)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: _faqs.asMap().entries.map((e) {
              final i = e.key;
              final faq = e.value;
              final isOpen = _openFaq == i;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () =>
                        setState(() => _openFaq = isOpen ? null : i),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(faq.question,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: textDark)),
                              ),
                              AnimatedRotation(
                                turns: isOpen ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 20,
                                    color: textLight),
                              ),
                            ],
                          ),
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(faq.answer,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: textMid,
                                      height: 1.6)),
                            ),
                            crossFadeState: isOpen
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 200),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i < _faqs.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: _HelpDivider(),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact us',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textDark)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              _contactRow(Icons.email_rounded, 'Email support',
                  'support@legaladmin.in',
                  const Color(0xFFEFF6FF), adminPrimary),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _HelpDivider(),
              ),
              _contactRow(Icons.phone_rounded, 'Call us',
                  '+91 80001 00002 · Mon–Sat, 9am–6pm',
                  const Color(0xFFF0FDF4), successGreen),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _HelpDivider(),
              ),
              _contactRow(Icons.chat_rounded, 'WhatsApp',
                  'Quick replies within 1 hour',
                  const Color(0xFFF5F3FF), const Color(0xFF7C3AED)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contactRow(IconData icon, String label, String val,
      Color bg, Color color) {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textDark)),
                  Text(val,
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

  Widget _buildRaiseTicketButton() {
    return GestureDetector(
      onTap: () => _showRaiseTicketSheet(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: adminPrimary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.confirmation_number_rounded,
                color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Raise a support ticket',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // ── Raise Ticket Sheet ─────────────────────────────────────
  void _showRaiseTicketSheet(BuildContext context) {
    final subjectCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    String selectedCategory = 'Case issue';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          decoration: const BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Raise a support ticket',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: textDark)),
              const SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category',
                        style:
                            TextStyle(fontSize: 12, color: textLight)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Case issue',
                        'Payment',
                        'Team access',
                        'Documents',
                        'Other'
                      ]
                          .map((c) => GestureDetector(
                                onTap: () =>
                                    setSheet(() => selectedCategory = c),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: selectedCategory == c
                                        ? adminPrimary
                                        : const Color(0xFFEFF6FF),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Text(c,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: selectedCategory == c
                                              ? Colors.white
                                              : adminPrimary)),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 14),
                    // Subject field
                    TextField(
                      controller: subjectCtrl,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textDark),
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        labelStyle: const TextStyle(
                            fontSize: 12, color: textLight),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: adminPrimary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Message field
                    TextField(
                      controller: msgCtrl,
                      maxLines: 4,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textDark),
                      decoration: InputDecoration(
                        labelText: 'Describe your issue...',
                        labelStyle: const TextStyle(
                            fontSize: 12, color: textLight),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: adminPrimary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Submit button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Ticket submitted! We\'ll respond in 2–4 hours.',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
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
                        padding:
                            const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [adminPrimary, Color(0xFF3B82F6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: adminPrimary.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.send_rounded,
                                color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text('Submit ticket',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Local widgets — no dependency on profile_screen.dart privates
// ══════════════════════════════════════════════════════════════

class _HelpDivider extends StatelessWidget {
  const _HelpDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color(0xFFE2E8F0),
            Colors.transparent
          ],
        ),
      ),
    );
  }
}

// ── Helper models ─────────────────────────────────────────────
class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}

class _QuickTopic {
  final IconData icon;
  final String label;
  final String sub;
  final Color iconBg;
  final Color iconColor;
  const _QuickTopic(
      this.icon, this.label, this.sub, this.iconBg, this.iconColor);
}