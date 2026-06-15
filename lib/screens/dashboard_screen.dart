// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// const Color adminPrimary = Color(0xFF1B4FD8);
// const Color adminPrimary2 = Color(0xFF3B72F5);

// // ═══════════════════════════════════════════════════════════════
// // Data Models
// // ═══════════════════════════════════════════════════════════════

// class UpcomingMeeting {
//   final String initials, professionalName, specialty, clientName, time, day;
//   final Color avatarBg, avatarText;
//   const UpcomingMeeting({
//     required this.initials,
//     required this.professionalName,
//     required this.specialty,
//     required this.clientName,
//     required this.time,
//     required this.day,
//     required this.avatarBg,
//     required this.avatarText,
//   });
// }

// class AdminReview {
//   final String clientInitials, clientName, professionalName, specialty, comment;
//   final double rating;
//   final Color avatarBg, avatarText;
//   const AdminReview({
//     required this.clientInitials,
//     required this.clientName,
//     required this.professionalName,
//     required this.specialty,
//     required this.comment,
//     required this.rating,
//     required this.avatarBg,
//     required this.avatarText,
//   });
// }

// // ═══════════════════════════════════════════════════════════════
// // Sample Data
// // ═══════════════════════════════════════════════════════════════

// const List<UpcomingMeeting> kUpcomingMeetings = [
//   UpcomingMeeting(
//     initials: 'AN', professionalName: 'Dr. Anjali N.',
//     specialty: 'Clinical Psychology', clientName: 'Arjun R.',
//     time: '3:00 PM', day: 'Today',
//     avatarBg: Color(0xFFE6F1FB), avatarText: Color(0xFF185FA5),
//   ),
//   UpcomingMeeting(
//     initials: 'VR', professionalName: 'Adv. V. Rajan',
//     specialty: 'Property Law', clientName: 'Meena S.',
//     time: '5:00 PM', day: 'Today',
//     avatarBg: Color(0xFFEEEDFE), avatarText: Color(0xFF534AB7),
//   ),
//   UpcomingMeeting(
//     initials: 'RK', professionalName: 'Rahul Kumar',
//     specialty: 'CBT Therapy', clientName: 'Prathik V.',
//     time: '10:30 AM', day: 'Tomorrow',
//     avatarBg: Color(0xFFEAF3DE), avatarText: Color(0xFF3B6D11),
//   ),
//   UpcomingMeeting(
//     initials: 'MF', professionalName: 'Meera Fathima',
//     specialty: 'Family & Divorce', clientName: 'Reena P.',
//     time: '2:00 PM', day: '14 May',
//     avatarBg: Color(0xFFFAEEDA), avatarText: Color(0xFF854F0B),
//   ),
//   UpcomingMeeting(
//     initials: 'SJ', professionalName: 'Sanjay J.',
//     specialty: 'Stress & Anxiety', clientName: 'Kiran M.',
//     time: '4:00 PM', day: '15 May',
//     avatarBg: Color(0xFFEEEDFE), avatarText: Color(0xFF534AB7),
//   ),
// ];

// const List<AdminReview> kAdminReviews = [
//   AdminReview(
//     clientInitials: 'SR', clientName: 'Sreedev R.',
//     professionalName: 'Dr. Anjali N.', specialty: 'Clinical Psych',
//     comment: 'Excellent session! Felt very heard and understood. Will definitely rebook.',
//     rating: 4.9,
//     avatarBg: Color(0xFFEEF2FF), avatarText: Color(0xFF1B4FD8),
//   ),
//   AdminReview(
//     clientInitials: 'NK', clientName: 'Nithya K.',
//     professionalName: 'Adv. V. Rajan', specialty: 'Property Law',
//     comment: 'Very knowledgeable and explained everything clearly. Resolved our issue.',
//     rating: 4.7,
//     avatarBg: Color(0xFFEEEDFE), avatarText: Color(0xFF534AB7),
//   ),
//   AdminReview(
//     clientInitials: 'AM', clientName: 'Arun M.',
//     professionalName: 'Rahul Kumar', specialty: 'CBT Therapy',
//     comment: 'CBT techniques really helped with my anxiety. Great experience overall.',
//     rating: 4.8,
//     avatarBg: Color(0xFFEAF3DE), avatarText: Color(0xFF3B6D11),
//   ),
//   AdminReview(
//     clientInitials: 'PV', clientName: 'Priya V.',
//     professionalName: 'Meera Fathima', specialty: 'Family & Divorce',
//     comment: 'Professional and empathetic. Helped us navigate a tough situation.',
//     rating: 5.0,
//     avatarBg: Color(0xFFFAECE7), avatarText: Color(0xFF993C1D),
//   ),
// ];

// // ═══════════════════════════════════════════════════════════════
// // Admin Dashboard Screen
// // ═══════════════════════════════════════════════════════════════

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _AdminDashboardScreenState();
// }

// class _AdminDashboardScreenState extends State<DashboardScreen>
//     with SingleTickerProviderStateMixin {
//   int _selectedTab = 0;
//   late final AnimationController _headerAnim;
//   late final Animation<double> _fadeAnim;

//   @override
//   void initState() {
//     super.initState();
//     _headerAnim = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 600));
//     _fadeAnim =
//         CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut);
//     _headerAnim.forward();
//   }

//   @override
//   void dispose() {
//     _headerAnim.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: adminPrimary,
//       statusBarIconBrightness: Brightness.light,
//     ));

//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FB),
//       body: Column(
//         children: [
//           _buildHeader(),
//           _buildTabBar(),
//           Expanded(
//             child: _selectedTab == 0
//                 ? _buildOverviewTab()
//                 : _selectedTab == 1
//                     ? _buildMeetingsTab()
//                     : _buildReviewsTab(),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Header ────────────────────────────────────────────────────
//   Widget _buildHeader() {
//     return Container(
//       color: adminPrimary,
//       child: SafeArea(
//         bottom: false,
//         child: FadeTransition(
//           opacity: _fadeAnim,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 42,
//                       height: 42,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white.withOpacity(0.18),
//                       ),
//                       child: const Icon(Icons.admin_panel_settings_outlined,
//                           color: Colors.white, size: 22),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Admin Portal',
//                               style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.white.withOpacity(0.7))),
//                           const Text('MyTherapio',
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white,
//                                   letterSpacing: -0.3)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.18),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 6,
//                             height: 6,
//                             decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFF4ADE80)),
//                           ),
//                           const SizedBox(width: 5),
//                           const Text('Live',
//                               style: TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 18),
//                 // ── 4 Stat cards ──
//                 Row(
//                   children: [
//                     _headerStat('248', 'Total meetings',
//                         Icons.calendar_today_rounded),
//                     const SizedBox(width: 10),
//                     _headerStat('191', 'Completed',
//                         Icons.check_circle_outline_rounded),
//                     const SizedBox(width: 10),
//                     _headerStat('57', 'Upcoming',
//                         Icons.schedule_rounded),
//                     const SizedBox(width: 10),
//                     _headerStat('4.8★', 'Avg rating',
//                         Icons.star_outline_rounded),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _headerStat(String value, String label, IconData icon) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.14),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: Colors.white.withOpacity(0.55), size: 16),
//             const SizedBox(height: 4),
//             Text(value,
//                 style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white)),
//             const SizedBox(height: 1),
//             Text(label,
//                 style: TextStyle(
//                     fontSize: 9,
//                     color: Colors.white.withOpacity(0.65)),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Tab bar ───────────────────────────────────────────────────
//   Widget _buildTabBar() {
//     const tabs = ['Overview', 'Meetings', 'Reviews'];
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         children: List.generate(tabs.length, (i) {
//           final active = i == _selectedTab;
//           return Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => _selectedTab = i),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 margin: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
//                 height: 34,
//                 decoration: BoxDecoration(
//                   color: active ? adminPrimary : const Color(0xFFF4F6FB),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(tabs[i],
//                     style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: active
//                             ? Colors.white
//                             : const Color(0xFF6B7280))),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // Tab 1 — Overview
//   // ═══════════════════════════════════════════════════════════════
//   Widget _buildOverviewTab() {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildRevenueSection(),
//           const SizedBox(height: 20),
//           _buildMeetingsProgressSection(),
//           const SizedBox(height: 20),
//           _buildRatingBreakdownSection(),
//           const SizedBox(height: 20),
//           _buildTopProfessionalsSection(),
//         ],
//       ),
//     );
//   }

//   Widget _buildRevenueSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _sectionHeader('Revenue summary', 'View all', () {}),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             Expanded(
//               child: _amountCard(
//                 iconBg: const Color(0xFFEAF3DE),
//                 iconColor: const Color(0xFF3B6D11),
//                 icon: Icons.currency_rupee_rounded,
//                 value: '₹1,43,500',
//                 label: 'Total earned',
//                 valueColor: const Color(0xFF3B6D11),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: _amountCard(
//                 iconBg: const Color(0xFFFAEEDA),
//                 iconColor: const Color(0xFF854F0B),
//                 icon: Icons.hourglass_top_rounded,
//                 value: '₹28,200',
//                 label: 'Pending payout',
//                 valueColor: const Color(0xFF854F0B),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         _card(
//           child: Column(
//             children: [
//               _revenueRow('Counselling sessions', '₹98,400', 0.68,
//                   adminPrimary),
//               const SizedBox(height: 12),
//               _revenueRow('Legal advisory', '₹31,500', 0.22,
//                   const Color(0xFF534AB7)),
//               const SizedBox(height: 12),
//               // _revenueRow('Financial planning', '₹13,600', 0.10,
//               //     const Color(0xFF1D9E75)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _amountCard({
//     required Color iconBg,
//     required Color iconColor,
//     required IconData icon,
//     required String value,
//     required String label,
//     required Color valueColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE5E7EB)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//                 color: iconBg, borderRadius: BorderRadius.circular(8)),
//             child: Icon(icon, color: iconColor, size: 16),
//           ),
//           const SizedBox(height: 8),
//           Text(value,
//               style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w700,
//                   color: valueColor)),
//           const SizedBox(height: 2),
//           Text(label,
//               style: const TextStyle(
//                   fontSize: 11, color: Color(0xFF6B7280))),
//         ],
//       ),
//     );
//   }

//   Widget _revenueRow(
//       String label, String amount, double fraction, Color color) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(label,
//                 style: const TextStyle(
//                     fontSize: 12, color: Color(0xFF6B7280))),
//             Text(amount,
//                 style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF111827))),
//           ],
//         ),
//         const SizedBox(height: 6),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(3),
//           child: LinearProgressIndicator(
//             value: fraction,
//             backgroundColor: const Color(0xFFF3F4F6),
//             valueColor: AlwaysStoppedAnimation<Color>(color),
//             minHeight: 6,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMeetingsProgressSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _sectionHeader('Meetings overview', null, null),
//         const SizedBox(height: 10),
//         _card(
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   _meetingStatBox('248', 'Total', adminPrimary,
//                       const Color(0xFFEEF2FF)),
//                   const SizedBox(width: 10),
//                   _meetingStatBox('191', 'Completed',
//                       const Color(0xFF1D9E75), const Color(0xFFE1F5EE)),
//                   const SizedBox(width: 10),
//                   _meetingStatBox(
//                       '57', 'Upcoming', const Color(0xFF854F0B),
//                       const Color(0xFFFAEEDA)),
//                 ],
//               ),
//               const SizedBox(height: 14),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(6),
//                 child: SizedBox(
//                   height: 12,
//                   child: Row(
//                     children: [
//                       Flexible(
//                         flex: 191,
//                         child: Container(color: const Color(0xFF1D9E75)),
//                       ),
//                       Flexible(
//                         flex: 57,
//                         child: Container(color: const Color(0xFFFAC775)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   _legendDot(const Color(0xFF1D9E75), 'Completed (77%)'),
//                   const SizedBox(width: 14),
//                   _legendDot(const Color(0xFFFAC775), 'Upcoming (23%)'),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _meetingStatBox(
//       String value, String label, Color textColor, Color bg) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//             color: bg, borderRadius: BorderRadius.circular(10)),
//         child: Column(
//           children: [
//             Text(value,
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: textColor)),
//             const SizedBox(height: 2),
//             Text(label,
//                 style:
//                     const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _legendDot(Color color, String label) {
//     return Row(
//       children: [
//         Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
//         const SizedBox(width: 5),
//         Text(label,
//             style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
//       ],
//     );
//   }

//   Widget _buildRatingBreakdownSection() {
//     final rows = [
//       ('5 stars', 0.72, '72%'),
//       ('4 stars', 0.20, '20%'),
//       ('3 stars', 0.06, '6%'),
//       ('1–2 stars', 0.02, '2%'),
//     ];
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _sectionHeader('Rating breakdown', '184 reviews', null),
//         const SizedBox(height: 10),
//         _card(
//           child: Column(
//             children: rows.map((r) {
//               final isLow = r.$1 == '1–2 stars';
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 60,
//                       child: Text(r.$1,
//                           style: const TextStyle(
//                               fontSize: 11, color: Color(0xFF6B7280))),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(3),
//                           child: LinearProgressIndicator(
//                             value: r.$2,
//                             backgroundColor: const Color(0xFFF3F4F6),
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                                 isLow
//                                     ? const Color(0xFFE24B4A)
//                                     : const Color(0xFFF59E0B)),
//                             minHeight: 6,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 32,
//                       child: Text(r.$3,
//                           style: const TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF111827)),
//                           textAlign: TextAlign.right),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTopProfessionalsSection() {
//     final professionals = [
//       ('Dr. Anjali N.', 'Clinical Psychology', 4.9, 312, 'AN',
//           const Color(0xFFE6F1FB), const Color(0xFF185FA5)),
//       ('Rahul Kumar', 'CBT Therapy', 4.8, 198, 'RK',
//           const Color(0xFFEAF3DE), const Color(0xFF3B6D11)),
//       ('Adv. V. Rajan', 'Property Law', 4.7, 156, 'VR',
//           const Color(0xFFEEEDFE), const Color(0xFF534AB7)),
//     ];
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _sectionHeader('Top professionals', 'See all', () {}),
//         const SizedBox(height: 10),
//         ...professionals.map((p) {
//           return Container(
//             margin: const EdgeInsets.only(bottom: 10),
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFE5E7EB)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle, color: p.$6),
//                   alignment: Alignment.center,
//                   child: Text(p.$5,
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: p.$7)),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(p.$1,
//                           style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF111827))),
//                       const SizedBox(height: 2),
//                       Text(p.$2,
//                           style: const TextStyle(
//                               fontSize: 11, color: Color(0xFF6B7280))),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Row(children: [
//                       const Icon(Icons.star_rounded,
//                           color: Color(0xFFF59E0B), size: 14),
//                       const SizedBox(width: 3),
//                       Text('${p.$3}',
//                           style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF111827))),
//                     ]),
//                     const SizedBox(height: 2),
//                     Text('${p.$4} reviews',
//                         style: const TextStyle(
//                             fontSize: 10, color: Color(0xFF9CA3AF))),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }),
//       ],
//     );
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // Tab 2 — Meetings
//   // ═══════════════════════════════════════════════════════════════
//   Widget _buildMeetingsTab() {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Summary chips
//           Row(
//             children: [
//               _summaryChip('57 upcoming', adminPrimary,
//                   const Color(0xFFEEF2FF)),
//               const SizedBox(width: 8),
//               _summaryChip('191 completed', const Color(0xFF1D9E75),
//                   const Color(0xFFE1F5EE)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _sectionHeader('Upcoming meetings', null, null),
//           const SizedBox(height: 10),
//           _card(
//             child: Column(
//               children: List.generate(kUpcomingMeetings.length, (i) {
//                 final m = kUpcomingMeetings[i];
//                 return Column(
//                   children: [
//                     if (i != 0)
//                       const Divider(height: 1, color: Color(0xFFF3F4F6)),
//                     _meetingRow(m),
//                   ],
//                 );
//               }),
//             ),
//           ),
//           const SizedBox(height: 20),
//           _sectionHeader('Completed meetings', 'See all', () {}),
//           const SizedBox(height: 10),
//           _completedMeetingCard(
//               'Dr. Anjali N.', 'Clinical Psych', 'Arjun R.', '9 May',
//               '11:00 AM', const Color(0xFFE6F1FB), const Color(0xFF185FA5),
//               'AN'),
//           _completedMeetingCard(
//               'Adv. V. Rajan', 'Property Law', 'Bindu S.', '8 May',
//               '3:30 PM', const Color(0xFFEEEDFE), const Color(0xFF534AB7),
//               'VR'),
//           _completedMeetingCard(
//               'Rahul Kumar', 'CBT Therapy', 'Sanjay P.', '7 May',
//               '5:00 PM', const Color(0xFFEAF3DE), const Color(0xFF3B6D11),
//               'RK'),
//         ],
//       ),
//     );
//   }

//   Widget _summaryChip(String label, Color textColor, Color bg) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//           color: bg, borderRadius: BorderRadius.circular(20)),
//       child: Text(label,
//           style: TextStyle(
//               fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
//     );
//   }

//   Widget _meetingRow(UpcomingMeeting m) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration:
//                 BoxDecoration(shape: BoxShape.circle, color: m.avatarBg),
//             alignment: Alignment.center,
//             child: Text(m.initials,
//                 style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: m.avatarText)),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(m.professionalName,
//                     style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF111827))),
//                 const SizedBox(height: 2),
//                 Text('${m.specialty} · ${m.clientName}',
//                     style: const TextStyle(
//                         fontSize: 11, color: Color(0xFF9CA3AF))),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(m.time,
//                   style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: adminPrimary)),
//               const SizedBox(height: 2),
//               Text(m.day,
//                   style: const TextStyle(
//                       fontSize: 10, color: Color(0xFF9CA3AF))),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _completedMeetingCard(
//     String professional,
//     String specialty,
//     String client,
//     String date,
//     String time,
//     Color avatarBg,
//     Color avatarText,
//     String initials,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE5E7EB)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(shape: BoxShape.circle, color: avatarBg),
//             alignment: Alignment.center,
//             child: Text(initials,
//                 style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: avatarText)),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(professional,
//                     style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF111827))),
//                 const SizedBox(height: 2),
//                 Text('$specialty · $client',
//                     style: const TextStyle(
//                         fontSize: 11, color: Color(0xFF9CA3AF))),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                 decoration: BoxDecoration(
//                     color: const Color(0xFFE1F5EE),
//                     borderRadius: BorderRadius.circular(6)),
//                 child: const Text('Done',
//                     style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1D9E75))),
//               ),
//               const SizedBox(height: 4),
//               Text('$date · $time',
//                   style: const TextStyle(
//                       fontSize: 10, color: Color(0xFF9CA3AF))),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // Tab 3 — Reviews
//   // ═══════════════════════════════════════════════════════════════
//   Widget _buildReviewsTab() {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Overall rating banner
//           _card(
//             child: Row(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Overall rating',
//                         style: TextStyle(
//                             fontSize: 12, color: Color(0xFF6B7280))),
//                     const SizedBox(height: 4),
//                     const Text('4.8',
//                         style: TextStyle(
//                             fontSize: 36,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF111827))),
//                     Row(
//                       children: List.generate(5, (i) => const Icon(
//                           Icons.star_rounded,
//                           color: Color(0xFFF59E0B),
//                           size: 16)),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text('184 total reviews',
//                         style: TextStyle(
//                             fontSize: 11, color: Color(0xFF9CA3AF))),
//                   ],
//                 ),
//                 const Spacer(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     _ratingBar('5★', 0.72, '133'),
//                     const SizedBox(height: 6),
//                     _ratingBar('4★', 0.20, '37'),
//                     const SizedBox(height: 6),
//                     _ratingBar('3★', 0.06, '11'),
//                     const SizedBox(height: 6),
//                     _ratingBar('1–2★', 0.02, '3'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           _sectionHeader('Recent reviews', '${kAdminReviews.length} shown',
//               null),
//           const SizedBox(height: 10),
//           _card(
//             child: Column(
//               children: List.generate(kAdminReviews.length, (i) {
//                 final r = kAdminReviews[i];
//                 return Column(
//                   children: [
//                     if (i != 0)
//                       const Divider(height: 1, color: Color(0xFFF3F4F6)),
//                     _reviewRow(r),
//                   ],
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _ratingBar(String label, double fraction, String count) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 30,
//           child: Text(label,
//               style: const TextStyle(
//                   fontSize: 10, color: Color(0xFF9CA3AF)),
//               textAlign: TextAlign.right),
//         ),
//         const SizedBox(width: 6),
//         SizedBox(
//           width: 80,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(3),
//             child: LinearProgressIndicator(
//               value: fraction,
//               backgroundColor: const Color(0xFFF3F4F6),
//               valueColor: const AlwaysStoppedAnimation<Color>(
//                   Color(0xFFF59E0B)),
//               minHeight: 5,
//             ),
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(count,
//             style: const TextStyle(
//                 fontSize: 10, color: Color(0xFF9CA3AF))),
//       ],
//     );
//   }

//   Widget _reviewRow(AdminReview r) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle, color: r.avatarBg),
//                 alignment: Alignment.center,
//                 child: Text(r.clientInitials,
//                     style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: r.avatarText)),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(r.clientName,
//                         style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF111827))),
//                     Text('${r.professionalName} · ${r.specialty}',
//                         style: const TextStyle(
//                             fontSize: 11, color: Color(0xFF9CA3AF))),
//                   ],
//                 ),
//               ),
//               Text('${r.rating}',
//                   style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFFF59E0B))),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: List.generate(
//               5,
//               (i) => Icon(
//                 i < r.rating.floor()
//                     ? Icons.star_rounded
//                     : Icons.star_outline_rounded,
//                 color: const Color(0xFFF59E0B),
//                 size: 14,
//               ),
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(r.comment,
//               style: const TextStyle(
//                   fontSize: 12,
//                   color: Color(0xFF6B7280),
//                   height: 1.5)),
//         ],
//       ),
//     );
//   }

//   // ── Shared helpers ────────────────────────────────────────────
//   Widget _card({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFE5E7EB)),
//       ),
//       child: child,
//     );
//   }

//   Widget _sectionHeader(
//       String title, String? linkText, VoidCallback? onTap) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title,
//             style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF111827))),
//         if (linkText != null)
//           GestureDetector(
//             onTap: onTap,
//             child: Text(linkText,
//                 style: const TextStyle(
//                     fontSize: 12,
//                     color: adminPrimary,
//                     fontWeight: FontWeight.w500)),
//           ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytherapio_admin_app/screens/meetings/meetings_screen.dart';
import 'package:mytherapio_admin_app/screens/profile/payment_screen.dart';
import 'package:mytherapio_admin_app/screens/profile/profile_screen.dart';

const Color adminPrimary = Color(0xFF1B4FD8);
const Color adminPrimary2 = Color(0xFF3B72F5);

// ═══════════════════════════════════════════════════════════════
// Data Models
// ═══════════════════════════════════════════════════════════════

class UpcomingMeeting {
  final String initials, professionalName, specialty, clientName, time, day;
  final Color avatarBg, avatarText;
  const UpcomingMeeting({
    required this.initials,
    required this.professionalName,
    required this.specialty,
    required this.clientName,
    required this.time,
    required this.day,
    required this.avatarBg,
    required this.avatarText,
  });
}

class AdminReview {
  final String clientInitials, clientName, professionalName, specialty, comment;
  final double rating;
  final Color avatarBg, avatarText;
  const AdminReview({
    required this.clientInitials,
    required this.clientName,
    required this.professionalName,
    required this.specialty,
    required this.comment,
    required this.rating,
    required this.avatarBg,
    required this.avatarText,
  });
}

// ═══════════════════════════════════════════════════════════════
// Sample Data
// ═══════════════════════════════════════════════════════════════

const List<UpcomingMeeting> kUpcomingMeetings = [
  UpcomingMeeting(
    initials: 'AN', professionalName: 'Dr. Anjali N.',
    specialty: 'Clinical Psychology', clientName: 'Arjun R.',
    time: '3:00 PM', day: 'Today',
    avatarBg: Color(0xFFE6F1FB), avatarText: Color(0xFF185FA5),
  ),
  UpcomingMeeting(
    initials: 'VR', professionalName: 'Adv. V. Rajan',
    specialty: 'Property Law', clientName: 'Meena S.',
    time: '5:00 PM', day: 'Today',
    avatarBg: Color(0xFFEEEDFE), avatarText: Color(0xFF534AB7),
  ),
  UpcomingMeeting(
    initials: 'RK', professionalName: 'Rahul Kumar',
    specialty: 'CBT Therapy', clientName: 'Prathik V.',
    time: '10:30 AM', day: 'Tomorrow',
    avatarBg: Color(0xFFEAF3DE), avatarText: Color(0xFF3B6D11),
  ),
  UpcomingMeeting(
    initials: 'MF', professionalName: 'Meera Fathima',
    specialty: 'Family & Divorce', clientName: 'Reena P.',
    time: '2:00 PM', day: '14 May',
    avatarBg: Color(0xFFFAEEDA), avatarText: Color(0xFF854F0B),
  ),
  UpcomingMeeting(
    initials: 'SJ', professionalName: 'Sanjay J.',
    specialty: 'Stress & Anxiety', clientName: 'Kiran M.',
    time: '4:00 PM', day: '15 May',
    avatarBg: Color(0xFFEEEDFE), avatarText: Color(0xFF534AB7),
  ),
];

const List<AdminReview> kAdminReviews = [
  AdminReview(
    clientInitials: 'SR', clientName: 'Sreedev R.',
    professionalName: 'Dr. Anjali N.', specialty: 'Clinical Psych',
    comment: 'Excellent session! Felt very heard and understood. Will definitely rebook.',
    rating: 4.9,
    avatarBg: Color(0xFFEEF2FF), avatarText: Color(0xFF1B4FD8),
  ),
  AdminReview(
    clientInitials: 'NK', clientName: 'Nithya K.',
    professionalName: 'Adv. V. Rajan', specialty: 'Property Law',
    comment: 'Very knowledgeable and explained everything clearly. Resolved our issue.',
    rating: 4.7,
    avatarBg: Color(0xFFEEEDFE), avatarText: Color(0xFF534AB7),
  ),
  AdminReview(
    clientInitials: 'AM', clientName: 'Arun M.',
    professionalName: 'Rahul Kumar', specialty: 'CBT Therapy',
    comment: 'CBT techniques really helped with my anxiety. Great experience overall.',
    rating: 4.8,
    avatarBg: Color(0xFFEAF3DE), avatarText: Color(0xFF3B6D11),
  ),
  AdminReview(
    clientInitials: 'PV', clientName: 'Priya V.',
    professionalName: 'Meera Fathima', specialty: 'Family & Divorce',
    comment: 'Professional and empathetic. Helped us navigate a tough situation.',
    rating: 5.0,
    avatarBg: Color(0xFFFAECE7), avatarText: Color(0xFF993C1D),
  ),
];

// ═══════════════════════════════════════════════════════════════
// Admin Dashboard Screen
// ═══════════════════════════════════════════════════════════════

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  int _selectedNavIndex = 0; // 0=Home, 1=Meetings, 2=Payments, 3=Profile

  late final AnimationController _headerAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut);
    _headerAnim.forward();
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: adminPrimary,
      statusBarIconBrightness: Brightness.light,
    ));

    // return Scaffold(
    //   backgroundColor: const Color(0xFFF4F6FB),
    //   body: _selectedNavIndex == 0
    //       ? _buildHomePage()
    //       : _selectedNavIndex == 1,
    //           // ? _buildMeetingsNavPage()
    //           // : _selectedNavIndex == 2
    //               // ? _buildPaymentsPage()
    //               // : _buildProfilePage(),
    //   bottomNavigationBar: _buildBottomNavBar(),
    // );

  //    return Scaffold(
  //     backgroundColor: const Color(0xFFF4F6FB),
  //     body: Column(
  //       children: [
  //         _buildHeader(),
  //         _buildTabBar(),
  //         Expanded(
  //           child: _selectedTab == 0
  //               ? _buildOverviewTab()
  //               : _selectedTab == 1
  //                   ? _buildMeetingsTab()
  //                   : _buildReviewsTab(),
  //         ),
  //       ],
  //     ),
  //     bottomNavigationBar: _buildBottomNavBar(),
  //   );
    
  // }

  return Scaffold(
  backgroundColor: const Color(0xFFF4F6FB),
  body: _selectedNavIndex == 0
      ? Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: _selectedTab == 0
                  ? _buildOverviewTab()
                  : _selectedTab == 1
                      ? _buildMeetingsTab()
                      : _buildReviewsTab(),
            ),
          ],
        )
      : _selectedNavIndex == 1
          ? const MeetingsScreen()
          : _selectedNavIndex == 2
              ? const PaymentScreen()
              : const ProfileScreen(),
  bottomNavigationBar: _buildBottomNavBar(),
);
  }

  // ═══════════════════════════════════════════════════════════════
  // Home Page — full existing dashboard
  // ═══════════════════════════════════════════════════════════════
  Widget _buildHomePage() {
    return Column(
      children: [
        _buildHeader(),
        _buildTabBar(),
        Expanded(
          child: _selectedTab == 0
              ? _buildOverviewTab()
              : _selectedTab == 1
                  ? _buildMeetingsTab()
                  : _buildReviewsTab(),
        ),
      ],
    );
  }

  // ── Header ────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: adminPrimary,
      child: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.18),
                      ),
                      child: const Icon(Icons.admin_panel_settings_outlined,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Admin Portal',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.7))),
                          const Text('MyTherapio',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.3)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF4ADE80)),
                          ),
                          const SizedBox(width: 5),
                          const Text('Live',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _headerStat('248', 'Total meetings',
                        Icons.calendar_today_rounded),
                    const SizedBox(width: 10),
                    _headerStat('191', 'Completed',
                        Icons.check_circle_outline_rounded),
                    const SizedBox(width: 10),
                    _headerStat('57', 'Upcoming', Icons.schedule_rounded),
                    const SizedBox(width: 10),
                    _headerStat(
                        '4.8★', 'Avg rating', Icons.star_outline_rounded),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerStat(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.55), size: 16),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 1),
            Text(label,
                style:
                    TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.65)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  // ── Tab bar ───────────────────────────────────────────────────
  Widget _buildTabBar() {
    const tabs = ['Overview', 'Meetings', 'Reviews'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final active = i == _selectedTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
                height: 34,
                decoration: BoxDecoration(
                  color: active ? adminPrimary : const Color(0xFFF4F6FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(tabs[i],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : const Color(0xFF6B7280))),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Tab 1 — Overview
  // ═══════════════════════════════════════════════════════════════
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRevenueSection(),
          const SizedBox(height: 20),
          _buildMeetingsProgressSection(),
          const SizedBox(height: 20),
          _buildRatingBreakdownSection(),
          const SizedBox(height: 20),
          _buildTopProfessionalsSection(),
        ],
      ),
    );
  }

  Widget _buildRevenueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Revenue summary', 'View all', () {}),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _amountCard(
                iconBg: const Color(0xFFEAF3DE),
                iconColor: const Color(0xFF3B6D11),
                icon: Icons.currency_rupee_rounded,
                value: '₹1,43,500',
                label: 'Total earned',
                valueColor: const Color(0xFF3B6D11),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _amountCard(
                iconBg: const Color(0xFFFAEEDA),
                iconColor: const Color(0xFF854F0B),
                icon: Icons.hourglass_top_rounded,
                value: '₹28,200',
                label: 'Pending payout',
                valueColor: const Color(0xFF854F0B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _card(
          child: Column(
            children: [
              _revenueRow(
                  'Counselling sessions', '₹98,400', 0.68, adminPrimary),
              const SizedBox(height: 12),
              _revenueRow('Legal advisory', '₹31,500', 0.22,
                  const Color(0xFF534AB7)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _amountCard({
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: valueColor)),
          const SizedBox(height: 2),
          Text(label,
              style:
                  const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _revenueRow(
      String label, String amount, double fraction, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF6B7280))),
            Text(amount,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827))),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: fraction,
            backgroundColor: const Color(0xFFF3F4F6),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildMeetingsProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Meetings overview', null, null),
        const SizedBox(height: 10),
        _card(
          child: Column(
            children: [
              Row(
                children: [
                  _meetingStatBox(
                      '248', 'Total', adminPrimary, const Color(0xFFEEF2FF)),
                  const SizedBox(width: 10),
                  _meetingStatBox('191', 'Completed',
                      const Color(0xFF1D9E75), const Color(0xFFE1F5EE)),
                  const SizedBox(width: 10),
                  _meetingStatBox('57', 'Upcoming',
                      const Color(0xFF854F0B), const Color(0xFFFAEEDA)),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 12,
                  child: Row(
                    children: [
                      Flexible(
                          flex: 191,
                          child:
                              Container(color: const Color(0xFF1D9E75))),
                      Flexible(
                          flex: 57,
                          child:
                              Container(color: const Color(0xFFFAC775))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _legendDot(
                      const Color(0xFF1D9E75), 'Completed (77%)'),
                  const SizedBox(width: 14),
                  _legendDot(
                      const Color(0xFFFAC775), 'Upcoming (23%)'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _meetingStatBox(
      String value, String label, Color textColor, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF6B7280))),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: Color(0xFF6B7280))),
      ],
    );
  }

  Widget _buildRatingBreakdownSection() {
    final rows = [
      ('5 stars', 0.72, '72%'),
      ('4 stars', 0.20, '20%'),
      ('3 stars', 0.06, '6%'),
      ('1–2 stars', 0.02, '2%'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Rating breakdown', '184 reviews', null),
        const SizedBox(height: 10),
        _card(
          child: Column(
            children: rows.map((r) {
              final isLow = r.$1 == '1–2 stars';
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(r.$1,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF6B7280))),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: r.$2,
                            backgroundColor: const Color(0xFFF3F4F6),
                            valueColor: AlwaysStoppedAnimation<Color>(isLow
                                ? const Color(0xFFE24B4A)
                                : const Color(0xFFF59E0B)),
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      child: Text(r.$3,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827)),
                          textAlign: TextAlign.right),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTopProfessionalsSection() {
    final professionals = [
      ('Dr. Anjali N.', 'Clinical Psychology', 4.9, 312, 'AN',
          const Color(0xFFE6F1FB), const Color(0xFF185FA5)),
      ('Rahul Kumar', 'CBT Therapy', 4.8, 198, 'RK',
          const Color(0xFFEAF3DE), const Color(0xFF3B6D11)),
      ('Adv. V. Rajan', 'Property Law', 4.7, 156, 'VR',
          const Color(0xFFEEEDFE), const Color(0xFF534AB7)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Top professionals', 'See all', () {}),
        const SizedBox(height: 10),
        ...professionals.map((p) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: p.$6),
                  alignment: Alignment.center,
                  child: Text(p.$5,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: p.$7)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.$1,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827))),
                      const SizedBox(height: 2),
                      Text(p.$2,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFF59E0B), size: 14),
                      const SizedBox(width: 3),
                      Text('${p.$3}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827))),
                    ]),
                    const SizedBox(height: 2),
                    Text('${p.$4} reviews',
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFF9CA3AF))),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Tab 2 — Meetings
  // ═══════════════════════════════════════════════════════════════
  Widget _buildMeetingsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _summaryChip(
                  '57 upcoming', adminPrimary, const Color(0xFFEEF2FF)),
              const SizedBox(width: 8),
              _summaryChip('191 completed', const Color(0xFF1D9E75),
                  const Color(0xFFE1F5EE)),
            ],
          ),
          const SizedBox(height: 16),
          _sectionHeader('Upcoming meetings', null, null),
          const SizedBox(height: 10),
          _card(
            child: Column(
              children: List.generate(kUpcomingMeetings.length, (i) {
                final m = kUpcomingMeetings[i];
                return Column(
                  children: [
                    if (i != 0)
                      const Divider(
                          height: 1, color: Color(0xFFF3F4F6)),
                    _meetingRow(m),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          _sectionHeader('Completed meetings', 'See all', () {}),
          const SizedBox(height: 10),
          _completedMeetingCard('Dr. Anjali N.', 'Clinical Psych',
              'Arjun R.', '9 May', '11:00 AM',
              const Color(0xFFE6F1FB), const Color(0xFF185FA5), 'AN'),
          _completedMeetingCard('Adv. V. Rajan', 'Property Law',
              'Bindu S.', '8 May', '3:30 PM',
              const Color(0xFFEEEDFE), const Color(0xFF534AB7), 'VR'),
          _completedMeetingCard('Rahul Kumar', 'CBT Therapy', 'Sanjay P.',
              '7 May', '5:00 PM',
              const Color(0xFFEAF3DE), const Color(0xFF3B6D11), 'RK'),
        ],
      ),
    );
  }

  Widget _summaryChip(String label, Color textColor, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor)),
    );
  }

  Widget _meetingRow(UpcomingMeeting m) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: m.avatarBg),
            alignment: Alignment.center,
            child: Text(m.initials,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: m.avatarText)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.professionalName,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text('${m.specialty} · ${m.clientName}',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(m.time,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: adminPrimary)),
              const SizedBox(height: 2),
              Text(m.day,
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF9CA3AF))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _completedMeetingCard(
    String professional,
    String specialty,
    String client,
    String date,
    String time,
    Color avatarBg,
    Color avatarText,
    String initials,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: avatarBg),
            alignment: Alignment.center,
            child: Text(initials,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: avatarText)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(professional,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text('$specialty · $client',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                    color: const Color(0xFFE1F5EE),
                    borderRadius: BorderRadius.circular(6)),
                child: const Text('Done',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D9E75))),
              ),
              const SizedBox(height: 4),
              Text('$date · $time',
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF9CA3AF))),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Tab 3 — Reviews
  // ═══════════════════════════════════════════════════════════════
  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _card(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Overall rating',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                    const SizedBox(height: 4),
                    const Text('4.8',
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827))),
                    Row(
                      children: List.generate(
                          5,
                          (i) => const Icon(Icons.star_rounded,
                              color: Color(0xFFF59E0B), size: 16)),
                    ),
                    const SizedBox(height: 4),
                    const Text('184 total reviews',
                        style: TextStyle(
                            fontSize: 11, color: Color(0xFF9CA3AF))),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _ratingBar('5★', 0.72, '133'),
                    const SizedBox(height: 6),
                    _ratingBar('4★', 0.20, '37'),
                    const SizedBox(height: 6),
                    _ratingBar('3★', 0.06, '11'),
                    const SizedBox(height: 6),
                    _ratingBar('1–2★', 0.02, '3'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionHeader(
              'Recent reviews', '${kAdminReviews.length} shown', null),
          const SizedBox(height: 10),
          _card(
            child: Column(
              children: List.generate(kAdminReviews.length, (i) {
                final r = kAdminReviews[i];
                return Column(
                  children: [
                    if (i != 0)
                      const Divider(
                          height: 1, color: Color(0xFFF3F4F6)),
                    _reviewRow(r),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingBar(String label, double fraction, String count) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(label,
              style:
                  const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
              textAlign: TextAlign.right),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFF59E0B)),
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(count,
            style: const TextStyle(
                fontSize: 10, color: Color(0xFF9CA3AF))),
      ],
    );
  }

  Widget _reviewRow(AdminReview r) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: r.avatarBg),
                alignment: Alignment.center,
                child: Text(r.clientInitials,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: r.avatarText)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.clientName,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827))),
                    Text('${r.professionalName} · ${r.specialty}',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF9CA3AF))),
                  ],
                ),
              ),
              Text('${r.rating}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF59E0B))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < r.rating.floor()
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: const Color(0xFFF59E0B),
                size: 14,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(r.comment,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  height: 1.5)),
        ],
      ),
    );
  }


  Widget _buildBottomNavBar() {
    const items = [
      (Icons.home_outlined, Icons.home_rounded, 'Home'),
      (Icons.calendar_today_outlined, Icons.calendar_today_rounded,
          'Meetings'),
      (Icons.credit_card_outlined, Icons.credit_card_rounded, 'Payments'),
      (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: List.generate(items.length, (i) {
              final active = i == _selectedNavIndex;
              final item = items[i];
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _selectedNavIndex = i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 32,
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFFEEF2FF)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          active ? item.$2 : item.$1,
                          color: active
                              ? adminPrimary
                              : const Color(0xFF9CA3AF),
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.$3,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? adminPrimary
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: child,
    );
  }

  Widget _sectionHeader(
      String title, String? linkText, VoidCallback? onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827))),
        if (linkText != null)
          GestureDetector(
            onTap: onTap,
            child: Text(linkText,
                style: const TextStyle(
                    fontSize: 12,
                    color: adminPrimary,
                    fontWeight: FontWeight.w500)),
          ),
      ],
    );
  }
}