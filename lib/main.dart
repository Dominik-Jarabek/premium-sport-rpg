import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const PremiumSportRPG());
}

class PremiumSportRPG extends StatelessWidget {
  const PremiumSportRPG({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Sport RPG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      home: const MobilniRam(child: HlavniNavigace()),
    );
  }
}

// --- WIDGET: MOBILNÍ RÁM PRO WEBOVÉ PORTFOLIO ---
class MobilniRam extends StatelessWidget {
  final Widget child;
  const MobilniRam({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double sirkaObrazovky = MediaQuery.of(context).size.width;

    if (sirkaObrazovky > 500) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0C),
        body: Center(
          child: Container(
            width: 420,
            height: 840,
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFF1C1C1E), width: 12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: child,
            ),
          ),
        ),
      );
    }

    return child;
  }
}

// --- STRUKTURA PRO TRÉNINK ---
class Trening {
  final String id;
  final String nazev;
  final IconData ikona;
  final DateTime datum;
  bool jeSplneno;
  String? narocnost;
  String? cas;
  String? vykon;
  String? poznamka;
  String? cestaKFotce;

  Trening({
    required this.id,
    required this.nazev,
    required this.ikona,
    required this.datum,
    this.jeSplneno = false,
    this.narocnost,
    this.cas,
    this.vykon,
    this.poznamka,
    this.cestaKFotce,
  });
}

// --- GLOBÁLNÍ STATE MANAGER ---
class HerniData {
  static int coiny = 120;
  static double kilometry = 5.20;
  static int darovaneKoruny = 5;
  static int celkemVybranoKomunitou = 42530;
  static const int komunitniCil = 100000;

  static String posledniSportJmeno = 'Běh venku';
  static String posledniSportInfo = '5,20 km • 28:12 min';

  // Levely svalů
  static Map<String, int> svalyLvl = {
    'Triceps': 1,
    'Přímý sval břišní': 1,
    'Biceps': 1,
    'Stehno (Quadriceps)': 1,
    'Ramena': 1,
    'Hamstrings': 1,
    'Prsa': 1,
    'Hýždě': 1,
    'Záda': 1,
    'Lýtko': 1,
  };

  // Globální úložiště tréninků
  static List<Trening> vsechnyTreningy = [
    Trening(
      id: '1',
      nazev: 'Běh venku',
      ikona: Icons.directions_run,
      datum: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).subtract(const Duration(days: 1)),
      jeSplneno: true,
      narocnost: 'Střední',
      cas: '28:12 min',
      vykon: '5.20 km',
      poznamka: 'Běželo se skvěle, super počasí!',
      cestaKFotce: 'foto_beh.jpg',
    ),
    Trening(
      id: '2',
      nazev: 'Silový trénink',
      ikona: Icons.fitness_center,
      datum: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      jeSplneno: false,
    ),
    Trening(
      id: '3',
      nazev: 'Jóga',
      ikona: Icons.self_improvement,
      datum: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).add(const Duration(days: 1)),
      jeSplneno: false,
    ),
    Trening(
      id: '4',
      nazev: 'HIIT',
      ikona: Icons.timer,
      datum: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).add(const Duration(days: 3)),
      jeSplneno: false,
    ),
  ];
}

// --- TŘÍDA PRO SPODNÍ NAVIGACI ---
class HlavniNavigace extends StatefulWidget {
  const HlavniNavigace({super.key});

  @override
  State<HlavniNavigace> createState() => _HlavniNavigaceState();
}

class _HlavniNavigaceState extends State<HlavniNavigace> {
  int _selectedIndex = 0;

  void _obnovitData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _obrazovky = [
      HlavniObrazovkaAvatar(onObnoveni: _obnovitData),
      PomahejObrazovka(onObnoveni: _obnovitData),
      const MojeCviceniObrazovka(),
    ];

    return Scaffold(
      body: _obrazovky[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1C1C1E),
        selectedItemColor: const Color(0xFFFF6600),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Můj Avatar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Pomáhej'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Moje cvičení',
          ),
        ],
      ),
    );
  }
}

// --- OBRAZOVKA: MOJE CVIČENÍ ---
class MojeCviceniObrazovka extends StatefulWidget {
  const MojeCviceniObrazovka({super.key});

  @override
  State<MojeCviceniObrazovka> createState() => _MojeCviceniObrazovkaState();
}

class _MojeCviceniObrazovkaState extends State<MojeCviceniObrazovka> {
  DateTime _vybraneDatum = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime _aktualniMesic = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  final List<Map<String, dynamic>> _appleWatchSporty = [
    {'jmeno': 'Běh venku', 'ikona': Icons.directions_run},
    {'jmeno': 'Běh v hale', 'ikona': Icons.directions_run},
    {'jmeno': 'Chůze venku', 'ikona': Icons.directions_walk},
    {'jmeno': 'Jízda na kole venku', 'ikona': Icons.directions_bike},
    {'jmeno': 'Jízda na kole v hale', 'ikona': Icons.pedal_bike},
    {'jmeno': 'Plavání v bazénu', 'ikona': Icons.pool},
    {'jmeno': 'Silový trénink', 'ikona': Icons.fitness_center},
    {'jmeno': 'HIIT', 'ikona': Icons.timer},
    {'jmeno': 'Trénink středu těla', 'ikona': Icons.accessibility_new},
    {'jmeno': 'Jóga', 'ikona': Icons.self_improvement},
    {'jmeno': 'Pilates', 'ikona': Icons.spa},
    {'jmeno': 'Tanec', 'ikona': Icons.music_note},
  ];

  late Map<String, dynamic> _vybranySport;

  @override
  void initState() {
    super.initState();
    _vybranySport = _appleWatchSporty[0];
  }

  bool _maDenPlanovanyTrening(DateTime den) {
    return HerniData.vsechnyTreningy.any(
      (t) =>
          t.datum.year == den.year &&
          t.datum.month == den.month &&
          t.datum.day == den.day &&
          !t.jeSplneno,
    );
  }

  bool _maDenPouzeSplneneTreningy(DateTime den) {
    var treningyVDen = HerniData.vsechnyTreningy.where(
      (t) =>
          t.datum.year == den.year &&
          t.datum.month == den.month &&
          t.datum.day == den.day,
    );
    if (treningyVDen.isEmpty) return false;
    return treningyVDen.every((t) => t.jeSplneno);
  }

  void _otevriDialogSplneni(Trening trening) {
    String vybranaNarocnost = 'Střední';
    final TextEditingController casController = TextEditingController();
    final TextEditingController vykonController = TextEditingController();
    final TextEditingController poznamkaController = TextEditingController();

    String? nahranaFotkaCesta;
    bool nacitaSeFotka = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1C1C1E),
              title: Text(
                'Dokončit: ${trening.nazev}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Jak náročný byl trénink?',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: vybranaNarocnost,
                          dropdownColor: const Color(0xFF1C1C1E),
                          isExpanded: true,
                          items:
                              <String>[
                                'Lehká',
                                'Střední',
                                'Těžká',
                                'Brutální',
                              ].map((String hodnota) {
                                return DropdownMenuItem<String>(
                                  value: hodnota,
                                  child: Text(
                                    hodnota,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                          onChanged: (nova) {
                            if (nova != null) {
                              setDialogState(() => vybranaNarocnost = nova);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: casController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Čas tréninku (např. 45 min, 1:15 h)',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF2C2C2E),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6600),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: vykonController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText:
                            'Kolik jsi uběhl / Výkon (např. 5 km, 4 série)',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF2C2C2E),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6600),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: poznamkaController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Poznámka k tréninku (pocity, detaily...)',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF2C2C2E),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6600),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Fotka z tréninku',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (nacitaSeFotka)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF6600),
                          ),
                        ),
                      )
                    else if (nahranaFotkaCesta != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green, width: 1),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'foto_treninku.jpg připraveno',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFFF6600),
                            side: const BorderSide(color: Color(0xFFFF6600)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.add_a_photo, size: 16),
                          label: const Text(
                            'Přidat fotku z tréninku',
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            setDialogState(() => nacitaSeFotka = true);
                            Future.delayed(const Duration(milliseconds: 800), () {
                              setDialogState(() {
                                nacitaSeFotka = false;
                                nahranaFotkaCesta =
                                    'foto_${DateTime.now().millisecondsSinceEpoch}.jpg';
                              });
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Zrušit',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6600),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      trening.jeSplneno = true;
                      trening.narocnost = vybranaNarocnost;
                      trening.cas = casController.text.isEmpty
                          ? 'Nezadáno'
                          : casController.text;
                      trening.vykon = vykonController.text.isEmpty
                          ? 'Nezadáno'
                          : vykonController.text;
                      trening.poznamka = poznamkaController.text.isEmpty
                          ? null
                          : poznamkaController.text;
                      trening.cestaKFotce = nahranaFotkaCesta;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Trénink ${trening.nazev} splněn! 🎉'),
                        backgroundColor: const Color(0xFF1C1C1E),
                      ),
                    );
                  },
                  child: const Text(
                    'Uložit splněné',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Trening> vsechnyPlanovane = HerniData.vsechnyTreningy
        .where((t) => !t.jeSplneno)
        .toList();
    vsechnyPlanovane.sort((a, b) => a.datum.compareTo(b.datum));

    List<Trening> vsechnySplnene = HerniData.vsechnyTreningy
        .where((t) => t.jeSplneno)
        .toList();
    vsechnySplnene.sort((a, b) => b.datum.compareTo(a.datum));

    int dnyVMesici = DateTime(
      _aktualniMesic.year,
      _aktualniMesic.month + 1,
      0,
    ).day;
    int zacatekDneVTyzdnu = DateTime(
      _aktualniMesic.year,
      _aktualniMesic.month,
      1,
    ).weekday;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Moje cvičení a Plán',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          onPressed: () => setState(
                            () => _aktualniMesic = DateTime(
                              _aktualniMesic.year,
                              _aktualniMesic.month - 1,
                              1,
                            ),
                          ),
                        ),
                        Text(
                          '${_aktualniMesic.month}/${_aktualniMesic.year}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                          onPressed: () => setState(
                            () => _aktualniMesic = DateTime(
                              _aktualniMesic.year,
                              _aktualniMesic.month + 1,
                              1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          'Po',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          'Út',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          'St',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          'Čt',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          'Pá',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          'So',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          'Ne',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 6,
                            crossAxisSpacing: 6,
                          ),
                      itemCount: dnyVMesici + (zacatekDneVTyzdnu - 1),
                      itemBuilder: (context, index) {
                        if (index < zacatekDneVTyzdnu - 1)
                          return const SizedBox();

                        int denCislo = index - (zacatekDneVTyzdnu - 2);
                        DateTime denDatum = DateTime(
                          _aktualniMesic.year,
                          _aktualniMesic.month,
                          denCislo,
                        );

                        bool jeVybrany =
                            denDatum.year == _vybraneDatum.year &&
                            denDatum.month == _vybraneDatum.month &&
                            denDatum.day == _vybraneDatum.day;
                        bool maPlan = _maDenPlanovanyTrening(denDatum);
                        bool maSplneno = _maDenPouzeSplneneTreningy(denDatum);

                        Color barvaKolecka = Colors.transparent;
                        Color barvaTextu = Colors.white;
                        BoxBorder? ohraniceni;

                        // NOVÝ UPRAVENÝ KÓD:
                        if (maSplneno) {
                          // Tmavě oranžová pro hotové tréninky
                          barvaKolecka = const Color(0xFFB34700);
                          barvaTextu = Colors.white;
                        } else if (maPlan) {
                          // Původní jasná oranžová pro nesplněné / naplánované tréninky
                          barvaKolecka = const Color(0xFFFF6600);
                          barvaTextu = Colors.white;
                        }

                        if (jeVybrany) {
                          ohraniceni = Border.all(
                            color: Colors.white,
                            width: 2,
                          );
                        }

                        return GestureDetector(
                          onTap: () => setState(() => _vybraneDatum = denDatum),
                          child: Container(
                            decoration: BoxDecoration(
                              color: barvaKolecka,
                              shape: BoxShape.circle,
                              border: ohraniceni,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '$denCislo',
                                style: TextStyle(
                                  color: barvaTextu,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'NOVÝ TRÉNINK NA VYBRANÝ DEN',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Map<String, dynamic>>(
                    value: _vybranySport,
                    dropdownColor: const Color(0xFF1C1C1E),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFFFF6600),
                    ),
                    items: _appleWatchSporty.map((sport) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: sport,
                        child: Row(
                          children: [
                            Icon(
                              sport['ikona'],
                              color: const Color(0xFFFF6600),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              sport['jmeno'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (novySport) {
                      if (novySport != null) {
                        setState(() => _vybranySport = novySport);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6600),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: const Text(
                    'Naplánovat na vybraný den',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    setState(() {
                      HerniData.vsechnyTreningy.add(
                        Trening(
                          id: DateTime.now().toString(),
                          nazev: _vybranySport['jmeno'],
                          ikona: _vybranySport['ikona'],
                          datum: _vybraneDatum,
                        ),
                      );
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Přidáno do plánu na ${_vybraneDatum.day}. ${_vybraneDatum.month}.',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.hourglass_empty,
                              color: Color(0xFFFF6600),
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'PLÁN (ČEKÁ)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (vsechnyPlanovane.isEmpty)
                          const Text(
                            'Žádný plán.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          ...vsechnyPlanovane.map(
                            (trening) => _vytvorKartuPlanu(trening),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFFFF6600),
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'HISTORIE',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (vsechnySplnene.isEmpty)
                          const Text(
                            'Nic nesplněno.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          ...vsechnySplnene.map(
                            (trening) => _vytvorKartuHistorie(trening),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vytvorKartuPlanu(Trening t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(t.ikona, color: const Color(0xFFFF6600), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t.nazev,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.check_box_outline_blank,
                  color: Color(0xFFFF6600),
                  size: 22,
                ),
                onPressed: () => _otevriDialogSplneni(t),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Termín: ${t.datum.day}. ${t.datum.month}. ${t.datum.year}',
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _vytvorKartuHistorie(Trening t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFFF6600).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(t.ikona, color: const Color(0xFFFF6600), size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  t.nazev,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 12),
          Text(
            'Splněno: ${t.datum.day}. ${t.datum.month}. ${t.datum.year}',
            style: const TextStyle(
              color: Color(0xFFFF6600),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Náročnost: ${t.narocnost}',
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          Text(
            'Čas: ${t.cas}',
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          Text(
            'Výkon: ${t.vykon}',
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          if (t.poznamka != null) ...[
            const SizedBox(height: 6),
            Text(
              'Poznámka: ${t.poznamka}',
              style: const TextStyle(
                color: Color(0xFFFF6600),
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// --- OBRAZOVKA: MŮJ AVATAR ---
class HlavniObrazovkaAvatar extends StatefulWidget {
  final VoidCallback onObnoveni;
  const HlavniObrazovkaAvatar({super.key, required this.onObnoveni});

  @override
  State<HlavniObrazovkaAvatar> createState() => _HlavniObrazovkaAvatarState();
}

class _HlavniObrazovkaAvatarState extends State<HlavniObrazovkaAvatar> {
  void _vylepsiSval(String sval) {
    const int cenaVylepseni = 10;
    if (HerniData.coiny >= cenaVylepseni) {
      setState(() {
        HerniData.coiny -= cenaVylepseni;
        HerniData.svalyLvl[sval] = (HerniData.svalyLvl[sval] ?? 1) + 1;
      });
      widget.onObnoveni();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nedostatek coinů!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Můj Avatar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Úprava zobrazení loga s fallbackem, pokud soubor chybí
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/logo.png',
                        height: 35,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Chybí logo.png',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Color(0xFFCCFF00),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${HerniData.coiny}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Hlavní grafika bez jakýchkoliv oranžových textových boxů navíc
            Center(
              child: Container(
                width: double.infinity,
                height: 380,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/postava_muz.png',
                      height: 360,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Text(
                              'Obrázek postava_muz.png nebyl nalezen v assets/',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TRÉNINKOVÉ CENTRUM (1 upgrade = 10 coinů)',
                    style: TextStyle(
                      color: Color(0xFFFF6600),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.4,
                        ),
                    itemCount: HerniData.svalyLvl.length,
                    itemBuilder: (context, index) {
                      String svalJmeno = HerniData.svalyLvl.keys.elementAt(
                        index,
                      );
                      int svalLvl = HerniData.svalyLvl[svalJmeno] ?? 1;

                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    svalJmeno,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Lvl $svalLvl',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _vylepsiSval(svalJmeno),
                              icon: const Icon(
                                Icons.add_circle,
                                color: Color(0xFFFF6600),
                                size: 28,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// --- OBRAZOVKA: POMÁHEJ ---
class PomahejObrazovka extends StatefulWidget {
  final VoidCallback onObnoveni;
  const PomahejObrazovka({super.key, required this.onObnoveni});

  @override
  State<PomahejObrazovka> createState() => _PomahejObrazovkaState();
}

class _PomahejObrazovkaState extends State<PomahejObrazovka> {
  final String _mujUcet = '123456789';
  final String _kodBanky = '0100';

  final List<Map<String, dynamic>> _sportyAvatar = [
    {'jmeno': 'Běh venku', 'typ': 'kardio', 'ikona': Icons.directions_run},
    {'jmeno': 'Cyklistika', 'typ': 'kardio', 'ikona': Icons.directions_bike},
    {
      'jmeno': 'Posilovna / Kruháč',
      'typ': 'sila',
      'ikona': Icons.fitness_center,
    },
    {'jmeno': 'Kalistenika', 'typ': 'sila', 'ikona': Icons.accessibility_new},
    {'jmeno': 'Jóga', 'typ': 'sila', 'ikona': Icons.self_improvement},
  ];

  void _otevriZadaniBehuDialog() {
    final TextEditingController hlavniHodnotaController =
        TextEditingController();
    final TextEditingController kcController = TextEditingController();
    Map<String, dynamic> vybranySport = _sportyAvatar[0];

    void prepocitejKoruny() {
      double? hodnota = double.tryParse(
        hlavniHodnotaController.text.replaceAll(',', '.'),
      );
      if (hodnota != null) {
        kcController.text = hodnota.round().toString();
      } else {
        kcController.text = '';
      }
    }

    hlavniHodnotaController.addListener(prepocitejKoruny);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            bool jeKardio = vybranySport['typ'] == 'kardio';

            return AlertDialog(
              backgroundColor: const Color(0xFF1C1C1E),
              title: const Text(
                'Zapiš svou aktivitu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Map<String, dynamic>>(
                          value: vybranySport,
                          dropdownColor: const Color(0xFF1C1C1E),
                          isExpanded: true,
                          items: _sportyAvatar.map((sport) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: sport,
                              child: Row(
                                children: [
                                  Icon(
                                    sport['ikona'],
                                    color: const Color(0xFFFF6600),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    sport['jmeno'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (novySport) {
                            if (novySport != null) {
                              setDialogState(() => vybranySport = novySport);
                              prepocitejKoruny();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      jeKardio
                          ? 'Pravidlo: 1 km = 1 Kč na charitu.'
                          : 'Pravidlo: 1 minuta = 1 Kč na charitu.',
                      style: const TextStyle(
                        color: Color(0xFFFF6600),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: hlavniHodnotaController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: jeKardio
                            ? 'Kolik jsi uběhl/ujel? (km)'
                            : 'Jak dlouho jsi cvičil? (minut)',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF2C2C2E),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6600),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: kcController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Kolik přispěješ? (Kč)',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF2C2C2E),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6600),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Zrušit',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6600),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    double zadanaHodnota =
                        double.tryParse(
                          hlavniHodnotaController.text.replaceAll(',', '.'),
                        ) ??
                        0.0;
                    int zadaneKc = int.tryParse(kcController.text) ?? 0;
                    if (zadanaHodnota <= 0 || zadaneKc <= 0) return;
                    Navigator.pop(context);
                    _ukazPlatebniQR(zadanaHodnota, zadaneKc, vybranySport);
                  },
                  child: const Text(
                    'Generovat QR kód',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _ukazPlatebniQR(double hodnota, int kc, Map<String, dynamic> sport) {
    String variabilniSymbol = (100000 + Random().nextInt(900000)).toString();
    String qrUrl =
        'https://api.paylibo.com/paylibo/generator/czech/image?accountNumber=$_mujUcet&bankCode=$_kodBanky&amount=$kc&currency=CZK&vs=$variabilniSymbol&message=Beh%20RPG';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          title: Text(
            'Příspěvek $kc Kč',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Naskenuj QR kód ve své bankovní aplikaci.',
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                'VS: $variabilniSymbol',
                style: const TextStyle(
                  color: Color(0xFFFF6600),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  qrUrl,
                  height: 180,
                  width: 180,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Zrušit', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6600),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _simulujOvereniBanky(hodnota, kc, sport, variabilniSymbol);
              },
              child: const Text(
                'Mám zaplaceno',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _simulujOvereniBanky(
    double hodnota,
    int kc,
    Map<String, dynamic> sport,
    String vs,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future.delayed(const Duration(seconds: 3), () {
              if (!mounted) return;
              Navigator.pop(context);

              bool platbaDorazila = Random().nextDouble() < 0.85;

              if (platbaDorazila) {
                setState(() {
                  if (sport['typ'] == 'kardio') HerniData.kilometry += hodnota;
                  HerniData.darovaneKoruny += kc;
                  HerniData.coiny += (kc * 10);
                  HerniData.celkemVybranoKomunitou += kc;
                  HerniData.posledniSportJmeno = sport['jmeno'];
                  HerniData.posledniSportInfo = sport['typ'] == 'kardio'
                      ? '${hodnota.toStringAsFixed(2)} km • Příspěvek: $kc Kč'
                      : '${hodnota.round()} min • Příspěvek: $kc Kč';
                });
                widget.onObnoveni();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green[800],
                    content: Text(
                      '✅ Bankovní API potvrdilo platbu (VS: $vs). Bylo ti připsáno ${kc * 10} coinů!',
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red[900],
                    duration: const Duration(seconds: 5),
                    content: Text(
                      '❌ Bankovní API: Platba s VS $vs nebyla nalezena. Zkontrolujte odeslání platby.',
                    ),
                  ),
                );
              }
            });

            return AlertDialog(
              backgroundColor: const Color(0xFF1C1C1E),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6600),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ověřování platby...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Komunikuji s Bankovním API České spořitelny. Kontroluji připsání platby pod VS: $vs.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double komunitniProcento =
        HerniData.celkemVybranoKomunitou / HerniData.komunitniCil;
    if (komunitniProcento > 1.0) komunitniProcento = 1.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pomáhej pohybem',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'MOJE CHARITATIVNÍ KILOMETRY:\n${HerniData.kilometry.toStringAsFixed(2)} km = ${HerniData.darovaneKoruny} Kč',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (HerniData.kilometry % 10) / 10,
                      backgroundColor: const Color(0xFF2C2C2E),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6600),
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF6600).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.public,
                            color: Color(0xFFFF6600),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'SPOLEČNĚ UŽ JSME VYBRALI',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${HerniData.celkemVybranoKomunitou} / ${HerniData.komunitniCil} Kč',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${HerniData.celkemVybranoKomunitou} Kč',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: komunitniProcento,
                      backgroundColor: const Color(0xFF2C2C2E),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6600),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6600),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _otevriZadaniBehuDialog,
                child: const Text(
                  'SPORTOVAT A POMOCT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'POSLEDNÍ AKTIVITA',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF2C2C2E),
                  child: Icon(Icons.directions_run, color: Color(0xFFFF6600)),
                ),
                title: Text(
                  HerniData.posledniSportJmeno,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  HerniData.posledniSportInfo,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
