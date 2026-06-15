import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color adminPrimary = Color(0xFF1B4FD8);

// ═══════════════════════════════════════════════════════════════
// Data Model
// ═══════════════════════════════════════════════════════════════

enum MeetingStatus { upcoming, completed }

class Meeting {
  final String id;
  final String initials;
  final String professionalName;
  final String specialty;
  final String clientName;
  final String time;
  final String date;
  final Color avatarBg;
  final Color avatarText;
  MeetingStatus status;

  Meeting({
    required this.id,
    required this.initials,
    required this.professionalName,
    required this.specialty,
    required this.clientName,
    required this.time,
    required this.date,
    required this.avatarBg,
    required this.avatarText,
    this.status = MeetingStatus.upcoming,
  });
}

// ═══════════════════════════════════════════════════════════════
// Meetings Screen
// ═══════════════════════════════════════════════════════════════

class MeetingsScreen extends StatefulWidget {
  const MeetingsScreen({Key? key}) : super(key: key);

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mutable list so we can move upcoming → completed
  final List<Meeting> _meetings = [
    Meeting(
      id: '1',
      initials: 'AN',
      professionalName: 'Dr. Anjali N.',
      specialty: 'Clinical Psychology',
      clientName: 'Arjun R.',
      time: '3:00 PM',
      date: 'Today',
      avatarBg: const Color(0xFFE6F1FB),
      avatarText: const Color(0xFF185FA5),
    ),
    Meeting(
      id: '2',
      initials: 'VR',
      professionalName: 'Adv. V. Rajan',
      specialty: 'Property Law',
      clientName: 'Meena S.',
      time: '5:00 PM',
      date: 'Today',
      avatarBg: const Color(0xFFEEEDFE),
      avatarText: const Color(0xFF534AB7),
    ),
    Meeting(
      id: '3',
      initials: 'RK',
      professionalName: 'Rahul Kumar',
      specialty: 'CBT Therapy',
      clientName: 'Prathik V.',
      time: '10:30 AM',
      date: 'Tomorrow',
      avatarBg: const Color(0xFFEAF3DE),
      avatarText: const Color(0xFF3B6D11),
    ),
    Meeting(
      id: '4',
      initials: 'MF',
      professionalName: 'Meera Fathima',
      specialty: 'Family & Divorce',
      clientName: 'Reena P.',
      time: '2:00 PM',
      date: '14 Jun',
      avatarBg: const Color(0xFFFAEEDA),
      avatarText: const Color(0xFF854F0B),
    ),
    Meeting(
      id: '5',
      initials: 'SJ',
      professionalName: 'Sanjay J.',
      specialty: 'Stress & Anxiety',
      clientName: 'Kiran M.',
      time: '4:00 PM',
      date: '15 Jun',
      avatarBg: const Color(0xFFEEEDFE),
      avatarText: const Color(0xFF534AB7),
    ),
    // Pre-existing completed
    Meeting(
      id: '6',
      initials: 'AN',
      professionalName: 'Dr. Anjali N.',
      specialty: 'Clinical Psych',
      clientName: 'Arjun R.',
      time: '11:00 AM',
      date: '9 May',
      avatarBg: const Color(0xFFE6F1FB),
      avatarText: const Color(0xFF185FA5),
      status: MeetingStatus.completed,
    ),
    Meeting(
      id: '7',
      initials: 'VR',
      professionalName: 'Adv. V. Rajan',
      specialty: 'Property Law',
      clientName: 'Bindu S.',
      time: '3:30 PM',
      date: '8 May',
      avatarBg: const Color(0xFFEEEDFE),
      avatarText: const Color(0xFF534AB7),
      status: MeetingStatus.completed,
    ),
    Meeting(
      id: '8',
      initials: 'RK',
      professionalName: 'Rahul Kumar',
      specialty: 'CBT Therapy',
      clientName: 'Sanjay P.',
      time: '5:00 PM',
      date: '7 May',
      avatarBg: const Color(0xFFEAF3DE),
      avatarText: const Color(0xFF3B6D11),
      status: MeetingStatus.completed,
    ),
  ];

  List<Meeting> get _upcoming =>
      _meetings.where((m) => m.status == MeetingStatus.upcoming).toList();
  List<Meeting> get _allMeetings => _meetings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  
  void _markAsCompleted(String meetingId) {
    setState(() {
      final m = _meetings.firstWhere((m) => m.id == meetingId);
      m.status = MeetingStatus.completed;
    });
    
    _tabController.animateTo(1);
  }

  void _showJoinCallPopup(BuildContext context, Meeting meeting) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
     

      builder: (_) => _JoinCallSheet(
  meeting: meeting,
  onAudioCall: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AudioCallScreen(
          meeting: meeting,
          onCallEnded: () => _markAsCompleted(meeting.id),
        ),
      ),
    );
  },
  onVideoCall: () {
    Navigator.pop(context);

    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          meeting: meeting,
          onCallEnded: () => _markAsCompleted(meeting.id),
        ),
      ),
    );
  },
),
    );
  }

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
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUpcomingTab(),
                _buildAllMeetingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────
  Widget _buildHeader() {
    final upcomingCount = _upcoming.length;
    final completedCount =
        _meetings.where((m) => m.status == MeetingStatus.completed).length;

    return Container(
      color: adminPrimary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Meetings',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.4)),
              const SizedBox(height: 14),
              Row(
                children: [
                  _headerStatChip(
                    '$upcomingCount',
                    'Upcoming',
                    Icons.schedule_rounded,
                    Colors.white.withOpacity(0.18),
                  ),
                  const SizedBox(width: 10),
                  _headerStatChip(
                    '$completedCount',
                    'Completed',
                    Icons.check_circle_outline_rounded,
                    Colors.white.withOpacity(0.18),
                  ),
                  const SizedBox(width: 10),
                  _headerStatChip(
                    '${_meetings.length}',
                    'Total',
                    Icons.calendar_today_rounded,
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            Text(label,
                style: TextStyle(
                    fontSize: 10, color: Colors.white.withOpacity(0.65))),
          ],
        ),
      ),
    );
  }

  // ── Custom Tab Bar ─────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: adminPrimary,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF6B7280),
        labelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'All Meetings'),
        ],
      ),
    );
  }

  // ── Upcoming Tab ───────────────────────────────────────────────
  Widget _buildUpcomingTab() {
    final list = _upcoming;
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.calendar_today_rounded,
                  color: adminPrimary, size: 30),
            ),
            const SizedBox(height: 14),
            const Text('No upcoming meetings',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151))),
            const SizedBox(height: 4),
            const Text('All done for now!',
                style:
                    TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
      itemCount: list.length,
      itemBuilder: (_, i) => _UpcomingMeetingCard(
        meeting: list[i],
        onJoinCall: () => _showJoinCallPopup(context, list[i]),
      ),
    );
  }

  // ── All Meetings Tab ───────────────────────────────────────────
  Widget _buildAllMeetingsTab() {
    final upcoming = _meetings
        .where((m) => m.status == MeetingStatus.upcoming)
        .toList();
    final completed = _meetings
        .where((m) => m.status == MeetingStatus.completed)
        .toList();

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
      children: [
        if (upcoming.isNotEmpty) ...[
          _sectionLabel('Upcoming', upcoming.length, const Color(0xFF1B4FD8),
              const Color(0xFFEEF2FF)),
          const SizedBox(height: 10),
          ...upcoming.map((m) => _AllMeetingCard(meeting: m)),
          const SizedBox(height: 20),
        ],
        if (completed.isNotEmpty) ...[
          _sectionLabel('Completed', completed.length,
              const Color(0xFF1D9E75), const Color(0xFFE1F5EE)),
          const SizedBox(height: 10),
          ...completed.map((m) => _AllMeetingCard(meeting: m)),
        ],
      ],
    );
  }

  Widget _sectionLabel(
      String label, int count, Color textColor, Color bg) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827))),
        const SizedBox(width: 8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
              color: bg, borderRadius: BorderRadius.circular(20)),
          child: Text('$count',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textColor)),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Upcoming Meeting Card
// ═══════════════════════════════════════════════════════════════

class _UpcomingMeetingCard extends StatelessWidget {
  final Meeting meeting;
  final VoidCallback onJoinCall;

  const _UpcomingMeetingCard({
    required this.meeting,
    required this.onJoinCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Top section
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: meeting.avatarBg),
                  alignment: Alignment.center,
                  child: Text(meeting.initials,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: meeting.avatarText)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(meeting.professionalName,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827))),
                      const SizedBox(height: 2),
                      Text(meeting.specialty,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
                // Date badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(meeting.date,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: adminPrimary)),
                      Text(meeting.time,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: adminPrimary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          // Client info + Join button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.person_outline_rounded,
                    size: 14, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 5),
                Text('Client: ',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9CA3AF))),
                Text(meeting.clientName,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151))),
                const Spacer(),
                GestureDetector(
                  onTap: onJoinCall,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: adminPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.call_rounded,
                            color: Colors.white, size: 14),
                        SizedBox(width: 6),
                        Text('Join Call',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// All Meetings Card
// ═══════════════════════════════════════════════════════════════

class _AllMeetingCard extends StatelessWidget {
  final Meeting meeting;
  const _AllMeetingCard({required this.meeting});

  @override
  Widget build(BuildContext context) {
    final isCompleted = meeting.status == MeetingStatus.completed;
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
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: meeting.avatarBg),
            alignment: Alignment.center,
            child: Text(meeting.initials,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: meeting.avatarText)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meeting.professionalName,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text('${meeting.specialty} · ${meeting.clientName}',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFFE1F5EE)
                      : const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isCompleted ? 'Done' : 'Upcoming',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isCompleted
                          ? const Color(0xFF1D9E75)
                          : adminPrimary),
                ),
              ),
              const SizedBox(height: 4),
              Text('${meeting.date} · ${meeting.time}',
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF9CA3AF))),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Join Call Bottom Sheet
// ═══════════════════════════════════════════════════════════════

class _JoinCallSheet extends StatefulWidget {
  final Meeting meeting;
  final VoidCallback onAudioCall;
  final VoidCallback onVideoCall;

  const _JoinCallSheet({
    required this.meeting,
    required this.onAudioCall,
    required this.onVideoCall,
  });

  @override
  State<_JoinCallSheet> createState() => _JoinCallSheetState();
}

class _JoinCallSheetState extends State<_JoinCallSheet> {
  // null = nothing selected, 'audio' or 'video'
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final audioSelected = _selected == 'audio';
    final videoSelected = _selected == 'video';
    final audioDisabled = videoSelected;
    final videoDisabled = audioSelected;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          // Meeting info
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: widget.meeting.avatarBg),
            alignment: Alignment.center,
            child: Text(widget.meeting.initials,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: widget.meeting.avatarText)),
          ),
          const SizedBox(height: 10),
          Text(widget.meeting.professionalName,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827))),
          const SizedBox(height: 2),
          Text('${widget.meeting.specialty} · ${widget.meeting.clientName}',
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF6B7280))),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.schedule_rounded,
                  size: 13, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 4),
              Text('${widget.meeting.date} at ${widget.meeting.time}',
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF9CA3AF))),
            ],
          ),
          const SizedBox(height: 28),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Choose call type',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151))),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // ── Audio Call ──────────────────────────────────
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: audioDisabled ? 0.35 : 1.0,
                  child: GestureDetector(
                    onTap: audioDisabled
                        ? null
                        : () => setState(() {
                              _selected =
                                  _selected == 'audio' ? null : 'audio';
                            }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: audioSelected
                            ? adminPrimary
                            : const Color(0xFFF4F6FB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: audioSelected
                              ? adminPrimary
                              : const Color(0xFFE5E7EB),
                          width: audioSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.call_rounded,
                            color: audioSelected
                                ? Colors.white
                                : const Color(0xFF374151),
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Audio Call',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: audioSelected
                                    ? Colors.white
                                    : const Color(0xFF374151)),
                          ),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: audioSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : const Color(0xFFE1F5EE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              audioSelected ? 'Selected ✓' : 'Available',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: audioSelected
                                      ? Colors.white
                                      : const Color(0xFF1D9E75)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // ── Video Call ──────────────────────────────────
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: videoDisabled ? 0.35 : 1.0,
                  child: GestureDetector(
                    onTap: videoDisabled
                        ? null
                        : () => setState(() {
                              _selected =
                                  _selected == 'video' ? null : 'video';
                            }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: videoSelected
                            ? const Color(0xFF0F1E6B)
                            : const Color(0xFFF4F6FB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: videoSelected
                              ? const Color(0xFF0F1E6B)
                              : const Color(0xFFE5E7EB),
                          width: videoSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.videocam_rounded,
                            color: videoSelected
                                ? Colors.white
                                : const Color(0xFF374151),
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Video Call',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: videoSelected
                                    ? Colors.white
                                    : const Color(0xFF374151)),
                          ),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: videoSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : const Color(0xFFE1F5EE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              videoSelected ? 'Selected ✓' : 'Available',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: videoSelected
                                      ? Colors.white
                                      : const Color(0xFF1D9E75)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // ── Start Call button — active only when something selected ──
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _selected != null ? 1.0 : 0.4,
            child: GestureDetector(
              onTap: _selected == null
                  ? null
                  : () {
                      if (_selected == 'audio') {
                        widget.onAudioCall();
                      } else {
                        widget.onVideoCall();
                      }
                    },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _selected != null
                      ? adminPrimary
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _selected == 'video'
                          ? Icons.videocam_rounded
                          : Icons.call_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selected == null
                          ? 'Select a call type'
                          : 'Start ${_selected == 'audio' ? 'Audio' : 'Video'} Call',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FB),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text('Cancel',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280))),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Audio Call Screen
// ═══════════════════════════════════════════════════════════════

class AudioCallScreen extends StatefulWidget {
  final Meeting meeting;
  final VoidCallback onCallEnded;

  const AudioCallScreen({
    Key? key,
    required this.meeting,
    required this.onCallEnded,
  }) : super(key: key);

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _seconds = 0;
  bool _muted = false;
  bool _speakerOn = false;
  bool _showEndConfirm = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05)
        .animate(CurvedAnimation(
            parent: _pulseController, curve: Curves.easeInOut));

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF0F2A80),
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onEndCall() {
    setState(() => _showEndConfirm = true);
  }

  void _confirmEnd() {
    _timer?.cancel();
    widget.onCallEnded();
    Navigator.pop(context);
    // Show "Meeting Over" snackbar back in parent
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1E6B),
      body: Stack(
        children: [
          // Background circles
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF4ADE80)),
                            ),
                            const SizedBox(width: 5),
                            const Text('On Call',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Avatar with pulse
                ScaleTransition(
                  scale: _pulseAnim,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.meeting.avatarBg,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.15),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(widget.meeting.initials,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: widget.meeting.avatarText)),
                  ),
                ),

                const SizedBox(height: 20),

                Text(widget.meeting.professionalName,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3)),
                const SizedBox(height: 4),
                Text(widget.meeting.specialty,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.6))),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_outline_rounded,
                        size: 13, color: Color(0xFF93C5FD)),
                    const SizedBox(width: 4),
                    Text('Client: ${widget.meeting.clientName}',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF93C5FD))),
                  ],
                ),

                const SizedBox(height: 24),

                // Timer
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined,
                          color: Color(0xFF93C5FD), size: 16),
                      const SizedBox(width: 6),
                      Text(_formattedTime,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.5)),
                    ],
                  ),
                ),

                const Spacer(),

                // Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _callControl(
                        icon: _muted
                            ? Icons.mic_off_rounded
                            : Icons.mic_rounded,
                        label: _muted ? 'Unmute' : 'Mute',
                        active: _muted,
                        onTap: () => setState(() => _muted = !_muted),
                      ),
                      _callControl(
                        icon: _speakerOn
                            ? Icons.volume_up_rounded
                            : Icons.volume_down_rounded,
                        label: _speakerOn ? 'Speaker' : 'Earpiece',
                        active: _speakerOn,
                        onTap: () =>
                            setState(() => _speakerOn = !_speakerOn),
                      ),
                      _callControl(
                        icon: Icons.dialpad_rounded,
                        label: 'Keypad',
                        active: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // End Call button
                GestureDetector(
                  onTap: _onEndCall,
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE24B4A),
                    ),
                    child: const Icon(Icons.call_end_rounded,
                        color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(height: 8),
                Text('End Call',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5))),
                const SizedBox(height: 36),
              ],
            ),
          ),

          // End Call Confirmation Overlay
          if (_showEndConfirm)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFEDED),
                        ),
                        child: const Icon(Icons.call_end_rounded,
                            color: Color(0xFFE24B4A), size: 26),
                      ),
                      const SizedBox(height: 14),
                      const Text('End Meeting?',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827))),
                      const SizedBox(height: 6),
                      Text(
                        'Call duration: $_formattedTime\nThis will mark the meeting as completed.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            height: 1.5),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _showEndConfirm = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6FB),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: const Text('Continue',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF374151))),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: _confirmEnd,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE24B4A),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: const Text('End Meeting',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  

  Widget _callControl({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? Colors.white.withOpacity(0.25)
                  : Colors.white.withOpacity(0.1),
            ),
            child: Icon(icon,
                color: active ? Colors.white : Colors.white.withOpacity(0.6),
                size: 22),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.55))),
        ],
      ),
    );
  }

  
}



class VideoCallScreen extends StatefulWidget {
  final Meeting meeting;
  final VoidCallback onCallEnded;

  const VideoCallScreen({
    super.key,
    required this.meeting,
    required this.onCallEnded,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  CallState _callState = CallState.connecting;
  int _secondsElapsed = 0;
  Timer? _callTimer;

  @override
  void initState() {
    super.initState();

    // Pulse animation for connecting state
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Simulate connecting → connected after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _callState = CallState.connected);
        _startCallTimer();
      }
    });
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _secondsElapsed++);
    });
  }

  String get _callDuration {
    final m = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsElapsed % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _onEndCallPressed() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'End Call?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to end this video call?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('End Call'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      widget.onCallEnded();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _callTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.grey.shade900,
                    Colors.black,
                  ],
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pulse animation on avatar when connecting
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _callState == CallState.connecting
                            ? _pulseAnimation.value
                            : 1.0,
                        child: child,
                      );
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: widget.meeting.avatarBg,
                      child: Text(
                        widget.meeting.initials,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: widget.meeting.avatarText,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    widget.meeting.professionalName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.meeting.specialty,
                    style: const TextStyle(color: Colors.white60, fontSize: 14),
                  ),

                  const SizedBox(height: 16),

                  // Status text
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _callState == CallState.connecting
                        ? const Text(
                            'Connecting...',
                            key: ValueKey('connecting'),
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 14,
                              letterSpacing: 1.2,
                            ),
                          )
                        : Text(
                            _callDuration,
                            key: const ValueKey('timer'),
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // Bottom controls
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mute button (optional extra)
                  FloatingActionButton(
                    heroTag: 'mute',
                    backgroundColor: Colors.white24,
                    mini: true,
                    onPressed: () {}, // add mute logic if needed
                    child: const Icon(Icons.mic_off, color: Colors.white),
                  ),

                  const SizedBox(width: 32),

                  // End call button
                  FloatingActionButton(
                    heroTag: 'end_call',
                    backgroundColor: Colors.red,
                    onPressed: _onEndCallPressed,
                    child: const Icon(Icons.call_end, size: 28),
                  ),

                  const SizedBox(width: 32),

                  // Camera toggle (optional extra)
                  FloatingActionButton(
                    heroTag: 'camera',
                    backgroundColor: Colors.white24,
                    mini: true,
                    onPressed: () {}, 
                    child: const Icon(Icons.videocam_off, color: Colors.white),
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

enum CallState { connecting, connected }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// const Color adminPrimary = Color(0xFF2563EB);
// const Color adminDeep = Color(0xFF1E3A8A);
// const Color adminAccent = Color(0xFF60A5FA);
// const Color cardBg = Color(0xFFFFFFFF);
// const Color pageBg = Color(0xFFF1F5F9);
// const Color textDark = Color(0xFF0F172A);
// const Color textMid = Color(0xFF475569);
// const Color textLight = Color(0xFF94A3B8);
// const Color successGreen = Color(0xFF10B981);
// const Color dangerRed = Color(0xFFEF4444);

// // ═══════════════════════════════════════════════════════════════
// // Data Model
// // ═══════════════════════════════════════════════════════════════

// enum MeetingStatus { upcoming, completed }

// class Meeting {
//   final String id;
//   final String initials;
//   final String professionalName;
//   final String specialty;
//   final String clientName;
//   final String time;
//   final String date;
//   final Color avatarBg;
//   final Color avatarText;
//   MeetingStatus status;

//   Meeting({
//     required this.id,
//     required this.initials,
//     required this.professionalName,
//     required this.specialty,
//     required this.clientName,
//     required this.time,
//     required this.date,
//     required this.avatarBg,
//     required this.avatarText,
//     this.status = MeetingStatus.upcoming,
//   });
// }

// // ═══════════════════════════════════════════════════════════════
// // Meetings Screen
// // ═══════════════════════════════════════════════════════════════

// class MeetingsScreen extends StatefulWidget {
//   const MeetingsScreen({Key? key}) : super(key: key);

//   @override
//   State<MeetingsScreen> createState() => _MeetingsScreenState();
// }

// class _MeetingsScreenState extends State<MeetingsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   final List<Meeting> _meetings = [
//     Meeting(
//       id: '1',
//       initials: 'AN',
//       professionalName: 'Dr. Anjali N.',
//       specialty: 'Clinical Psychology',
//       clientName: 'Arjun R.',
//       time: '3:00 PM',
//       date: 'Today',
//       avatarBg: const Color(0xFFDBEAFE),
//       avatarText: const Color(0xFF1D4ED8),
//     ),
//     Meeting(
//       id: '2',
//       initials: 'VR',
//       professionalName: 'Adv. V. Rajan',
//       specialty: 'Property Law',
//       clientName: 'Meena S.',
//       time: '5:00 PM',
//       date: 'Today',
//       avatarBg: const Color(0xFFEDE9FE),
//       avatarText: const Color(0xFF6D28D9),
//     ),
//     Meeting(
//       id: '3',
//       initials: 'RK',
//       professionalName: 'Rahul Kumar',
//       specialty: 'CBT Therapy',
//       clientName: 'Prathik V.',
//       time: '10:30 AM',
//       date: 'Tomorrow',
//       avatarBg: const Color(0xFFD1FAE5),
//       avatarText: const Color(0xFF065F46),
//     ),
//     Meeting(
//       id: '4',
//       initials: 'MF',
//       professionalName: 'Meera Fathima',
//       specialty: 'Family & Divorce',
//       clientName: 'Reena P.',
//       time: '2:00 PM',
//       date: '14 Jun',
//       avatarBg: const Color(0xFFFEF3C7),
//       avatarText: const Color(0xFF92400E),
//     ),
//     Meeting(
//       id: '5',
//       initials: 'SJ',
//       professionalName: 'Sanjay J.',
//       specialty: 'Stress & Anxiety',
//       clientName: 'Kiran M.',
//       time: '4:00 PM',
//       date: '15 Jun',
//       avatarBg: const Color(0xFFFFE4E6),
//       avatarText: const Color(0xFF9F1239),
//     ),
//     Meeting(
//       id: '6',
//       initials: 'AN',
//       professionalName: 'Dr. Anjali N.',
//       specialty: 'Clinical Psych',
//       clientName: 'Arjun R.',
//       time: '11:00 AM',
//       date: '9 May',
//       avatarBg: const Color(0xFFDBEAFE),
//       avatarText: const Color(0xFF1D4ED8),
//       status: MeetingStatus.completed,
//     ),
//     Meeting(
//       id: '7',
//       initials: 'VR',
//       professionalName: 'Adv. V. Rajan',
//       specialty: 'Property Law',
//       clientName: 'Bindu S.',
//       time: '3:30 PM',
//       date: '8 May',
//       avatarBg: const Color(0xFFEDE9FE),
//       avatarText: const Color(0xFF6D28D9),
//       status: MeetingStatus.completed,
//     ),
//     Meeting(
//       id: '8',
//       initials: 'RK',
//       professionalName: 'Rahul Kumar',
//       specialty: 'CBT Therapy',
//       clientName: 'Sanjay P.',
//       time: '5:00 PM',
//       date: '7 May',
//       avatarBg: const Color(0xFFD1FAE5),
//       avatarText: const Color(0xFF065F46),
//       status: MeetingStatus.completed,
//     ),
//   ];

//   List<Meeting> get _upcoming =>
//       _meetings.where((m) => m.status == MeetingStatus.upcoming).toList();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _markAsCompleted(String meetingId) {
//     setState(() {
//       final m = _meetings.firstWhere((m) => m.id == meetingId);
//       m.status = MeetingStatus.completed;
//     });
//     _tabController.animateTo(1);
//   }

//   void _showJoinCallPopup(BuildContext context, Meeting meeting) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => _JoinCallSheet(
//         meeting: meeting,
//         onAudioCall: () {
//           Navigator.pop(context);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AudioCallScreen(
//                 meeting: meeting,
//                 onCallEnded: () => _markAsCompleted(meeting.id),
//               ),
//             ),
//           );
//         },
//         onVideoCall: () {
//           Navigator.pop(context);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => VideoCallScreen(
//                 meeting: meeting,
//                 onCallEnded: () => _markAsCompleted(meeting.id),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));

//     return Scaffold(
//       backgroundColor: pageBg,
//       body: Column(
//         children: [
//           _buildHeader(),
//           _buildTabBar(),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildUpcomingTab(),
//                 _buildAllMeetingsTab(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Header ────────────────────────────────────────────────────
//   Widget _buildHeader() {
//     final upcomingCount =
//         _meetings.where((m) => m.status == MeetingStatus.upcoming).length;
//     final completedCount =
//         _meetings.where((m) => m.status == MeetingStatus.completed).length;

//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Meetings',
//                         style: TextStyle(
//                           fontSize: 26,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.white,
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         'Manage all your sessions',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white.withOpacity(0.6),
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   Container(
//                     padding: const EdgeInsets.all(9),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.notifications_none_rounded,
//                         color: Colors.white, size: 20),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 18),
//               Row(
//                 children: [
//                   _statCard('$upcomingCount', 'Upcoming',
//                       Icons.schedule_rounded, const Color(0xFF60A5FA)),
//                   const SizedBox(width: 10),
//                   _statCard('$completedCount', 'Completed',
//                       Icons.check_circle_rounded, const Color(0xFF34D399)),
//                   const SizedBox(width: 10),
//                   _statCard('${_meetings.length}', 'Total',
//                       Icons.calendar_month_rounded, const Color(0xFFA78BFA)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _statCard(String value, String label, IconData icon, Color accent) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.12),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: Colors.white.withOpacity(0.1)),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 color: accent.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: accent, size: 16),
//             ),
//             const SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(value,
//                     style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.white)),
//                 Text(label,
//                     style: TextStyle(
//                         fontSize: 9,
//                         color: Colors.white.withOpacity(0.6),
//                         fontWeight: FontWeight.w500)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Tab Bar ────────────────────────────────────────────────────
//   Widget _buildTabBar() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFFF1F5F9),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TabBar(
//           controller: _tabController,
//           indicator: BoxDecoration(
//             color: adminPrimary,
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: [
//               BoxShadow(
//                 color: adminPrimary.withOpacity(0.35),
//                 blurRadius: 8,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           indicatorSize: TabBarIndicatorSize.tab,
//           labelColor: Colors.white,
//           unselectedLabelColor: textMid,
//           labelStyle:
//               const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
//           unselectedLabelStyle:
//               const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//           dividerColor: Colors.transparent,
//           padding: const EdgeInsets.all(3),
//           tabs: const [
//             Tab(text: 'Upcoming'),
//             Tab(text: 'All Meetings'),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Upcoming Tab ───────────────────────────────────────────────
//   Widget _buildUpcomingTab() {
//     final list = _upcoming;
//     if (list.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 72,
//               height: 72,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     adminPrimary.withOpacity(0.1),
//                     adminAccent.withOpacity(0.1)
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Icon(Icons.calendar_today_rounded,
//                   color: adminPrimary, size: 32),
//             ),
//             const SizedBox(height: 16),
//             const Text('No upcoming meetings',
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: textDark)),
//             const SizedBox(height: 4),
//             const Text('You\'re all caught up!',
//                 style: TextStyle(fontSize: 13, color: textLight)),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
//       itemCount: list.length,
//       itemBuilder: (_, i) => _UpcomingMeetingCard(
//         meeting: list[i],
//         onJoinCall: () => _showJoinCallPopup(context, list[i]),
//         index: i,
//       ),
//     );
//   }

//   // ── All Meetings Tab ───────────────────────────────────────────
//   Widget _buildAllMeetingsTab() {
//     final upcoming =
//         _meetings.where((m) => m.status == MeetingStatus.upcoming).toList();
//     final completed =
//         _meetings.where((m) => m.status == MeetingStatus.completed).toList();

//     return ListView(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
//       children: [
//         if (upcoming.isNotEmpty) ...[
//           _sectionLabel('Upcoming', upcoming.length, adminPrimary,
//               const Color(0xFFEFF6FF)),
//           const SizedBox(height: 10),
//           ...upcoming.asMap().entries.map(
//                 (e) => _AllMeetingCard(meeting: e.value, index: e.key),
//               ),
//           const SizedBox(height: 20),
//         ],
//         if (completed.isNotEmpty) ...[
//           _sectionLabel('Completed', completed.length, successGreen,
//               const Color(0xFFECFDF5)),
//           const SizedBox(height: 10),
//           ...completed.asMap().entries.map(
//                 (e) => _AllMeetingCard(meeting: e.value, index: e.key),
//               ),
//         ],
//       ],
//     );
//   }

//   Widget _sectionLabel(String label, int count, Color color, Color bg) {
//     return Row(
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 color: textDark)),
//         const SizedBox(width: 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
//           decoration: BoxDecoration(
//               color: bg, borderRadius: BorderRadius.circular(20)),
//           child: Text('$count',
//               style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   color: color)),
//         ),
//       ],
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // Upcoming Meeting Card — Upgraded
// // ═══════════════════════════════════════════════════════════════

// class _UpcomingMeetingCard extends StatelessWidget {
//   final Meeting meeting;
//   final VoidCallback onJoinCall;
//   final int index;

//   const _UpcomingMeetingCard({
//     required this.meeting,
//     required this.onJoinCall,
//     required this.index,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isToday = meeting.date == 'Today';
//     final isTomorrow = meeting.date == 'Tomorrow';

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: cardBg,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF2563EB).withOpacity(0.06),
//             blurRadius: 20,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Top accent bar
//           if (isToday)
//             Container(
//               height: 3,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [adminPrimary, adminAccent],
//                 ),
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
//               ),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // Avatar with shadow
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: meeting.avatarBg,
//                     boxShadow: [
//                       BoxShadow(
//                         color: meeting.avatarText.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(meeting.initials,
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           color: meeting.avatarText)),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(meeting.professionalName,
//                               style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w700,
//                                   color: textDark)),
//                           if (isToday) ...[
//                             const SizedBox(width: 6),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 6, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFEFF6FF),
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: const Text('Today',
//                                   style: TextStyle(
//                                       fontSize: 9,
//                                       fontWeight: FontWeight.w700,
//                                       color: adminPrimary)),
//                             ),
//                           ],
//                         ],
//                       ),
//                       const SizedBox(height: 3),
//                       Row(
//                         children: [
//                           Container(
//                             width: 6,
//                             height: 6,
//                             decoration: BoxDecoration(
//                               color: meeting.avatarText.withOpacity(0.5),
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           Text(meeting.specialty,
//                               style: const TextStyle(
//                                   fontSize: 11,
//                                   color: textMid,
//                                   fontWeight: FontWeight.w500)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Date/Time badge
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: isToday
//                           ? [adminPrimary, const Color(0xFF3B82F6)]
//                           : [
//                               const Color(0xFFF8FAFC),
//                               const Color(0xFFF1F5F9)
//                             ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: isToday
//                         ? [
//                             BoxShadow(
//                               color: adminPrimary.withOpacity(0.3),
//                               blurRadius: 8,
//                               offset: const Offset(0, 3),
//                             )
//                           ]
//                         : [],
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         isTomorrow ? 'Tmr' : meeting.date,
//                         style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                             color: isToday ? Colors.white70 : textMid),
//                       ),
//                       const SizedBox(height: 1),
//                       Text(meeting.time,
//                           style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w800,
//                               color: isToday ? Colors.white : textDark)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Divider
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             height: 1,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.transparent,
//                   const Color(0xFFE2E8F0),
//                   Colors.transparent
//                 ],
//               ),
//             ),
//           ),
//           // Bottom row
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF8FAFC),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: const Color(0xFFE2E8F0)),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.person_rounded,
//                           size: 12, color: textLight),
//                       const SizedBox(width: 4),
//                       Text(meeting.clientName,
//                           style: const TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: textMid)),
//                     ],
//                   ),
//                 ),
//                 const Spacer(),
//                 GestureDetector(
//                   onTap: onJoinCall,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 18, vertical: 9),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [adminPrimary, Color(0xFF3B82F6)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: adminPrimary.withOpacity(0.35),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         Icon(Icons.call_rounded,
//                             color: Colors.white, size: 14),
//                         SizedBox(width: 6),
//                         Text('Join Call',
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // All Meetings Card — Upgraded
// // ═══════════════════════════════════════════════════════════════

// class _AllMeetingCard extends StatelessWidget {
//   final Meeting meeting;
//   final int index;
//   const _AllMeetingCard({required this.meeting, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     final isCompleted = meeting.status == MeetingStatus.completed;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: cardBg,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: meeting.avatarBg,
//               boxShadow: [
//                 BoxShadow(
//                   color: meeting.avatarText.withOpacity(0.15),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             alignment: Alignment.center,
//             child: Text(meeting.initials,
//                 style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: meeting.avatarText)),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(meeting.professionalName,
//                     style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: textDark)),
//                 const SizedBox(height: 3),
//                 Text('${meeting.specialty} · ${meeting.clientName}',
//                     style: const TextStyle(
//                         fontSize: 11, color: textLight, height: 1.3)),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 9, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: isCompleted
//                       ? const Color(0xFFECFDF5)
//                       : const Color(0xFFEFF6FF),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 5,
//                       height: 5,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color:
//                             isCompleted ? successGreen : adminPrimary,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       isCompleted ? 'Done' : 'Upcoming',
//                       style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700,
//                           color: isCompleted
//                               ? successGreen
//                               : adminPrimary),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text('${meeting.date} · ${meeting.time}',
//                   style: const TextStyle(
//                       fontSize: 10, color: textLight)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // Join Call Bottom Sheet — Upgraded
// // ═══════════════════════════════════════════════════════════════

// class _JoinCallSheet extends StatefulWidget {
//   final Meeting meeting;
//   final VoidCallback onAudioCall;
//   final VoidCallback onVideoCall;

//   const _JoinCallSheet({
//     required this.meeting,
//     required this.onAudioCall,
//     required this.onVideoCall,
//   });

//   @override
//   State<_JoinCallSheet> createState() => _JoinCallSheetState();
// }

// class _JoinCallSheetState extends State<_JoinCallSheet> {
//   String? _selected;

//   @override
//   Widget build(BuildContext context) {
//     final audioSelected = _selected == 'audio';
//     final videoSelected = _selected == 'video';

//     return Container(
//       decoration: const BoxDecoration(
//         color: cardBg,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//       ),
//       padding: const EdgeInsets.fromLTRB(24, 14, 24, 40),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Handle
//           Container(
//             width: 36,
//             height: 4,
//             decoration: BoxDecoration(
//                 color: const Color(0xFFE2E8F0),
//                 borderRadius: BorderRadius.circular(2)),
//           ),
//           const SizedBox(height: 22),
//           // Avatar
//           Container(
//             width: 62,
//             height: 62,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: widget.meeting.avatarBg,
//               boxShadow: [
//                 BoxShadow(
//                   color: widget.meeting.avatarText.withOpacity(0.25),
//                   blurRadius: 16,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             alignment: Alignment.center,
//             child: Text(widget.meeting.initials,
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w800,
//                     color: widget.meeting.avatarText)),
//           ),
//           const SizedBox(height: 12),
//           Text(widget.meeting.professionalName,
//               style: const TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w800,
//                   color: textDark)),
//           const SizedBox(height: 3),
//           Text('${widget.meeting.specialty} · ${widget.meeting.clientName}',
//               style: const TextStyle(fontSize: 12, color: textMid)),
//           const SizedBox(height: 6),
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.schedule_rounded,
//                     size: 12, color: textLight),
//                 const SizedBox(width: 4),
//                 Text(
//                     '${widget.meeting.date} at ${widget.meeting.time}',
//                     style: const TextStyle(
//                         fontSize: 11,
//                         color: textMid,
//                         fontWeight: FontWeight.w500)),
//               ],
//             ),
//           ),
//           const SizedBox(height: 26),
//           const Align(
//             alignment: Alignment.centerLeft,
//             child: Text('Choose call type',
//                 style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: textDark)),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               // Audio Call
//               Expanded(
//                 child: _CallTypeOption(
//                   icon: Icons.call_rounded,
//                   label: 'Audio Call',
//                   isSelected: audioSelected,
//                   isDisabled: videoSelected,
//                   selectedColor: adminPrimary,
//                   onTap: () => setState(() {
//                     _selected = _selected == 'audio' ? null : 'audio';
//                   }),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // Video Call
//               Expanded(
//                 child: _CallTypeOption(
//                   icon: Icons.videocam_rounded,
//                   label: 'Video Call',
//                   isSelected: videoSelected,
//                   isDisabled: audioSelected,
//                   selectedColor: const Color(0xFF7C3AED),
//                   onTap: () => setState(() {
//                     _selected = _selected == 'video' ? null : 'video';
//                   }),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           // Start Call button
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 250),
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: _selected != null
//                   ? LinearGradient(
//                       colors: _selected == 'audio'
//                           ? [adminPrimary, const Color(0xFF3B82F6)]
//                           : [
//                               const Color(0xFF7C3AED),
//                               const Color(0xFF9333EA)
//                             ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     )
//                   : null,
//               color: _selected == null ? const Color(0xFFE2E8F0) : null,
//               borderRadius: BorderRadius.circular(14),
//               boxShadow: _selected != null
//                   ? [
//                       BoxShadow(
//                         color: (_selected == 'audio'
//                                 ? adminPrimary
//                                 : const Color(0xFF7C3AED))
//                             .withOpacity(0.35),
//                         blurRadius: 14,
//                         offset: const Offset(0, 5),
//                       )
//                     ]
//                   : [],
//             ),
//             child: GestureDetector(
//               onTap: _selected == null
//                   ? null
//                   : () {
//                       if (_selected == 'audio') {
//                         widget.onAudioCall();
//                       } else {
//                         widget.onVideoCall();
//                       }
//                     },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       _selected == 'video'
//                           ? Icons.videocam_rounded
//                           : Icons.call_rounded,
//                       color: _selected != null
//                           ? Colors.white
//                           : textLight,
//                       size: 18,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       _selected == null
//                           ? 'Select a call type'
//                           : 'Start ${_selected == 'audio' ? 'Audio' : 'Video'} Call',
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: _selected != null
//                               ? Colors.white
//                               : textLight),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF8FAFC),
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: const Color(0xFFE2E8F0)),
//               ),
//               alignment: Alignment.center,
//               child: const Text('Cancel',
//                   style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: textMid)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CallTypeOption extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isSelected;
//   final bool isDisabled;
//   final Color selectedColor;
//   final VoidCallback onTap;

//   const _CallTypeOption({
//     required this.icon,
//     required this.label,
//     required this.isSelected,
//     required this.isDisabled,
//     required this.selectedColor,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       duration: const Duration(milliseconds: 200),
//       opacity: isDisabled ? 0.3 : 1.0,
//       child: GestureDetector(
//         onTap: isDisabled ? null : onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 220),
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           decoration: BoxDecoration(
//             gradient: isSelected
//                 ? LinearGradient(
//                     colors: [selectedColor, selectedColor.withOpacity(0.8)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   )
//                 : null,
//             color: isSelected ? null : const Color(0xFFF8FAFC),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: isSelected
//                   ? selectedColor
//                   : const Color(0xFFE2E8F0),
//               width: isSelected ? 2 : 1,
//             ),
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                       color: selectedColor.withOpacity(0.3),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     )
//                   ]
//                 : [],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 width: 44,
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? Colors.white.withOpacity(0.2)
//                       : selectedColor.withOpacity(0.08),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon,
//                     color: isSelected ? Colors.white : selectedColor,
//                     size: 22),
//               ),
//               const SizedBox(height: 10),
//               Text(label,
//                   style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w700,
//                       color: isSelected ? Colors.white : textDark)),
//               const SizedBox(height: 4),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? Colors.white.withOpacity(0.2)
//                       : const Color(0xFFECFDF5),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   isSelected ? 'Selected ✓' : 'Available',
//                   style: TextStyle(
//                       fontSize: 9,
//                       fontWeight: FontWeight.w700,
//                       color: isSelected
//                           ? Colors.white
//                           : successGreen),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // Audio Call Screen — Upgraded
// // ═══════════════════════════════════════════════════════════════

// class AudioCallScreen extends StatefulWidget {
//   final Meeting meeting;
//   final VoidCallback onCallEnded;

//   const AudioCallScreen({
//     Key? key,
//     required this.meeting,
//     required this.onCallEnded,
//   }) : super(key: key);

//   @override
//   State<AudioCallScreen> createState() => _AudioCallScreenState();
// }

// class _AudioCallScreenState extends State<AudioCallScreen>
//     with SingleTickerProviderStateMixin {
//   Timer? _timer;
//   int _seconds = 0;
//   bool _muted = false;
//   bool _speakerOn = false;
//   bool _showEndConfirm = false;

//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnim;

//   @override
//   void initState() {
//     super.initState();
//     _timer =
//         Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() => _seconds++);
//     });
//     _pulseController = AnimationController(
//         vsync: this,
//         duration: const Duration(milliseconds: 1500))
//       ..repeat(reverse: true);
//     _pulseAnim = Tween<double>(begin: 0.93, end: 1.07).animate(
//         CurvedAnimation(
//             parent: _pulseController, curve: Curves.easeInOut));

//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pulseController.dispose();
//     super.dispose();
//   }

//   String get _formattedTime {
//     final m = (_seconds ~/ 60).toString().padLeft(2, '0');
//     final s = (_seconds % 60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }

//   void _confirmEnd() {
//     _timer?.cancel();
//     widget.onCallEnded();
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF0D1B5E), Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Decorative circles
//             Positioned(
//               top: -100,
//               right: -60,
//               child: Container(
//                 width: 280,
//                 height: 280,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white.withOpacity(0.04),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 60,
//               left: -80,
//               child: Container(
//                 width: 240,
//                 height: 240,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white.withOpacity(0.04),
//                 ),
//               ),
//             ),
//             SafeArea(
//               child: Column(
//                 children: [
//                   // Top bar
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: Container(
//                             width: 38,
//                             height: 38,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.12),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Icon(
//                                 Icons.arrow_back_ios_new_rounded,
//                                 color: Colors.white,
//                                 size: 16),
//                           ),
//                         ),
//                         const Spacer(),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 14, vertical: 7),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.12),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                                 color: Colors.white.withOpacity(0.1)),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 7,
//                                 height: 7,
//                                 decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Color(0xFF4ADE80)),
//                               ),
//                               const SizedBox(width: 6),
//                               const Text('On Call',
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 50),

//                   // Pulse Avatar
//                   ScaleTransition(
//                     scale: _pulseAnim,
//                     child: Container(
//                       width: 108,
//                       height: 108,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: widget.meeting.avatarBg,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.white.withOpacity(0.2),
//                             blurRadius: 40,
//                             spreadRadius: 8,
//                           ),
//                           BoxShadow(
//                             color: adminPrimary.withOpacity(0.4),
//                             blurRadius: 60,
//                             spreadRadius: 5,
//                           ),
//                         ],
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(widget.meeting.initials,
//                           style: TextStyle(
//                               fontSize: 34,
//                               fontWeight: FontWeight.w800,
//                               color: widget.meeting.avatarText)),
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   Text(widget.meeting.professionalName,
//                       style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.white,
//                           letterSpacing: -0.4)),
//                   const SizedBox(height: 5),
//                   Text(widget.meeting.specialty,
//                       style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.white.withOpacity(0.55),
//                           fontWeight: FontWeight.w400)),
//                   const SizedBox(height: 6),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.person_rounded,
//                             size: 12, color: adminAccent),
//                         const SizedBox(width: 4),
//                         Text('Client: ${widget.meeting.clientName}',
//                             style: const TextStyle(
//                                 fontSize: 11,
//                                 color: adminAccent,
//                                 fontWeight: FontWeight.w500)),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 28),

//                   // Timer
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 24, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.1)),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.timer_outlined,
//                             color: adminAccent, size: 16),
//                         const SizedBox(width: 8),
//                         Text(_formattedTime,
//                             style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.w800,
//                                 color: Colors.white,
//                                 letterSpacing: 2)),
//                       ],
//                     ),
//                   ),

//                   const Spacer(),

//                   // Controls
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _callControl(
//                           icon: _muted
//                               ? Icons.mic_off_rounded
//                               : Icons.mic_rounded,
//                           label: _muted ? 'Unmute' : 'Mute',
//                           active: _muted,
//                           onTap: () =>
//                               setState(() => _muted = !_muted),
//                         ),
//                         _callControl(
//                           icon: _speakerOn
//                               ? Icons.volume_up_rounded
//                               : Icons.volume_down_rounded,
//                           label: _speakerOn ? 'Speaker' : 'Earpiece',
//                           active: _speakerOn,
//                           onTap: () =>
//                               setState(() => _speakerOn = !_speakerOn),
//                         ),
//                         _callControl(
//                           icon: Icons.dialpad_rounded,
//                           label: 'Keypad',
//                           active: false,
//                           onTap: () {},
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 36),

//                   // End Call
//                   GestureDetector(
//                     onTap: () => setState(() => _showEndConfirm = true),
//                     child: Container(
//                       width: 72,
//                       height: 72,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: dangerRed,
//                         boxShadow: [
//                           BoxShadow(
//                             color: dangerRed.withOpacity(0.45),
//                             blurRadius: 20,
//                             offset: const Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(Icons.call_end_rounded,
//                           color: Colors.white, size: 30),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text('End Call',
//                       style: TextStyle(
//                           fontSize: 11,
//                           color: Colors.white.withOpacity(0.45),
//                           fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),

//             // End confirm overlay
//             if (_showEndConfirm)
//               Container(
//                 color: Colors.black.withOpacity(0.65),
//                 child: Center(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 28),
//                     padding: const EdgeInsets.all(26),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.15),
//                           blurRadius: 40,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           width: 60,
//                           height: 60,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color(0xFFFEF2F2),
//                           ),
//                           child: const Icon(Icons.call_end_rounded,
//                               color: dangerRed, size: 28),
//                         ),
//                         const SizedBox(height: 16),
//                         const Text('End Meeting?',
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w800,
//                                 color: textDark)),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Duration: $_formattedTime\nThis will mark the meeting as completed.',
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                               fontSize: 12,
//                               color: textMid,
//                               height: 1.6),
//                         ),
//                         const SizedBox(height: 22),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () => setState(
//                                     () => _showEndConfirm = false),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 13),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFF1F5F9),
//                                     borderRadius:
//                                         BorderRadius.circular(12),
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: const Text('Continue',
//                                       style: TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w700,
//                                           color: textMid)),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: _confirmEnd,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 13),
//                                   decoration: BoxDecoration(
//                                     gradient: const LinearGradient(
//                                       colors: [
//                                         Color(0xFFEF4444),
//                                         Color(0xFFF87171)
//                                       ],
//                                     ),
//                                     borderRadius:
//                                         BorderRadius.circular(12),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: dangerRed.withOpacity(0.35),
//                                         blurRadius: 10,
//                                         offset: const Offset(0, 4),
//                                       )
//                                     ],
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: const Text('End Meeting',
//                                       style: TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w700,
//                                           color: Colors.white)),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _callControl({
//     required IconData icon,
//     required String label,
//     required bool active,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: 58,
//             height: 58,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: active
//                   ? Colors.white.withOpacity(0.25)
//                   : Colors.white.withOpacity(0.1),
//               border: Border.all(
//                 color: active
//                     ? Colors.white.withOpacity(0.4)
//                     : Colors.white.withOpacity(0.1),
//               ),
//             ),
//             child: Icon(icon,
//                 color: active
//                     ? Colors.white
//                     : Colors.white.withOpacity(0.55),
//                 size: 22),
//           ),
//           const SizedBox(height: 7),
//           Text(label,
//               style: TextStyle(
//                   fontSize: 10,
//                   color: Colors.white.withOpacity(0.5),
//                   fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // Video Call Screen — Upgraded
// // ═══════════════════════════════════════════════════════════════

// class VideoCallScreen extends StatefulWidget {
//   final Meeting meeting;
//   final VoidCallback onCallEnded;

//   const VideoCallScreen({
//     super.key,
//     required this.meeting,
//     required this.onCallEnded,
//   });

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;

//   CallState _callState = CallState.connecting;
//   int _secondsElapsed = 0;
//   Timer? _callTimer;
//   bool _micOn = true;
//   bool _camOn = true;

//   @override
//   void initState() {
//     super.initState();
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     )..repeat(reverse: true);
//     _pulseAnimation = Tween<double>(begin: 0.93, end: 1.07).animate(
//       CurvedAnimation(
//           parent: _pulseController, curve: Curves.easeInOut),
//     );

//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) {
//         setState(() => _callState = CallState.connected);
//         _startCallTimer();
//       }
//     });
//   }

//   void _startCallTimer() {
//     _callTimer =
//         Timer.periodic(const Duration(seconds: 1), (_) {
//       if (mounted) setState(() => _secondsElapsed++);
//     });
//   }

//   String get _callDuration {
//     final m = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
//     final s = (_secondsElapsed % 60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }

//   Future<void> _onEndCallPressed() async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           padding: const EdgeInsets.all(26),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1A1A2E),
//             borderRadius: BorderRadius.circular(24),
//             border: Border.all(color: Colors.white.withOpacity(0.08)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 56,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: dangerRed.withOpacity(0.15),
//                 ),
//                 child: const Icon(Icons.call_end_rounded,
//                     color: dangerRed, size: 26),
//               ),
//               const SizedBox(height: 16),
//               const Text('End Video Call?',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w800)),
//               const SizedBox(height: 8),
//               Text(
//                 'Are you sure you want to end this call?',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.55), fontSize: 13),
//               ),
//               const SizedBox(height: 22),
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(ctx, false),
//                       child: Container(
//                         padding:
//                             const EdgeInsets.symmetric(vertical: 13),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         alignment: Alignment.center,
//                         child: const Text('Cancel',
//                             style: TextStyle(
//                                 color: Colors.white70,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13)),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(ctx, true),
//                       child: Container(
//                         padding:
//                             const EdgeInsets.symmetric(vertical: 13),
//                         decoration: BoxDecoration(
//                           color: dangerRed,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: dangerRed.withOpacity(0.4),
//                               blurRadius: 12,
//                               offset: const Offset(0, 4),
//                             )
//                           ],
//                         ),
//                         alignment: Alignment.center,
//                         child: const Text('End Call',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 13)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//     if (confirm == true && mounted) {
//       widget.onCallEnded();
//       Navigator.pop(context);
//     }
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _callTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Background
//           Container(
//             decoration: const BoxDecoration(
//               gradient: RadialGradient(
//                 center: Alignment.center,
//                 radius: 1.2,
//                 colors: [Color(0xFF1A1A2E), Color(0xFF0D0D1A)],
//               ),
//             ),
//           ),

//           // Glow behind avatar
//           if (_callState == CallState.connected)
//             Center(
//               child: Container(
//                 width: 200,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: widget.meeting.avatarText.withOpacity(0.15),
//                       blurRadius: 80,
//                       spreadRadius: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//           SafeArea(
//             child: Column(
//               children: [
//                 // Top bar
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Container(
//                           width: 38,
//                           height: 38,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                               Icons.arrow_back_ios_new_rounded,
//                               color: Colors.white,
//                               size: 16),
//                         ),
//                       ),
//                       const Spacer(),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 14, vertical: 7),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                               color: Colors.white.withOpacity(0.08)),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 7,
//                               height: 7,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: _callState == CallState.connecting
//                                     ? const Color(0xFFFBBF24)
//                                     : const Color(0xFF4ADE80),
//                               ),
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               _callState == CallState.connecting
//                                   ? 'Connecting...'
//                                   : 'Video Call',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const Spacer(),

//                 // Avatar
//                 AnimatedBuilder(
//                   animation: _pulseAnimation,
//                   builder: (context, child) {
//                     return Transform.scale(
//                       scale: _callState == CallState.connecting
//                           ? _pulseAnimation.value
//                           : 1.0,
//                       child: child,
//                     );
//                   },
//                   child: Container(
//                     width: 110,
//                     height: 110,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: widget.meeting.avatarBg,
//                       boxShadow: [
//                         BoxShadow(
//                           color: widget.meeting.avatarText.withOpacity(0.3),
//                           blurRadius: 30,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(widget.meeting.initials,
//                         style: TextStyle(
//                             fontSize: 36,
//                             fontWeight: FontWeight.w800,
//                             color: widget.meeting.avatarText)),
//                   ),
//                 ),

//                 const SizedBox(height: 22),

//                 Text(widget.meeting.professionalName,
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: -0.3)),
//                 const SizedBox(height: 5),
//                 Text(widget.meeting.specialty,
//                     style: TextStyle(
//                         color: Colors.white.withOpacity(0.5),
//                         fontSize: 13)),
//                 const SizedBox(height: 16),

//                 // Status / Timer
//                 AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 400),
//                   child: _callState == CallState.connecting
//                       ? Container(
//                           key: const ValueKey('connecting'),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 7),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFBBF24).withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                                 color: const Color(0xFFFBBF24)
//                                     .withOpacity(0.3)),
//                           ),
//                           child: const Text('Connecting...',
//                               style: TextStyle(
//                                   color: Color(0xFFFBBF24),
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w600,
//                                   letterSpacing: 0.8)),
//                         )
//                       : Container(
//                           key: const ValueKey('timer'),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 7),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF4ADE80).withOpacity(0.12),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                                 color: const Color(0xFF4ADE80)
//                                     .withOpacity(0.3)),
//                           ),
//                           child: Text(_callDuration,
//                               style: const TextStyle(
//                                   color: Color(0xFF4ADE80),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700,
//                                   letterSpacing: 1.5)),
//                         ),
//                 ),

//                 const Spacer(),

//                 // Controls
//                 Container(
//                   margin: const EdgeInsets.fromLTRB(24, 0, 24, 48),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 24, vertical: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.07),
//                     borderRadius: BorderRadius.circular(28),
//                     border: Border.all(
//                         color: Colors.white.withOpacity(0.08)),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _videoControl(
//                         icon: _micOn ? Icons.mic_rounded : Icons.mic_off_rounded,
//                         label: _micOn ? 'Mute' : 'Unmute',
//                         active: !_micOn,
//                         onTap: () => setState(() => _micOn = !_micOn),
//                       ),
//                       // End Call (center)
//                       GestureDetector(
//                         onTap: _onEndCallPressed,
//                         child: Container(
//                           width: 64,
//                           height: 64,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: dangerRed,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: dangerRed.withOpacity(0.45),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 6),
//                               )
//                             ],
//                           ),
//                           child: const Icon(Icons.call_end_rounded,
//                               color: Colors.white, size: 28),
//                         ),
//                       ),
//                       _videoControl(
//                         icon: _camOn
//                             ? Icons.videocam_rounded
//                             : Icons.videocam_off_rounded,
//                         label: _camOn ? 'Cam Off' : 'Cam On',
//                         active: !_camOn,
//                         onTap: () => setState(() => _camOn = !_camOn),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _videoControl({
//     required IconData icon,
//     required String label,
//     required bool active,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: 52,
//             height: 52,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: active
//                   ? dangerRed.withOpacity(0.2)
//                   : Colors.white.withOpacity(0.12),
//               border: Border.all(
//                 color: active
//                     ? dangerRed.withOpacity(0.4)
//                     : Colors.white.withOpacity(0.1),
//               ),
//             ),
//             child: Icon(icon,
//                 color: active ? dangerRed : Colors.white.withOpacity(0.7),
//                 size: 22),
//           ),
//           const SizedBox(height: 6),
//           Text(label,
//               style: TextStyle(
//                   fontSize: 10,
//                   color: Colors.white.withOpacity(0.45),
//                   fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }

// enum CallState { connecting, connected }