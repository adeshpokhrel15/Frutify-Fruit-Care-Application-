import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fruitify/services/image_storage_data.dart';
import 'package:image_picker/image_picker.dart';
import '../app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/primary_button.dart';
import 'add_fruit_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _capturedFile;
  bool _saving = false;
  String? _error;

  Future<void> _takePicture() async {
    setState(() => _error = null);
    try {
      final photo = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1600, imageQuality: 85);
      if (photo != null) {
        setState(() => _capturedFile = photo);
      }
    } catch (e) {
      setState(() => _error = 'Could not open the camera. Check camera permissions and try again.');
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _error = null);
    try {
      final photo = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 85);
      if (photo != null) {
        setState(() => _capturedFile = photo);
      }
    } catch (e) {
      setState(() => _error = 'Could not open the gallery. Check photo permissions and try again.');
    }
  }

  Future<void> _next() async {
    if (_capturedFile == null) return;
    setState(() => _saving = true);
    final savedPath = await ImageStorageService.instance.saveCapturedImage(_capturedFile!);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AddFruitScreen(imagePath: savedPath)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = _capturedFile != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.lightRed,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('Take Picture of the Fruits', style: AppTextStyles.body(size: 16, color: Colors.white, weight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: hasPhoto
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(_capturedFile!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: Responsive.isTablet(context) ? 420 : 320,
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: Responsive.isTablet(context) ? 160 : 110,
                            color: AppColors.primaryRed.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Take a photo of your fruit or plant\nto add it to your collection',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body(size: 14, color: AppColors.textGrey),
                          ),
                        ],
                      ),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(_error!, style: AppTextStyles.body(size: 12.5, color: AppColors.primaryRed)),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                Responsive.horizontalPadding(context),
                12,
                Responsive.horizontalPadding(context),
                24,
              ),
              child: ResponsiveCenter(
                child: Column(
                  children: [
                    if (!hasPhoto)
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              label: 'Open Camera',
                              color: AppColors.lightRed,
                              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              onPressed: _takePicture,
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryOutlineButton(
                              label: 'Retake',
                              onPressed: () => setState(() => _capturedFile = null),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: _pickFromGallery,
                      icon: const Icon(Icons.photo_library_outlined, color: AppColors.darkGreen),
                      label: Text('Choose from gallery instead', style: AppTextStyles.body(color: AppColors.darkGreen, weight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 6),
                    PrimaryButton(
                      label: _saving ? 'Saving...' : 'Next',
                      color: AppColors.lightRed,
                      onPressed: (hasPhoto && !_saving) ? _next : null,
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