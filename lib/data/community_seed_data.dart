import 'package:flutter/material.dart';
import '../models/community_post.dart';

List<CommunityPost> buildSeedCommunityPosts() {
  final now = DateTime.now();
  return [
    CommunityPost(
      id: 'seed-1',
      authorName: 'Bijay Sharma',
      avatarColor: const Color(0xFFF7941D),
      timestamp: DateTime(now.year, 8, 16, 19, 56),
      text: 'Hello guys! Today, I want to share my Fruits photos for app. Thanks.',
      views: 23,
      reactions: 9,
      comments: 5,
      shares: 7,
    ),
    CommunityPost(
      id: 'seed-2',
      authorName: 'Arpan Bro',
      avatarColor: const Color(0xFF4C8557),
      timestamp: DateTime(now.year, 2, 16, 20, 56),
      text: 'My baby fruits',
      imagePath: 'images/banana.PNG',
      isAssetImage: true,
      views: 23000,
      reactions: 9,
      comments: 5,
      shares: 7,
    ),
    CommunityPost(
      id: 'seed-3',
      authorName: 'Adesh Pokhrel',
      avatarColor: const Color(0xFFFF3B47),
      timestamp: DateTime(now.year, 2, 16, 18, 34),
      text: 'Hello guys! Today I want to share my Plant care journey with you all.',
      views: 41,
      reactions: 12,
      comments: 3,
      shares: 2,
    ),
  ];
}