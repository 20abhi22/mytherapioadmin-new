// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';

// // ─── Models ───────────────────────────────────────────────────────────────────

// enum DocStatus { idle, uploading, uploaded, approved, rejected }

// class DocumentItem {
//   final String id;
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final Color color;
//   final Color bgColor;
//   DocStatus status;
//   File? file;
//   String? fileName;

//   DocumentItem({
//     required this.id,
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.color,
//     required this.bgColor,
//     this.status = DocStatus.idle,
//     this.file,
//     this.fileName,
//   });
// }

// // ─── Screen ───────────────────────────────────────────────────────────────────

// class DocumentUploadScreen extends StatefulWidget {
//   const DocumentUploadScreen({super.key});

//   @override
//   State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
// }

// class _DocumentUploadScreenState extends State<DocumentUploadScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _headerAnim;
//   late Animation<double> _headerFade;
//   late Animation<Offset> _headerSlide;

//   final ImagePicker _picker = ImagePicker();

//   final List<DocumentItem> _docs = [
//     DocumentItem(
//       id: 'photo',
//       title: 'Profile Photo',
//       subtitle: 'Clear selfie with good lighting',
//       icon: Icons.person_rounded,
//       color: const Color(0xFF7C3AED),
//       bgColor: const Color(0xFFF5F3FF),
//     ),
//     DocumentItem(
//       id: 'aadhaar',
//       title: 'Aadhaar Card',
//       subtitle: 'Front & back clearly visible',
//       icon: Icons.credit_card_rounded,
//       color: const Color(0xFF0369A1),
//       bgColor: const Color(0xFFE0F2FE),
//     ),
//     DocumentItem(
//       id: 'certificate',
//       title: 'Certificate / Proof',
//       subtitle: 'Relevant certificate or document',
//       icon: Icons.workspace_premium_rounded,
//       color: const Color(0xFF854F0B),
//       bgColor: const Color(0xFFFAEEDA),
//     ),
//   ];

//   bool _isSubmitting = false;
//   bool _isSubmitted = false;

//   @override
//   void initState() {
//     super.initState();
//     _headerAnim = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 700));
//     _headerFade =
//         CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut);
//     _headerSlide = Tween<Offset>(
//       begin: const Offset(0, 0.12),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut));
//     _headerAnim.forward();
//   }

//   @override
//   void dispose() {
//     _headerAnim.dispose();
//     super.dispose();
//   }

//   int get _uploadedCount =>
//       _docs.where((d) => d.status != DocStatus.idle).length;

//   bool get _allUploaded => _docs.every((d) => d.status != DocStatus.idle);

//   double get _progress => _docs.isEmpty ? 0 : _uploadedCount / _docs.length;

//   // ── Pick file ──────────────────────────────────────────────────────────────
//   Future<void> _pickDocument(DocumentItem doc) async {
//     if (doc.status == DocStatus.uploading) return;

//     final choice = await _showPickerSheet(doc);
//     if (choice == null) return;

//     XFile? picked;
//     if (choice == 'camera') {
//       picked = await _picker.pickImage(
//           source: ImageSource.camera, imageQuality: 85);
//     } else if (choice == 'gallery') {
//       picked = await _picker.pickImage(
//           source: ImageSource.gallery, imageQuality: 85);
//     } else {
//       // file picker simulation
//       picked = await _picker.pickImage(
//           source: ImageSource.gallery, imageQuality: 85);
//     }

//     if (picked == null) return;

//     setState(() => doc.status = DocStatus.uploading);

//     // simulate upload delay
//     await Future.delayed(const Duration(milliseconds: 1800));

//     setState(() {
//       doc.status = DocStatus.uploaded;
//       doc.file = File(picked!.path);
//       doc.fileName = picked.name;
//     });
//   }

//   Future<String?> _showPickerSheet(DocumentItem doc) async {
//     return showModalBottomSheet<String>(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _PickerSheet(doc: doc),
//     );
//   }

//   // ── Remove doc ─────────────────────────────────────────────────────────────
//   void _removeDoc(DocumentItem doc) {
//     setState(() {
//       doc.status = DocStatus.idle;
//       doc.file = null;
//       doc.fileName = null;
//     });
//   }

//   // ── Submit ─────────────────────────────────────────────────────────────────
//   Future<void> _submit() async {
//     if (!_allUploaded || _isSubmitting) return;
//     setState(() => _isSubmitting = true);
//     await Future.delayed(const Duration(seconds: 2));
//     setState(() {
//       _isSubmitting = false;
//       _isSubmitted = true;
//       for (final d in _docs) {
//         d.status = DocStatus.uploaded; // set to pending review
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FB),
//       appBar: _buildAppBar(),
//       body: _isSubmitted ? _buildPendingView() : _buildUploadView(),
//     );
//   }

//   // ── AppBar ─────────────────────────────────────────────────────────────────
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       systemOverlayStyle: SystemUiOverlayStyle.dark,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new_rounded,
//             color: Color(0xFF1A1A1A), size: 20),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: const Text(
//         'Document Verification',
//         style: TextStyle(
//           color: Color(0xFF1A1A1A),
//           fontSize: 18,
//           fontWeight: FontWeight.w700,
//           letterSpacing: -0.3,
//         ),
//       ),
//       centerTitle: false,
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(1),
//         child: Container(height: 1, color: const Color(0xFFF0F0F0)),
//       ),
//     );
//   }

//   // ── Upload View ────────────────────────────────────────────────────────────
//   Widget _buildUploadView() {
//     return FadeTransition(
//       opacity: _headerFade,
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SlideTransition(
//                 position: _headerSlide, child: _buildProgressHeader()),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildInfoBanner(),
//                   const SizedBox(height: 24),
//                   const Text(
//                     'Required Documents',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF1A1A1A),
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Upload all 3 documents to proceed',
//                     style: TextStyle(fontSize: 13, color: Colors.grey[500]),
//                   ),
//                   const SizedBox(height: 16),
//                   ..._docs.map((doc) => _buildDocCard(doc)),
//                   const SizedBox(height: 24),
//                   _buildSubmitButton(),
//                   const SizedBox(height: 16),
//                   _buildFooterNote(),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Progress Header ────────────────────────────────────────────────────────
//   Widget _buildProgressHeader() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '$_uploadedCount of ${_docs.length} documents uploaded',
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1A1A1A),
//                 ),
//               ),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _allUploaded
//                       ? const Color(0xFFECFDF5)
//                       : const Color(0xFFF4F6FB),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   _allUploaded ? '✅ Ready to submit' : 'In progress',
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     color: _allUploaded
//                         ? const Color(0xFF16A34A)
//                         : const Color(0xFF6B7280),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: _progress,
//               minHeight: 8,
//               backgroundColor: const Color(0xFFF0F0F0),
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 _allUploaded
//                     ? const Color(0xFF16A34A)
//                     : const Color(0xFF6366F1),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Info Banner ────────────────────────────────────────────────────────────
//   Widget _buildInfoBanner() {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFFEFF6FF),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFBFDBFE)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.info_rounded, color: Color(0xFF2563EB), size: 18),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Tips for faster approval',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1E40AF),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '• Ensure documents are clear & fully visible\n• Files must be JPG, PNG, or PDF\n• Max file size: 5 MB per document',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.blue[700],
//                     height: 1.6,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Doc Card ───────────────────────────────────────────────────────────────
//   Widget _buildDocCard(DocumentItem doc) {
//     final isUploaded = doc.status == DocStatus.uploaded ||
//         doc.status == DocStatus.approved ||
//         doc.status == DocStatus.rejected;
//     final isUploading = doc.status == DocStatus.uploading;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: isUploaded
//               ? const Color(0xFF16A34A).withOpacity(0.3)
//               : isUploading
//                   ? const Color(0xFF6366F1).withOpacity(0.3)
//                   : const Color(0xFFE5E7EB),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(11),
//                   decoration: BoxDecoration(
//                     color: isUploaded
//                         ? const Color(0xFFECFDF5)
//                         : doc.bgColor,
//                     borderRadius: BorderRadius.circular(13),
//                   ),
//                   child: Icon(
//                     isUploaded
//                         ? Icons.check_circle_rounded
//                         : doc.icon,
//                     color: isUploaded ? const Color(0xFF16A34A) : doc.color,
//                     size: 22,
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         doc.title,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFF1A1A1A),
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         isUploaded
//                             ? doc.fileName ?? 'File uploaded'
//                             : doc.subtitle,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: isUploaded
//                               ? const Color(0xFF16A34A)
//                               : Colors.grey[500],
//                           fontWeight: isUploaded
//                               ? FontWeight.w500
//                               : FontWeight.w400,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 _buildDocAction(doc, isUploaded, isUploading),
//               ],
//             ),
//             if (isUploading) ...[
//               const SizedBox(height: 14),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: const LinearProgressIndicator(
//                   minHeight: 4,
//                   backgroundColor: Color(0xFFF0F0F0),
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               const Text(
//                 'Uploading...',
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Color(0xFF6366F1),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDocAction(
//       DocumentItem doc, bool isUploaded, bool isUploading) {
//     if (isUploading) {
//       return const SizedBox(
//         width: 22,
//         height: 22,
//         child: CircularProgressIndicator(
//           strokeWidth: 2.5,
//           color: Color(0xFF6366F1),
//         ),
//       );
//     }

//     if (isUploaded) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           GestureDetector(
//             onTap: () => _removeDoc(doc),
//             child: Container(
//               padding: const EdgeInsets.all(7),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFEF2F2),
//                 borderRadius: BorderRadius.circular(9),
//               ),
//               child: const Icon(Icons.delete_outline_rounded,
//                   size: 16, color: Color(0xFFDC2626)),
//             ),
//           ),
//           const SizedBox(width: 6),
//           GestureDetector(
//             onTap: () => _pickDocument(doc),
//             child: Container(
//               padding: const EdgeInsets.all(7),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF4F6FB),
//                 borderRadius: BorderRadius.circular(9),
//               ),
//               child: const Icon(Icons.refresh_rounded,
//                   size: 16, color: Color(0xFF6B7280)),
//             ),
//           ),
//         ],
//       );
//     }

//     return GestureDetector(
//       onTap: () => _pickDocument(doc),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           color: doc.bgColor,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.upload_rounded, size: 14, color: doc.color),
//             const SizedBox(width: 5),
//             Text(
//               'Upload',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 color: doc.color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Submit Button ──────────────────────────────────────────────────────────
//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 54,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         child: ElevatedButton(
//           onPressed: _allUploaded && !_isSubmitting ? _submit : null,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: _allUploaded
//                 ? const Color(0xFF16A34A)
//                 : const Color(0xFFE5E7EB),
//             disabledBackgroundColor: const Color(0xFFE5E7EB),
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//           ),
//           child: _isSubmitting
//               ? const SizedBox(
//                   width: 22,
//                   height: 22,
//                   child: CircularProgressIndicator(
//                       color: Colors.white, strokeWidth: 2.5),
//                 )
//               : Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       _allUploaded
//                           ? Icons.send_rounded
//                           : Icons.lock_outline_rounded,
//                       size: 18,
//                       color: _allUploaded
//                           ? Colors.white
//                           : const Color(0xFF9CA3AF),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       _allUploaded
//                           ? 'Submit for Verification'
//                           : 'Upload all documents to continue',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: _allUploaded
//                             ? Colors.white
//                             : const Color(0xFF9CA3AF),
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFooterNote() {
//     return Center(
//       child: Text(
//         '🔒  Your documents are encrypted & stored securely',
//         style: TextStyle(
//           fontSize: 12,
//           color: Colors.grey[400],
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );
//   }

//   // ── Pending / Submitted View ───────────────────────────────────────────────
//   Widget _buildPendingView() {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             // Lottie-style static success icon
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFFF7ED),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFFFF9800).withOpacity(0.2),
//                     blurRadius: 30,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: const Center(
//                 child: Text('⏳', style: TextStyle(fontSize: 46)),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Documents Submitted!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w800,
//                 color: Color(0xFF1A1A1A),
//                 letterSpacing: -0.5,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Our team is reviewing your documents.\nYou\'ll be notified once approved.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//                 height: 1.6,
//               ),
//             ),
//             const SizedBox(height: 32),

//             // Status Cards
//             ..._docs.map((doc) => _buildStatusCard(doc)),

//             const SizedBox(height: 24),

//             // Timeline
//             _buildApprovalTimeline(),

//             const SizedBox(height: 28),

//             // Note
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFFF7ED),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: const Color(0xFFFED7AA)),
//               ),
//               child: Row(
//                 children: [
//                   const Text('💡', style: TextStyle(fontSize: 18)),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       'Approval usually takes 24–48 hours. You can close this screen — we\'ll notify you.',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.orange[800],
//                         height: 1.5,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),

//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: OutlinedButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: OutlinedButton.styleFrom(
//                   side: const BorderSide(color: Color(0xFFE5E7EB)),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child: const Text(
//                   'Go Back to Home',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1A1A1A),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusCard(DocumentItem doc) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(9),
//             decoration: BoxDecoration(
//               color: doc.bgColor,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(doc.icon, color: doc.color, size: 18),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   doc.title,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1A1A1A),
//                   ),
//                 ),
//                 Text(
//                   doc.fileName ?? 'Uploaded',
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Colors.grey[400],
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           _statusBadge('Under Review'),
//         ],
//       ),
//     );
//   }

//   Widget _statusBadge(String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF7ED),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: const Color(0xFFFED7AA)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 6,
//             height: 6,
//             decoration: const BoxDecoration(
//               color: Color(0xFFF59E0B),
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 5),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF92400E),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildApprovalTimeline() {
//     final steps = [
//       {'label': 'Documents Uploaded', 'done': true},
//       {'label': 'Under Review', 'done': false},
//       {'label': 'Verified & Approved', 'done': false},
//       {'label': 'Dashboard Unlocked 🎉', 'done': false},
//     ];

//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(Icons.timeline_rounded, size: 16, color: Color(0xFF6B7280)),
//               SizedBox(width: 6),
//               Text(
//                 'Verification Progress',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF1A1A1A),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...steps.asMap().entries.map((entry) {
//             final i = entry.key;
//             final step = entry.value;
//             final isDone = step['done'] as bool;
//             final isCurrent = i == 1;
//             final isLast = i == steps.length - 1;

//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   width: 28,
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 24,
//                         height: 24,
//                         decoration: BoxDecoration(
//                           color: isDone
//                               ? const Color(0xFF16A34A)
//                               : isCurrent
//                                   ? const Color(0xFFFFF7ED)
//                                   : const Color(0xFFF4F6FB),
//                           shape: BoxShape.circle,
//                           border: isCurrent
//                               ? Border.all(
//                                   color: const Color(0xFFF59E0B), width: 2)
//                               : null,
//                         ),
//                         child: Center(
//                           child: isDone
//                               ? const Icon(Icons.check_rounded,
//                                   size: 14, color: Colors.white)
//                               : isCurrent
//                                   ? Container(
//                                       width: 8,
//                                       height: 8,
//                                       decoration: const BoxDecoration(
//                                         color: Color(0xFFF59E0B),
//                                         shape: BoxShape.circle,
//                                       ),
//                                     )
//                                   : Container(
//                                       width: 8,
//                                       height: 8,
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[300],
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                         ),
//                       ),
//                       if (!isLast)
//                         Container(
//                           width: 2,
//                           height: 28,
//                           color: isDone
//                               ? const Color(0xFF16A34A).withOpacity(0.3)
//                               : const Color(0xFFF0F0F0),
//                         ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Padding(
//                   padding: EdgeInsets.only(
//                       bottom: isLast ? 0 : 14, top: 3),
//                   child: Text(
//                     step['label'] as String,
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: isCurrent || isDone
//                           ? FontWeight.w600
//                           : FontWeight.w400,
//                       color: isDone
//                           ? const Color(0xFF16A34A)
//                           : isCurrent
//                               ? const Color(0xFF92400E)
//                               : Colors.grey[400],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

// // ─── Picker Bottom Sheet ───────────────────────────────────────────────────────

// class _PickerSheet extends StatelessWidget {
//   final DocumentItem doc;
//   const _PickerSheet({required this.doc});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(9),
//                 decoration: BoxDecoration(
//                   color: doc.bgColor,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(doc.icon, color: doc.color, size: 18),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Upload ${doc.title}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   Text(
//                     'Choose how to upload',
//                     style: TextStyle(fontSize: 12, color: Colors.grey[400]),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           _sheetOption(
//             context,
//             icon: Icons.camera_alt_rounded,
//             color: const Color(0xFF7C3AED),
//             bg: const Color(0xFFF5F3FF),
//             title: 'Take a Photo',
//             subtitle: 'Open camera and capture now',
//             value: 'camera',
//           ),
//           const SizedBox(height: 10),
//           _sheetOption(
//             context,
//             icon: Icons.photo_library_rounded,
//             color: const Color(0xFF0369A1),
//             bg: const Color(0xFFE0F2FE),
//             title: 'Choose from Gallery',
//             subtitle: 'Pick from your photos',
//             value: 'gallery',
//           ),
//           const SizedBox(height: 10),
//           _sheetOption(
//             context,
//             icon: Icons.upload_file_rounded,
//             color: const Color(0xFF854F0B),
//             bg: const Color(0xFFFAEEDA),
//             title: 'Upload from Files',
//             subtitle: 'PDF, JPG, PNG — max 5 MB',
//             value: 'file',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _sheetOption(
//     BuildContext context, {
//     required IconData icon,
//     required Color color,
//     required Color bg,
//     required String title,
//     required String subtitle,
//     required String value,
//   }) {
//     return GestureDetector(
//       onTap: () => Navigator.pop(context, value),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF8F9FB),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(9),
//               decoration: BoxDecoration(
//                 color: bg,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: color, size: 18),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: TextStyle(fontSize: 11.5, color: Colors.grey[400]),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios_rounded,
//                 size: 13, color: Color(0xFFD1D5DB)),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytherapio_admin_app/backend/api.dart';
import 'package:mytherapio_admin_app/screens/auth/login_screen.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

enum DocStatus { idle, uploading, uploaded, approved, rejected }

class DocumentItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;
  DocStatus status;
  File? file;
  String? fileName;

  DocumentItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.status = DocStatus.idle,
    this.file,
    this.fileName,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnim;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  final ImagePicker _picker = ImagePicker();

  final List<DocumentItem> _docs = [
    DocumentItem(
      id: 'photo',
      title: 'Profile Photo',
      subtitle: 'Clear selfie with good lighting',
      icon: Icons.person_rounded,
      color: const Color(0xFF7C3AED),
      bgColor: const Color(0xFFF5F3FF),
    ),
    DocumentItem(
      id: 'aadhaar',
      title: 'Aadhaar Card',
      subtitle: 'Front & back clearly visible',
      icon: Icons.credit_card_rounded,
      color: const Color(0xFF0369A1),
      bgColor: const Color(0xFFE0F2FE),
    ),
    DocumentItem(
      id: 'certificate',
      title: 'Certificate / Proof',
      subtitle: 'Relevant certificate or document',
      icon: Icons.workspace_premium_rounded,
      color: const Color(0xFF854F0B),
      bgColor: const Color(0xFFFAEEDA),
    ),
  ];

  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _headerFade =
        CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut));
    _headerAnim.forward();
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    super.dispose();
  }

  int get _uploadedCount =>
      _docs.where((d) => d.status != DocStatus.idle).length;

  bool get _allUploaded => _docs.every((d) => d.status != DocStatus.idle);

  double get _progress => _docs.isEmpty ? 0 : _uploadedCount / _docs.length;

  // ── Pick file ──────────────────────────────────────────────────────────────
  Future<void> _pickDocument(DocumentItem doc) async {
    if (doc.status == DocStatus.uploading) return;

    final choice = await _showPickerSheet(doc);
    if (choice == null) return;

    XFile? picked;
    if (choice == 'camera') {
      picked = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 85);
    } else if (choice == 'gallery') {
      picked = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 85);
    } else {
      // file picker simulation
      picked = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 85);
    }

    if (picked == null) return;

    setState(() => doc.status = DocStatus.uploading);

    // simulate upload delay
    await Future.delayed(const Duration(milliseconds: 1800));

    setState(() {
      doc.status = DocStatus.uploaded;
      doc.file = File(picked!.path);
      doc.fileName = picked.name;
    });
  }

  Future<String?> _showPickerSheet(DocumentItem doc) async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PickerSheet(doc: doc),
    );
  }

  // ── Remove doc ─────────────────────────────────────────────────────────────
  void _removeDoc(DocumentItem doc) {
    setState(() {
      doc.status = DocStatus.idle;
      doc.file = null;
      doc.fileName = null;
    });
  }

  // ── View doc ───────────────────────────────────────────────────────────────
  void _viewDocument(DocumentItem doc) {
    if (doc.file == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenImageViewer(doc: doc),
      ),
    );
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_allUploaded || _isSubmitting) return;

    final profilePhoto = _docs.firstWhere((d) => d.id == 'photo').file;
    final aadharCard = _docs.firstWhere((d) => d.id == 'aadhaar').file;
    final certificate = _docs.firstWhere((d) => d.id == 'certificate').file;

    if (profilePhoto == null || aadharCard == null || certificate == null) {
      _showUploadError('Please upload all required documents.');
      return;
    }

    setState(() => _isSubmitting = true);

    final result = await API.uploadAdminDocuments(
      profilePhoto: profilePhoto,
      aadharCard: aadharCard,
      certificate: certificate,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result is Map && result['status'] == 'success') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      return;
    }

    final msg = result is Map
        ? (result['message'] ?? 'Upload failed. Please try again.')
        : 'Something went wrong. Please try again.';
    _showUploadError(msg.toString());
  }

  void _showUploadError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontFamily: 'SFProText', fontSize: 13),
        ),
        backgroundColor: const Color(0xFFE24B4A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: _buildAppBar(),
      body: _isSubmitted ? _buildPendingView() : _buildUploadView(),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1A1A1A), size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Document Verification',
        style: TextStyle(
          color: Color(0xFF1A1A1A),
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFF0F0F0)),
      ),
    );
  }

  // ── Upload View ────────────────────────────────────────────────────────────
  Widget _buildUploadView() {
    return FadeTransition(
      opacity: _headerFade,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
                position: _headerSlide, child: _buildProgressHeader()),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoBanner(),
                  const SizedBox(height: 24),
                  const Text(
                    'Required Documents',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Upload all 3 documents to proceed',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 16),
                  ..._docs.map((doc) => _buildDocCard(doc)),
                  const SizedBox(height: 24),
                  _buildSubmitButton(),
                  const SizedBox(height: 16),
                  _buildFooterNote(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Progress Header ────────────────────────────────────────────────────────
  Widget _buildProgressHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_uploadedCount of ${_docs.length} documents uploaded',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _allUploaded
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFF4F6FB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _allUploaded ? '✅ Ready to submit' : 'In progress',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _allUploaded
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFF0F0F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                _allUploaded
                    ? const Color(0xFF16A34A)
                    : const Color(0xFF6366F1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Info Banner ────────────────────────────────────────────────────────────
  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: Color(0xFF2563EB), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tips for faster approval',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E40AF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• Ensure documents are clear & fully visible\n• Files must be JPG, PNG, or PDF\n• Max file size: 5 MB per document',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Doc Card ───────────────────────────────────────────────────────────────
  Widget _buildDocCard(DocumentItem doc) {
    final isUploaded = doc.status == DocStatus.uploaded ||
        doc.status == DocStatus.approved ||
        doc.status == DocStatus.rejected;
    final isUploading = doc.status == DocStatus.uploading;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isUploaded
              ? const Color(0xFF16A34A).withOpacity(0.3)
              : isUploading
                  ? const Color(0xFF6366F1).withOpacity(0.3)
                  : const Color(0xFFE5E7EB),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: isUploaded
                        ? const Color(0xFFECFDF5)
                        : doc.bgColor,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    isUploaded
                        ? Icons.check_circle_rounded
                        : doc.icon,
                    color: isUploaded ? const Color(0xFF16A34A) : doc.color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isUploaded
                            ? doc.fileName ?? 'File uploaded'
                            : doc.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isUploaded
                              ? const Color(0xFF16A34A)
                              : Colors.grey[500],
                          fontWeight: isUploaded
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildDocAction(doc, isUploaded, isUploading),
              ],
            ),
            if (isUploading) ...[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  minHeight: 4,
                  backgroundColor: Color(0xFFF0F0F0),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Uploading...',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDocAction(
      DocumentItem doc, bool isUploaded, bool isUploading) {
    if (isUploading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Color(0xFF6366F1),
        ),
      );
    }

    if (isUploaded) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // View icon
          GestureDetector(
            onTap: () => _viewDocument(doc),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.visibility_rounded,
                  size: 16, color: Color(0xFF2563EB)),
            ),
          ),
          const SizedBox(width: 6),
          // Delete icon
          GestureDetector(
            onTap: () => _removeDoc(doc),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  size: 16, color: Color(0xFFDC2626)),
            ),
          ),
          const SizedBox(width: 6),
          // Re-upload icon
          GestureDetector(
            onTap: () => _pickDocument(doc),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FB),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.refresh_rounded,
                  size: 16, color: Color(0xFF6B7280)),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => _pickDocument(doc),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: doc.bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.upload_rounded, size: 14, color: doc.color),
            const SizedBox(width: 5),
            Text(
              'Upload',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: doc.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Submit Button ──────────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ElevatedButton(
          onPressed: _allUploaded && !_isSubmitting ? _submit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _allUploaded
                ? const Color(0xFF16A34A)
                : const Color(0xFFE5E7EB),
            disabledBackgroundColor: const Color(0xFFE5E7EB),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _allUploaded
                          ? Icons.send_rounded
                          : Icons.lock_outline_rounded,
                      size: 18,
                      color: _allUploaded
                          ? Colors.white
                          : const Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _allUploaded
                          ? 'Submit for Verification'
                          : 'Upload all documents to continue',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _allUploaded
                            ? Colors.white
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFooterNote() {
    return Center(
      child: Text(
        '🔒  Your documents are encrypted & stored securely',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[400],
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // ── Pending / Submitted View ───────────────────────────────────────────────
  Widget _buildPendingView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Lottie-style static success icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF9800).withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Text('⏳', style: TextStyle(fontSize: 46)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Documents Submitted!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Our team is reviewing your documents.\nYou\'ll be notified once approved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),

            // Status Cards
            ..._docs.map((doc) => _buildStatusCard(doc)),

            const SizedBox(height: 24),

            // Timeline
            _buildApprovalTimeline(),

            const SizedBox(height: 28),

            // Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Approval usually takes 24–48 hours. You can close this screen — we\'ll notify you.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange[800],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Go Back to Home',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(DocumentItem doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: doc.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(doc.icon, color: doc.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  doc.fileName ?? 'Uploaded',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _statusBadge('Under Review'),
        ],
      ),
    );
  }

  Widget _statusBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF92400E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalTimeline() {
    final steps = [
      {'label': 'Documents Uploaded', 'done': true},
      {'label': 'Under Review', 'done': false},
      {'label': 'Verified & Approved', 'done': false},
      {'label': 'Dashboard Unlocked 🎉', 'done': false},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline_rounded, size: 16, color: Color(0xFF6B7280)),
              SizedBox(width: 6),
              Text(
                'Verification Progress',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isDone = step['done'] as bool;
            final isCurrent = i == 1;
            final isLast = i == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isDone
                              ? const Color(0xFF16A34A)
                              : isCurrent
                                  ? const Color(0xFFFFF7ED)
                                  : const Color(0xFFF4F6FB),
                          shape: BoxShape.circle,
                          border: isCurrent
                              ? Border.all(
                                  color: const Color(0xFFF59E0B), width: 2)
                              : null,
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(Icons.check_rounded,
                                  size: 14, color: Colors.white)
                              : isCurrent
                                  ? Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF59E0B),
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 28,
                          color: isDone
                              ? const Color(0xFF16A34A).withOpacity(0.3)
                              : const Color(0xFFF0F0F0),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: isLast ? 0 : 14, top: 3),
                  child: Text(
                    step['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isCurrent || isDone
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isDone
                          ? const Color(0xFF16A34A)
                          : isCurrent
                              ? const Color(0xFF92400E)
                              : Colors.grey[400],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ─── Full Screen Image Viewer ─────────────────────────────────────────────────

class _FullScreenImageViewer extends StatefulWidget {
  final DocumentItem doc;
  const _FullScreenImageViewer({required this.doc});

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  final TransformationController _ctrl = TransformationController();
  bool _isZoomed = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _ctrl.value = Matrix4.identity();
    setState(() => _isZoomed = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.doc.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_isZoomed)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: _resetZoom,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Reset zoom',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: GestureDetector(
        onDoubleTap: _isZoomed ? _resetZoom : null,
        child: Center(
          child: InteractiveViewer(
            transformationController: _ctrl,
            minScale: 0.8,
            maxScale: 5.0,
            clipBehavior: Clip.none,
            onInteractionEnd: (details) {
              final scale = _ctrl.value.getMaxScaleOnAxis();
              setState(() => _isZoomed = scale > 1.05);
            },
            child: Image.file(
              widget.doc.file!,
              fit: BoxFit.contain,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image_rounded,
                    color: Colors.white38, size: 64),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Picker Bottom Sheet ───────────────────────────────────────────────────────

class _PickerSheet extends StatelessWidget {
  final DocumentItem doc;
  const _PickerSheet({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: doc.bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(doc.icon, color: doc.color, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload ${doc.title}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    'Choose how to upload',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _sheetOption(
            context,
            icon: Icons.camera_alt_rounded,
            color: const Color(0xFF7C3AED),
            bg: const Color(0xFFF5F3FF),
            title: 'Take a Photo',
            subtitle: 'Open camera and capture now',
            value: 'camera',
          ),
          const SizedBox(height: 10),
          _sheetOption(
            context,
            icon: Icons.photo_library_rounded,
            color: const Color(0xFF0369A1),
            bg: const Color(0xFFE0F2FE),
            title: 'Choose from Gallery',
            subtitle: 'Pick from your photos',
            value: 'gallery',
          ),
          const SizedBox(height: 10),
          _sheetOption(
            context,
            icon: Icons.upload_file_rounded,
            color: const Color(0xFF854F0B),
            bg: const Color(0xFFFAEEDA),
            title: 'Upload from Files',
            subtitle: 'PDF, JPG, PNG — max 5 MB',
            value: 'file',
          ),
        ],
      ),
    );
  }

  Widget _sheetOption(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required Color bg,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.5, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: Color(0xFFD1D5DB)),
          ],
        ),
      ),
    );
  }
}
