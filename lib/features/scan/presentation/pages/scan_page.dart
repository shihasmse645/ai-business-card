import 'package:businesscardapp/features/scan/presentation/widgets/extracted_data_card.dart';
import 'package:businesscardapp/features/scan/presentation/widgets/image_preview_widget.dart';
import 'package:businesscardapp/features/scan/scan_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(
      builder: (context, provider, child) {
        final hasExtracted = provider.extractedContact != null;
        final hasAnyImage =
            provider.frontImage != null || provider.backImage != null;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text('AI Business Card Scanner'),
            actions: [
              if (hasAnyImage || hasExtracted)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    tooltip: 'Clear all',
                    onPressed: provider.clear,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions banner (shown when no images yet)
                if (!hasAnyImage) ...[
                  _InstructionsBanner(),
                  const SizedBox(height: 20),
                ],
                ImageCardWidget(
                  title: 'Front Side',
                  image: provider.frontImage,
                  isFront: true,
                  provider: provider,
                ),
                ImageCardWidget(
                  title: 'Back Side',
                  image: provider.backImage,
                  isFront: false,
                  provider: provider,
                ),

                const SizedBox(height: 24),

                // Extract / Clear button
                _PrimaryActionButton(
                  isLoading: provider.isLoading,
                  hasExtracted: hasExtracted,
                  onExtract: provider.extractText,
                  onClear: provider.clear,
                  enabled: hasAnyImage,
                ),

                // Extracted data section
                ExtractedContactSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Instructions Banner ──────────────────────────────────────────────────────

class _InstructionsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00A896).withOpacity(0.08),
            const Color(0xFF4ECDC4).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00A896).withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF00A896).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.tips_and_updates_rounded,
              color: Color(0xFF00A896),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How it works',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Upload front & back of a business card, then tap Extract Data to scan with AI.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Primary Action Button ────────────────────────────────────────────────────

class _PrimaryActionButton extends StatelessWidget {
  final bool isLoading;
  final bool hasExtracted;
  final bool enabled;
  final VoidCallback onExtract;
  final VoidCallback onClear;

  const _PrimaryActionButton({
    required this.isLoading,
    required this.hasExtracted,
    required this.enabled,
    required this.onExtract,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !enabled && !hasExtracted;

    return GestureDetector(
      onTap: isLoading
          ? null
          : isDisabled
          ? null
          : hasExtracted
          ? onClear
          : onExtract,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 54,
        decoration: BoxDecoration(
          gradient: isDisabled || isLoading
              ? null
              : hasExtracted
              ? const LinearGradient(
                  colors: [Color(0xFFE74C3C), Color(0xFFFF6B6B)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFF00A896), Color(0xFF4ECDC4)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isDisabled || isLoading ? const Color(0xFFE2E8F0) : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isDisabled || isLoading
              ? []
              : [
                  BoxShadow(
                    color:
                        (hasExtracted
                                ? const Color(0xFFE74C3C)
                                : const Color(0xFF00A896))
                            .withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
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
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Row(
                    key: ValueKey(hasExtracted),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        hasExtracted
                            ? Icons.delete_sweep_rounded
                            : Icons.auto_awesome_rounded,
                        color: isDisabled
                            ? const Color(0xFF94A3B8)
                            : Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        hasExtracted ? 'Clear Extracted Data' : 'Extract Data',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDisabled
                              ? const Color(0xFF94A3B8)
                              : Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
