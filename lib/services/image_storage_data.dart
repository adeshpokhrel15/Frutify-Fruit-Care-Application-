import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

/// Copies a picked/captured photo out of the picker's temporary cache and
/// into the app's own persistent documents directory, so the photo is still
/// there after the OS clears temp/cache files (which it can do at any time).
class ImageStorageService {
  ImageStorageService._();
  static final ImageStorageService instance = ImageStorageService._();

  Future<String> saveCapturedImage(XFile file, {String folder = 'fruit_photos'}) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${docsDir.path}/$folder');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final ext = file.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final savedPath = '${imagesDir.path}/$fileName';
    await File(file.path).copy(savedPath);
    return savedPath;
  }

  Future<void> deleteImage(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}