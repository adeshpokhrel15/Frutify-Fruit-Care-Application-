import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/community_post.dart';
import '../services/image_storage_data.dart';
import '../state/app_state.dart';
import '../utils/responsive.dart';

class ComposePostScreen extends StatefulWidget {
  const ComposePostScreen({super.key});

  @override
  State<ComposePostScreen> createState() => _ComposePostScreenState();
}

class _ComposePostScreenState extends State<ComposePostScreen> {
  final _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedPhoto;
  bool _posting = false;

  bool get _canPost => _textController.text.trim().isNotEmpty || _pickedPhoto != null;

  Future<void> _pickPhoto(ImageSource source) async {
    final photo = await _picker.pickImage(source: source, maxWidth: 1600, imageQuality: 85);
    if (photo != null) setState(() => _pickedPhoto = photo);
  }

  void _showPhotoSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primaryRed),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.primaryRed),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_canPost) return;
    setState(() => _posting = true);

    String? savedImagePath;
    if (_pickedPhoto != null) {
      savedImagePath = await ImageStorageService.instance.saveCapturedImage(_pickedPhoto!, folder: 'community_photos');
    }

    if (!mounted) return;
    final app = context.read<AppState>();
    app.addPost(
      CommunityPost(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorName: app.userName,
        avatarColor: AppColors.primaryRed,
        timestamp: DateTime.now(),
        text: _textController.text.trim(),
        imagePath: savedImagePath,
        isAssetImage: false,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post', style: AppTextStyles.body(size: 17, weight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: TextButton(
                onPressed: (_canPost && !_posting) ? _submit : null,
                child: Text(
                  _posting ? 'Posting...' : 'Post',
                  style: TextStyle(
                    color: (_canPost && !_posting) ? AppColors.primaryRed : AppColors.textGrey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
        child: ResponsiveCenter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryRed,
                    child: Text(
                      context.watch<AppState>().userName.isNotEmpty ? context.watch<AppState>().userName[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(context.watch<AppState>().userName, style: AppTextStyles.body(size: 15, weight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                maxLines: 6,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                ),
                style: AppTextStyles.body(size: 16),
              ),
              if (_pickedPhoto != null) ...[
                const SizedBox(height: 12),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(File(_pickedPhoto!.path), width: double.infinity, height: 220, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 16,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, color: Colors.white, size: 18),
                          onPressed: () => setState(() => _pickedPhoto = null),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _showPhotoSourceSheet,
                icon: const Icon(Icons.image_outlined, color: AppColors.darkGreen),
                label: Text(_pickedPhoto == null ? 'Add Photo' : 'Change Photo', style: const TextStyle(color: AppColors.darkGreen)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}