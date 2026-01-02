import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';

class ImpostorGameLayout extends StatelessWidget {
  const ImpostorGameLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Layer
          const PixelStarfield(),

          // Foreground Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                          child: Column(
                            children: [
                              // Inner Header Section
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    PixelButton(
                                      label: 'BACK',
                                      color: const Color(0xFF415A77),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'IMPOSTOR GAME',
                                          style: GoogleFonts.pressStart2p(
                                            color: const Color(0xFFE0E1DD),
                                            fontSize: 23,
                                            shadows: [
                                              const Shadow(
                                                color: Colors.black,
                                                offset: Offset(4, 4),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ), // Balance right side roughly
                                  ],
                                ),
                              ),
                              // Pixel Divider
                              Container(
                                height: 4,
                                color: const Color(0xFF778DA9),
                                margin: const EdgeInsets.only(bottom: 16),
                              ),
                              // Main Game Content
                              const Expanded(
                                child: Center(
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PixelStarfield extends StatefulWidget {
  const PixelStarfield({super.key});

  @override
  State<PixelStarfield> createState() => _PixelStarfieldState();
}

class _PixelStarfieldState extends State<PixelStarfield>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Generate stars
    for (int i = 0; i < 50; i++) {
      _stars.add(
        Star(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextBool() ? 2 : 4,
          speed: 0.2 + _random.nextDouble() * 0.5,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarPainter(_stars, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Star {
  double x;
  double y;
  final double size;
  final double speed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1B263B), // Deep Midnight Blue
          Color(0xFF000000), // Pure Black
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final starPaint = Paint()..color = Colors.white.withOpacity(0.4);

    for (var star in stars) {
      // Calculate animated Y position
      // Move downwards
      double currentY = (star.y + (animationValue * star.speed)) % 1.0;

      canvas.drawRect(
        Rect.fromLTWH(
          star.x * size.width,
          currentY * size.height,
          star.size,
          star.size,
        ),
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) => true;
}
