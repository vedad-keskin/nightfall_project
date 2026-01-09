import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:nightfall_project/services/language_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nightfall_project/services/sound_settings_service.dart';

/// Represents the alliance the Gambler bet on
enum GamblerBet {
  village, // +1 point if Village wins
  werewolves, // +2 points if Werewolves win
  specials, // +3 points if Specials (Jester) wins
}

class GamblerBetDialog extends StatefulWidget {
  final String playerName;
  final Function(GamblerBet) onBetConfirmed;

  const GamblerBetDialog({
    super.key,
    required this.playerName,
    required this.onBetConfirmed,
  });

  @override
  State<GamblerBetDialog> createState() => _GamblerBetDialogState();
}

class _GamblerBetDialogState extends State<GamblerBetDialog>
    with TickerProviderStateMixin {
  // Default to village selected
  GamblerBet _selectedBet = GamblerBet.village;
  bool _isRolling = false;
  bool _betConfirmed = false;
  final Random _random = Random();

  // Carousel state
  late PageController _pageController;
  int _currentPageIndex = 0;
  final List<GamblerBet> _bets = [
    GamblerBet.village,
    GamblerBet.werewolves,
    GamblerBet.specials,
  ];

  // Animation Controllers
  late AnimationController _diceController;
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  // Dice face values for animation
  int _dice1 = 1;
  int _dice2 = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);

    _diceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _diceController.addListener(_onDiceRoll);

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  void _onDiceRoll() {
    if (_isRolling) {
      setState(() {
        _dice1 = _random.nextInt(6) + 1;
        _dice2 = _random.nextInt(6) + 1;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _diceController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> _playDiceSound() async {
    if (context.read<SoundSettingsService>().isMuted) return;
    final player = AudioPlayer();
    try {
      await player.play(AssetSource('audio/werewolves/dice_roll.mp3'));
    } catch (e) {
      debugPrint('Dice sound not available: $e');
    }
  }

  Future<void> _confirmBet() async {
    setState(() {
      _isRolling = true;
    });

    _playDiceSound();
    _diceController.forward();

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isRolling = false;
      _betConfirmed = true;
    });

    await Future.delayed(const Duration(milliseconds: 2000));

    widget.onBetConfirmed(_selectedBet);
  }

  Color _getBetColor(GamblerBet bet) {
    switch (bet) {
      case GamblerBet.village:
        return const Color(0xFF52B788); // Green
      case GamblerBet.werewolves:
        return const Color(0xFFE63946); // Red
      case GamblerBet.specials:
        return const Color(0xFF9D4EDD); // Purple
    }
  }

  String _getBetLabel(GamblerBet bet) {
    final lang = context.read<LanguageService>();
    switch (bet) {
      case GamblerBet.village:
        return lang.translate('gambler_bet_village');
      case GamblerBet.werewolves:
        return lang.translate('gambler_bet_werewolves');
      case GamblerBet.specials:
        return lang.translate('gambler_bet_specials');
    }
  }

  String _getBetReward(GamblerBet bet) {
    final lang = context.read<LanguageService>();
    switch (bet) {
      case GamblerBet.village:
        return lang.translate('gambler_village_reward');
      case GamblerBet.werewolves:
        return lang.translate('gambler_werewolves_reward');
      case GamblerBet.specials:
        return lang.translate('gambler_specials_reward');
    }
  }

  IconData _getBetIcon(GamblerBet bet) {
    switch (bet) {
      case GamblerBet.village:
        return Icons.home; // Shield - protection, villagers defending
      case GamblerBet.werewolves:
        return Icons.pets; // Paw - werewolves
      case GamblerBet.specials:
        return Icons.auto_awesome; // Stars - special/magical
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 340,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          border: Border.all(
            color: const Color(0xFFD4AF37),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(6, 6),
              blurRadius: 0,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF415A77), width: 2),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with ornate design
              _buildOrnateHeader(),
              const SizedBox(height: 8),

              // Player name
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.playerName.toUpperCase(),
                  style: GoogleFonts.vt323(
                    color: const Color(0xFFD4AF37),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                lang.translate('gambler_bet_title'),
                style: GoogleFonts.pressStart2p(
                  color: const Color(0xFFD4AF37),
                  fontSize: 14,
                  shadows: [
                    const Shadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                lang.translate('gambler_bet_subtitle'),
                style: GoogleFonts.vt323(
                  color: Colors.white60,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Dice decoration
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDice(_dice1),
                  const SizedBox(width: 16),
                  _buildDice(_dice2),
                ],
              ),
              const SizedBox(height: 16),

              // Bet options - Carousel or Confirmed display
              if (!_betConfirmed) ...[
                _buildCarousel(),
                const SizedBox(height: 16),
                _buildConfirmButton(),
              ] else ...[
                _buildConfirmedBetDisplay(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrnateHeader() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCornerOrnament(false),
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFD4AF37).withOpacity(0),
                    Color.lerp(
                      const Color(0xFFD4AF37),
                      const Color(0xFFFFD700),
                      _pulseController.value,
                    )!,
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Center diamond with glow
            Transform.rotate(
              angle: pi / 4,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  border: Border.all(color: const Color(0xFF8B6914), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37)
                          .withOpacity(0.3 + _pulseController.value * 0.4),
                      blurRadius: 6 + _pulseController.value * 4,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.lerp(
                      const Color(0xFFD4AF37),
                      const Color(0xFFFFD700),
                      _pulseController.value,
                    )!,
                    const Color(0xFFD4AF37).withOpacity(0),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildCornerOrnament(true),
          ],
        );
      },
    );
  }

  Widget _buildCornerOrnament(bool flip) {
    return Transform(
      transform:
          flip ? (Matrix4.identity()..scale(-1.0, 1.0)) : Matrix4.identity(),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 20,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD4AF37),
                  const Color(0xFFD4AF37).withOpacity(0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDice(int value) {
    return AnimatedBuilder(
      animation: _diceController,
      builder: (context, child) {
        // Create realistic 3D tumbling effect
        final progress = _diceController.value;
        final bounceY = _isRolling ? sin(progress * pi * 6) * 8 * (1 - progress) : 0.0;
        final rotateX = _isRolling ? progress * pi * 4 : 0.0;
        final rotateZ = _isRolling ? progress * pi * 3 : 0.0;
        final scale = _isRolling ? 1.0 + sin(progress * pi * 4) * 0.15 * (1 - progress) : 1.0;

        return Transform.translate(
          offset: Offset(0, -bounceY),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateX(rotateX)
              ..rotateZ(rotateZ)
              ..scale(scale),
            alignment: Alignment.center,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFFFBF0),
                    const Color(0xFFF5EED9),
                    const Color(0xFFE8DFC8),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF3D2914), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(3 + bounceY * 0.2, 3 + bounceY * 0.3),
                    blurRadius: _isRolling ? 4 : 0,
                  ),
                  if (_isRolling)
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: _buildDiceFace(value),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiceFace(int value) {
    // Create dot positions for each dice face
    List<Alignment> dots = [];
    switch (value) {
      case 1:
        dots = [Alignment.center];
        break;
      case 2:
        dots = [
          const Alignment(-0.5, -0.5),
          const Alignment(0.5, 0.5),
        ];
        break;
      case 3:
        dots = [
          const Alignment(-0.5, -0.5),
          Alignment.center,
          const Alignment(0.5, 0.5),
        ];
        break;
      case 4:
        dots = [
          const Alignment(-0.5, -0.5),
          const Alignment(0.5, -0.5),
          const Alignment(-0.5, 0.5),
          const Alignment(0.5, 0.5),
        ];
        break;
      case 5:
        dots = [
          const Alignment(-0.5, -0.5),
          const Alignment(0.5, -0.5),
          Alignment.center,
          const Alignment(-0.5, 0.5),
          const Alignment(0.5, 0.5),
        ];
        break;
      case 6:
        dots = [
          const Alignment(-0.5, -0.6),
          const Alignment(0.5, -0.6),
          const Alignment(-0.5, 0.0),
          const Alignment(0.5, 0.0),
          const Alignment(-0.5, 0.6),
          const Alignment(0.5, 0.6),
        ];
        break;
    }

    return Stack(
      children: dots.map((alignment) {
        return Align(
          alignment: alignment,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2D1810),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        // Swipeable carousel
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
                // Auto-select when swiped
                _selectedBet = _bets[index];
              });
            },
            itemCount: _bets.length,
            itemBuilder: (context, index) {
              return _buildCarouselCard(_bets[index], index);
            },
          ),
        ),
        const SizedBox(height: 12),
        // Circle indicators
        _buildPageIndicators(),
        const SizedBox(height: 6),
        // Swipe hint
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.4 + _pulseController.value * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chevron_left,
                    color: Color(0xFFD4AF37),
                    size: 16,
                  ),
                  Text(
                    'SWIPE',
                    style: GoogleFonts.vt323(
                      color: const Color(0xFFD4AF37),
                      fontSize: 14,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFD4AF37),
                    size: 16,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_bets.length, (index) {
        final bet = _bets[index];
        final isCurrentPage = index == _currentPageIndex;
        final color = _getBetColor(bet);

        return GestureDetector(
          onTap: () {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: isCurrentPage ? 12 : 8,
            height: isCurrentPage ? 12 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrentPage ? color : const Color(0xFF415A77),
              border: Border.all(
                color: isCurrentPage ? Colors.white : const Color(0xFF415A77),
                width: 2,
              ),
              boxShadow: isCurrentPage
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.6),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCarouselCard(GamblerBet bet, int index) {
    final isSelected = _selectedBet == bet;
    final isCurrent = index == _currentPageIndex;
    final color = _getBetColor(bet);

    return AnimatedBuilder(
      animation: Listenable.merge([_glowController, _rotateController]),
      builder: (context, child) {
        return AnimatedScale(
          scale: isCurrent ? 1.0 : 0.85,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: isCurrent ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating rune circle behind card (only for current)
                  if (isCurrent)
                    Transform.rotate(
                      angle: _rotateController.value * 2 * pi,
                      child: CustomPaint(
                        size: const Size(150, 150),
                        painter: _RuneCirclePainter(
                          color: color.withOpacity(0.2 + _glowController.value * 0.1),
                        ),
                      ),
                    ),

                  // Main card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(isSelected ? 0.4 : 0.2),
                          color.withOpacity(isSelected ? 0.2 : 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? color : color.withOpacity(0.5),
                        width: isSelected ? 3 : 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(4, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with glow
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : color,
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: color.withOpacity(
                                          0.4 + _glowController.value * 0.3),
                                      blurRadius:
                                          10 + _glowController.value * 8,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            _getBetIcon(bet),
                            color: isSelected ? Colors.white : color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Alliance name
                        Text(
                          _getBetLabel(bet),
                          style: GoogleFonts.pressStart2p(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),

                        // Reward badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.6),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getBetReward(bet),
                            style: GoogleFonts.pressStart2p(
                              color: Colors.amber,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: !_isRolling ? _confirmBet : null,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.2),
              border: Border.all(
                color: Color.lerp(
                  const Color(0xFFD4AF37),
                  const Color(0xFFFFD700),
                  _pulseController.value,
                )!,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37)
                      .withOpacity(0.2 + _pulseController.value * 0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isRolling ? Icons.casino : Icons.casino_outlined,
                  color: const Color(0xFFD4AF37),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _isRolling
                      ? '...'
                      : context
                          .read<LanguageService>()
                          .translate('gambler_roll_dice'),
                  style: GoogleFonts.pressStart2p(
                    color: const Color(0xFFD4AF37),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfirmedBetDisplay() {
    final color = _getBetColor(_selectedBet);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  border: Border.all(color: color, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      _getBetIcon(_selectedBet),
                      color: color,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getBetLabel(_selectedBet),
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getBetReward(_selectedBet),
                      style: GoogleFonts.vt323(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.read<LanguageService>().translate('gambler_fate_sealed'),
                style: GoogleFonts.pressStart2p(
                  color: const Color(0xFFD4AF37),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Custom painter for mystical rune circle
class _RuneCirclePainter extends CustomPainter {
  final Color color;

  _RuneCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw main circle
    canvas.drawCircle(center, radius, paint);

    // Draw inner circle
    canvas.drawCircle(center, radius * 0.75, paint);

    // Draw rune marks around the circle
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final x1 = center.dx + cos(angle) * (radius - 5);
      final y1 = center.dy + sin(angle) * (radius - 5);
      final x2 = center.dx + cos(angle) * (radius * 0.75 + 5);
      final y2 = center.dy + sin(angle) * (radius * 0.75 + 5);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

      // Small diamond shapes at each point
      final diamondX = center.dx + cos(angle) * radius;
      final diamondY = center.dy + sin(angle) * radius;
      final path = Path()
        ..moveTo(diamondX, diamondY - 4)
        ..lineTo(diamondX + 3, diamondY)
        ..lineTo(diamondX, diamondY + 4)
        ..lineTo(diamondX - 3, diamondY)
        ..close();
      canvas.drawPath(path, paint..style = PaintingStyle.fill);
      paint.style = PaintingStyle.stroke;
    }
  }

  @override
  bool shouldRepaint(covariant _RuneCirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
