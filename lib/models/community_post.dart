import 'package:flutter/material.dart';

class CommunityPost {
  final String id;
  final String authorName;
  final Color avatarColor;
  final DateTime timestamp;
  final String text;
  final String? imagePath;
  final bool isAssetImage;
  final int views;
  final int reactions;
  final int comments;
  final int shares;

  const CommunityPost({
    required this.id,
    required this.authorName,
    required this.avatarColor,
    required this.timestamp,
    required this.text,
    this.imagePath,
    this.isAssetImage = false,
    this.views = 0,
    this.reactions = 0,
    this.comments = 0,
    this.shares = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorName': authorName,
        'avatarColor': avatarColor.value,
        'timestamp': timestamp.toIso8601String(),
        'text': text,
        'imagePath': imagePath,
        'isAssetImage': isAssetImage,
        'views': views,
        'reactions': reactions,
        'comments': comments,
        'shares': shares,
      };

  factory CommunityPost.fromJson(Map<String, dynamic> json) => CommunityPost(
        id: json['id'] as String,
        authorName: json['authorName'] as String,
        avatarColor: Color(json['avatarColor'] as int),
        timestamp: DateTime.parse(json['timestamp'] as String),
        text: json['text'] as String,
        imagePath: json['imagePath'] as String?,
        isAssetImage: json['isAssetImage'] as bool? ?? false,
        views: json['views'] as int? ?? 0,
        reactions: json['reactions'] as int? ?? 0,
        comments: json['comments'] as int? ?? 0,
        shares: json['shares'] as int? ?? 0,
      );
}