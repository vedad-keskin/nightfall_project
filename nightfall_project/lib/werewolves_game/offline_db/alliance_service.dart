class WerewolfAlliance {
  final int id;
  final String name;
  final String description;

  WerewolfAlliance({
    required this.id,
    required this.name,
    required this.description,
  });
}

class WerewolfAllianceService {
  static final List<WerewolfAlliance> _alliances = [
    WerewolfAlliance(
      id: 1,
      name: 'Villagers',
      description:
          'The peaceful inhabitants of the village. Their goal is to find and eliminate all werewolves.',
    ),
    WerewolfAlliance(
      id: 2,
      name: 'Werewolves',
      description:
          'The predators of the night. Their goal is to outnumber the villagers to take over the town.',
    ),
    WerewolfAlliance(
      id: 3,
      name: 'Jester',
      description:
          'A chaotic soul who wins only if they are voted out by the village during the day.',
    ),
  ];

  List<WerewolfAlliance> getAlliances() => _alliances;

  WerewolfAlliance? getAllianceById(int id) {
    try {
      return _alliances.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
