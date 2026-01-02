import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/impostor_game/categories_section/categories_screen.dart';
import 'package:nightfall_project/impostor_game/leaderboards/leaderboards_screen.dart';
import 'package:nightfall_project/impostor_game/offline_db/category_service.dart';
import 'package:nightfall_project/impostor_game/offline_db/game_settings_service.dart';
import 'package:nightfall_project/impostor_game/offline_db/player_service.dart';
import 'package:nightfall_project/impostor_game/players_section/players_screen.dart';

class ImpostorGameLayout extends StatefulWidget {
  const ImpostorGameLayout({super.key});

  @override
  State<ImpostorGameLayout> createState() => _ImpostorGameLayoutState();
}

class _ImpostorGameLayoutState extends State<ImpostorGameLayout> {
  int _playerCount = 1;
  final PlayerService _playerService = PlayerService();

  int _categoryCount = 0;
  final CategoryService _categoryService = CategoryService();

  bool _hintsEnabled = true;
  final GameSettingsService _gameSettingsService = GameSettingsService();

  @override
  void initState() {
    super.initState();
    _loadPlayerCount();
    _loadCategoryCount();
    _loadHintsSettings();
  }

  Future<void> _loadPlayerCount() async {
    final players = await _playerService.loadPlayers();
    if (mounted) {
      setState(() {
        _playerCount = players.length;
      });
    }
  }

  Future<void> _loadCategoryCount() async {
    final selected = await _categoryService.loadSelectedCategoryIds();
    if (mounted) {
      setState(() {
        _categoryCount = selected.length;
      });
    }
  }

  Future<void> _loadHintsSettings() async {
    final enabled = await _gameSettingsService.loadHintsEnabled();
    if (mounted) {
      setState(() {
        _hintsEnabled = enabled;
      });
    }
  }

  Future<void> _toggleHints() async {
    final newValue = !_hintsEnabled;
    await _gameSettingsService.saveHintsEnabled(newValue);
    if (mounted) {
      setState(() {
        _hintsEnabled = newValue;
      });
    }
  }

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
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'IMPOSTOR GAME',
                                          style: GoogleFonts.pressStart2p(
                                            color: const Color(0xFFE0E1DD),
                                            fontSize: 15,
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
                                    // Empty SizedBox to balance the row roughly against the Back button
                                    const SizedBox(width: 2),
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
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      // Player Count Section
                                      GestureDetector(
                                        onTap: () async {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const PlayersScreen(),
                                            ),
                                          );
                                          _loadPlayerCount();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF1B263B,
                                            ).withOpacity(0.8),
                                            border: Border.all(
                                              color: const Color(0xFF415A77),
                                              width: 3,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'PLAYERS',
                                                style: GoogleFonts.vt323(
                                                  color: Colors.white70,
                                                  fontSize: 28,
                                                ),
                                              ),
                                              Text(
                                                '$_playerCount',
                                                style: GoogleFonts.vt323(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Categories Section
                                      GestureDetector(
                                        onTap: () async {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CategoriesScreen(),
                                            ),
                                          );
                                          _loadCategoryCount(); // This refreshes the count
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF1B263B,
                                            ).withOpacity(0.8),
                                            border: Border.all(
                                              color: const Color(0xFF415A77),
                                              width: 3,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'CATEGORIES',
                                                style: GoogleFonts.vt323(
                                                  color: Colors.white70,
                                                  fontSize: 28,
                                                ),
                                              ),
                                              Text(
                                                '$_categoryCount',
                                                style: GoogleFonts.vt323(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Leaderboards Section
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LeaderboardsScreen(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF1B263B,
                                            ).withOpacity(0.8),
                                            border: Border.all(
                                              color: const Color(0xFF415A77),
                                              width: 3,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'LEADERBOARDS',
                                                style: GoogleFonts.vt323(
                                                  color: Colors.white70,
                                                  fontSize: 28,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.leaderboard,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Hints Section
                                      GestureDetector(
                                        onTap: _toggleHints,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: _hintsEnabled
                                                ? const Color(
                                                    0xFF1B4332,
                                                  ).withOpacity(
                                                    0.8,
                                                  ) // Green-ish
                                                : const Color(
                                                    0xFF3D0C02,
                                                  ).withOpacity(0.8), // Red-ish
                                            border: Border.all(
                                              color: _hintsEnabled
                                                  ? const Color(0xFF52B788)
                                                  : const Color(0xFF9D0208),
                                              width: 3,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'HINTS',
                                                style: GoogleFonts.vt323(
                                                  color: Colors.white70,
                                                  fontSize: 28,
                                                ),
                                              ),
                                              Text(
                                                _hintsEnabled ? "ON" : "OFF",
                                                style: GoogleFonts.vt323(
                                                  color: _hintsEnabled
                                                      ? const Color(0xFF95D5B2)
                                                      : const Color(0xFFFFBA08),
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
