import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../core/utils/helpers.dart';
import '../models/contact_model.dart';

class OcrService {
  final TextRecognizer _recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  Future<ContactModel> extractFromImages(File front, File back) async {
    String fullText = '';

    // Process front
    final input1 = InputImage.fromFile(front);
    final result1 = await _recognizer.processImage(input1);
    fullText += result1.text + '\n';

    // Process back
    final input2 = InputImage.fromFile(back);
    final result2 = await _recognizer.processImage(input2);
    fullText += result2.text;

    return parseBusinessCardText(fullText);
  }

  void dispose() => _recognizer.close();
}
