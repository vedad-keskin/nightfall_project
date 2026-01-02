class Word {
  final int id;
  final String name;
  final int categoryId;
  final String hint;

  Word({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.hint,
  });
}

class WordsService {
  // Category IDs:
  // 1: Lokacije
  // 2: Hrana

  static final List<Word> _words = [
    // --- Lokacije (Category ID: 1, IDs 1-50) ---
    Word(id: 1, name: 'Bolnica', categoryId: 1, hint: 'Mjesto za bolesne'),
    Word(id: 2, name: 'Škola', categoryId: 1, hint: 'Mjesto za učenje'),
    Word(id: 3, name: 'Biblioteka', categoryId: 1, hint: 'Puno knjiga'),
    Word(id: 4, name: 'Muzej', categoryId: 1, hint: 'Historijski predmeti'),
    Word(id: 5, name: 'Kino', categoryId: 1, hint: 'Gledanje filmova'),
    Word(id: 6, name: 'Restoran', categoryId: 1, hint: 'Mjesto za jelo'),
    Word(id: 7, name: 'Aerodrom', categoryId: 1, hint: 'Avioni slijeću'),
    Word(id: 8, name: 'Željeznička stanica', categoryId: 1, hint: 'Vozovi'),
    Word(id: 9, name: 'Autobuska stanica', categoryId: 1, hint: 'Autobusi'),
    Word(id: 10, name: 'Banka', categoryId: 1, hint: 'Novac'),
    Word(id: 11, name: 'Pošta', categoryId: 1, hint: 'Pisma i paketi'),
    Word(
      id: 12,
      name: 'Supermarket',
      categoryId: 1,
      hint: 'Kupovina namirnica',
    ),
    Word(id: 13, name: 'Pijaca', categoryId: 1, hint: 'Svježe voće i povrće'),
    Word(id: 14, name: 'Park', categoryId: 1, hint: 'Priroda u gradu'),
    Word(id: 15, name: 'Zoološki vrt', categoryId: 1, hint: 'Životinje'),
    Word(id: 16, name: 'Plaža', categoryId: 1, hint: 'More i pijesak'),
    Word(id: 17, name: 'Planina', categoryId: 1, hint: 'Visoko i hladno'),
    Word(id: 18, name: 'Šuma', categoryId: 1, hint: 'Puno drveća'),
    Word(id: 19, name: 'Selo', categoryId: 1, hint: 'Manje mjesto'),
    Word(id: 20, name: 'Grad', categoryId: 1, hint: 'Veliko mjesto'),
    Word(id: 21, name: 'Hotel', categoryId: 1, hint: 'Spavanje na putu'),
    Word(id: 22, name: 'Kamp', categoryId: 1, hint: 'Šatori'),
    Word(id: 23, name: 'Farma', categoryId: 1, hint: 'Domaće životinje'),
    Word(id: 24, name: 'Bazen', categoryId: 1, hint: 'Plivanje'),
    Word(id: 25, name: 'Teretana', categoryId: 1, hint: 'Vježbanje'),
    Word(id: 26, name: 'Stadion', categoryId: 1, hint: 'Sportski događaji'),
    Word(id: 27, name: 'Pozorište', categoryId: 1, hint: 'Predstave'),
    Word(id: 28, name: 'Crkva', categoryId: 1, hint: 'Vjerski objekt'),
    Word(id: 29, name: 'Džamija', categoryId: 1, hint: 'Vjerski objekt'),
    Word(id: 30, name: 'Sinagoga', categoryId: 1, hint: 'Vjerski objekt'),
    Word(id: 31, name: 'Dvorac', categoryId: 1, hint: 'Kraljevi i kraljice'),
    Word(id: 32, name: 'Zatvor', categoryId: 1, hint: 'Kazna'),
    Word(id: 33, name: 'Vatrogasna stanica', categoryId: 1, hint: 'Vatrogasci'),
    Word(id: 34, name: 'Policijska stanica', categoryId: 1, hint: 'Policija'),
    Word(id: 35, name: 'Bolničko vozilo', categoryId: 1, hint: 'Hitna pomoć'),
    Word(id: 36, name: 'Svemirski brod', categoryId: 1, hint: 'Svemir'),
    Word(id: 37, name: 'Podmornica', categoryId: 1, hint: 'Pod vodom'),
    Word(id: 38, name: 'Avion', categoryId: 1, hint: 'Letenje'),
    Word(id: 39, name: 'Voz', categoryId: 1, hint: 'Pruga'),
    Word(id: 40, name: 'Brod', categoryId: 1, hint: 'Plovidba'),
    Word(id: 41, name: 'Auto', categoryId: 1, hint: 'Vožnja'),
    Word(id: 42, name: 'Benzinska pumpa', categoryId: 1, hint: 'Gorivo'),
    Word(id: 43, name: 'Garaža', categoryId: 1, hint: 'Popravka auta'),
    Word(id: 44, name: 'Most', categoryId: 1, hint: 'Prelaz preko rijeke'),
    Word(id: 45, name: 'Tunel', categoryId: 1, hint: 'Kroz planinu'),
    Word(id: 46, name: 'Tvrđava', categoryId: 1, hint: 'Odbrana'),
    Word(id: 47, name: 'Pećina', categoryId: 1, hint: 'Mračno i vlažno'),
    Word(id: 48, name: 'Ostrvo', categoryId: 1, hint: 'Kopno u vodi'),
    Word(id: 49, name: 'Pustinja', categoryId: 1, hint: 'Pijesak i vrućina'),
    Word(id: 50, name: 'Sjeverni pol', categoryId: 1, hint: 'Led i hladnoća'),

    // --- Hrana (Category ID: 2, IDs 51-100) ---
    Word(id: 51, name: 'Ćevapi', categoryId: 2, hint: 'Meso u somunu'),
    Word(id: 52, name: 'Burek', categoryId: 2, hint: 'Pita s mesom'),
    Word(id: 53, name: 'Sirnica', categoryId: 2, hint: 'Pita sa sirom'),
    Word(id: 54, name: 'Zeljanica', categoryId: 2, hint: 'Pita sa zeljem'),
    Word(id: 55, name: 'Krompiruša', categoryId: 2, hint: 'Pita s krompirom'),
    Word(id: 56, name: 'Sarma', categoryId: 2, hint: 'Meso u kupusu'),
    Word(
      id: 57,
      name: 'Punjenje paprike',
      categoryId: 2,
      hint: 'Paprike s mesom',
    ),
    Word(id: 58, name: 'Grah', categoryId: 2, hint: 'Varivo'),
    Word(id: 59, name: 'Baklava', categoryId: 2, hint: 'Slatko s orasima'),
    Word(id: 60, name: 'Hurmašica', categoryId: 2, hint: 'Slatki kolač'),
    Word(id: 61, name: 'Tufahija', categoryId: 2, hint: 'Jabuka i šlag'),
    Word(id: 62, name: 'Begova čorba', categoryId: 2, hint: 'Gusta supa'),
    Word(id: 63, name: 'Bosanski lonac', categoryId: 2, hint: 'Meso i povrće'),
    Word(id: 64, name: 'Kljukuša', categoryId: 2, hint: 'Tijesto i krompir'),
    Word(id: 65, name: 'Uštipci', categoryId: 2, hint: 'Prženo tijesto'),
    Word(id: 66, name: 'Somun', categoryId: 2, hint: 'Hljeb'),
    Word(id: 67, name: 'Kafa', categoryId: 2, hint: 'Crni napitak'),
    Word(id: 68, name: 'Čaj', categoryId: 2, hint: 'Topli napitak'),
    Word(id: 69, name: 'Sok', categoryId: 2, hint: 'Voćni napitak'),
    Word(id: 70, name: 'Voda', categoryId: 2, hint: 'Piće života'),
    Word(id: 71, name: 'Pizza', categoryId: 2, hint: 'Italijansko jelo'),
    Word(id: 72, name: 'Hamburger', categoryId: 2, hint: 'Brza hrana'),
    Word(id: 73, name: 'Pomfrit', categoryId: 2, hint: 'Prženi krompirići'),
    Word(id: 74, name: 'Sendvič', categoryId: 2, hint: 'Hljeb i prilozi'),
    Word(id: 75, name: 'Salata', categoryId: 2, hint: 'Svježe povrće'),
    Word(id: 76, name: 'Supa', categoryId: 2, hint: 'Tečno jelo'),
    Word(id: 77, name: 'Riba', categoryId: 2, hint: 'Iz vode'),
    Word(id: 78, name: 'Piletina', categoryId: 2, hint: 'Meso peradi'),
    Word(id: 79, name: 'Govedina', categoryId: 2, hint: 'Crveno meso'),
    Word(id: 80, name: 'Jagnjetina', categoryId: 2, hint: 'Pečenje'),
    Word(id: 81, name: 'Kolač', categoryId: 2, hint: 'Deserti'),
    Word(id: 82, name: 'Torta', categoryId: 2, hint: 'Rođendanska'),
    Word(id: 83, name: 'Sladoled', categoryId: 2, hint: 'Ledena poslastica'),
    Word(id: 84, name: 'Čokolada', categoryId: 2, hint: 'Slatkiš od kakaa'),
    Word(id: 85, name: 'Keks', categoryId: 2, hint: 'Suhi kolačić'),
    Word(id: 86, name: 'Jabuka', categoryId: 2, hint: 'Voće'),
    Word(id: 87, name: 'Banana', categoryId: 2, hint: 'Žuto voće'),
    Word(id: 88, name: 'Jagoda', categoryId: 2, hint: 'Crveno voće'),
    Word(id: 89, name: 'Lubenica', categoryId: 2, hint: 'Ljetno voće'),
    Word(id: 90, name: 'Grožđe', categoryId: 2, hint: 'Vino'),
    Word(id: 91, name: 'Narandža', categoryId: 2, hint: 'Citrus'),
    Word(id: 92, name: 'Limun', categoryId: 2, hint: 'Kiselo'),
    Word(id: 93, name: 'Luk', categoryId: 2, hint: 'Suze'),
    Word(id: 94, name: 'Krompir', categoryId: 2, hint: 'Gomolj'),
    Word(id: 95, name: 'Paradajz', categoryId: 2, hint: 'Crveno povrće'),
    Word(id: 96, name: 'Krastavac', categoryId: 2, hint: 'Zeleno povrće'),
    Word(id: 97, name: 'Paprika', categoryId: 2, hint: 'Povrće'),
    Word(id: 98, name: 'Mrkva', categoryId: 2, hint: 'Narandžasto povrće'),
    Word(id: 99, name: 'Sir', categoryId: 2, hint: 'Mliječni proizvod'),
    Word(id: 100, name: 'Mlijeko', categoryId: 2, hint: 'Bijeli napitak'),
  ];

  List<Word> getAllWords() {
    return _words;
  }

  List<Word> getWordsForCategory(int categoryId) {
    return _words.where((w) => w.categoryId == categoryId).toList();
  }

  int getWordCountForCategory(int categoryId) {
    return _words.where((w) => w.categoryId == categoryId).length;
  }
}
