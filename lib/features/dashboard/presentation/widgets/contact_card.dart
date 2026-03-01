import 'package:businesscardapp/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  final ContactModel contact;
  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00A896).withOpacity(0.08),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00A896), Color(0xFF4ECDC4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  // Avatar circle
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (contact.company.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            contact.company,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Contact details
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                children: [
                  if (contact.phone.isNotEmpty) ...[
                    ContactRow(
                      icon: Icons.phone_rounded,
                      text: contact.phone,
                      actions: [
                        _ActionButton(
                          icon: Icons.call_rounded,
                          color: const Color(0xFF00A896),
                          tooltip: 'Call',
                          onTap: () =>
                              launchUrl(Uri.parse("tel:${contact.phone}")),
                        ),
                        const SizedBox(width: 6),
                        _ActionButton(
                          icon: Icons.chat_rounded,
                          color: const Color(0xFF25D366),
                          tooltip: 'WhatsApp',
                          onTap: () => launchUrl(
                            Uri.parse(
                              "https://wa.me/${contact.phone.replaceAll('+', '').replaceAll(' ', '')}",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (contact.email.isNotEmpty) ...[
                    ContactRow(
                      icon: Icons.email_rounded,
                      text: contact.email,
                      actions: [
                        _ActionButton(
                          icon: Icons.send_rounded,
                          color: const Color(0xFF4ECDC4),
                          tooltip: 'Send email',
                          onTap: () =>
                              launchUrl(Uri.parse("mailto:${contact.email}")),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (contact.website.isNotEmpty) ...[
                    ContactRow(
                      icon: Icons.language_rounded,
                      text: contact.website,
                      actions: [
                        _ActionButton(
                          icon: Icons.open_in_new_rounded,
                          color: const Color(0xFF00A896),
                          tooltip: 'Open website',
                          onTap: () {
                            final url = contact.website.startsWith('http')
                                ? contact.website
                                : 'https://${contact.website}';
                            launchUrl(Uri.parse(url));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    // color: Colors.grey[400],
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Saved On ${DateFormat('dd MMM yyyy, hh:mm a').format(contact.date)}",
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).primaryColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<Widget> actions;

  const ContactRow({
    super.key,
    required this.icon,
    required this.text,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF00A896).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF00A896)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}
