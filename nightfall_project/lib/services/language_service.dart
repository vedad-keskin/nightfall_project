import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  String _currentLanguage = 'en';

  LanguageService() {
    _loadLanguage();
  }

  String get currentLanguage => _currentLanguage;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? 'en';
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    if (_currentLanguage == langCode) return;
    _currentLanguage = langCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, langCode);
    notifyListeners();
  }

  String translate(String key) {
    if (_currentLanguage == 'bs') {
      return _bsTranslations[key] ?? _enTranslations[key] ?? key;
    }
    return _enTranslations[key] ?? key;
  }

  static const Map<String, String> _enTranslations = {
    'mafia': 'MAFIA',
    'impostor': 'IMPOSTOR',
    'play_now': 'PLAY NOW',
    'back': 'BACK',
    'players_title': 'PLAYERS',
    'categories_title': 'CATEGORIES',
    'leaderboards_title': 'LEADERBOARDS',
    'hints_title': 'HINTS',
    'on': 'ON',
    'off': 'OFF',
    'game_on': 'GAME ON',
    'need_players_error': 'Need at least 3 players!',
    'no_categories_error': 'No categories selected!',
    'no_words_error': 'Selected category has no words!',
    'words_available': 'words available',
    'enter_name_hint': 'Enter name...',
    'add_button': 'ADD',
    'edit_name_title': 'EDIT NAME',
    'save_button': 'SAVE',
    'cancel_button': 'CANCEL',
    'select_categories_title': 'SELECT CATEGORIES',
    'words_count': 'words',
    'pass_device_title': 'PASS THE DEVICE',
    'waiting_players': 'Waiting for all players...',
    'game_start': 'GAME START',
    'secret_role': 'SECRET ROLE',
    'top_secret': 'TOP SECRET',
    'tap_to_flip': 'TAP TO FLIP',
    'understood_button': 'UNDERSTOOD',
    'you_are_the': 'YOU ARE THE',
    'word_is': 'THE WORD IS:',
    'category_label': 'CATEGORY:',
    'hint_label': 'HINT:',
    'discussion_time': 'DISCUSSION TIME',
    'inst_1': 'Go around in a circle for 2 or 3 rounds.',
    'inst_2': 'Each player must say ONE WORD related to their secret.',
    'inst_3': 'After rounds are over, you must vote for the IMPOSTOR!',
    'starting_player_label': 'STARTING PLAYER',
    'start_voting_button': 'START VOTING',
    'who_is_impostor': 'WHO IS THE IMPOSTOR?',
    'drag_suspect_here': 'DRAG SUSPECT HERE',
    'reveal_impostor_button': 'REVEAL IMPOSTOR',
    'vote_instruction': 'Drag a player to the box to vote',
    'verdict_title': 'THE VERDICT',
    'voted_as_impostor': 'VOTED AS IMPOSTOR:',
    'verdict_innocent': 'THEY WERE INNOCENT!',
    'verdict_impostor': 'THEY WERE THE IMPOSTOR!',
    'real_impostor_was': 'THE REAL IMPOSTOR WAS:',
    'secret_word': 'SECRET WORD',
    'impostor_escaped': 'THE IMPOSTOR ESCAPED!',
    'point_to': '+1 POINT TO',
    'innocents_win': 'INNOCENTS WIN!',
    'caught_impostor': 'You caught the Impostor!',
    'back_to_menu': 'BACK TO MENU',
    'reset_points_q': 'RESET POINTS?',
    'reset_undo_warn':
        'All player points will be set to zero. This cannot be undone.',
    'reset_button': 'RESET',
    'top_players_title': 'TOP PLAYERS',
    'no_players_found': 'No players found.',
  };

  static const Map<String, String> _bsTranslations = {
    'mafia': 'MAFIJA',
    'impostor': 'VARALICA',
    'play_now': 'ZAIGRAJ',
    'back': 'NAZAD',
    'players_title': 'IGRAČI',
    'categories_title': 'KATEGORIJE',
    'leaderboards_title': 'TABELA',
    'hints_title': 'HINTOVI',
    'on': 'UPALJENO',
    'off': 'UGAŠENO',
    'game_on': 'KRENI',
    'need_players_error': 'Potrebno je bar 3 igrača!',
    'no_categories_error': 'Kategorija nije odabrana!',
    'no_words_error': 'Odabrana kategorija nema riječi!',
    'words_available': 'riječi dostupno',
    'enter_name_hint': 'Unesi ime...',
    'add_button': 'DODAJ',
    'edit_name_title': 'UREDI IME',
    'save_button': 'SPASI',
    'cancel_button': 'ODUSTANI',
    'select_categories_title': 'ODABERITE KATEGORIJE',
    'words_count': 'riječi',
    'pass_device_title': 'PROSLIJEDI UREĐAJ',
    'waiting_players': 'Čekanje na sve igrače...',
    'game_start': 'POČNI IGRU',
    'secret_role': 'TAJNA ULOGA',
    'top_secret': 'STROGO POVJERLJIVO',
    'tap_to_flip': 'DODIRNI ZA OKRETANJE',
    'understood_button': 'RAZUMIJEM',
    'you_are_the': 'TI SI',
    'word_is': 'RIJEČ JE:',
    'category_label': 'KATEGORIJA:',
    'hint_label': 'TRAG:',
    'discussion_time': 'VRIJEME ZA DISKUSIJU',
    'inst_1': 'Idite u krug 2 ili 3 runde.',
    'inst_2': 'Svaki igrač mora reći JEDNU RIJEČ vezanu za tajnu.',
    'inst_3': 'Nakon rundi, glasajte za VARALICU!',
    'starting_player_label': 'POČETNI IGRAČ',
    'start_voting_button': 'POČNI GLASANJE',
    'who_is_impostor': 'KO JE VARALICA?',
    'drag_suspect_here': 'DOVUCI SUMNJIVCA OVDJE',
    'reveal_impostor_button': 'OTKRIJ VARALICU',
    'vote_instruction': 'Dovuci igrača u prostor za glasanje',
    'verdict_title': 'PRESUDA',
    'voted_as_impostor': 'GLASANO KAO VARALICA:',
    'verdict_innocent': 'BIO/LA JE NEVIN!',
    'verdict_impostor': 'BIO/LA JE VARALICA!',
    'real_impostor_was': 'PRAVA VARALICA JE BILA:',
    'secret_word': 'TAJNA RIJEČ',
    'impostor_escaped': 'VARALICA JE POBJEGLA!',
    'point_to': '+1 BOD ZA',
    'innocents_win': 'NEVINI POBJEĐUJU!',
    'caught_impostor': 'Uhvatili ste Varalicu!',
    'back_to_menu': 'NAZAD NA MENI',
    'reset_points_q': 'RESETUJ BODOVE?',
    'reset_undo_warn': 'Svi bodovi će biti nula. Ovo se ne može poništiti.',
    'reset_button': 'RESETUJ',
    'top_players_title': 'NAJBOLJI IGRAČI',
    'no_players_found': 'Nema igrača.',
  };
}
