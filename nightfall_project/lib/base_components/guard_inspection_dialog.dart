import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_button.dart';
import 'package:nightfall_project/services/language_service.dart';
import 'package:provider/provider.dart';

class GuardInspectionDialog extends StatelessWidget {
  final String playerName;
  final bool isWerewolf;
  final VoidCallback onClose;

  const GuardInspectionDialog({
    super.key,
    required this.playerName,
    required this.isWerewolf,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();

    // Alliance Visuals
    final String imagePath = isWerewolf
        ? 'assets/images/guard_werewolves.png'
        : 'assets/images/guard_villagers.png';

    final Color primaryColor = isWerewolf
        ? const Color(0xFFE63946) // Red for Werewolves
        : const Color(0xFF06D6A0); // Green for Villagers

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 450),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          border: Border.all(color: primaryColor, width: 4),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: primaryColor.withOpacity(0.2),
              child: Text(
                lang.translate('royal_guard_check').toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.pressStart2p(
                  color: primaryColor,
                  fontSize: 14,
                ),
              ),
            ),

            // Image Content
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      playerName.toUpperCase(),
                      style: GoogleFonts.vt323(
                        color: Colors.white,
                        fontSize: 32,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isWerewolf
                          ? lang.translate('target_is_werewolf')
                          : lang.translate('target_is_villager'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.vt323(
                        color: primaryColor,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Image with 880x1034 aspect ratio
                    AspectRatio(
                      aspectRatio: 880 / 1034,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primaryColor.withOpacity(0.5),
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: PixelButton(
                label: lang.translate(
                  'understood',
                ), // We'll need to check if this key exists or use a fallback
                color: primaryColor.withOpacity(0.8),
                onPressed: onClose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
