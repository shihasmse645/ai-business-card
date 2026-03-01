import 'package:businesscardapp/models/contact_model.dart';

ContactModel parseBusinessCardText(String rawText) {
  final lines = rawText
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  String name = lines.isNotEmpty ? lines[0] : '';
  String company = lines.length > 1 ? lines[1] : '';

  final emailReg = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
  final phoneReg = RegExp(
    r'[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{3,7}',
  );
  final webReg = RegExp(r'(https?://|www\.)[^\s]+');

  String email = '';
  String phone = '';
  String website = '';

  for (var line in lines) {
    if (email.isEmpty && emailReg.hasMatch(line)) {
      email = emailReg.firstMatch(line)!.group(0)!;
    }
    if (phone.isEmpty && phoneReg.hasMatch(line)) {
      phone = phoneReg.firstMatch(line)!.group(0)!;
    }
    if (website.isEmpty && webReg.hasMatch(line)) {
      website = webReg.firstMatch(line)!.group(0)!;
    }
  }

  return ContactModel(
    name: name,
    company: company,
    phone: phone.replaceAll(RegExp(r'[^0-9+]'), ''),
    email: email,
    website: website,
    // date: DateTime.now().toIso8601String().split('T')[0],
    date: DateTime.now(),
  );
}
