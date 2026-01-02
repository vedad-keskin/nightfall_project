import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';

class ImpostorGameLayout extends StatelessWidget {
  const ImpostorGameLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient Background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B263B), // Deep Midnight Blue
              Color(0xFF000000), // Pure Black
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header Section
                Row(
                  children: [
                    PixelButton(
                      label: 'BACK',
                      color: const Color(0xFF415A77),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'IMPOSTOR',
                          style: GoogleFonts.pressStart2p(
                            color: const Color(0xFFE0E1DD),
                            fontSize: 32,
                            shadows: [
                              const Shadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Balance the row if needed, or leave it asymmetric.
                    // To perfectly center title, we'd need an invisible widget of same size as button on right.
                    // For now, Expanded Center is good enough.
                    const SizedBox(
                      width: 80,
                    ), // Rough balance for the button width
                  ],
                ),
                const SizedBox(height: 24),

                // Game Area
                Expanded(
                  child: Container(
                    // Layer 1: Outer Shadow/Border
                    decoration: BoxDecoration(
                      color: const Color(0xFF000000),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(8, 8),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      // Layer 2: Metallic Frame
                      decoration: const BoxDecoration(
                        color: Color(0xFF778DA9),
                        border: Border.symmetric(
                          vertical: BorderSide(
                            color: Color(0xFF415A77),
                            width: 6,
                          ),
                          horizontal: BorderSide(
                            color: Color(0xFFE0E1DD),
                            width: 6,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Container(
                        // Layer 3: Inner Game Area
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF0D1B2A,
                          ).withOpacity(0.95), // Deep Dark Blue
                          border: Border.all(
                            color: Colors.black.withOpacity(0.8),
                            width: 4,
                          ),
                        ),
                        child: const Center(
                          // Placeholder for game content
                          child: Text(
                            "GAME AREA",
                            style: TextStyle(
                              color: Color(0xFFE0E1DD),
                              fontFamily: 'Courier',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
}
