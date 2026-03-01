import 'package:businesscardapp/features/dashboard/dashboard_provider.dart';
import 'package:businesscardapp/features/scan/scan_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExtractedContactSection extends StatelessWidget {
  const ExtractedContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(
      builder: (context, provider, child) {
        final contact = provider.extractedContact;
        if (contact == null) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),

            // Section header
            Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00A896), Color(0xFF4ECDC4)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Extracted Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A896).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Editable',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF00A896),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Fields card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00A896).withOpacity(0.07),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTextField(
                    label: 'Name',
                    value: contact.name,
                    icon: Icons.person_rounded,
                    onChanged: (v) =>
                        provider.update(contact.copyWith(name: v)),
                  ),
                  _buildTextField(
                    label: 'Company',
                    value: contact.company,
                    icon: Icons.business_rounded,
                    onChanged: (v) =>
                        provider.update(contact.copyWith(company: v)),
                  ),
                  _buildTextField(
                    label: 'Phone',
                    value: contact.phone,
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                    onChanged: (v) =>
                        provider.update(contact.copyWith(phone: v)),
                  ),
                  _buildTextField(
                    label: 'Email',
                    value: contact.email,
                    icon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (v) =>
                        provider.update(contact.copyWith(email: v)),
                  ),
                  _buildTextField(
                    label: 'Website',
                    value: contact.website,
                    icon: Icons.language_rounded,
                    keyboardType: TextInputType.url,
                    onChanged: (v) =>
                        provider.update(contact.copyWith(website: v)),
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Save button
            // _SaveButton(provider: provider),
            GestureDetector(
              // onTap: provider.isLoading ? null : provider.saveContact,
              onTap: provider.isLoading
                  ? null
                  : () async {
                      final success = await provider.saveContact();

                      if (success) {
                        context.read<DashboardProvider>().loadContacts();
                      }
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 54,
                decoration: BoxDecoration(
                  gradient: provider.isLoading
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xFF00A896), Color(0xFF4ECDC4)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                  color: provider.isLoading ? const Color(0xFFE2E8F0) : null,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: provider.isLoading
                      ? []
                      : [
                          BoxShadow(
                            color: const Color(0xFF00A896).withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Center(
                  child: provider.isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF94A3B8),
                            ),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Save to Google Sheets',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required IconData icon,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: TextFormField(
        initialValue: value,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 13,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF00A896).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF00A896)),
          ),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00A896), width: 2),
          ),
        ),
      ),
    );
  }
}
