import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytherapio_admin_app/backend/api.dart';
import 'package:mytherapio_admin_app/screens/profile/contact_us_screen.dart';
import 'package:mytherapio_admin_app/screens/profile/help_support_screen.dart';
import 'package:mytherapio_admin_app/screens/profile/privacy_policy_screen.dart';
import 'package:mytherapio_admin_app/screens/profile/subscription_plan_screen.dart';

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
// Admin Profile Screen
// ═══════════════════════════════════════════════════════════════
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Arjun Menon';
  String _email = 'arjun.menon@admin.com';
  String _phone = '+91 98765 43210';
  String _phoneNumber = '';
  String _countryCode = '';
  String _phoneCode = '';
  String _role = 'Super Admin';
  String _location = 'Kochi, Kerala';
  String _bio = 'Managing platform operations and professional onboarding.';
  String? _profilePhotoUrl;
  bool _isLoadingProfile = true;
  bool _isUploadingDocument = false;

  double _walletBalance = 12450.00;
  String _selectedPlan = 'free';

  final List<_DocumentItem> _documents = [
    _DocumentItem(
      name: 'Adhaar Card',
      type: 'PDF',
      size: '1.2 MB',
      uploadedOn: '12 Jan 2025',
      icon: Icons.verified_user_rounded,
      color: adminPrimary,
    ),
    _DocumentItem(
      name: 'Profile',
      type: 'PDF',
      size: '840 KB',
      uploadedOn: '3 Mar 2025',
      icon: Icons.description_rounded,
      color: const Color(0xFF7C3AED),
    ),
    _DocumentItem(
      name: 'Documents',
      type: 'DOCX',
      size: '560 KB',
      uploadedOn: '20 Apr 2025',
      icon: Icons.article_rounded,
      color: successGreen,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadAdminProfile();
  }

  Future<void> _loadAdminProfile() async {
    final result = await API.getAdminProfile();

    if (!mounted) return;

    if (result is Map && result['status'] == 'success') {
      final data = result['data'];
      if (data is Map) {
        setState(() {
          final profilePhoto = _stringValue(data['profile_photo']);
          _name = _stringValue(data['name'], fallback: _name);
          _email = _stringValue(data['email'], fallback: _email);
          _countryCode = _stringValue(data['country_code'], fallback: _countryCode);
          _phoneCode = _stringValue(data['phone_code'], fallback: _phoneCode);
          _phoneNumber = _stringValue(data['phone'], fallback: _phoneNumber);
          _phone = _formatPhone(data);
          _role = _stringValue(data['role'], fallback: 'Admin');
          _location = _stringValue(data['location'], fallback: _location);
          _bio = _stringValue(data['bio'], fallback: _bio);
          _profilePhotoUrl = profilePhoto.isEmpty ? null : profilePhoto;
          _walletBalance = _doubleValue(data['wallet_balance']);
          _selectedPlan =
              _stringValue(data['subscription_plan'], fallback: _selectedPlan)
                  .toLowerCase();
          _documents
            ..clear()
            ..addAll(_mapDocuments(data['documents']));
          _isLoadingProfile = false;
        });
      } else {
        setState(() => _isLoadingProfile = false);
      }
      return;
    }

    setState(() => _isLoadingProfile = false);
    final msg = result is Map
        ? (result['message'] ?? 'Unable to fetch profile.')
        : 'Unable to fetch profile.';
    _showSnack(context, msg.toString());
  }

  String _stringValue(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  double _doubleValue(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _formatPhone(Map data) {
    final phoneCode = _stringValue(data['phone_code']);
    final phone = _stringValue(data['phone'], fallback: _phone);
    return phoneCode.isEmpty ? phone : '$phoneCode $phone';
  }

  ({String firstName, String lastName}) _splitName(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return (firstName: '', lastName: '');
    if (parts.length == 1) return (firstName: parts.first, lastName: '');

    return (
      firstName: parts.first,
      lastName: parts.sublist(1).join(' '),
    );
  }

  Future<bool> _submitProfileUpdate({
    String? firstName,
    String? lastName,
    String? countryCode,
    String? phoneCode,
    String? phone,
    String? gmail,
    String? bio,
    String? roleTitle,
    String? locationName,
    required String successMessage,
  }) async {
    final response = await API.updateAdminProfile(
      firstName: firstName,
      lastName: lastName,
      countryCode: countryCode,
      phoneCode: phoneCode,
      phone: phone,
      gmail: gmail,
      bio: bio,
      roleTitle: roleTitle,
      locationName: locationName,
    );

    if (response is Map && response['status'] == 'success') {
      API.showSnackBar('Success', successMessage);
      return true;
    }

    final message = response is Map
        ? (response['message'] ?? 'Update failed')
        : 'Update failed';
    API.showSnackBar('Error', message.toString());
    return false;
  }

  List<_DocumentItem> _mapDocuments(dynamic docs) {
    if (docs is! List) return [];

    return docs.whereType<Map>().where((doc) {
      return _stringValue(doc['doc_type']) != 'profile_photo';
    }).map((doc) {
      final docType = _stringValue(doc['doc_type']);
      final fileName = _stringValue(doc['doc_file']);
      final name = _stringValue(
        doc['doc_name'],
        fallback: _documentName(docType, fileName),
      );
      final type = _documentExtension(fileName);

      return _DocumentItem(
        name: name,
        type: type,
        size: _stringValue(doc['doc_size_text'], fallback: '-'),
        uploadedOn: _formatCreatedAt(doc['created_at']),
        icon: _documentIcon(docType),
        color: _documentColor(docType),
      );
    }).toList();
  }

  String _documentName(String docType, String fileName) {
    switch (docType) {
      case 'profile_photo':
        return 'Profile Photo';
      case 'aadhar_card':
        return 'Aadhaar Card';
      case 'certificate':
        return 'Certificate';
      case 'profile':
        return 'Profile';
      default:
        return fileName.isNotEmpty ? fileName : 'Document';
    }
  }

  String _documentExtension(String fileName) {
    final parts = fileName.split('.');
    if (parts.length < 2) return 'FILE';
    return parts.last.toUpperCase();
  }

  String _formatCreatedAt(dynamic value) {
    if (value == null) return '-';
    final parsed = DateTime.tryParse(value.toString());
    if (parsed == null) return value.toString();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
  }

  String _formatBytes(int bytes) {
    const mb = 1024 * 1024;
    if (bytes >= mb) return '${(bytes / mb).toStringAsFixed(1)} MB';
    return '${(bytes / 1024).toStringAsFixed(0)} KB';
  }

  void _showFileSizeError({
    required int selectedBytes,
    required int maxBytes,
  }) {
    _showErrorSnack(
      'File is too large. Max ${_formatBytes(maxBytes)}, selected ${_formatBytes(selectedBytes)}.',
    );
  }

  Future<void> _pickAndUploadDocument({
    required String docType,
    required List<String> allowedExtensions,
    required int maxBytes,
  }) async {
    if (_isUploadingDocument) return;

    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        withData: false,
      );

      if (picked == null || picked.files.isEmpty) return;
      if (!mounted) return;

      final selected = picked.files.single;
      final path = selected.path;

      if (path == null || path.isEmpty) {
        _showErrorSnack('Could not read the selected file. Please try again.');
        return;
      }

      if (selected.size > maxBytes) {
        _showFileSizeError(
          selectedBytes: selected.size,
          maxBytes: maxBytes,
        );
        return;
      }

      final extension = selected.extension?.toLowerCase();
      if (extension == null || !allowedExtensions.contains(extension)) {
        _showErrorSnack(
          'Unsupported file type. Allowed: ${allowedExtensions.join(', ').toUpperCase()}.',
        );
        return;
      }

      setState(() => _isUploadingDocument = true);
      final result = await API.updateAdminDocument(
        documentFile: File(path),
        docType: docType,
      );

      if (!mounted) return;
      setState(() => _isUploadingDocument = false);

      if (result is Map && result['status'] == 'success') {
        _showSnack(context, 'Document uploaded successfully');
        await _loadAdminProfile();
        return;
      }

      final msg = result is Map
          ? (result['message'] ?? 'Document upload failed.')
          : 'Document upload failed.';
      _showErrorSnack(msg.toString());
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploadingDocument = false);
      _showErrorSnack('Unable to pick or upload file. ${e.toString()}');
    }
  }

  Future<void> _pickAndUploadProfilePhoto(ImageSource source) async {
    if (_isUploadingDocument) return;

    const maxBytes = 5 * 1024 * 1024;

    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
      );

      if (picked == null) return;
      if (!mounted) return;

      final file = File(picked.path);
      final size = await file.length();

      if (size > maxBytes) {
        _showFileSizeError(selectedBytes: size, maxBytes: maxBytes);
        return;
      }

      setState(() => _isUploadingDocument = true);
      final result = await API.updateAdminDocument(
        documentFile: file,
        docType: 'profile_photo',
      );

      if (!mounted) return;
      setState(() => _isUploadingDocument = false);

      if (result is Map && result['status'] == 'success') {
        _showSnack(context, 'Profile photo updated successfully');
        await _loadAdminProfile();
        return;
      }

      final msg = result is Map
          ? (result['message'] ?? 'Profile photo update failed.')
          : 'Profile photo update failed.';
      _showErrorSnack(msg.toString());
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploadingDocument = false);
      _showErrorSnack('Unable to update profile photo. ${e.toString()}');
    }
  }

  IconData _documentIcon(String docType) {
    switch (docType) {
      case 'profile_photo':
        return Icons.person_rounded;
      case 'aadhar_card':
        return Icons.verified_user_rounded;
      case 'certificate':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.description_rounded;
    }
  }

  Color _documentColor(String docType) {
    switch (docType) {
      case 'profile_photo':
        return const Color(0xFF7C3AED);
      case 'aadhar_card':
        return adminPrimary;
      case 'certificate':
        return successGreen;
      default:
        return textMid;
    }
  }

  String get _initials {
    final parts = _name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'A';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: pageBg,
      body: RefreshIndicator(
        onRefresh: _loadAdminProfile,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
          _buildSliverHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoadingProfile) ...[
                    const SizedBox(height: 12),
                    const LinearProgressIndicator(minHeight: 2),
                  ],
                  const SizedBox(height: 16),
                  _buildWalletCard(),
                  const SizedBox(height: 20),
                  _buildContactSection(),
                  const SizedBox(height: 20),
                  _buildDocumentsSection(),
                  const SizedBox(height: 20),
                  _buildSubscriptionSection(),
                  // const SizedBox(height: 20),
                  // _buildAccountSection(),
                  const SizedBox(height: 20),
                  _buildSupportSection(),
                  const SizedBox(height: 20),
                  _buildLogoutButton(context),
                  const SizedBox(height: 8),
                  Center(
                    child: Text('Version 2.4.1 · Admin Build',
                        style: TextStyle(
                            fontSize: 11,
                            color: textLight,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  // ── Sliver Header ───────────────────────────────────────────
  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
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
          child: Stack(
            children: [
              // Background decorative circles
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Avatar with edit button
                    Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                            image: _profilePhotoUrl == null
                                ? null
                                : DecorationImage(
                                    image: NetworkImage(_profilePhotoUrl!),
                                    fit: BoxFit.cover,
                                  ),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.4), width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: _profilePhotoUrl == null
                              ? Text(_initials,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white))
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _showAvatarOptions(context),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: adminAccent,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt_rounded,
                                  color: Colors.white, size: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(_name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.3)),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showEditProfileSheet(context),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.shield_rounded,
                                  size: 11, color: adminAccent),
                              const SizedBox(width: 4),
                              Text(_role,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded,
                                size: 12, color: Colors.white.withOpacity(0.6)),
                            const SizedBox(width: 3),
                            Text(_location,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.6))),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        _bio,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.55),
                            height: 1.4),
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

  // ── Wallet Card ─────────────────────────────────────────────
  Widget _buildWalletCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: adminPrimary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 60,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.account_balance_wallet_rounded,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text('Admin Wallet',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showWalletDetails(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: const Text('Details',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  '₹${_walletBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5),
                ),
                const SizedBox(height: 4),
                Text('Available Balance',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white.withOpacity(0.55))),
                const SizedBox(height: 18),
                Row(
                  children: [
                    // _walletAction(
                    //     Icons.add_rounded, 'Add Money', () {}),
                    const SizedBox(width: 10),
                    _walletAction(Icons.send_rounded, 'Withdraw', () {}),
                    const SizedBox(width: 10),
                    _walletAction(Icons.history_rounded, 'History', () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSubscriptionSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Container(
  //             width: 32,
  //             height: 32,
  //             decoration: BoxDecoration(
  //               color: const Color(0xFFEFF6FF),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: const Icon(Icons.workspace_premium_rounded,
  //                 color: adminPrimary, size: 17),
  //           ),
  //           const SizedBox(width: 10),
  //           const Text('Subscription Plan',
  //               style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w700,
  //                   color: textDark)),
  //         ],
  //       ),
  //       const SizedBox(height: 12),
  //       _buildPlanCard(
  //         id: 'free',
  //         name: 'Free',
  //         subtitle: 'Basic platform access',
  //         price: '₹0',
  //         period: 'forever',
  //         badge: 'Current plan',
  //         badgeColor: successGreen,
  //         features: [
  //           _PlanFeature('Up to 3 active cases', true),
  //           _PlanFeature('Basic client profiles', true),
  //           _PlanFeature('1 lawyer / consultant slot', true),
  //           _PlanFeature('Document vault', false),
  //           _PlanFeature('Hearing schedule & reminders', false),
  //           _PlanFeature('Revenue & commission reports', false),
  //         ],
  //       ),
  //       const SizedBox(height: 10),
  //       // _buildPlanCard(
  //       //   id: 'monthly',
  //       //   name: 'Monthly',
  //       //   subtitle: 'Billed every month, cancel anytime',
  //       //   price: '₹799',
  //       //   period: '/month',
  //       //   features: [
  //       //     _PlanFeature('Unlimited active cases', true),
  //       //     _PlanFeature('Full client & spouse profiles', true),
  //       //     _PlanFeature('Up to 10 lawyer / consultant slots', true),
  //       //     _PlanFeature('Document vault (5 GB)', true),
  //       //     _PlanFeature('Hearing schedule & reminders', true),
  //       //     _PlanFeature('Revenue & commission reports', false),
  //       //   ],
  //       // ),
  //       // const SizedBox(height: 10),
  //       // _buildPlanCard(
  //       //   id: 'yearly',
  //       //   name: 'Yearly',
  //       //   subtitle: 'Billed once a year',
  //       //   price: '₹6,399',
  //       //   period: '/year',
  //       //   originalPrice: '₹9,588',
  //       //   badge: 'Most popular',
  //       //   badgeColor: const Color(0xFF7C3AED),
  //       //   savingTag: 'Save 33%',
  //       //   features: [
  //       //     _PlanFeature('Unlimited active cases', true),
  //       //     _PlanFeature('Full client & spouse profiles', true),
  //       //     _PlanFeature('Unlimited lawyer / consultant slots', true),
  //       //     _PlanFeature('Document vault (50 GB)', true),
  //       //     _PlanFeature('Hearing schedule & reminders', true),
  //       //     _PlanFeature('Revenue & commission reports', true),
  //       //   ],
  //       // ),
  //       // if (_selectedPlan != 'free') ...[
  //       //   const SizedBox(height: 14),
  //       //   GestureDetector(
  //       //     onTap: () => _showSnack(context,
  //       //         'Redirecting to ${_selectedPlan == 'monthly' ? 'Monthly' : 'Yearly'} payment...'),
  //       //     child: Container(
  //       //       width: double.infinity,
  //       //       padding: const EdgeInsets.symmetric(vertical: 15),
  //       //       decoration: BoxDecoration(
  //       //         gradient: const LinearGradient(
  //       //           colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
  //       //         ),
  //       //         borderRadius: BorderRadius.circular(14),
  //       //         boxShadow: [
  //       //           BoxShadow(
  //       //               color: adminPrimary.withOpacity(0.3),
  //       //               blurRadius: 12,
  //       //               offset: const Offset(0, 4)),
  //       //         ],
  //       //       ),
  //       //       alignment: Alignment.center,
  //       //       child: Row(
  //       //         mainAxisSize: MainAxisSize.min,
  //       //         children: [
  //       //           const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
  //       //           const SizedBox(width: 8),
  //       //           Text(
  //       //             'Upgrade to ${_selectedPlan == 'monthly' ? 'Monthly' : 'Yearly'}',
  //       //             style: const TextStyle(
  //       //                 fontSize: 14,
  //       //                 fontWeight: FontWeight.w700,
  //       //                 color: Colors.white),
  //       //           ),
  //       //         ],
  //       //       ),
  //       //     ),
  //       //   ),
  //       // ],
  //     ],
  //   );
  // }


  Widget _buildSubscriptionSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.workspace_premium_rounded,
                color: adminPrimary, size: 17),
          ),
          const SizedBox(width: 10),
          const Text('Subscription Plan',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textDark)),
        ],
      ),
      const SizedBox(height: 12),
      // ── Current plan card (tappable → SubscriptionPlansScreen) ──
      GestureDetector(
        onTap: () async {
          final result = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (_) => SubscriptionPlansScreen(
                currentPlan: _selectedPlan,
              ),
            ),
          );
          // If user upgraded/changed plan, update state
          if (result != null) {
            setState(() => _selectedPlan = result);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _selectedPlan == 'yearly'
                  ? [const Color(0xFF1E3A8A), const Color(0xFF2563EB)]
                  : _selectedPlan == 'monthly'
                      ? [const Color(0xFF1E3A8A), const Color(0xFF2563EB)]
                      : [const Color(0xFF1E3A8A), const Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: adminPrimary.withOpacity(0.25),
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
                    Row(
                      children: [
                        Text(
                          _selectedPlan == 'free'
                              ? 'Free Plan'
                              : _selectedPlan == 'monthly'
                                  ? 'Monthly Plan'
                                  : 'Yearly Plan',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Active',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _selectedPlan == 'free'
                          ? 'Tap to upgrade & unlock features'
                          : _selectedPlan == 'monthly'
                              ? '₹799/month · Renews automatically'
                              : '₹6,399/year · Best value',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.75)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: 14),
              ),
            ],
          ),
        ),
      ),
      // ── Upgrade nudge (only for free plan) ──
      if (_selectedPlan == 'free') ...[
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final result = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (_) => SubscriptionPlansScreen(
                  currentPlan: _selectedPlan,
                ),
              ),
            );
            if (result != null) {
              setState(() => _selectedPlan = result);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: adminPrimary.withOpacity(0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.bolt_rounded,
                    color: adminPrimary, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Upgrade to Monthly or Yearly to unlock all features',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: adminPrimary),
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: adminPrimary, size: 18),
              ],
            ),
          ),
        ),
      ],
    ],
  );
}

  Widget _buildPlanCard({
    required String id,
    required String name,
    required String subtitle,
    required String price,
    required String period,
    String? originalPrice,
    String? badge,
    Color? badgeColor,
    String? savingTag,
    required List<_PlanFeature> features,
  }) {
    final isSelected = _selectedPlan == id;
    final isYearly = id == 'yearly';
    final activeColor = isYearly ? const Color(0xFF7C3AED) : adminPrimary;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: (badgeColor ?? adminPrimary).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(badge,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badgeColor ?? adminPrimary)),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radio
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? activeColor : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                    color: isSelected ? activeColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.circle, color: Colors.white, size: 8)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: textDark)),
                          if (savingTag != null) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(savingTag,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF78350F))),
                            ),
                          ],
                        ],
                      ),
                      Text(subtitle,
                          style:
                              const TextStyle(fontSize: 11, color: textLight)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(price,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: textDark)),
                    Text(period,
                        style: const TextStyle(fontSize: 10, color: textLight)),
                    if (originalPrice != null)
                      Text(originalPrice,
                          style: const TextStyle(
                              fontSize: 11,
                              color: textLight,
                              decoration: TextDecoration.lineThrough)),
                  ],
                ),
              ],
            ),
            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent,
                  Color(0xFFE2E8F0),
                  Colors.transparent
                ]),
              ),
            ),
            // Features
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        f.enabled
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 15,
                        color: f.enabled ? successGreen : textLight,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(f.label,
                            style: TextStyle(
                                fontSize: 12,
                                color: f.enabled ? textDark : textLight)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _walletAction(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Contact Section ─────────────────────────────────────────
  Widget _buildContactSection() {
    return _SectionCard(
      title: 'Contact Info',
      icon: Icons.contact_page_rounded,
      iconColor: adminPrimary,
      children: [
        _ContactTile(
          icon: Icons.phone_rounded,
          label: 'Phone Number',
          value: _phone,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: adminPrimary,
          onEdit: () => _showEditFieldSheet(
            context,
            title: 'Edit Phone Number',
            label: 'Phone',
            currentValue: _phoneNumber.isNotEmpty ? _phoneNumber : _phone,
            keyboardType: TextInputType.phone,
            onSave: (val) async {
              final success = await _submitProfileUpdate(
                countryCode: _countryCode.isEmpty ? null : _countryCode,
                phoneCode: _phoneCode.isEmpty ? null : _phoneCode,
                phone: val,
                successMessage: 'Contact updated successfully',
              );
              if (!success || !mounted) return false;
              setState(() {
                _phoneNumber = val;
                _phone = _phoneCode.isEmpty ? val : '$_phoneCode $val';
              });
              return true;
            },
          ),
        ),
        const _Divider(),
        _ContactTile(
          icon: Icons.email_rounded,
          label: 'Email Address',
          value: _email,
          iconBg: const Color(0xFFF0FDF4),
          iconColor: successGreen,
          onEdit: () => _showEditFieldSheet(
            context,
            title: 'Edit Email Address',
            label: 'Email',
            currentValue: _email,
            keyboardType: TextInputType.emailAddress,
            onSave: (val) async {
              final success = await _submitProfileUpdate(
                gmail: val,
                successMessage: 'Contact updated successfully',
              );
              if (!success || !mounted) return false;
              setState(() => _email = val);
              return true;
            },
          ),
        ),
        const _Divider(),
        _ContactTile(
          icon: Icons.location_on_rounded,
          label: 'Location',
          value: _location,
          iconBg: const Color(0xFFFFF7ED),
          iconColor: warningAmber,
          onEdit: () => _showEditFieldSheet(
            context,
            title: 'Edit Location',
            label: 'Location',
            currentValue: _location,
            keyboardType: TextInputType.text,
            onSave: (val) async {
              final success = await _submitProfileUpdate(
                locationName: val,
                successMessage: 'Profile updated successfully',
              );
              if (!success || !mounted) return false;
              setState(() => _location = val);
              return true;
            },
          ),
        ),
      ],
    );
  }

  // ── Documents Section ───────────────────────────────────────
  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.folder_rounded,
                  color: Color(0xFF7C3AED), size: 17),
            ),
            const SizedBox(width: 10),
            const Text('Documents & Certificates',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textDark)),
            const Spacer(),
            GestureDetector(
              onTap: () => _showUploadOptions(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.upload_rounded, size: 13, color: adminPrimary),
                    SizedBox(width: 4),
                    Text('Upload',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: adminPrimary)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: _documents.isEmpty
                ? [
                    const Padding(
                      padding: EdgeInsets.all(18),
                      child: Text(
                        'No documents uploaded yet',
                        style: TextStyle(
                          fontSize: 12,
                          color: textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ]
                : _documents.asMap().entries.map((entry) {
                    final i = entry.key;
                    final doc = entry.value;
                    return Column(
                      children: [
                        _DocumentTile(
                          doc: doc,
                          onDelete: () => _confirmDeleteDocument(context, i),
                          onReplace: () =>
                              _showUploadOptions(context, replacing: doc.name),
                        ),
                        if (i < _documents.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: _Divider(),
                          ),
                      ],
                    );
                  }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Support Section ─────────────────────────────────────────
  Widget _buildSupportSection() {
    return _SectionCard(
      title: 'Accounts',
      icon: Icons.manage_accounts_rounded,
      iconColor: successGreen,
      children: [
        // _SettingsTile(
        //   icon: Icons.help_outline_rounded,
        //   label: 'Help & Support',
        //   iconBg: const Color(0xFFF0FDF4),
        //   iconColor: successGreen,
        //   onTap: () => _showSnack(context, 'Help & Support tapped'),
        // ),

        _SettingsTile(
          icon: Icons.help_outline_rounded,
          label: 'Help & Support',
          iconBg: const Color(0xFFF0FDF4),
          iconColor: successGreen,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HelpSupportScreen(),
              ),
            );
          },
        ),
        const _Divider(),
        // _SettingsTile(
        //   icon: Icons.headset_mic_rounded,
        //   label: 'Contact Us',
        //   iconBg: const Color(0xFFEFF6FF),
        //   iconColor: adminPrimary,
        //   onTap: () => _showContactUsSheet(context),
        // ),

        _SettingsTile(
          icon: Icons.headset_mic_rounded,
          label: 'Contact Us',
          iconBg: const Color(0xFFEFF6FF),
          iconColor: adminPrimary,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ContactUsScreen()),
          ),
        ),
        const _Divider(),
        _SettingsTile(
            icon: Icons.shield_rounded,
            label: 'Privacy Policy',
            iconBg: const Color(0xFFEFF6FF),
            iconColor: adminPrimary,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()))),

        // _SettingsTile(
        //   icon: Icons.star_rate_rounded,
        //   label: 'Rate the App',
        //   iconBg: const Color(0xFFFFFBEB),
        //   iconColor: warningAmber,
        //   onTap: () => _showSnack(context, 'Rate the App tapped'),
        // ),
        // const _Divider(),
        // _SettingsTile(
        //   icon: Icons.info_outline_rounded,
        //   label: 'About',
        //   iconBg: const Color(0xFFF8FAFC),
        //   iconColor: textMid,
        //   trailing: Text('v2.4.1',
        //       style: TextStyle(fontSize: 11, color: textLight)),
        //   onTap: () => _showSnack(context, 'About tapped'),
        // ),
      ],
    );
  }

  // ── Logout Button ───────────────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirmLogout(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: dangerRed.withOpacity(0.2)),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.logout_rounded, color: dangerRed, size: 18),
            SizedBox(width: 8),
            Text('Logout',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: dangerRed)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // Bottom Sheets & Dialogs
  // ═══════════════════════════════════════════════════════════

  void _showEditProfileSheet(BuildContext context) {
    final nameCtrl = TextEditingController(text: _name);
    final bioCtrl = TextEditingController(text: _bio);
    final roleCtrl = TextEditingController(text: _role);
    final locationCtrl = TextEditingController(text: _location);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheetWrapper(
        title: 'Edit Profile',
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetTextField(controller: nameCtrl, label: 'Full Name'),
              const SizedBox(height: 12),
              _SheetTextField(
                  controller: roleCtrl, label: 'Role / Designation'),
              const SizedBox(height: 12),
              _SheetTextField(controller: locationCtrl, label: 'Location'),
              const SizedBox(height: 12),
              _SheetTextField(controller: bioCtrl, label: 'Bio', maxLines: 3),
              const SizedBox(height: 20),
              _SheetSaveButton(
                onTap: () async {
                  final nextName = nameCtrl.text.trim().isNotEmpty
                      ? nameCtrl.text.trim()
                      : _name;
                  final nameParts = _splitName(nextName);
                  final nextBio = bioCtrl.text.trim().isNotEmpty
                      ? bioCtrl.text.trim()
                      : _bio;
                  final nextRole = roleCtrl.text.trim().isNotEmpty
                      ? roleCtrl.text.trim()
                      : _role;
                  final nextLocation = locationCtrl.text.trim().isNotEmpty
                      ? locationCtrl.text.trim()
                      : _location;

                  final success = await _submitProfileUpdate(
                    firstName: nameParts.firstName,
                    lastName: nameParts.lastName,
                    roleTitle: nextRole,
                    bio: nextBio,
                    locationName: nextLocation,
                    successMessage: 'Profile updated successfully',
                  );

                  if (!success || !mounted) return;

                  setState(() {
                    _name = nextName;
                    _bio = nextBio;
                    _role = nextRole;
                    _location = nextLocation;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditFieldSheet(
    BuildContext context, {
    required String title,
    required String label,
    required String currentValue,
    required TextInputType keyboardType,
    required Future<bool> Function(String value) onSave,
  }) {
    final ctrl = TextEditingController(text: currentValue);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheetWrapper(
        title: title,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetTextField(
                  controller: ctrl, label: label, keyboardType: keyboardType),
              const SizedBox(height: 20),
              _SheetSaveButton(
                onTap: () async {
                  var success = true;
                  if (ctrl.text.trim().isNotEmpty) {
                    success = await onSave(ctrl.text.trim());
                  }
                  if (!success || !context.mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadOptions(BuildContext context, {String? replacing}) {
    const fiveMb = 5 * 1024 * 1024;
    const tenMb = 10 * 1024 * 1024;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheetWrapper(
        title: replacing != null ? 'Replace Document' : 'Upload Document',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isUploadingDocument)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            if (replacing != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: warningAmber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 14, color: warningAmber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Replacing: $replacing',
                          style: TextStyle(
                              fontSize: 11,
                              color: warningAmber,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            _UploadOption(
              icon: Icons.picture_as_pdf_rounded,
              label: 'Aadhaar Card',
              subtitle: 'PDF, JPG, PNG - max 10 MB',
              color: dangerRed,
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadDocument(
                  docType: 'aadhar_card',
                  allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
                  maxBytes: tenMb,
                );
              },
            ),
            const SizedBox(height: 10),
            _UploadOption(
              icon: Icons.image_rounded,
              label: 'Profile',
              subtitle: 'JPG, PNG - max 5 MB',
              color: successGreen,
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadDocument(
                  docType: 'profile',
                  allowedExtensions: const ['jpg', 'jpeg', 'png'],
                  maxBytes: fiveMb,
                );
              },
            ),
            const SizedBox(height: 10),
            _UploadOption(
              icon: Icons.folder_open_rounded,
              label: 'Certificate / Documents',
              subtitle: 'PDF, JPG, PNG, DOC, DOCX - max 10 MB',
              color: adminPrimary,
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadDocument(
                  docType: 'certificate',
                  allowedExtensions: const [
                    'pdf',
                    'jpg',
                    'jpeg',
                    'png',
                    'doc',
                    'docx',
                  ],
                  maxBytes: tenMb,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteDocument(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Document?',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: textDark)),
        content: Text(
          'Are you sure you want to delete "${_documents[index].name}"? This cannot be undone.',
          style: const TextStyle(fontSize: 12, color: textMid, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: textMid, fontWeight: FontWeight.w600)),
          ),
          GestureDetector(
            onTap: () {
              setState(() => _documents.removeAt(index));
              Navigator.pop(ctx);
              _showSnack(context, 'Document deleted');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: dangerRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Delete',
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

  void _showAvatarOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheetWrapper(
        title: 'Change Profile Photo',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UploadOption(
              icon: Icons.camera_alt_rounded,
              label: 'Take a Photo',
              subtitle: 'Open camera',
              color: adminPrimary,
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadProfilePhoto(ImageSource.camera);
              },
            ),
            const SizedBox(height: 10),
            _UploadOption(
              icon: Icons.photo_library_rounded,
              label: 'Choose from Gallery',
              subtitle: 'Select from your photos',
              color: const Color(0xFF7C3AED),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadProfilePhoto(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showWalletDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheetWrapper(
        title: 'Wallet Details',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_rounded,
                      color: Colors.white, size: 22),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Available Balance',
                          style:
                              TextStyle(fontSize: 11, color: Colors.white70)),
                      Text('₹${_walletBalance.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _transactionTile('Service Charge', '+₹3,200', '28 May', true),
            const _Divider(),
            _transactionTile('Withdrawal', '-₹5,000', '20 May', false),
            const _Divider(),
            _transactionTile('Referral Bonus', '+₹750', '15 May', true),
            const _Divider(),
            _transactionTile('Withdrawal', '-₹2,000', '10 May', false),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _transactionTile(
      String title, String amount, String date, bool isCredit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color:
                  isCredit ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCredit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: isCredit ? successGreen : dangerRed,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textDark)),
                Text(date,
                    style: const TextStyle(fontSize: 11, color: textLight)),
              ],
            ),
          ),
          Text(amount,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isCredit ? successGreen : dangerRed)),
        ],
      ),
    );
  }

  void _showContactUsSheet(BuildContext context) {
    final msgCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheetWrapper(
        title: 'Contact Us',
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact methods
              Row(
                children: [
                  _contactMethod(
                      Icons.email_rounded,
                      'Email',
                      'support@platform.com',
                      const Color(0xFFF0FDF4),
                      successGreen),
                  const SizedBox(width: 10),
                  _contactMethod(Icons.phone_rounded, 'Call', '+91 80001 00002',
                      const Color(0xFFEFF6FF), adminPrimary),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Send a Message',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textDark)),
              const SizedBox(height: 10),
              _SheetTextField(
                  controller: msgCtrl,
                  label: 'Describe your issue...',
                  maxLines: 4),
              const SizedBox(height: 16),
              _SheetSaveButton(
                label: 'Send Message',
                icon: Icons.send_rounded,
                onTap: () {
                  Navigator.pop(context);
                  _showSnack(context, 'Message sent!');
                },
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactMethod(
      IconData icon, String label, String value, Color bg, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 10, color: color, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 10, color: textMid, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout?',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w800, color: textDark)),
        content: const Text(
          'Are you sure you want to log out of your admin account?',
          style: TextStyle(fontSize: 12, color: textMid, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: textMid, fontWeight: FontWeight.w600)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
              _showSnack(context, 'Logged out');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: dangerRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Logout',
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

  void _showErrorSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        backgroundColor: dangerRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Reusable Widgets
// ═══════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 10),
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textDark)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onEdit;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconBg,
    required this.iconColor,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: textLight,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textDark)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.edit_rounded, size: 12, color: adminPrimary),
                  SizedBox(width: 4),
                  Text('Edit',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: adminPrimary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textDark)),
            ),
            trailing ??
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 13, color: textLight),
          ],
        ),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  final _DocumentItem doc;
  final VoidCallback onDelete;
  final VoidCallback onReplace;

  const _DocumentTile({
    required this.doc,
    required this.onDelete,
    required this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: doc.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(doc.icon, color: doc.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textDark)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: doc.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(doc.type,
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: doc.color)),
                    ),
                    const SizedBox(width: 6),
                    Text('${doc.size} · ${doc.uploadedOn}',
                        style: const TextStyle(fontSize: 10, color: textLight)),
                  ],
                ),
              ],
            ),
          ),
          // Actions
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'replace') onReplace();
              if (val == 'delete') onDelete();
            },
            icon:
                const Icon(Icons.more_vert_rounded, size: 18, color: textLight),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'replace',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz_rounded,
                        size: 16, color: adminPrimary),
                    SizedBox(width: 8),
                    Text('Replace',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded,
                        size: 16, color: dangerRed),
                    SizedBox(width: 8),
                    Text('Delete',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: dangerRed)),
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

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Color(0xFFE2E8F0), Colors.transparent],
        ),
      ),
    );
  }
}

// ── Bottom Sheet Wrapper ───────────────────────────────────────
class _BottomSheetWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const _BottomSheetWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 18),
          Text(title,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w800, color: textDark)),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

// ── Sheet Text Field ──────────────────────────────────────────
class _SheetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;

  const _SheetTextField({
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: textDark),
      decoration: InputDecoration(
        labelText: label,
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
}

// ── Sheet Save Button ─────────────────────────────────────────
class _SheetSaveButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;

  const _SheetSaveButton({
    required this.onTap,
    this.label = 'Save Changes',
    this.icon = Icons.check_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
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
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// ── Upload Option Tile ────────────────────────────────────────
class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _UploadOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textDark)),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 11, color: textLight)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: color.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

// ── Document Item Model ───────────────────────────────────────
class _DocumentItem {
  final String name;
  final String type;
  final String size;
  final String uploadedOn;
  final IconData icon;
  final Color color;

  const _DocumentItem({
    required this.name,
    required this.type,
    required this.size,
    required this.uploadedOn,
    required this.icon,
    required this.color,
  });
}

class _PlanFeature {
  final String label;
  final bool enabled;
  const _PlanFeature(this.label, this.enabled);
}
