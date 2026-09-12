import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../models/community_post.dart';
import '../../state/app_state.dart';
import '../../utils/responsive.dart';
import '../compose_post_screen.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _CommunityHeader(userName: app.userName, notificationCount: app.notificationCount),
          Expanded(
            child: app.posts.isEmpty
                ? const _EmptyFeed()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: app.posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _PostCard(post: app.posts[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Red header with greeting + notification bell, plus the tappable
/// "What's on your mind?" composer bar.
class _CommunityHeader extends StatelessWidget {
  final String userName;
  final int notificationCount;
  const _CommunityHeader({required this.userName, required this.notificationCount});

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.horizontalPadding(context);
    return Container(
      width: double.infinity,
      color: AppColors.primaryRed,
      padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 20),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning,', style: AppTextStyles.body(size: 14, color: Colors.white, weight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(userName, style: AppTextStyles.serifHeading(size: 22, color: Colors.white)),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                      child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                    ),
                    if (notificationCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 7,
                            backgroundColor: AppColors.primaryRed,
                            child: Text('$notificationCount', style: const TextStyle(fontSize: 9, color: Colors.white)),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComposePostScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Whats on you mind?', style: AppTextStyles.body(size: 14, color: Colors.white70)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(border: Border.all(color: Colors.white70), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.image_outlined, color: Colors.white, size: 18),
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
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.groups_outlined, size: 72, color: AppColors.paleRedCard),
          const SizedBox(height: 16),
          Text('No posts yet', style: AppTextStyles.serifHeading(size: 18)),
          const SizedBox(height: 6),
          Text('Be the first to share something!', style: AppTextStyles.body(color: AppColors.textGrey)),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final CommunityPost post;
  const _PostCard({required this.post});

  String _formatTimestamp(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} at $hh:$mm';
  }

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.horizontalPadding(context);
    return ResponsiveCenter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: hPad),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: post.avatarColor,
                  child: Text(
                    post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: AppTextStyles.body(size: 14.5, weight: FontWeight.w700)),
                      Text(_formatTimestamp(post.timestamp), style: AppTextStyles.body(size: 11.5, color: AppColors.textGrey)),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: AppColors.textGrey),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.text, style: AppTextStyles.body(size: 14)),
            if (post.imagePath != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: post.isAssetImage
                    ? Image.asset(post.imagePath!, width: double.infinity, height: 220, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imageFallback())
                    : Image.file(File(post.imagePath!), width: double.infinity, height: 220, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imageFallback()),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.remove_red_eye_outlined, size: 16, color: AppColors.textGrey),
                const SizedBox(width: 4),
                Text(_formatCount(post.views), style: AppTextStyles.body(size: 12, color: AppColors.textGrey)),
                const Spacer(),
                const _ReactionCluster(),
                const SizedBox(width: 6),
                Text('${post.reactions}', style: AppTextStyles.body(size: 12, color: AppColors.textGrey)),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionStat(icon: Icons.share_outlined, count: post.shares),
                _ActionStat(icon: Icons.mode_comment_outlined, count: post.comments),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      width: double.infinity,
      height: 220,
      color: AppColors.paleGreenCard,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined, color: AppColors.darkGreen, size: 40),
    );
  }
}

class _ReactionCluster extends StatelessWidget {
  const _ReactionCluster();

  @override
  Widget build(BuildContext context) {
    const emojis = ['👍', '❤️', '😂', '😮', '😢'];
    return SizedBox(
      width: 70,
      height: 20,
      child: Stack(
        children: List.generate(emojis.length, (i) {
          return Positioned(
            left: i * 12.0,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Text(emojis[i], style: const TextStyle(fontSize: 11)),
            ),
          );
        }),
      ),
    );
  }
}

class _ActionStat extends StatelessWidget {
  final IconData icon;
  final int count;
  const _ActionStat({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textGrey),
        const SizedBox(width: 6),
        Text('$count', style: AppTextStyles.body(size: 13, color: AppColors.textGrey)),
      ],
    );
  }
}