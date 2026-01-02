import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PixelTeamDialog extends StatelessWidget {
  const PixelTeamDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black, // Outer black border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(8, 8),
              blurRadius: 0,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF778DA9), // Metallic frame
            border: Border.symmetric(
              vertical: const BorderSide(color: Color(0xFF415A77), width: 4),
              horizontal: const BorderSide(color: Color(0xFFE0E1DD), width: 4),
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            color: const Color(0xFF0D1B2A), // Dark blueprint background
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle('NIGHTFALL PROJECT'),
                const SizedBox(height: 8),
                _buildSubtitle('TEAM'),
                const SizedBox(height: 24),
                _buildCreditRow('Developer', 'Vedad Keskin'),
                const SizedBox(height: 16),
                _buildCreditRow('Design & Art', 'Nidal Keskin'),
                _buildCreditRow('', 'Iman-Bejana Keskin'),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    '[ CLOSE ]',
                    style: GoogleFonts.pressStart2p(
                      color: const Color(0xFFE0E1DD),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.pressStart2p(
        color: const Color(0xFFE0E1DD),
        fontSize: 18,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      style: GoogleFonts.pressStart2p(
        color: const Color(0xFF415A77),
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCreditRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (label.isNotEmpty)
            Text(
              label.toUpperCase(),
              style: GoogleFonts.vt323(
                color: const Color(0xFF415A77),
                fontSize: 16,
              ),
            ),
          Text(
            value,
            style: GoogleFonts.vt323(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
