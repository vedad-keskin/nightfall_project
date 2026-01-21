import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_starfield_background.dart';
import 'package:nightfall_project/services/sound_settings_service.dart';
import 'package:provider/provider.dart';

class NightfallIntroScreen extends StatefulWidget {
  final Widget next;
  final Duration totalDuration;
  final String? introSoundAsset; // ex: 'audio/werewolves/wolf_howl.mp3'

  const NightfallIntroScreen({
    super.key,
    required this.next,
    this.totalDuration = const Duration(milliseconds: 3200),
    this.introSoundAsset = 'audio/werewolves/wolf_howl.mp3',
  });

  @override
  State<NightfallIntroScreen> createState() => _NightfallIntroScreenState();
}

class _NightfallIntroScreenState extends State<NightfallIntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _navTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.totalDuration)
      ..forward();

    // Fire-and-forget intro sting (respects mute).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final asset = widget.introSoundAsset;
      if (asset == null || asset.isEmpty) return;
      // In tests (or if used standalone), SoundSettingsService may not be provided.
      try {
        final sound = Provider.of<SoundSettingsService>(context, listen: false);
        // ignore: discarded_futures
        sound.playGlobal(asset, loop: false);
      } catch (_) {
        // No-op: sound is optional for this intro.
      }
    });

    _navTimer = Timer(widget.totalDuration + const Duration(milliseconds: 250), () {
      _goNext();
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    if (!mounted || _navigated) return;
    _navigated = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: widget.next,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _goNext, // allow skipping
        child: Stack(
          children: [
            const Positioned.fill(child: PixelStarfieldBackground()),
            // Subtle vignette / mood.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.15),
                    radius: 1.1,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
            ),
            // Scanlines + glitch flicker overlay.
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value;
                  final flicker = (sin(t * pi * 18) * 0.5 + 0.5);
                  final opacity = (t < 0.15)
                      ? (t / 0.15)
                      : (t > 0.92)
                          ? ((1 - t) / 0.08)
                          : 1.0;
                  return CustomPaint(
                    painter: _ScanlineGlitchPainter(
                      time: t,
                      flicker: flicker,
                      opacity: opacity.clamp(0.0, 1.0),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final t = _controller.value;

                    // Logo pops in quickly, then settles.
                    final logoScale = _easeOutBack(_interval(t, 0.08, 0.42));
                    final logoFade = _easeOut(_interval(t, 0.02, 0.25));

                    // Title "glitch" offset.
                    final jitterPhase = (sin(t * pi * 26) * 0.5 + 0.5);
                    final jitter = (t > 0.18 && t < 0.68) ? (jitterPhase * 2.0) : 0.0;

                    // Progress bar fills.
                    final progress = _easeInOut(_interval(t, 0.18, 0.92));

                    // Fade everything out at the end (so transition looks clean).
                    final overallFade = (t > 0.9)
                        ? (1.0 - _easeIn(_interval(t, 0.9, 1.0)))
                        : 1.0;

                    return Opacity(
                      opacity: overallFade.clamp(0.0, 1.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Opacity(
                            opacity: logoFade.clamp(0.0, 1.0),
                            child: Transform.scale(
                              scale: (0.75 + 0.25 * logoScale).clamp(0.0, 1.2),
                              child: _PixelLogoFrame(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.asset(
                                    'assets/images/logo.jpg',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          _GlitchTitle(
                            text: 'NIGHTFALL',
                            jitter: jitter,
                            intensity: _interval(t, 0.16, 0.7),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'PROJECT',
                            style: GoogleFonts.pressStart2p(
                              fontSize: 14,
                              color: const Color(0xFFE0E1DD).withOpacity(0.8),
                              shadows: const [
                                Shadow(color: Colors.black, offset: Offset(2, 2)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 34),
                          _PixelProgressBar(value: progress),
                          const SizedBox(height: 12),
                          _LoadingText(phase: t),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PixelLogoFrame extends StatelessWidget {
  final Widget child;
  const _PixelLogoFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            offset: const Offset(10, 10),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF778DA9).withOpacity(0.95),
          border: Border.all(color: const Color(0xFFE0E1DD).withOpacity(0.85), width: 2),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D1B2A),
            border: Border.all(color: Colors.black.withOpacity(0.65), width: 2),
          ),
          padding: const EdgeInsets.all(6),
          child: child,
        ),
      ),
    );
  }
}

class _GlitchTitle extends StatelessWidget {
  final String text;
  final double jitter;
  final double intensity;

  const _GlitchTitle({
    required this.text,
    required this.jitter,
    required this.intensity,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.pressStart2p(
      fontSize: 22,
      color: const Color(0xFFE0E1DD),
      shadows: const [
        Shadow(color: Colors.black, offset: Offset(2, 2)),
      ],
    );

    final amp = (intensity.clamp(0.0, 1.0)) * 1.8;

    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: Offset(-jitter * amp, 0),
          child: Text(text, style: baseStyle.copyWith(color: Colors.redAccent.withOpacity(0.65))),
        ),
        Transform.translate(
          offset: Offset(jitter * amp, 0),
          child: Text(text, style: baseStyle.copyWith(color: Colors.lightBlueAccent.withOpacity(0.55))),
        ),
        Text(text, style: baseStyle),
      ],
    );
  }
}

class _PixelProgressBar extends StatelessWidget {
  final double value;
  const _PixelProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return Container(
      width: 260,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            offset: const Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          border: Border.all(color: const Color(0xFF415A77), width: 2),
        ),
        padding: const EdgeInsets.all(2),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: max(0.02, v),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF778DA9),
                border: Border.all(color: const Color(0xFFE0E1DD).withOpacity(0.85), width: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingText extends StatelessWidget {
  final double phase;
  const _LoadingText({required this.phase});

  @override
  Widget build(BuildContext context) {
    final dots = ((phase * 6).floor() % 4);
    final dotStr = List.filled(dots, '.').join();
    return Text(
      'loading$dotStr',
      style: GoogleFonts.vt323(
        fontSize: 22,
        color: const Color(0xFFE0E1DD).withOpacity(0.7),
        fontWeight: FontWeight.bold,
        shadows: const [Shadow(color: Colors.black, offset: Offset(1, 1))],
      ),
    );
  }
}

class _ScanlineGlitchPainter extends CustomPainter {
  final double time;
  final double flicker;
  final double opacity;

  _ScanlineGlitchPainter({
    required this.time,
    required this.flicker,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || opacity <= 0) return;

    // Scanlines.
    final scanPaint = Paint()..color = Colors.white.withOpacity(0.04 * opacity);
    const gap = 6.0;
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), scanPaint);
    }

    // Occasional horizontal glitch bars.
    final burst = (time > 0.18 && time < 0.55) ? (0.35 + 0.65 * flicker) : 0.0;
    final barCount = (burst * 6).floor();
    if (barCount > 0) {
      final barPaint = Paint()..color = Colors.black.withOpacity(0.18 * opacity);
      for (int i = 0; i < barCount; i++) {
        final y = _noise(size.height, i, time) * size.height;
        final h = 8 + (_noise(20, i + 9, time) * 18);
        final dx = (_noise(1, i + 19, time) - 0.5) * 18;
        canvas.save();
        canvas.translate(dx, 0);
        canvas.drawRect(Rect.fromLTWH(0, y, size.width, h), barPaint);
        canvas.restore();
      }
    }

    // Tiny vignette flicker.
    final fogPaint = Paint()
      ..color = Colors.black.withOpacity((0.06 + 0.06 * flicker) * opacity);
    canvas.drawRect(Offset.zero & size, fogPaint);
  }

  double _noise(double scale, int seed, double t) {
    // Deterministic-ish noise: seed + time (Random has no reseed API).
    final r = Random(1337 + seed + (t * 1000).floor());
    return r.nextDouble() * scale / max(1.0, scale);
  }

  @override
  bool shouldRepaint(covariant _ScanlineGlitchPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.flicker != flicker ||
        oldDelegate.opacity != opacity;
  }
}

double _interval(double t, double start, double end) {
  if (t <= start) return 0;
  if (t >= end) return 1;
  return (t - start) / (end - start);
}

double _easeOut(double x) => 1 - pow(1 - x, 2).toDouble();
double _easeIn(double x) => pow(x, 2).toDouble();
double _easeInOut(double x) => x < 0.5
    ? 2 * x * x
    : 1 - pow(-2 * x + 2, 2).toDouble() / 2;

double _easeOutBack(double x) {
  const c1 = 1.70158;
  const c3 = c1 + 1;
  return 1 + c3 * pow(x - 1, 3).toDouble() + c1 * pow(x - 1, 2).toDouble();
}

