import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/contact_model.dart';
import '../../services/ocr_service.dart';
import '../../services/google_sheets_service.dart';

class ScanProvider with ChangeNotifier {
  File? frontImage;
  File? backImage;
  ContactModel? extractedContact;
  bool isLoading = false;
  bool isExtracting = false;

  String message = '';

  final OcrService _ocrService = OcrService();
  final GoogleSheetsService _sheetsService = GoogleSheetsService();
  void update(ContactModel updated) {
    extractedContact = updated;
    notifyListeners();
  }

  Future<void> pickImage(bool isFront, ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    if (isFront) {
      frontImage = File(picked.path);
    } else {
      backImage = File(picked.path);
    }
    notifyListeners();
  }

  Future<void> extractText() async {
    if (frontImage == null || backImage == null) {
      // message = "Please upload both front & back images";
      Get.snackbar(
        "Error",
        "No Data Available to Extract",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: const EdgeInsets.all(5),
        borderRadius: 8,
        duration: const Duration(seconds: 1),
      );
      notifyListeners();
      return;
    }

    isExtracting = true;
    message = "Extracting text...";
    notifyListeners();

    try {
      extractedContact = await _ocrService.extractFromImages(
        frontImage!,
        backImage!,
      );
      message = "Text extracted successfully! You can edit below.";
    } catch (e) {
      message = "OCR failed: $e";
    }

    isExtracting = false;
    notifyListeners();
  }

  Future<bool> saveContact() async {
    if (extractedContact == null) return false;

    try {
      isLoading = true;
      notifyListeners();

      final bool success = await _sheetsService.saveContact(extractedContact!);

      Get.snackbar(
        success ? "Success" : "Error",
        success ? "Contact saved successfully" : "Failed to save contact",
        snackPosition: SnackPosition.TOP,
        backgroundColor: success ? Colors.green : Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(5),
        borderRadius: 8,
        duration: const Duration(seconds: 1),
      );

      if (success) {
        clear();
      }

      return success; // 👈 return result
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    frontImage = null;
    backImage = null;
    extractedContact = null;
    message = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }
}
