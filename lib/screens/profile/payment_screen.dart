// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});
 
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
 
// class _PaymentScreenState extends State<PaymentScreen> {
//   static const int ratePerMeeting = 800;
//   static const int minimumHold = 6000;
 
//   int meetings = 10;
//   final TextEditingController _withdrawController = TextEditingController();
//   String? _withdrawError;
//   bool _withdrawValid = false;
 
//   int get walletBalance => meetings * ratePerMeeting;
//   int get withdrawable => (walletBalance - minimumHold).clamp(0, double.maxFinite.toInt());
//   bool get isUnlocked => walletBalance > minimumHold;
//   double get progressPct => (walletBalance / minimumHold).clamp(0.0, 1.0);
 
//   void _changeMeetings(int delta) {
//     setState(() {
//       meetings = (meetings + delta).clamp(0, 9999);
//       _withdrawController.clear();
//       _withdrawError = null;
//       _withdrawValid = false;
//     });
//   }
 
//   void _validateWithdraw(String value) {
//     final amount = int.tryParse(value) ?? 0;
//     setState(() {
//       if (value.isEmpty || amount <= 0) {
//         _withdrawError = null;
//         _withdrawValid = false;
//       } else if (amount > withdrawable) {
//         _withdrawError = 'Amount exceeds withdrawable balance (₹${_fmt(withdrawable)})';
//         _withdrawValid = false;
//       } else if (!isUnlocked) {
//         _withdrawError = 'Minimum ₹${_fmt(minimumHold)} wallet balance required';
//         _withdrawValid = false;
//       } else {
//         _withdrawError = null;
//         _withdrawValid = true;
//       }
//     });
//   }
 
//   String _fmt(int amount) {
//     final s = amount.toString();
//     if (s.length <= 3) return s;
//     final last3 = s.substring(s.length - 3);
//     final rest = s.substring(0, s.length - 3);
//     final withCommas = rest.replaceAllMapped(
//       RegExp(r'(\d{1,2})(?=(\d{2})+$)'),
//       (m) => '${m[1]},',
//     );
//     return '$withCommas,$last3';
//   }
 
//   void _handleWithdraw() {
//     final amount = int.tryParse(_withdrawController.text) ?? 0;
//     if (!_withdrawValid || amount <= 0) return;
 
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Confirm Withdrawal'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Amount: ₹${_fmt(amount)}', style: const TextStyle(fontWeight: FontWeight.w500)),
//             const SizedBox(height: 6),
//             Text(
//               'Wallet after withdrawal: ₹${_fmt(walletBalance - amount)}',
//               style: TextStyle(color: Colors.grey[600], fontSize: 13),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancel'),
//           ),
//           FilledButton(
//             style: FilledButton.styleFrom(backgroundColor: const Color(0xFF1D9E75)),
//             onPressed: () {
//               Navigator.pop(ctx);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('₹${_fmt(amount)} withdrawal initiated!'),
//                   backgroundColor: const Color(0xFF1D9E75),
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               );
//               setState(() {
//                 _withdrawController.clear();
//                 _withdrawError = null;
//                 _withdrawValid = false;
//               });
//             },
//             child: const Text('Confirm'),
//           ),
//         ],
//       ),
//     );
//   }
 
//   @override
//   void dispose() {
//     _withdrawController.dispose();
//     super.dispose();
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     final remainingToMin = (minimumHold - walletBalance).clamp(0, minimumHold);
//     final withdrawAmount = int.tryParse(_withdrawController.text) ?? 0;
//     final afterWithdraw = _withdrawValid ? walletBalance - withdrawAmount : null;
 
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         elevation: 0,
//         centerTitle: false,
//         title: const Text(
//           'Payments',
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
//         ),
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Meeting counter
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Meetings completed',
//                           style: TextStyle(fontSize: 13, color: Colors.grey)),
//                       const SizedBox(height: 4),
//                       Text('× ₹$ratePerMeeting per meeting',
//                           style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                     ],
//                   ),
//                   const Spacer(),
//                   _CounterButton(
//                     icon: Icons.remove,
//                     onTap: () => _changeMeetings(-1),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     '$meetings',
//                     style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(width: 12),
//                   _CounterButton(
//                     icon: Icons.add,
//                     onTap: () => _changeMeetings(1),
//                   ),
//                 ],
//               ),
//             ),
 
//             const SizedBox(height: 14),
 
//             // Wallet balance card
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Wallet balance',
//                       style: TextStyle(fontSize: 13, color: Colors.grey)),
//                   const SizedBox(height: 6),
//                   Text(
//                     '₹${_fmt(walletBalance)}',
//                     style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 10),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: isUnlocked
//                           ? const Color(0xFFEAF3DE)
//                           : const Color(0xFFFAEEDA),
//                       borderRadius: BorderRadius.circular(999),
//                     ),
//                     child: Text(
//                       isUnlocked
//                           ? 'Withdraw unlocked'
//                           : 'Need ₹${_fmt(remainingToMin)} more to unlock',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: isUnlocked
//                             ? const Color(0xFF27500A)
//                             : const Color(0xFF633806),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
 
//             const SizedBox(height: 14),
 
//             // Stat cards
//             Row(
//               children: [
//                 Expanded(
//                   child: _StatCard(
//                     label: 'Withdrawable',
//                     value: '₹${_fmt(withdrawable)}',
//                     valueColor: isUnlocked
//                         ? const Color(0xFF1D9E75)
//                         : Colors.grey.shade600,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 const Expanded(
//                   child: _StatCard(
//                     label: 'Minimum hold',
//                     value: '₹6,000',
//                   ),
//                 ),
//               ],
//             ),
 
//             const SizedBox(height: 14),
 
//             // Progress bar
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Progress to minimum (₹6,000)',
//                       style: TextStyle(fontSize: 13, color: Colors.grey)),
//                   const SizedBox(height: 10),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(999),
//                     child: LinearProgressIndicator(
//                       value: progressPct,
//                       minHeight: 10,
//                       backgroundColor: Colors.grey.shade200,
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         isUnlocked
//                             ? const Color(0xFF1D9E75)
//                             : const Color(0xFFBA7517),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text('₹0',
//                           style: TextStyle(fontSize: 11, color: Colors.grey)),
//                       Text('${(progressPct * 100).round()}%',
//                           style: const TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey)),
//                       const Text('₹6,000',
//                           style: TextStyle(fontSize: 11, color: Colors.grey)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
 
//             const SizedBox(height: 14),
 
//             // Withdraw section
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Withdraw to bank',
//                       style: TextStyle(
//                           fontSize: 15, fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 14),
 
//                   // Amount input
//                   TextField(
//                     controller: _withdrawController,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     onChanged: _validateWithdraw,
//                     enabled: isUnlocked,
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.w500),
//                     decoration: InputDecoration(
//                       prefixText: '₹ ',
//                       prefixStyle: const TextStyle(
//                           fontSize: 16, color: Colors.grey),
//                       hintText: '0',
//                       filled: true,
//                       fillColor: Colors.grey.shade50,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                             color: Color(0xFF1D9E75), width: 1.5),
//                       ),
//                       disabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.grey.shade200),
//                       ),
//                     ),
//                   ),
 
//                   const SizedBox(height: 12),
 
//                   // Info rows
//                   _InfoRow(
//                       label: 'Available to withdraw',
//                       value: '₹${_fmt(withdrawable)}'),
//                   _InfoRow(
//                     label: 'After withdrawal',
//                     value: afterWithdraw != null
//                         ? '₹${_fmt(afterWithdraw)}'
//                         : '—',
//                     valueColor: _withdrawValid
//                         ? const Color(0xFF1D9E75)
//                         : null,
//                   ),
 
//                   // Error / success message
//                   if (_withdrawError != null) ...[
//                     const SizedBox(height: 10),
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFAEEDA),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.warning_amber_rounded,
//                               size: 16, color: Color(0xFF633806)),
//                           const SizedBox(width: 6),
//                           Expanded(
//                             child: Text(
//                               _withdrawError!,
//                               style: const TextStyle(
//                                   fontSize: 12, color: Color(0xFF633806)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
 
//                   if (_withdrawValid) ...[
//                     const SizedBox(height: 10),
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFEAF3DE),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Row(
//                         children: [
//                           Icon(Icons.check_circle_outline,
//                               size: 16, color: Color(0xFF27500A)),
//                           SizedBox(width: 6),
//                           Text(
//                             'Amount is valid for withdrawal',
//                             style: TextStyle(
//                                 fontSize: 12, color: Color(0xFF27500A)),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
 
//                   const SizedBox(height: 14),
 
//                   // Withdraw button
//                   SizedBox(
//                     width: double.infinity,
//                     child: FilledButton(
//                       onPressed: _withdrawValid ? _handleWithdraw : null,
//                       style: FilledButton.styleFrom(
//                         backgroundColor: const Color(0xFF1D9E75),
//                         disabledBackgroundColor: Colors.grey.shade200,
//                         disabledForegroundColor: Colors.grey,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text(
//                         'Withdraw to bank',
//                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
 
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }
 
// // ─── Helper Widgets ───────────────────────────────────────────────
 
// class _CounterButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
 
//   const _CounterButton({required this.icon, required this.onTap});
 
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 34,
//         height: 34,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.grey.shade300),
//           color: Colors.grey.shade50,
//         ),
//         child: Icon(icon, size: 18, color: Colors.black87),
//       ),
//     );
//   }
// }
 
// class _StatCard extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color? valueColor;
 
//   const _StatCard({
//     required this.label,
//     required this.value,
//     this.valueColor,
//   });
 
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label,
//               style: const TextStyle(fontSize: 12, color: Colors.grey)),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//               color: valueColor ?? Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
 
// class _InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color? valueColor;
 
//   const _InfoRow({
//     required this.label,
//     required this.value,
//     this.valueColor,
//   });
 
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label,
//               style: const TextStyle(fontSize: 13, color: Colors.grey)),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: valueColor ?? Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color adminPrimary = Color(0xFF1B4FD8);
const Color adminDeep = Color(0xFF0F2A80);
const Color pageBg = Color(0xFFF4F6FB);

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const int ratePerMeeting = 800;
  static const int minimumHold = 6000;

  int meetings = 10;
  final TextEditingController _withdrawController = TextEditingController();
  String? _withdrawError;
  bool _withdrawValid = false;

  int get walletBalance => meetings * ratePerMeeting;
  int get withdrawable =>
      (walletBalance - minimumHold).clamp(0, double.maxFinite.toInt());
  bool get isUnlocked => walletBalance > minimumHold;
  double get progressPct => (walletBalance / minimumHold).clamp(0.0, 1.0);

  void _changeMeetings(int delta) {
    setState(() {
      meetings = (meetings + delta).clamp(0, 9999);
      _withdrawController.clear();
      _withdrawError = null;
      _withdrawValid = false;
    });
  }

  void _validateWithdraw(String value) {
    final amount = int.tryParse(value) ?? 0;
    setState(() {
      if (value.isEmpty || amount <= 0) {
        _withdrawError = null;
        _withdrawValid = false;
      } else if (!isUnlocked) {
        _withdrawError =
            'Minimum ₹${_fmt(minimumHold)} wallet balance required';
        _withdrawValid = false;
      } else if (amount > withdrawable) {
        _withdrawError =
            'Amount exceeds withdrawable balance (₹${_fmt(withdrawable)})';
        _withdrawValid = false;
      } else {
        _withdrawError = null;
        _withdrawValid = true;
      }
    });
  }

  String _fmt(int amount) {
    final s = amount.toString();
    if (s.length <= 3) return s;
    final last3 = s.substring(s.length - 3);
    final rest = s.substring(0, s.length - 3);
    final withCommas = rest.replaceAllMapped(
      RegExp(r'(\d{1,2})(?=(\d{2})+$)'),
      (m) => '${m[1]},',
    );
    return '$withCommas,$last3';
  }

  void _handleWithdraw() {
    final amount = int.tryParse(_withdrawController.text) ?? 0;
    if (!_withdrawValid || amount <= 0) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.account_balance_rounded,
                  color: adminPrimary, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('Confirm Withdrawal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount',
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF6B7280))),
                  Text('₹${_fmt(amount)}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: adminPrimary)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wallet after',
                    style:
                        TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                Text('₹${_fmt(walletBalance - amount)}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151))),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF6B7280))),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: adminPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text('₹${_fmt(amount)} withdrawal initiated!'),
                    ],
                  ),
                  backgroundColor: const Color(0xFF1D9E75),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
              setState(() {
                _withdrawController.clear();
                _withdrawError = null;
                _withdrawValid = false;
              });
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _withdrawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: adminPrimary,
      statusBarIconBrightness: Brightness.light,
    ));

    final remainingToMin =
        (minimumHold - walletBalance).clamp(0, minimumHold);
    final withdrawAmount =
        int.tryParse(_withdrawController.text) ?? 0;
    final afterWithdraw =
        _withdrawValid ? walletBalance - withdrawAmount : null;

    return Scaffold(
      backgroundColor: pageBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.fromLTRB(16, 16, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Meetings Counter Card ─────────────────────
                  _sectionCard(
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                              Icons.video_call_rounded,
                              color: adminPrimary,
                              size: 22),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text('Meetings completed',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280))),
                            Text('× ₹$ratePerMeeting per meeting',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF9CA3AF))),
                          ],
                        ),
                        const Spacer(),
                        _CounterButton(
                          icon: Icons.remove,
                          onTap: () => _changeMeetings(-1),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$meetings',
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827)),
                        ),
                        const SizedBox(width: 10),
                        _CounterButton(
                          icon: Icons.add,
                          onTap: () => _changeMeetings(1),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Wallet Balance Card ───────────────────────
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Wallet balance',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280))),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isUnlocked
                                    ? const Color(0xFFE1F5EE)
                                    : const Color(0xFFFFF3E0),
                                borderRadius:
                                    BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isUnlocked
                                        ? Icons
                                            .lock_open_rounded
                                        : Icons.lock_rounded,
                                    size: 11,
                                    color: isUnlocked
                                        ? const Color(
                                            0xFF1D9E75)
                                        : const Color(
                                            0xFFB45309),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isUnlocked
                                        ? 'Withdraw unlocked'
                                        : 'Need ₹${_fmt(remainingToMin)} more',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight:
                                          FontWeight.w600,
                                      color: isUnlocked
                                          ? const Color(
                                              0xFF1D9E75)
                                          : const Color(
                                              0xFFB45309),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${_fmt(walletBalance)}',
                          style: const TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                              letterSpacing: -1),
                        ),
                        const SizedBox(height: 16),
                        // Progress bar
                        Row(
                          children: [
                            const Text('₹0',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF9CA3AF))),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets
                                    .symmetric(horizontal: 8),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(
                                          999),
                                  child: LinearProgressIndicator(
                                    value: progressPct,
                                    minHeight: 8,
                                    backgroundColor:
                                        const Color(0xFFE5E7EB),
                                    valueColor:
                                        AlwaysStoppedAnimation<
                                            Color>(
                                      isUnlocked
                                          ? const Color(
                                              0xFF1D9E75)
                                          : adminPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text('₹${_fmt(minimumHold)} min',
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF9CA3AF))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Center(
                          child: Text(
                            '${(progressPct * 100).round()}% of minimum reached',
                            style: TextStyle(
                                fontSize: 11,
                                color: isUnlocked
                                    ? const Color(0xFF1D9E75)
                                    : const Color(0xFF6B7280)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Stat chips ────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatChip(
                          icon: Icons.account_balance_wallet_rounded,
                          label: 'Withdrawable',
                          value: '₹${_fmt(withdrawable)}',
                          iconBg: const Color(0xFFEEF2FF),
                          iconColor: adminPrimary,
                          valueColor: isUnlocked
                              ? adminPrimary
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: _StatChip(
                          icon: Icons.lock_outline_rounded,
                          label: 'Minimum hold',
                          value: '₹6,000',
                          iconBg: Color(0xFFFFF3E0),
                          iconColor: Color(0xFFB45309),
                          valueColor: Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Withdraw Section ──────────────────────────
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                  Icons.account_balance_rounded,
                                  color: adminPrimary,
                                  size: 18),
                            ),
                            const SizedBox(width: 10),
                            const Text('Withdraw to bank',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827))),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Amount input
                        TextField(
                          controller: _withdrawController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: _validateWithdraw,
                          enabled: isUnlocked,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827)),
                          decoration: InputDecoration(
                            prefixText: '₹ ',
                            prefixStyle: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w500),
                            hintText: '0',
                            hintStyle: const TextStyle(
                                color: Color(0xFFD1D5DB)),
                            filled: true,
                            fillColor: isUnlocked
                                ? const Color(0xFFF9FAFB)
                                : const Color(0xFFF3F4F6),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE5E7EB)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE5E7EB)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: adminPrimary,
                                  width: 2),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFFF3F4F6)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Info rows
                        _InfoRow(
                          icon: Icons
                              .account_balance_wallet_outlined,
                          label: 'Available to withdraw',
                          value: '₹${_fmt(withdrawable)}',
                          valueColor: isUnlocked
                              ? adminPrimary
                              : const Color(0xFF9CA3AF),
                        ),
                        const Divider(
                            height: 1,
                            color: Color(0xFFF3F4F6)),
                        _InfoRow(
                          icon: Icons.savings_outlined,
                          label: 'Wallet after withdrawal',
                          value: afterWithdraw != null
                              ? '₹${_fmt(afterWithdraw)}'
                              : '—',
                          valueColor: _withdrawValid
                              ? const Color(0xFF1D9E75)
                              : const Color(0xFF9CA3AF),
                        ),

                        // Status message
                        if (_withdrawError != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius:
                                  BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color(
                                      0xFFFFCC80)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                    Icons
                                        .warning_amber_rounded,
                                    size: 16,
                                    color: Color(0xFFB45309)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _withdrawError!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color:
                                            Color(0xFFB45309)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        if (_withdrawValid) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1F5EE),
                              borderRadius:
                                  BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color(
                                      0xFF9FE1CB)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    size: 16,
                                    color: Color(0xFF1D9E75)),
                                SizedBox(width: 8),
                                Text(
                                  'Amount is valid for withdrawal',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0F6E56)),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Withdraw button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _withdrawValid
                                ? _handleWithdraw
                                : null,
                            icon: const Icon(
                                Icons.account_balance_rounded,
                                size: 18),
                            label: const Text(
                              'Withdraw to bank',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: adminPrimary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  const Color(0xFFE5E7EB),
                              disabledForegroundColor:
                                  const Color(0xFF9CA3AF),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),

                        if (!isUnlocked) ...[
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Complete ${((minimumHold - walletBalance) / ratePerMeeting).ceil()} more meeting(s) to unlock withdrawal',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF9CA3AF)),
                            ),
                          ),
                        ],
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

  // ── Header (matches MeetingsScreen style) ─────────────────────
  Widget _buildHeader() {
    return Container(
      color: adminPrimary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Payments',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.4)),
              const SizedBox(height: 14),
              Row(
                children: [
                  _headerStatChip(
                    '₹${_fmt(walletBalance)}',
                    'Wallet',
                    Icons.account_balance_wallet_rounded,
                    Colors.white.withOpacity(0.18),
                  ),
                  const SizedBox(width: 10),
                  _headerStatChip(
                    '₹${_fmt(withdrawable)}',
                    'Withdrawable',
                    Icons.trending_up_rounded,
                    Colors.white.withOpacity(0.18),
                  ),
                  const SizedBox(width: 10),
                  _headerStatChip(
                    '$meetings',
                    'Meetings',
                    Icons.video_call_rounded,
                    Colors.white.withOpacity(0.18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerStatChip(
      String value, String label, IconData icon, Color bg) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.6), size: 15),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                overflow: TextOverflow.ellipsis),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.65))),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
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
}

// ═══════════════════════════════════════════════════════════════
// Helper Widgets
// ═══════════════════════════════════════════════════════════════

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          color: const Color(0xFFF4F6FB),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF374151)),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconBg;
  final Color iconColor;
  final Color valueColor;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconBg,
    required this.iconColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF9CA3AF))),
              const SizedBox(height: 2),
              Text(value,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: valueColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF6B7280))),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}
 