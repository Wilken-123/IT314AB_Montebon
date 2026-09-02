import 'package:flutter/material.dart';

void main() {
  runApp(const SocialApp());
}

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color (0xFF141414),
        fontFamily: 'Roboto',
      ),
      home: const FriendsPage(),
    );
  }
}

enum PresenceStatus { online, playing, away, offline }

class Friend {
  final String name;
  final String? avatarUrl;
  final PresenceStatus status;
  final String? activity; // e.g. "VALORANT"
  final String? device; // e.g. "Riot Mobile"

  const Friend({
    required this.name,
    this.avatarUrl,
    required this.status,
    this.activity,
    this.device,
  });

  Color get statusColor {
    switch (status) {
      case PresenceStatus.online:
        return const Color(0xFF3BA55C);
      case PresenceStatus.playing:
        return const Color(0xFF5865F2);
      case PresenceStatus.away:
        return const Color(0xFFFAA61A);
      case PresenceStatus.offline:
        return Colors.grey;
    }
  }

  String get statusLabel {
    switch (status) {
      case PresenceStatus.online:
        return 'Online';
      case PresenceStatus.playing:
        return 'Playing';
      case PresenceStatus.away:
        return 'Away';
      case PresenceStatus.offline:
        return 'Offline';
    }
  }

  IconData get deviceIcon {
    if (device == null) return Icons.desktop_windows_outlined;
    final lower = device!.toLowerCase();
    if (lower.contains('mobile')) return Icons.phone_iphone;
    return Icons.desktop_windows_outlined;
  }
}

class FriendsPage extends stateful widget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  int selectedTab = 0;

  final List<String> tabs = const ['Friends', 'Messages', 'Requests'];

  final List<Friend> playingNow = const [
    Friend(
      name: 'MissYouLikeKrazy',
      status: PresenceStatus.online,
      activity: 'VALORANT',
      device: 'PC',
    ),
    Friend(
      name: 'bread',
      status: PresenceStatus.playing,
      activity: 'VALORANT',
      device: 'PC',
    ),
    Friend(
      name: 'The14th',
      status: PresenceStatus.playing,
      activity: 'VALORANT',
      device: 'PC',
    ),
  ];

  final List<Friend> onlineFriends = const [
    Friend(
      name: 'Carlvendish',
      status: PresenceStatus.away,
      device: 'Riot Mobile',
    ),
    Friend(
      name: 'D1yah',
      status: PresenceStatus.away,
      device: 'Riot Mobile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                'Social',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            _buildTabRow(),
            const Divider(height: 1, color: Color(0xFF2A2A2A)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _SearchField(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _SectionHeader(
                    label: 'VALORANT',
                    count: playingNow.length,
                    icon: Icons.videogame_asset,
                    iconColor: const Color(0xFFFF4655),
                  ),
                  ...playingNow.map((f) => _FriendTile(friend: f)),
                  const SizedBox(height: 12),
                  _SectionHeader(
                    label: 'Online',
                    count: onlineFriends.length,
                  ),
                  ...onlineFriends.map((f) => _FriendTile(friend: f)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedTab;
          return Padding(
            padding: const EdgeInsets.only(right: 24),
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = index),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2,
                    width: 28,
                    color: isSelected ? Colors.redAccent : Colors.transparent,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.grey, size: 20),
          SizedBox(width: 8),
          Text('Search', style: TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  final IconData? icon;
  final Color? iconColor;

  const _SectionHeader({
    required this.label,
    required this.count,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: iconColor ?? Colors.grey),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  final Friend friend;

  const _FriendTile({required this.friend});

  @override
  Widget build(BuildContext context) {
    final subtitleParts = <String>[friend.statusLabel];
    if (friend.activity != null) subtitleParts.add(friend.activity!);
    if (friend.device != null) subtitleParts.add(friend.device!);
    final subtitle = subtitleParts.join(' - ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF3A3A3A),
                backgroundImage: friend.avatarUrl != null
                    ? NetworkImage(friend.avatarUrl!)
                    : null,
                child: friend.avatarUrl == null
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: friend.statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF141414), width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(friend.deviceIcon, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
