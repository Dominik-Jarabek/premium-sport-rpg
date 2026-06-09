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
      // ZMĚNA: Hlavní navigaci jsme zabalili do mobilního rámu
      home: const MobilniRam(child: HlavniNavigace()),
    );
  }
}

// --- NOVÝ WIDGET: MOBILNÍ RÁM PRO WEBOVÉ PORTFOLIO ---
class MobilniRam extends StatelessWidget {
  final Widget child;
  const MobilniRam({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Zjistíme šířku obrazovky v prohlížeči
    double sirkaObrazovky = MediaQuery.of(context).size.width;

    // Pokud je obrazovka širší než 500 pixelů (např. Chrome na PC / notebooku)
    if (sirkaObrazovky > 500) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0C), // Tmavé pozadí okolo telefonu
        body: Center(
          child: Container(
            width: 420, // Šířka simulovaného telefonu
            height: 840, // Výška simulovaného telefonu
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), // Zaoblené rohy telefonu
              border: Border.all(
                color: const Color(0xFF1C1C1E), // Rámeček "telefonu"
                width: 12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                28,
              ), // Oříznutí rohů aplikace uvnitř rámečku
              child: child,
            ),
          ),
        ),
      );
    }

    // Pokud je obrazovka úzká (skutečný mobil), rám se nepoužije a aplikace běží na celou obrazovku
    return child;
  }
}

// --- TŘÍDA PRO SPODNÍ NAVIGACI ---
class HlavniNavigace extends StatefulWidget {
  const HlavniNavigace({super.key});

  @override
  State<HlavniNavigace> createState() => _HlavniNavigaceState();
}

class _HlavniNavigaceState extends State<HlavniNavigace> {
  int _selectedIndex = 0;

  final List<Widget> _obrazovky = [
    const HlavniObrazovkaAvatar(),
    const MojeCviceniObrazovka(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _obrazovky[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1C1C1E),
        selectedItemColor: const Color(0xFFCCFF00),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Můj Avatar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Moje cvičení',
          ),
        ],
      ),
    );
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
  List<Trening> _vsechnyTreningy = [];

  @override
  void initState() {
    super.initState();
    _vybranySport = _appleWatchSporty[0];

    DateTime dnes = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    DateTime vcera = dnes.subtract(const Duration(days: 1));
    DateTime zitra = dnes.add(const Duration(days: 1));

    _vsechnyTreningy = [
      Trening(
        id: '1',
        nazev: 'Běh venku',
        ikona: Icons.directions_run,
        datum: vcera,
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
        datum: dnes,
        jeSplneno: false,
      ),
      Trening(
        id: '3',
        nazev: 'Jóga',
        ikona: Icons.self_improvement,
        datum: zitra,
        jeSplneno: false,
      ),
    ];
  }

  bool _maDenPlanovanyTrening(DateTime den) {
    return _vsechnyTreningy.any(
      (t) =>
          t.datum.year == den.year &&
          t.datum.month == den.month &&
          t.datum.day == den.day &&
          !t.jeSplneno,
    );
  }

  bool _maDenPouzeSplneneTreningy(DateTime den) {
    var treningyVDen = _vsechnyTreningy.where(
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
                            if (nova != null)
                              setDialogState(() => vybranaNarocnost = nova);
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
                            color: Color(0xFFCCFF00),
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
                            color: Color(0xFFCCFF00),
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
                            color: Color(0xFFCCFF00),
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
                            Color(0xFF00E5FF),
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
                            foregroundColor: const Color(0xFF00E5FF),
                            side: const BorderSide(color: Color(0xFF00E5FF)),
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
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: Colors.black,
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
    List<Trening> planovaneNaDen = _vsechnyTreningy
        .where(
          (t) =>
              t.datum.year == _vybraneDatum.year &&
              t.datum.month == _vybraneDatum.month &&
              t.datum.day == _vybraneDatum.day &&
              !t.jeSplneno,
        )
        .toList();
    List<Trening> splneneNaDen = _vsechnyTreningy
        .where(
          (t) =>
              t.datum.year == _vybraneDatum.year &&
              t.datum.month == _vybraneDatum.month &&
              t.datum.day == _vybraneDatum.day &&
              t.jeSplneno,
        )
        .toList();

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

                        if (maPlan) {
                          barvaKolecka = const Color(0xFFCCFF00);
                          barvaTextu = Colors.black;
                        } else if (maSplneno) {
                          barvaKolecka = const Color(0xFF00E5FF);
                          barvaTextu = Colors.black;
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
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: barvaKolecka,
                              shape: BoxShape.circle,
                              border: ohraniceni,
                            ),
                            child: Text(
                              '$denCislo',
                              style: TextStyle(
                                color: barvaTextu,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
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
                      color: Color(0xFFCCFF00),
                    ),
                    items: _appleWatchSporty.map((sport) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: sport,
                        child: Row(
                          children: [
                            Icon(
                              sport['ikona'],
                              color: const Color(0xFFCCFF00),
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
                      if (novySport != null)
                        setState(() => _vybranySport = novySport);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCFF00),
                    foregroundColor: Colors.black,
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
                      _vsechnyTreningy.add(
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
                        backgroundColor: const Color(0xFF1C1C1E),
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
                              color: Color(0xFFCCFF00),
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
                        if (planovaneNaDen.isEmpty)
                          const Text(
                            'Žádný plán.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          ...planovaneNaDen.map(
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
                              color: Color(0xFF00E5FF),
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
                        if (splneneNaDen.isEmpty)
                          const Text(
                            'Nic nesplněno.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          ...splneneNaDen.map(
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
      child: Row(
        children: [
          Icon(t.ikona, color: const Color(0xFFCCFF00), size: 20),
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
              color: Color(0xFFCCFF00),
              size: 22,
            ),
            onPressed: () => _otevriDialogSplneni(t),
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
          color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(t.ikona, color: const Color(0xFF00E5FF), size: 18),
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
                color: Color(0xFF00E5FF),
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (t.cestaKFotce != null) ...[
            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.image, color: Colors.green, size: 12),
                SizedBox(width: 4),
                Text(
                  'Fotka přiložena',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// --- HLAVNÍ OBRAZOVKA (AVATAR) ---
class HlavniObrazovkaAvatar extends StatefulWidget {
  const HlavniObrazovkaAvatar({super.key});

  @override
  State<HlavniObrazovkaAvatar> createState() => _HlavniObrazovkaAvatarState();
}

class _HlavniObrazovkaAvatarState extends State<HlavniObrazovkaAvatar> {
  final String _mujUcet = '123456789';
  final String _kodBanky = '0100';

  int _coiny = 120;
  double _kilometry = 5.20;
  int _darovaneKoruny = 5;

  int _celkemVybranoKomunitou = 42530;
  final int _komunitniCil = 100000;

  int _bicepsLevyLvl = 2;
  int _bicepsPravyLvl = 2;
  int _hrudnikLvl = 1;
  int _kvadricepsLvl = 1;
  int _brichoLvl = 1;

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

  String _posledniSportJmeno = 'Běh venku';
  String _posledniSportInfo = '5,20 km • 28:12 min';

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
                          items: _sportyAvatar.map((
                            Map<String, dynamic> sport,
                          ) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: sport,
                              child: Row(
                                children: [
                                  Icon(
                                    sport['ikona'],
                                    color: const Color(0xFFCCFF00),
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
                              setDialogState(() {
                                vybranySport = novySport;
                              });
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
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFCCFF00),
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
                            color: Color(0xFFCCFF00),
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
                            color: Color(0xFFCCFF00),
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
                    backgroundColor: const Color(0xFFCCFF00),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    double zadanaHodnota =
                        double.tryParse(
                          hlavniHodnotaController.text.replaceAll(',', '.'),
                        ) ??
                        0.0;
                    int zadaneKc = int.tryParse(kcController.text) ?? 0;
                    if (zadanaHodnota <= 0 || zadaneKc <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Prosím zadej platné hodnoty.'),
                        ),
                      );
                      return;
                    }
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
    bool jeKardio = sport['typ'] == 'kardio';
    String qrUrl =
        'https://api.paylibo.com/paylibo/generator/czech/image?accountNumber=$_mujUcet&bankCode=$_kodBanky&amount=$kc&currency=CZK&vs=$variabilniSymbol&message=Beh%20RPG%20VS%20$variabilniSymbol';

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
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                'VS: $variabilniSymbol',
                style: const TextStyle(
                  color: Color(0xFFCCFF00),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
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
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                jeKardio
                    ? 'Získáš: +${hodnota.toStringAsFixed(2)} km a +${kc * 10} coinů'
                    : 'Získáš: +${hodnota.round()} min a +${kc * 10} coinů',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
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
                backgroundColor: const Color(0xFFCCFF00),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
                _overPlatbuNaBankovnimUctu(
                  hodnota,
                  kc,
                  variabilniSymbol,
                  sport,
                );
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

  void _overPlatbuNaBankovnimUctu(
    double hodnota,
    int kc,
    String vs,
    Map<String, dynamic> sport,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCCFF00)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Čekáme na potvrzení bance...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ověřujeme variabilní symbol: $vs.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Zrušeno.')));
              },
              child: const Text('Zrušit', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C2C2E),
                foregroundColor: const Color(0xFFCCFF00),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (sport['typ'] == 'kardio') _kilometry += hodnota;
                  _darovaneKoruny += kc;
                  _coiny += (kc * 10);
                  _celkemVybranoKomunitou += kc;
                  _posledniSportJmeno = sport['jmeno'];
                  _posledniSportInfo = sport['typ'] == 'kardio'
                      ? '${hodnota.toStringAsFixed(2)} km • Příspěvek: $kc Kč'
                      : '${hodnota.round()} min • Příspěvek: $kc Kč';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Platba (VS $vs) potvrzena! 🎉'),
                    backgroundColor: const Color(0xFF1C1C1E),
                  ),
                );
              },
              child: const Text(
                'Simulovat úspěch',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  void _vylepsiSval(String sval) {
    const int cenaVylepseni = 10;
    if (_coiny >= cenaVylepseni) {
      setState(() {
        _coiny -= cenaVylepseni;
        if (sval == 'BicepsLevy') _bicepsLevyLvl++;
        if (sval == 'BicepsPravy') _bicepsPravyLvl++;
        if (sval == 'Hrudník') _hrudnikLvl++;
        if (sval == 'Kvadriceps') _kvadricepsLvl++;
        if (sval == 'Břicho') _brichoLvl++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nedostatek coinů!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _pozicovanySval({
    double? top,
    double? left,
    double? right,
    required String text,
    required VoidCallback akce,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: GestureDetector(
        onTap: akce,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFCCFF00), width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Color(0xFFCCFF00),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.black, size: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double komunitniProcento = _celkemVybranoKomunitou / _komunitniCil;
    if (komunitniProcento > 1.0) komunitniProcento = 1.0;

    return SafeArea(
      child: Column(
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
                        '$_coiny',
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
          Expanded(
            child: Center(
              child: SizedBox(
                width: 600,
                height: 400,
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/postava_muz.png',
                        height: 360,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Text(
                                'Chyba obrázku',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      ),
                    ),
                    _pozicovanySval(
                      top: 123,
                      left: 40,
                      text: 'BICEPS: Lvl $_bicepsLevyLvl',
                      akce: () => _vylepsiSval('BicepsLevy'),
                    ),
                    _pozicovanySval(
                      top: 123,
                      right: 53,
                      text: 'BICEPS: Lvl $_bicepsPravyLvl',
                      akce: () => _vylepsiSval('BicepsPravy'),
                    ),
                    _pozicovanySval(
                      top: 180,
                      right: 65,
                      text: 'HRUDNÍK: Lvl $_hrudnikLvl',
                      akce: () => _vylepsiSval('Hrudník'),
                    ),
                    _pozicovanySval(
                      top: 232,
                      left: 25,
                      text: 'KVADRICEPS: Lvl $_kvadricepsLvl',
                      akce: () => _vylepsiSval('Kvadriceps'),
                    ),
                    _pozicovanySval(
                      top: 233,
                      right: 30,
                      text: 'BŘIŠNÍ SVALY: Lvl $_brichoLvl',
                      akce: () => _vylepsiSval('Břicho'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'CHARITATIVNÍ KILOMETRY: ${_kilometry.toStringAsFixed(2)} km = $_darovaneKoruny Kč',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (_kilometry % 10) / 10,
                          backgroundColor: const Color(0xFF2C2C2E),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFCCFF00),
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFCCFF00).withValues(alpha: 0.2),
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
                                color: Color(0xFFCCFF00),
                                size: 16,
                              ),
                              SizedBox(width: 6),
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
                            '$_celkemVybranoKomunitou / $_komunitniCil Kč',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFCCFF00),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$_celkemVybranoKomunitou Kč',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: komunitniProcento,
                          backgroundColor: const Color(0xFF2C2C2E),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFCCFF00),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCCFF00),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _otevriZadaniBehuDialog,
                    child: const Text(
                      'SPORTOVAT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'POSLEDNÍ AKTIVITA',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF2C2C2E),
                child: Icon(Icons.directions_run, color: Color(0xFFCCFF00)),
              ),
              title: Text(
                _posledniSportJmeno,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _posledniSportInfo,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
