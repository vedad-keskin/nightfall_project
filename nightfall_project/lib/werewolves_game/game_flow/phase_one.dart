import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/werewolves_game/offline_db/role_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/player_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/alliance_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/game_settings_service.dart';

class WerewolfPhaseOneScreen extends StatefulWidget {
  const WerewolfPhaseOneScreen({super.key});

  @override
  State<WerewolfPhaseOneScreen> createState() => _WerewolfPhaseOneScreenState();
}

class _WerewolfPhaseOneScreenState extends State<WerewolfPhaseOneScreen> {
  final WerewolfRoleService _roleService = WerewolfRoleService();
  final WerewolfPlayerService _playerService = WerewolfPlayerService();
  final WerewolfAllianceService _allianceService = WerewolfAllianceService();
  final WerewolfGameSettingsService _settingsService =
      WerewolfGameSettingsService();

  late List<WerewolfRole> _availableRoles;
  final Map<int, int> _roleCounts = {};
  int _totalPlayers = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final players = await _playerService.loadPlayers();
    final allRoles = _roleService.getRoles();
    _totalPlayers = players.length;

    // Exclude Avenging Twin (ID 7)
    _availableRoles = allRoles.where((role) => role.id != 7).toList();

    // Load saved settings
    final savedRoles = await _settingsService.loadSelectedRoles(_totalPlayers);

    setState(() {
      if (savedRoles != null) {
        // Use saved roles
        for (var role in _availableRoles) {
          _roleCounts[role.id] = savedRoles[role.id] ?? 0;
        }
      } else {
        // Generate random roles
        _generateRandomSelection();
      }
      _isLoading = false;
    });
  }

  void _generateRandomSelection() {
    // Reset
    for (var role in _availableRoles) {
      _roleCounts[role.id] = 0;
    }

    final random = Random();
    int assigned = 0;

    // 1. Mandatory Aggressor (Werewolf or Vampire)
    // We prioritize Werewolf (ID 2) for simplicity in random start
    _roleCounts[2] = 1;
    assigned++;

    // 2. Randomly fill special roles if enough space
    final specialRoles = _availableRoles
        .where((r) => r.id != 1 && r.id != 2)
        .toList();
    specialRoles.shuffle();

    for (var role in specialRoles) {
      if (assigned >= _totalPlayers - 1)
        break; // Keep room for at least one villager

      // Special rule: Twins (ID 6) need 2 slots
      if (role.id == 6) {
        if (assigned <= _totalPlayers - 3 && random.nextBool()) {
          _roleCounts[6] = 2;
          assigned += 2;
        }
      } else {
        // Others (0-1)
        if (random.nextBool()) {
          _roleCounts[role.id] = 1;
          assigned++;
        }
      }
    }

    // 3. Fill the rest with Villagers
    _roleCounts[1] = _totalPlayers - assigned;
  }

  int get _selectedRoleCount =>
      _roleCounts.values.fold(0, (sum, count) => sum + count);

  bool get _isBalanceValid {
    final werewolfCount = _roleCounts[2] ?? 0;
    final vampireCount = _roleCounts[8] ?? 0;
    return (werewolfCount + vampireCount) >= 1;
  }

  bool get _canProceed {
    return _selectedRoleCount == _totalPlayers && _isBalanceValid;
  }

  void _updateRoleCount(int roleId, int delta) {
    setState(() {
      final currentCount = _roleCounts[roleId] ?? 0;

      // Specialized logic for Twins (ID 6): 0 or 2
      if (roleId == 6) {
        if (delta > 0) {
          _roleCounts[6] = 2;
        } else {
          _roleCounts[6] = 0;
        }
      } else {
        // Standard logic
        int newCount = currentCount + delta;
        if (newCount < 0) return;

        // Werewolves: 1-3
        if (roleId == 2 && newCount > 3) return;

        // Others (excluding Villagers): 0-1
        if (roleId != 1 && roleId != 2 && newCount > 1) return;

        _roleCounts[roleId] = newCount;
      }

      // Save changes immediately
      _settingsService.saveSelectedRoles(_roleCounts, _totalPlayers);
    });
  }

  Color _getAllianceColor(int allianceId) {
    switch (allianceId) {
      case 1:
        return Colors.blueAccent;
      case 2:
        return Colors.redAccent;
      case 3:
        return Colors.purpleAccent;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const PixelStarfield(),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      PixelButton(
                        label: 'BACK',
                        color: const Color(0xFF415A77),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'PREPARE GAME',
                          style: GoogleFonts.pressStart2p(
                            color: Colors.white,
                            fontSize: 18,
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
                    ],
                  ),
                ),

                // Player Info Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  color: Colors.redAccent.withOpacity(0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PLAYERS: $_totalPlayers',
                        style: GoogleFonts.vt323(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'SELECTED: $_selectedRoleCount',
                        style: GoogleFonts.vt323(
                          color: _selectedRoleCount == _totalPlayers
                              ? Colors.greenAccent
                              : Colors.amberAccent,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Roles List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _availableRoles.length,
                    itemBuilder: (context, index) {
                      final role = _availableRoles[index];
                      final count = _roleCounts[role.id] ?? 0;
                      final alliance = _allianceService.getAllianceById(
                        role.allianceId,
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B263B).withOpacity(0.8),
                          border: Border.all(
                            color: const Color(0xFF415A77),
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _getAllianceColor(role.allianceId),
                                width: 2,
                              ),
                            ),
                            child: Image.asset(
                              role.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            role.name.toUpperCase(),
                            style: GoogleFonts.pressStart2p(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            alliance?.name.toUpperCase() ?? '',
                            style: GoogleFonts.vt323(
                              color: _getAllianceColor(role.allianceId),
                              fontSize: 16,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildCounterButton(
                                Icons.remove,
                                () => _updateRoleCount(role.id, -1),
                              ),
                              Container(
                                width: 40,
                                child: Center(
                                  child: Text(
                                    '$count',
                                    style: GoogleFonts.pressStart2p(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              _buildCounterButton(
                                Icons.add,
                                () => _updateRoleCount(role.id, 1),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Footer Validation & Proceed
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1B2A),
                    border: Border(
                      top: BorderSide(color: const Color(0xFF778DA9), width: 4),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (_selectedRoleCount != _totalPlayers)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            _selectedRoleCount < _totalPlayers
                                ? 'NEED ${_totalPlayers - _selectedRoleCount} MORE ROLES'
                                : 'REMOVE ${_selectedRoleCount - _totalPlayers} ROLES',
                            style: GoogleFonts.vt323(
                              color: Colors.amberAccent,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      if (!_isBalanceValid &&
                          _selectedRoleCount == _totalPlayers)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'NEED AT LEAST ONE WEREWOLF OR VAMPIRE',
                            style: GoogleFonts.vt323(
                              color: Colors.redAccent,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      PixelButton(
                        label: 'PROCEED',
                        color: _canProceed ? Colors.greenAccent : Colors.grey,
                        onPressed: _canProceed
                            ? () {
                                // TODO: Navigate to assign roles phase
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF415A77),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
