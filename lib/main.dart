import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const PremiumSportRPG());

// ═══════════════════════ BARVY ════════════════════════════
class _C {
  static const Color bg = Color(0xFFF2EDE4);
  static const Color card = Color(0xFFFAF7F2);
  static const Color card2 = Color(0xFFEDE7DC);
  static const Color gold = Color(0xFFC4974A);
  static const Color goldL = Color(0xFFD4B070);
  static const Color goldD = Color(0xFF9A7035);
  static const Color text = Color(0xFF2C2418);
  static const Color textS = Color(0xFF9A8E80);
  static const Color border = Color(0xFFE0D8CC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF4A8C4A);
  static const Color red = Color(0xFFB33C3C);
}

// ═══════════════════════ LOGO (2D FLAT) ═════════════════
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size * 1.15,
    height: size,
    child: CustomPaint(painter: _AppLogoPainter()),
  );
}

class _AppLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size sz) {
    final w = sz.width;
    final h = sz.height;
    // ARM (darker gold, behind)
    canvas.drawPath(
      _arm(w, h),
      Paint()
        ..color = const Color(0xFF8A6528)
        ..style = PaintingStyle.fill,
    );
    // HEART (gradient fill)
    canvas.drawPath(
      _heart(w * 0.78, h),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFDDAA55), Color(0xFFC4974A), Color(0xFF9A7030)],
        ).createShader(Rect.fromLTWH(0, 0, double.maxFinite, double.maxFinite)),
    );
    // ECG line
    canvas.drawPath(
      Path()
        ..moveTo(w * .04, h * .52)
        ..lineTo(w * .17, h * .52)
        ..lineTo(w * .25, h * .20)
        ..lineTo(w * .33, h * .80)
        ..lineTo(w * .42, h * .52)
        ..lineTo(w * .60, h * .52),
      Paint()
        ..color = Colors.white.withValues(alpha: .92)
        ..style = PaintingStyle.stroke
        ..strokeWidth = h * .075
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    // ARM outline
    canvas.drawPath(
      _arm(w, h),
      Paint()
        ..color = const Color(0xFFDDAA55).withValues(alpha: .45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = h * .025
        ..strokeCap = StrokeCap.round,
    );
  }

  Path _heart(double w, double h) {
    final cx = w / 2;
    return Path()
      ..moveTo(cx, h * .90)
      ..cubicTo(w * .04, h * .65, -w * .01, h * .30, w * .22, h * .14)
      ..cubicTo(w * .36, h * .02, cx, h * .22, cx, h * .22)
      ..cubicTo(cx, h * .22, w * .64, h * .02, w * .78, h * .14)
      ..cubicTo(w * 1.01, h * .30, w * .96, h * .65, cx, h * .90)
      ..close();
  }

  Path _arm(double w, double h) => Path()
    ..moveTo(w * .60, h * .68)
    ..quadraticBezierTo(w * .74, h * .80, w * .88, h * .64)
    ..quadraticBezierTo(w * .98, h * .52, w * .90, h * .36)
    ..quadraticBezierTo(w * .94, h * .14, w * .76, h * .06)
    ..quadraticBezierTo(w * .62, h * .02, w * .57, h * .18)
    ..quadraticBezierTo(w * .57, h * .36, w * .68, h * .44)
    ..quadraticBezierTo(w * .62, h * .54, w * .60, h * .62)
    ..close();

  @override
  bool shouldRepaint(_) => false;
}

// ═══════════════════ HEXAGONÁLNÍ COIN BADGE ════════════
class _HexBadge extends StatelessWidget {
  final int value;
  const _HexBadge({required this.value});

  @override
  Widget build(BuildContext context) {
    // Responsivní velikost písma dle šířky obrazovky
    final sw = MediaQuery.of(context).size.width;
    final fs = sw < 360 ? 11.0 : 13.0;
    final label = '\$ $value';
    // Šířka = délka textu × šířka znaku + vnitřní mezera (padding) na každou stranu
    final textW = label.length * (fs * 0.68);
    final padH = 20.0; // horizontální padding uvnitř hexagonu
    final padV = 10.0; // vertikální padding
    final w = (textW + padH * 2).clamp(60.0, 140.0);
    final h = fs * 2 + padV * 2;

    return CustomPaint(
      painter: _HexPainter(
        fillColor: _C.card,
        strokeColor: _C.gold,
        strokeWidth: 1.6,
      ),
      child: SizedBox(
        width: w,
        height: h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$',
              style: TextStyle(
                color: _C.gold,
                fontWeight: FontWeight.bold,
                fontSize: fs,
              ),
            ),
            const SizedBox(width: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$value',
                style: TextStyle(
                  color: _C.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: fs,
                  letterSpacing: .3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HexPainter extends CustomPainter {
  final Color fillColor, strokeColor;
  final double strokeWidth;
  const _HexPainter({
    required this.fillColor,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final path = _hex(size);
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  Path _hex(Size s) {
    final cx = s.width / 2,
        cy = s.height / 2,
        r = (s.shortestSide / 2) - strokeWidth;
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final a = (pi / 3) * i - pi / 6;
      final x = cx + r * cos(a), y = cy + r * sin(a);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(covariant _HexPainter o) =>
      o.fillColor != fillColor || o.strokeColor != strokeColor;
}

// ═══════════════════════ WAVE PAINTER ═══════════════════
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _C.gold.withValues(alpha: .16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final y = size.height * (.25 + i * .28);
      final path = Path()
        ..moveTo(size.width * .38, y)
        ..cubicTo(
          size.width * .52,
          y - 7,
          size.width * .68,
          y + 7,
          size.width * .82,
          y,
        )
        ..cubicTo(
          size.width * .90,
          y - 3,
          size.width * .96,
          y + 2,
          size.width,
          y,
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ═══════════════════ OBCHOD — DATA MODEL ════════════════

enum VzacnostTyp {
  zakladni('Základní', Color(0xFF8A8A8A), 1),
  vzacne('Vzácné', Color(0xFF4A90D9), 2),
  epicke('Epické', Color(0xFF9B4DC4), 3),
  legendarni('Legendární', Color(0xFFC4974A), 4);

  final String nazev;
  final Color barva;
  final int hvezdicky;
  const VzacnostTyp(this.nazev, this.barva, this.hvezdicky);
}

enum TypPredmetu {
  triko('Triko', '👕', 'assets/ikony/triko.png'),
  kalhoty('Kalhoty', '👖', 'assets/ikony/kalhoty.png'),
  boty('Boty', '👟', 'assets/ikony/boty.png'),
  cepice('Čepice', '🧢', 'assets/ikony/cepice.png'),
  rukavice('Rukavice', '🥊', 'assets/ikony/rukavice.png');

  final String nazev;
  final String emoji;
  final String ikonaPath;
  const TypPredmetu(this.nazev, this.emoji, this.ikonaPath);

  Widget ikonaWidget({double size = 22}) => Image.asset(
    ikonaPath,
    width: size,
    height: size,
    errorBuilder: (_, __, ___) =>
        Text(emoji, style: TextStyle(fontSize: size * .85)),
  );
}

class PredmetObchodu {
  final String id, nazev, popis;
  final TypPredmetu typ;
  final VzacnostTyp vzacnost;
  final int cena;
  const PredmetObchodu({
    required this.id,
    required this.nazev,
    required this.popis,
    required this.typ,
    required this.vzacnost,
    required this.cena,
  });
}

const List<PredmetObchodu> _katalog = [
  // ── TRIKO (t1–t4) ───────────────────────────────────────
  PredmetObchodu(
    id: 't1',
    nazev: 'Triko Base',
    popis: 'Základní dres se sportovním logem.',
    typ: TypPredmetu.triko,
    vzacnost: VzacnostTyp.zakladni,
    cena: 50,
  ),
  PredmetObchodu(
    id: 't2',
    nazev: 'Triko Sport',
    popis: 'Funkční závodní dres s logem.',
    typ: TypPredmetu.triko,
    vzacnost: VzacnostTyp.vzacne,
    cena: 150,
  ),
  PredmetObchodu(
    id: 't3',
    nazev: 'Triko Elite',
    popis: 'Prémiové závodní triko Elite Series.',
    typ: TypPredmetu.triko,
    vzacnost: VzacnostTyp.epicke,
    cena: 380,
  ),
  PredmetObchodu(
    id: 't4',
    nazev: 'Triko Legend',
    popis: 'Legendární edice — pouze pro elitu.',
    typ: TypPredmetu.triko,
    vzacnost: VzacnostTyp.legendarni,
    cena: 900,
  ),
  // ── KALHOTY (k1–k4) ─────────────────────────────────────
  PredmetObchodu(
    id: 'k1',
    nazev: 'Kraťasy Base',
    popis: 'Lehké sportovní kraťasy.',
    typ: TypPredmetu.kalhoty,
    vzacnost: VzacnostTyp.zakladni,
    cena: 80,
  ),
  PredmetObchodu(
    id: 'k2',
    nazev: 'Kraťasy Sport',
    popis: 'Technické závodní kraťasy.',
    typ: TypPredmetu.kalhoty,
    vzacnost: VzacnostTyp.vzacne,
    cena: 200,
  ),
  PredmetObchodu(
    id: 'k3',
    nazev: 'Tepláky Elite',
    popis: 'Prémiové tepláky Elite Series.',
    typ: TypPredmetu.kalhoty,
    vzacnost: VzacnostTyp.epicke,
    cena: 450,
  ),
  PredmetObchodu(
    id: 'k4',
    nazev: 'Legíny Legend',
    popis: 'Legendární kompresní legíny.',
    typ: TypPredmetu.kalhoty,
    vzacnost: VzacnostTyp.legendarni,
    cena: 950,
  ),
  // ── BOTY (b1–b4) ────────────────────────────────────────
  PredmetObchodu(
    id: 'b1',
    nazev: 'Boty Base',
    popis: 'Základní tréninková obuv.',
    typ: TypPredmetu.boty,
    vzacnost: VzacnostTyp.zakladni,
    cena: 60,
  ),
  PredmetObchodu(
    id: 'b2',
    nazev: 'Boty Sport',
    popis: 'Výkonnostní závodní boty.',
    typ: TypPredmetu.boty,
    vzacnost: VzacnostTyp.vzacne,
    cena: 180,
  ),
  PredmetObchodu(
    id: 'b3',
    nazev: 'Boty Elite',
    popis: 'Prémiová závodní obuv Elite Series.',
    typ: TypPredmetu.boty,
    vzacnost: VzacnostTyp.epicke,
    cena: 420,
  ),
  PredmetObchodu(
    id: 'b4',
    nazev: 'Boty Legend',
    popis: 'Limitovaná edice Legend.',
    typ: TypPredmetu.boty,
    vzacnost: VzacnostTyp.legendarni,
    cena: 850,
  ),
  // ── ČEPICE (c1–c4) ──────────────────────────────────────
  PredmetObchodu(
    id: 'c1',
    nazev: 'Kšiltovka Base',
    popis: 'Klasická kšiltovka s logem.',
    typ: TypPredmetu.cepice,
    vzacnost: VzacnostTyp.zakladni,
    cena: 70,
  ),
  PredmetObchodu(
    id: 'c2',
    nazev: 'Čepice Sport',
    popis: 'Funkční sportovní čepice.',
    typ: TypPredmetu.cepice,
    vzacnost: VzacnostTyp.vzacne,
    cena: 160,
  ),
  PredmetObchodu(
    id: 'c3',
    nazev: 'Čepice Elite',
    popis: 'Prémiová čepice Elite Series.',
    typ: TypPredmetu.cepice,
    vzacnost: VzacnostTyp.epicke,
    cena: 350,
  ),
  PredmetObchodu(
    id: 'c4',
    nazev: 'Čepice Legend',
    popis: 'Legendární edice s unikátním znakem.',
    typ: TypPredmetu.cepice,
    vzacnost: VzacnostTyp.legendarni,
    cena: 800,
  ),
  // ── RUKAVICE (r1–r4) ────────────────────────────────────
  PredmetObchodu(
    id: 'r1',
    nazev: 'Rukavice Base',
    popis: 'Základní tréninkové rukavice.',
    typ: TypPredmetu.rukavice,
    vzacnost: VzacnostTyp.zakladni,
    cena: 55,
  ),
  PredmetObchodu(
    id: 'r2',
    nazev: 'Rukavice Sport',
    popis: 'Tréninkové rukavice se vzorem.',
    typ: TypPredmetu.rukavice,
    vzacnost: VzacnostTyp.vzacne,
    cena: 130,
  ),
  PredmetObchodu(
    id: 'r3',
    nazev: 'Rukavice Elite',
    popis: 'Prémiové závodní rukavice.',
    typ: TypPredmetu.rukavice,
    vzacnost: VzacnostTyp.epicke,
    cena: 320,
  ),
  PredmetObchodu(
    id: 'r4',
    nazev: 'Rukavice Legend',
    popis: 'Legendární rukavice šampionů.',
    typ: TypPredmetu.rukavice,
    vzacnost: VzacnostTyp.legendarni,
    cena: 780,
  ),
];

class PremiumSportRPG extends StatelessWidget {
  const PremiumSportRPG({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Premium Sport RPG',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light().copyWith(
      scaffoldBackgroundColor: _C.bg,
      colorScheme: const ColorScheme.light(primary: _C.gold, surface: _C.card),
    ),
    home: const MobilniRam(child: SplashObrazovka()),
  );
}

// ═══════════════════ SPLASH SCREEN ══════════════════════
class SplashObrazovka extends StatefulWidget {
  const SplashObrazovka({super.key});
  @override
  State<SplashObrazovka> createState() => _SplashObrazovkaState();
}

class _SplashObrazovkaState extends State<SplashObrazovka>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _glowOpacity;
  late Animation<double> _sloganOpacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _glowOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.50, curve: Curves.easeOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.05, 0.40, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.45, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.05, 0.50, curve: Curves.elasticOut),
      ),
    );

    _sloganOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.62, 0.80, curve: Curves.easeOut),
      ),
    );

    _ctrl.forward();

    // Přechod do hlavní aplikace
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (ctx, a, b) => const HlavniNavigace(),
          transitionDuration: const Duration(milliseconds: 700),
          transitionsBuilder: (ctx, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF110E08),
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, _) => Stack(
          children: [
            // Tmavý teplý gradient pozadí
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -.15),
                  radius: 1.0,
                  colors: [Color(0xFF2A1E0A), Color(0xFF0E0A05)],
                ),
              ),
            ),

            // Zlatý glow za logem
            Center(
              child: Opacity(
                opacity: _glowOpacity.value,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC4974A).withValues(alpha: .28),
                        blurRadius: 90,
                        spreadRadius: 40,
                      ),
                      BoxShadow(
                        color: const Color(0xFFFFD080).withValues(alpha: .12),
                        blurRadius: 140,
                        spreadRadius: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Střed: logo + název + slogan
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Image.asset(
                        'assets/logo.png',
                        width: 110,
                        height: 90,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const AppLogo(size: 90),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const SizedBox(height: 12),

                  // Slogan
                  Opacity(
                    opacity: _sloganOpacity.value,
                    child: const Text(
                      'Cvič. Pomáhej. Sbírej.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFC4974A),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Spodní verze / branding
            Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: _sloganOpacity.value,
                child: const Text(
                  'v1.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF5A4A2A),
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════ MOBILNÍ RÁM ═══════════════════════
class MobilniRam extends StatelessWidget {
  final Widget child;
  const MobilniRam({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 500) {
      return Scaffold(
        backgroundColor: const Color(0xFFD8D0C4),
        body: Center(
          child: Container(
            width: 420,
            height: 840,
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFFB8A890), width: 12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .22),
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

// ═══════════════════ TRÉNINK MODEL ══════════════════════
class Trening {
  final String id;
  final String nazev;
  final IconData ikona;
  final DateTime datum;
  bool jeSplneno;
  String typ;
  String? narocnost, cas, vykon, poznamka, cestaKFotce;

  Trening({
    required this.id,
    required this.nazev,
    required this.ikona,
    required this.datum,
    this.jeSplneno = false,
    this.typ = 'sila',
    this.narocnost,
    this.cas,
    this.vykon,
    this.poznamka,
    this.cestaKFotce,
  });
}

// ═══════════════════ GLOBÁLNÍ DATA ══════════════════════
class HerniData {
  static String jmeno = 'Sportovec';
  static int coiny = 120;
  static double kilometry = 5.20; // z Pomáhej
  static double kmZTreninku = 0.0; // z Moje cvičení
  static int minutZTreninku = 0; // z Moje cvičení
  static int darovaneKoruny = 5;
  static int celkemVybranoKomunitou = 42530;
  static const int komunitniCil = 100000;
  static String posledniSportJmeno = 'Běh venku';
  static String posledniSportInfo = '5,20 km • 28:12 min';

  // Obchod & Batoh
  static Set<String> vlastnene = {};
  static Map<String, String> oblecene = {};

  // ── XP SYSTÉM ─────────────────────────────────────────
  static int xp = 0;
  static int get xpUroven => xp ~/ 500 + 1;
  static double get xpProgress => (xp % 500) / 500.0;
  static int get xpDoNexUrovne => 500 - (xp % 500);
  static String get xpTitul {
    final u = xpUroven;
    if (u <= 2) return 'Začátečník';
    if (u <= 4) return 'Aktivní';
    if (u <= 7) return 'Pokročilý';
    if (u <= 12) return 'Expert';
    return 'Mistr';
  }

  static void pridejXP(int body) => xp += body;

  // ── TRUHLIČKY ─────────────────────────────────────────
  static DateTime? posledniVolnaTruhla;
  static bool get muzOtevritZdarma =>
      posledniVolnaTruhla == null ||
      DateTime.now().difference(posledniVolnaTruhla!) >=
          const Duration(hours: 8);
  static Duration get casDoVolneTruhly {
    if (muzOtevritZdarma) return Duration.zero;
    final diff =
        const Duration(hours: 8) -
        DateTime.now().difference(posledniVolnaTruhla!);
    return diff.isNegative ? Duration.zero : diff;
  }

  // ── ALIANCE ────────────────────────────────────────────
  static bool jeVAlianci = false;
  static String alianceNazev = '';
  static int alianceFond = 0; // sdílené coiny aliance
  static List<String> alianceClenove = [];
  static Map<String, int> budovyLvl = {
    'fitness': 1,
    'nemocnice': 1,
    'wellness': 1,
    'bezecky': 1,
    'bazen': 1,
  };

  static final Map<String, String> budovyNazvy = {
    'fitness': 'Fitness centrum',
    'nemocnice': 'Nemocnice',
    'wellness': 'Wellness & Regenerace',
    'bezecky': 'Běžecký okruh',
    'bazen': 'Bazén',
  };

  static final List<int> budovaCeny = [200, 500, 1000, 2500, 5000];

  static int budovaCena(String id) {
    final lvl = budovyLvl[id] ?? 1;
    if (lvl >= 5) return 0; // max level
    return budovaCeny[lvl - 1];
  }

  static List<Vyzva> aktivniVyzvy = [];
  static List<Vyzva> dokonceneVyzvy = [];

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

  static List<Trening> vsechnyTreninky = [
    Trening(
      id: '1',
      nazev: 'Běh venku',
      ikona: Icons.directions_run,
      datum: DateTime.now().subtract(const Duration(days: 1)),
      jeSplneno: true,
      typ: 'kardio',
      narocnost: 'Střední',
      cas: '28 min',
      vykon: '5.20 km',
      poznamka: 'Skvělý běh!',
    ),
    Trening(
      id: '2',
      nazev: 'Silový trénink',
      ikona: Icons.fitness_center,
      datum: DateTime.now(),
      typ: 'sila',
    ),
    Trening(
      id: '3',
      nazev: 'Jóga',
      ikona: Icons.self_improvement,
      datum: DateTime.now().add(const Duration(days: 1)),
      typ: 'mobilita',
    ),
    Trening(
      id: '4',
      nazev: 'HIIT',
      ikona: Icons.timer,
      datum: DateTime.now().add(const Duration(days: 3)),
      typ: 'sila',
    ),
  ];

  // Parsování km — přijímá číslo ("5", "5.2") i text ("5 km")
  static double parseKm(String? text) {
    if (text == null || text.isEmpty) return 0;
    final clean = text.replaceAll(',', '.').trim();
    final direct = double.tryParse(clean);
    if (direct != null) return direct;
    final m = RegExp(r'(\d+\.?\d*)').firstMatch(clean);
    return m != null ? double.tryParse(m.group(1)!) ?? 0 : 0;
  }

  // Parsování minut — přijímá číslo ("45") i text ("45 min", "1:15")
  static int parseMinuty(String? text) {
    if (text == null || text.isEmpty) return 0;
    final clean = text.trim();
    final direct = int.tryParse(clean);
    if (direct != null) return direct;
    final asDouble = double.tryParse(clean.replaceAll(',', '.'));
    if (asDouble != null) return asDouble.round();
    final m2 = RegExp(r'(\d+)[:\s](\d+)').firstMatch(clean);
    if (m2 != null)
      return (int.tryParse(m2.group(1)!) ?? 0) * 60 +
          (int.tryParse(m2.group(2)!) ?? 0);
    final m1 = RegExp(r'(\d+)').firstMatch(clean);
    return m1 != null ? int.tryParse(m1.group(1)!) ?? 0 : 0;
  }

  // ── SYSTÉM LEVELŮ ─────────────────────────────────────
  // Level = (nejnižší sval ~/ 5) + 1 → všechny na 5 = level 2, všechny na 10 = level 3 …
  static int get level {
    if (svalyLvl.isEmpty) return 1;
    final minSval = svalyLvl.values.reduce((a, b) => a < b ? a : b);
    return (minSval ~/ 5) + 1;
  }

  // Kolik levelů chybí nejslabšímu svalu do dalšího milníku (0–4)
  static int get progressNaLevel {
    if (svalyLvl.isEmpty) return 0;
    final minSval = svalyLvl.values.reduce((a, b) => a < b ? a : b);
    return minSval % 5;
  }

  // Titul podle levelu
  static String get levelTitul {
    final l = level;
    if (l <= 1) return 'Nováček';
    if (l <= 3) return 'Sportovec';
    if (l <= 5) return 'Veterán';
    if (l <= 8) return 'Elita';
    if (l <= 12) return 'Šampión';
    return 'Legenda';
  }
}

// ═════════════════ ŽEBŘÍČEK DATA ════════════════════════
class _Hrac {
  final String jmeno;
  final int coiny;
  final double km;
  final int treninky;
  final Color barva;
  final int level;
  const _Hrac(
    this.jmeno,
    this.coiny,
    this.km,
    this.treninky,
    this.barva,
    this.level,
  );
}

final List<_Hrac> _globalZebricek = [
  const _Hrac('Martin K.', 580, 142.5, 48, Color(0xFF5B8DD9), 9),
  const _Hrac('Jana P.', 445, 98.3, 38, Color(0xFFD95B8D), 7),
  const _Hrac('Petr N.', 390, 87.2, 32, Color(0xFF5BD9A4), 6),
  const _Hrac('Lucie H.', 355, 72.8, 29, Color(0xFFD9A45B), 5),
  const _Hrac('Tomáš V.', 320, 67.5, 26, Color(0xFF8D5BD9), 5),
  const _Hrac('Eva M.', 285, 58.1, 23, Color(0xFFD95B5B), 4),
  const _Hrac('Pavel R.', 260, 52.4, 21, Color(0xFF5BD95B), 4),
  const _Hrac('Kateřina B.', 230, 45.9, 18, Color(0xFF5BB8D9), 3),
  const _Hrac('Jakub F.', 210, 42.3, 17, Color(0xFFD9C45B), 3),
  const _Hrac('Monika S.', 185, 38.7, 15, Color(0xFFD95BAA), 2),
  const _Hrac('David K.', 165, 35.2, 13, Color(0xFF5BD9C4), 2),
  const _Hrac('Tereza V.', 145, 30.8, 12, Color(0xFFAA5BD9), 1),
];

final List<_Hrac> _pratelZebricek = [
  const _Hrac('Tomáš V.', 320, 67.5, 26, Color(0xFF8D5BD9), 5),
  const _Hrac('Eva M.', 285, 58.1, 23, Color(0xFFD95B5B), 4),
  const _Hrac('Pavel R.', 260, 52.4, 21, Color(0xFF5BD95B), 4),
  const _Hrac('Kateřina B.', 230, 45.9, 18, Color(0xFF5BB8D9), 3),
];

// ═════════════════ CUSTOM NAV ITEM ══════════════════════
class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: selected
                  ? BoxDecoration(
                      color: _C.gold.withValues(alpha: .13),
                      borderRadius: BorderRadius.circular(18),
                    )
                  : null,
              child: Icon(
                selected ? activeIcon : icon,
                color: selected ? _C.gold : _C.textS,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? _C.gold : _C.textS,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ═════════════════ HLAVNÍ NAVIGACE ══════════════════════
class HlavniNavigace extends StatefulWidget {
  const HlavniNavigace({super.key});
  @override
  State<HlavniNavigace> createState() => _HlavniNavigaceState();
}

class _HlavniNavigaceState extends State<HlavniNavigace> {
  int _idx = 0;
  void _obnovit() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final screens = [
      HlavniObrazovkaAvatar(onObnoveni: _obnovit),
      PomahejObrazovka(onObnoveni: _obnovit),
      const MojeCviceniObrazovka(),
      const StatistikyObrazovka(),
      ObchodObrazovka(onObnoveni: _obnovit),
      const VyzvyObrazovka(),
      AlianceObrazovka(onObnoveni: _obnovit),
    ];
    return Scaffold(
      backgroundColor: _C.bg,
      body: screens[_idx],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  _C.gold.withValues(alpha: .35),
                  _C.gold.withValues(alpha: .35),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.25, 0.75, 1.0],
              ),
            ),
          ),
          Container(
            color: _C.card,
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: HerniData.jmeno.length > 6
                        ? '${HerniData.jmeno.substring(0, 5)}…'
                        : HerniData.jmeno,
                    selected: _idx == 0,
                    onTap: () => setState(() => _idx = 0),
                  ),
                  _NavItem(
                    icon: Icons.favorite_border,
                    activeIcon: Icons.favorite,
                    label: 'Pomáhej',
                    selected: _idx == 1,
                    onTap: () => setState(() => _idx = 1),
                  ),
                  _NavItem(
                    icon: Icons.fitness_center_outlined,
                    activeIcon: Icons.fitness_center,
                    label: 'Cvičení',
                    selected: _idx == 2,
                    onTap: () => setState(() => _idx = 2),
                  ),
                  _NavItem(
                    icon: Icons.bar_chart_outlined,
                    activeIcon: Icons.bar_chart,
                    label: 'Statistiky',
                    selected: _idx == 3,
                    onTap: () => setState(() => _idx = 3),
                  ),
                  _NavItem(
                    icon: Icons.store_outlined,
                    activeIcon: Icons.store,
                    label: 'Obchod',
                    selected: _idx == 4,
                    onTap: () => setState(() => _idx = 4),
                  ),
                  _NavItem(
                    icon: Icons.emoji_events_outlined,
                    activeIcon: Icons.emoji_events,
                    label: 'Výzvy',
                    selected: _idx == 5,
                    onTap: () => setState(() => _idx = 5),
                  ),
                  _NavItem(
                    icon: Icons.shield_outlined,
                    activeIcon: Icons.shield,
                    label: 'Aliance',
                    selected: _idx == 6,
                    onTap: () => setState(() => _idx = 6),
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

// ═════════════════ STATISTIKY ════════════════════════════
class StatistikyObrazovka extends StatelessWidget {
  const StatistikyObrazovka({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: _C.bg,
        appBar: AppBar(
          backgroundColor: _C.card,
          elevation: 0,
          titleSpacing: 16,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Statistiky & Žebříček',
                style: TextStyle(
                  color: _C.gold,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.bar_chart, color: _C.gold, size: 22),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: _C.card2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: _C.gold,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: _C.white,
                unselectedLabelColor: _C.textS,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: '📊  Přehled'),
                  Tab(text: '🏆  Žebříček'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(children: [_PrehledTab(), _ZebricekView()]),
      ),
    );
  }
}

// ── Přehled Tab ──────────────────────────────────────────
class _PrehledTab extends StatefulWidget {
  const _PrehledTab();
  @override
  State<_PrehledTab> createState() => _PrehledTabState();
}

class _PrehledTabState extends State<_PrehledTab> {
  int _vybrano = 0; // 0=Kardio, 1=Síla, 2=Mobilita

  @override
  Widget build(BuildContext context) {
    final splnene = HerniData.vsechnyTreninky
        .where((t) => t.jeSplneno)
        .toList();
    final kardio = splnene.where((t) => t.typ == 'kardio').toList();
    final sila = splnene.where((t) => t.typ == 'sila').toList();
    final mobilita = splnene.where((t) => t.typ == 'mobilita').toList();

    // ── KM pouze z kardio vykon ────────────────────────
    double kmKardio = 0;
    for (final t in kardio) kmKardio += HerniData.parseKm(t.vykon);

    // ── Minuty pouze z cas pole (ne z vykon) ───────────
    int minSila = 0;
    for (final t in sila) minSila += HerniData.parseMinuty(t.cas);
    int minMob = 0;
    for (final t in mobilita) minMob += HerniData.parseMinuty(t.cas);
    int minKardio = 0;
    for (final t in kardio) minKardio += HerniData.parseMinuty(t.cas);

    // Aktivní sekce
    final List<Map<String, dynamic>> sekce = [
      {
        'label': '🏃  Kardio',
        'barva': const Color(0xFF5B8DD9),
        'ikona': Icons.directions_run_outlined,
        'count': kardio.length,
        'hlavniLabel': 'Uběhnuto / ujeto',
        'hlavniHodnota': kmKardio.toStringAsFixed(2),
        'hlavniJednotka': 'km',
        'vedlejsiLabel': 'Čas kardio',
        'vedlejsiHodnota': '$minKardio',
        'vedlejsiJednotka': 'min',
      },
      {
        'label': '💪  Síla',
        'barva': const Color(0xFFC4974A),
        'ikona': Icons.fitness_center_outlined,
        'count': sila.length,
        'hlavniLabel': 'Odcvičeno',
        'hlavniHodnota': '$minSila',
        'hlavniJednotka': 'min',
        'vedlejsiLabel': 'Tréninky',
        'vedlejsiHodnota': '${sila.length}',
        'vedlejsiJednotka': 'celkem',
      },
      {
        'label': '🧘  Mobilita',
        'barva': const Color(0xFF5BD9A4),
        'ikona': Icons.self_improvement_outlined,
        'count': mobilita.length,
        'hlavniLabel': 'Odcvičeno',
        'hlavniHodnota': '$minMob',
        'hlavniJednotka': 'min',
        'vedlejsiLabel': 'Tréninky',
        'vedlejsiHodnota': '${mobilita.length}',
        'vedlejsiJednotka': 'celkem',
      },
    ];
    final s = sekce[_vybrano];
    final Color barva = s['barva'] as Color;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Celkový souhrn (vždy viditelný) ─────────────
          Row(
            children: [
              Expanded(
                child: _MiniStatKarta(
                  ikona: Icons.monetization_on_outlined,
                  label: 'Coiny',
                  value: '${HerniData.coiny}',
                  unit: '',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStatKarta(
                  ikona: Icons.check_circle_outline,
                  label: 'Celkem tréninků',
                  value: '${splnene.length}',
                  unit: 'splněno',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Přepínač typu ────────────────────────────────
          const Text(
            'ZOBRAZIT STATISTIKU',
            style: TextStyle(
              color: _C.textS,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _C.card2,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: List.generate(sekce.length, (i) {
                final bool akt = _vybrano == i;
                final Color bv = sekce[i]['barva'] as Color;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _vybrano = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: akt
                          ? BoxDecoration(
                              color: bv.withValues(alpha: .15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: bv.withValues(alpha: .4),
                                width: 1.2,
                              ),
                            )
                          : null,
                      child: Text(
                        sekce[i]['label'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: akt ? FontWeight.bold : FontWeight.normal,
                          color: akt ? bv : _C.textS,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // ── Hlavní karta vybrané sekce ───────────────────
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: barva.withValues(alpha: .07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: barva.withValues(alpha: .3),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: barva.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        s['ikona'] as IconData,
                        color: barva,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      s['label'] as String,
                      style: TextStyle(
                        color: barva,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${s['count']} tréninků',
                      style: const TextStyle(color: _C.textS, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Hlavní číslo
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      s['hlavniHodnota'] as String,
                      style: TextStyle(
                        color: barva,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        s['hlavniJednotka'] as String,
                        style: TextStyle(
                          color: barva.withValues(alpha: .7),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  s['hlavniLabel'] as String,
                  style: const TextStyle(color: _C.textS, fontSize: 12),
                ),
                const SizedBox(height: 14),
                Container(height: 1, color: barva.withValues(alpha: .15)),
                const SizedBox(height: 12),
                // Vedlejší číslo
                Row(
                  children: [
                    Text(
                      s['vedlejsiHodnota'] as String,
                      style: const TextStyle(
                        color: _C.text,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${s['vedlejsiJednotka']}  ·  ${s['vedlejsiLabel']}',
                      style: const TextStyle(color: _C.textS, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _MiniStatKarta extends StatelessWidget {
  final IconData ikona;
  final String label, value, unit;
  const _MiniStatKarta({
    required this.ikona,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: _C.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _C.border),
    ),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: _C.gold.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(ikona, color: _C.gold, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _C.textS,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .4,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: _C.text,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (unit.isNotEmpty) ...[
                    const SizedBox(width: 3),
                    Text(
                      unit,
                      style: const TextStyle(color: _C.textS, fontSize: 11),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _TypKarta extends StatelessWidget {
  final IconData ikona;
  final String label;
  final Color barva;
  final List<String> radky;
  const _TypKarta({
    required this.ikona,
    required this.label,
    required this.barva,
    required this.radky,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: _C.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _C.border),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: barva.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(ikona, color: barva, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: _C.text,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: radky
              .map(
                (r) => Text(
                  r,
                  style: const TextStyle(color: _C.textS, fontSize: 12),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}

// ── Žebříček View ────────────────────────────────────────
class _ZebricekView extends StatefulWidget {
  const _ZebricekView();
  @override
  State<_ZebricekView> createState() => _ZebricekViewState();
}

class _ZebricekViewState extends State<_ZebricekView>
    with SingleTickerProviderStateMixin {
  late TabController _tc;

  @override
  void initState() {
    super.initState();
    _tc = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _C.card2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tc,
            indicator: BoxDecoration(
              color: _C.gold,
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: _C.white,
            unselectedLabelColor: _C.textS,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: '🌍  Globální'),
              Tab(text: '👥  Přátelé'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tc,
            children: [
              _LeaderboardList(seznam: _globalZebricek),
              _LeaderboardList(seznam: _pratelZebricek),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  final List<_Hrac> seznam;
  const _LeaderboardList({required this.seznam});

  @override
  Widget build(BuildContext context) {
    final kmCviceni = HerniData.vsechnyTreninky
        .where((t) => t.jeSplneno && t.typ == 'kardio')
        .fold(0.0, (sum, t) => sum + HerniData.parseKm(t.vykon));
    final aktualniHrac = _Hrac(
      HerniData.jmeno,
      HerniData.coiny,
      kmCviceni + HerniData.kilometry,
      HerniData.vsechnyTreninky.where((t) => t.jeSplneno).length,
      _C.gold,
      HerniData.level,
    );
    final vsichni = [...seznam];
    if (!vsichni.any((h) => h.jmeno == HerniData.jmeno))
      vsichni.add(aktualniHrac);
    vsichni.sort((a, b) => b.level.compareTo(a.level));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: vsichni.length,
      itemBuilder: (context, i) {
        final h = vsichni[i];
        final jeJa = h.jmeno == HerniData.jmeno;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: jeJa ? _C.gold.withValues(alpha: .08) : _C.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: jeJa ? _C.gold : _C.border,
              width: jeJa ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Pořadí
              SizedBox(
                width: 32,
                child: Text(
                  '${i + 1}.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: i == 0
                        ? const Color(0xFFFFD700)
                        : i == 1
                        ? const Color(0xFFC0C0C0)
                        : i == 2
                        ? const Color(0xFFCD7F32)
                        : _C.textS,
                  ),
                ),
              ),
              // Avatar kruh
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: h.barva.withValues(alpha: .2),
                  shape: BoxShape.circle,
                  border: Border.all(color: h.barva.withValues(alpha: .5)),
                ),
                child: Center(
                  child: Text(
                    h.jmeno[0],
                    style: TextStyle(
                      color: h.barva,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Jméno + detaily
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      h.jmeno,
                      style: const TextStyle(
                        color: _C.text,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${h.treninky} tréninků • ${h.km.toStringAsFixed(0)} km',
                      style: const TextStyle(color: _C.textS, fontSize: 11),
                    ),
                  ],
                ),
              ),
              // LEVEL (hlavní metrika žebříčku)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        'Lvl',
                        style: TextStyle(
                          color: h.barva.withValues(alpha: .7),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${h.level}',
                        style: TextStyle(
                          color: h.barva,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${h.coiny} coinů',
                    style: const TextStyle(color: _C.textS, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═════════════ MOJE CVIČENÍ ══════════════════════════════
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

  final List<Map<String, dynamic>> _sporty = [
    {'jmeno': 'Běh venku', 'ikona': Icons.directions_run, 'typ': 'kardio'},
    {'jmeno': 'Běh v hale', 'ikona': Icons.directions_run, 'typ': 'kardio'},
    {'jmeno': 'Chůze venku', 'ikona': Icons.directions_walk, 'typ': 'kardio'},
    {
      'jmeno': 'Jízda na kole venku',
      'ikona': Icons.directions_bike,
      'typ': 'kardio',
    },
    {
      'jmeno': 'Jízda na kole v hale',
      'ikona': Icons.pedal_bike,
      'typ': 'kardio',
    },
    {'jmeno': 'Plavání v bazénu', 'ikona': Icons.pool, 'typ': 'kardio'},
    {'jmeno': 'Silový trénink', 'ikona': Icons.fitness_center, 'typ': 'sila'},
    {'jmeno': 'HIIT', 'ikona': Icons.timer, 'typ': 'sila'},
    {
      'jmeno': 'Trénink středu těla',
      'ikona': Icons.accessibility_new,
      'typ': 'sila',
    },
    {'jmeno': 'Jóga', 'ikona': Icons.self_improvement, 'typ': 'mobilita'},
    {'jmeno': 'Pilates', 'ikona': Icons.spa, 'typ': 'mobilita'},
    {'jmeno': 'Tanec', 'ikona': Icons.music_note, 'typ': 'mobilita'},
  ];
  late Map<String, dynamic> _vybranySport;

  @override
  void initState() {
    super.initState();
    _vybranySport = _sporty[0];
  }

  bool _maPlan(DateTime den) => HerniData.vsechnyTreninky.any(
    (t) =>
        t.datum.year == den.year &&
        t.datum.month == den.month &&
        t.datum.day == den.day &&
        !t.jeSplneno,
  );
  bool _maSplneno(DateTime den) {
    final v = HerniData.vsechnyTreninky.where(
      (t) =>
          t.datum.year == den.year &&
          t.datum.month == den.month &&
          t.datum.day == den.day,
    );
    return v.isNotEmpty && v.every((t) => t.jeSplneno);
  }

  void _otevriDialogSplneni(Trening trening) {
    String vybranaNarocnost = 'Střední';
    final casCtrl = TextEditingController();
    final vykonCtrl = TextEditingController();
    final poznamkaCtrl = TextEditingController();
    String? nahranaFotka;
    bool nacitaFotku = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDS) => AlertDialog(
          backgroundColor: _C.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Dokončit: ${trening.nazev}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: _C.gold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Náročnost:',
                    style: TextStyle(color: _C.textS, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _C.card2,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _C.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: vybranaNarocnost,
                      dropdownColor: _C.card,
                      isExpanded: true,
                      style: const TextStyle(color: _C.text),
                      items: ['Lehká', 'Střední', 'Těžká', 'Brutální']
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,
                              child: Text(
                                v,
                                style: const TextStyle(color: _C.text),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setDS(() => vybranaNarocnost = v);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _numField(casCtrl, 'Čas tréninku', 'min'),
                const SizedBox(height: 12),
                if (trening.typ == 'kardio')
                  _numField(vykonCtrl, 'Vzdálenost', 'km')
                else
                  _inputField(
                    vykonCtrl,
                    'Výkon (série, opakování, poznámka...)',
                  ),
                const SizedBox(height: 12),
                _inputField(poznamkaCtrl, 'Poznámka...', maxLines: 2),
                const SizedBox(height: 12),
                if (nacitaFotku)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(_C.gold),
                    ),
                  )
                else if (nahranaFotka != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _C.card2,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _C.green),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: _C.green, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Fotka připravena',
                          style: TextStyle(color: _C.text, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _C.gold,
                        side: const BorderSide(color: _C.gold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.add_a_photo, size: 16),
                      label: const Text(
                        'Přidat fotku',
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        setDS(() => nacitaFotku = true);
                        Future.delayed(const Duration(milliseconds: 800), () {
                          setDS(() {
                            nacitaFotku = false;
                            nahranaFotka = 'foto.jpg';
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
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Zrušit', style: TextStyle(color: _C.textS)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.gold,
                foregroundColor: _C.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                setState(() {
                  trening.jeSplneno = true;
                  trening.narocnost = vybranaNarocnost;
                  trening.cas = casCtrl.text.isEmpty
                      ? 'Nezadáno'
                      : casCtrl.text;
                  trening.vykon = vykonCtrl.text.isEmpty
                      ? 'Nezadáno'
                      : vykonCtrl.text;
                  trening.poznamka = poznamkaCtrl.text.isEmpty
                      ? null
                      : poznamkaCtrl.text;
                  trening.cestaKFotce = nahranaFotka;
                  // +2 coiny za splnění
                  HerniData.coiny += 2;
                  HerniData.pridejXP(50); // +50 XP za splněný trénink
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${trening.nazev} splněn! +2 coiny 🎉'),
                    backgroundColor: _C.green,
                  ),
                );
              },
              child: const Text(
                'Uložit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
  }) => TextField(
    controller: ctrl,
    style: const TextStyle(color: _C.text),
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: hint,
      labelStyle: const TextStyle(color: _C.textS, fontSize: 12),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _C.border),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _C.gold),
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: _C.card2,
    ),
  );

  Widget _numField(TextEditingController ctrl, String label, String unit) =>
      TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          color: _C.text,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: _C.textS, fontSize: 12),
          suffixText: unit,
          suffixStyle: const TextStyle(
            color: _C.gold,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: _C.border),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: _C.gold, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: _C.card2,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final planovane =
        HerniData.vsechnyTreninky.where((t) => !t.jeSplneno).toList()
          ..sort((a, b) => a.datum.compareTo(b.datum));
    final splnene = HerniData.vsechnyTreninky.where((t) => t.jeSplneno).toList()
      ..sort((a, b) => b.datum.compareTo(a.datum));
    final dny = DateTime(_aktualniMesic.year, _aktualniMesic.month + 1, 0).day;
    final zacatek = DateTime(
      _aktualniMesic.year,
      _aktualniMesic.month,
      1,
    ).weekday;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Moje cvičení',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: _C.gold,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.fitness_center, color: _C.gold, size: 22),
              ],
            ),
            const SizedBox(height: 16),
            // Kalendář
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _C.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, color: _C.gold),
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _C.gold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, color: _C.gold),
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
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Po', 'Út', 'St', 'Čt', 'Pá', 'So', 'Ne']
                        .map(
                          (d) => Text(
                            d,
                            style: const TextStyle(
                              color: _C.textS,
                              fontSize: 11,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 6),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                    itemCount: dny + (zacatek - 1),
                    itemBuilder: (ctx, idx) {
                      if (idx < zacatek - 1) return const SizedBox();
                      final den = idx - (zacatek - 2);
                      final datum = DateTime(
                        _aktualniMesic.year,
                        _aktualniMesic.month,
                        den,
                      );
                      final jeVybran =
                          datum.year == _vybraneDatum.year &&
                          datum.month == _vybraneDatum.month &&
                          datum.day == _vybraneDatum.day;
                      Color bgColor = Colors.transparent;
                      Color fgColor = _C.text;
                      if (_maSplneno(datum)) {
                        bgColor = _C.goldD;
                        fgColor = _C.white;
                      } else if (_maPlan(datum)) {
                        bgColor = _C.gold;
                        fgColor = _C.white;
                      }
                      return GestureDetector(
                        onTap: () => setState(() => _vybraneDatum = datum),
                        child: Container(
                          decoration: BoxDecoration(
                            color: bgColor,
                            shape: BoxShape.circle,
                            border: jeVybran
                                ? Border.all(color: _C.text, width: 2)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '$den',
                              style: TextStyle(
                                color: fgColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
            const SizedBox(height: 16),
            // Dropdown + plánovat
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _C.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Map<String, dynamic>>(
                  value: _vybranySport,
                  dropdownColor: _C.card,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: _C.gold),
                  items: _sporty
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Row(
                            children: [
                              Icon(s['ikona'], color: _C.gold, size: 18),
                              const SizedBox(width: 10),
                              Text(
                                s['jmeno'],
                                style: const TextStyle(
                                  color: _C.text,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (s) {
                    if (s != null) setState(() => _vybranySport = s);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.gold,
                  foregroundColor: _C.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(
                  'Naplánovat na ${_vybraneDatum.day}. ${_vybraneDatum.month}.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  setState(
                    () => HerniData.vsechnyTreninky.add(
                      Trening(
                        id: DateTime.now().toString(),
                        nazev: _vybranySport['jmeno'],
                        ikona: _vybranySport['ikona'],
                        datum: _vybraneDatum,
                        typ: _vybranySport['typ'],
                      ),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Přidáno na ${_vybraneDatum.day}. ${_vybraneDatum.month}.',
                      ),
                      backgroundColor: _C.green,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.hourglass_empty, color: _C.gold, size: 13),
                          SizedBox(width: 4),
                          Text(
                            'PLÁN',
                            style: TextStyle(
                              color: _C.textS,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (planovane.isEmpty)
                        const Text(
                          'Žádný plán.',
                          style: TextStyle(
                            color: _C.textS,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else
                        ...planovane.map((t) => _kartickaPlanu(t)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle_outline,
                            color: _C.gold,
                            size: 13,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'HISTORIE',
                            style: TextStyle(
                              color: _C.textS,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (splnene.isEmpty)
                        const Text(
                          'Nic nesplněno.',
                          style: TextStyle(
                            color: _C.textS,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else
                        ...splnene.map((t) => _kartickaHistorie(t)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kartickaPlanu(Trening t) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: _C.card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _C.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(t.ikona, color: _C.gold, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                t.nazev,
                style: const TextStyle(
                  color: _C.text,
                  fontSize: 12,
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
                color: _C.gold,
                size: 20,
              ),
              onPressed: () => _otevriDialogSplneni(t),
            ),
          ],
        ),
        Text(
          '${t.datum.day}. ${t.datum.month}.',
          style: const TextStyle(color: _C.textS, fontSize: 10),
        ),
      ],
    ),
  );

  Widget _kartickaHistorie(Trening t) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: _C.card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _C.gold.withValues(alpha: .35)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(t.ikona, color: _C.gold, size: 16),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                t.nazev,
                style: const TextStyle(
                  color: _C.text,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Divider(color: _C.border, height: 10),
        Text(
          '✅ ${t.datum.day}. ${t.datum.month}.',
          style: const TextStyle(
            color: _C.gold,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (t.vykon != null)
          Text(
            'Výkon: ${t.vykon}',
            style: const TextStyle(color: _C.textS, fontSize: 10),
          ),
        if (t.cas != null)
          Text(
            'Čas: ${t.cas}',
            style: const TextStyle(color: _C.textS, fontSize: 10),
          ),
      ],
    ),
  );
}

// ═════════════════ MŮJ AVATAR ════════════════════════════
class HlavniObrazovkaAvatar extends StatefulWidget {
  final VoidCallback onObnoveni;
  const HlavniObrazovkaAvatar({super.key, required this.onObnoveni});
  @override
  State<HlavniObrazovkaAvatar> createState() => _HlavniObrazovkaAvatarState();
}

class _HlavniObrazovkaAvatarState extends State<HlavniObrazovkaAvatar>
    with SingleTickerProviderStateMixin {
  String? _aktivniSval;
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _glowAnim = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 70,
      ),
    ]).animate(_glowCtrl);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  void _vylepsiSval(String sval) {
    const int cena = 10;
    if (HerniData.coiny >= cena) {
      final stareLvl = HerniData.level;
      setState(() {
        HerniData.coiny -= cena;
        HerniData.svalyLvl[sval] = (HerniData.svalyLvl[sval] ?? 1) + 1;
        _aktivniSval = sval;
      });
      // Spustit glow animaci na postavě
      _glowCtrl.forward(from: 0);
      widget.onObnoveni();
      if (HerniData.level > stareLvl) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) _ukazLevelUp(HerniData.level);
        });
      }
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _aktivniSval = null);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nedostatek coinů!'),
          backgroundColor: _C.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _ukazLevelUp(int novaUroven) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 8),
              const Text(
                'LEVEL UP!',
                style: TextStyle(
                  color: _C.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Level $novaUroven',
                style: const TextStyle(
                  color: _C.text,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                HerniData.levelTitul,
                style: TextStyle(
                  color: _C.gold.withValues(alpha: .7),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _C.gold.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _C.gold.withValues(alpha: .25)),
                ),
                child: const Text(
                  'Všechny svaly dosáhly dalšího milníku!\nNásledující cíl: +5 ke každému svalu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _C.textS, fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.gold,
                    foregroundColor: _C.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Skvělé! 💪',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editJmeno() {
    final ctrl = TextEditingController(text: HerniData.jmeno);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Změnit jméno',
          style: TextStyle(color: _C.gold, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: _C.text),
          decoration: InputDecoration(
            hintText: 'Tvoje jméno...',
            hintStyle: const TextStyle(color: _C.textS),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: _C.border),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: _C.gold),
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: _C.card2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Zrušit', style: TextStyle(color: _C.textS)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.gold,
              foregroundColor: _C.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty)
                setState(() => HerniData.jmeno = ctrl.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text(
              'Uložit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ── HEADER ──────────────────────────────────────────
            Container(
              color: _C.card,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  // Jméno + edit + level
                  GestureDetector(
                    onTap: _editJmeno,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              HerniData.jmeno,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: _C.gold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.edit_outlined,
                              size: 13,
                              color: _C.gold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        // Level badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _C.gold.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _C.gold.withValues(alpha: .4),
                              width: .8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Lvl ${HerniData.level}',
                                style: const TextStyle(
                                  color: _C.gold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 6),
                              SizedBox(
                                width: 36,
                                height: 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    value: HerniData.progressNaLevel / 5,
                                    backgroundColor: _C.border,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          _C.gold,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        // XP bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF7B5EA7,
                            ).withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(
                                0xFF9B6BC7,
                              ).withValues(alpha: .4),
                              width: .8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'XP ${HerniData.xpUroven}',
                                style: const TextStyle(
                                  color: Color(0xFF9B6BC7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '· ${HerniData.xpTitul}',
                                style: const TextStyle(
                                  color: _C.textS,
                                  fontSize: 9,
                                ),
                              ),
                              const SizedBox(width: 5),
                              SizedBox(
                                width: 36,
                                height: 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    value: HerniData.xpProgress,
                                    backgroundColor: _C.border,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF9B6BC7),
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Logo střed
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        height: 38,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const AppLogo(size: 38),
                      ),
                    ),
                  ),
                  // Coin badge
                  _HexBadge(value: HerniData.coiny),
                ],
              ),
            ),
            // Zlatý separator
            Container(
              height: 1.5,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    _C.gold.withValues(alpha: .5),
                    _C.gold.withValues(alpha: .5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.25, 0.75, 1.0],
                ),
              ),
            ),

            // ── POSTAVA + OBLEČENÉ ──────────────────────────────
            // ── POSTAVA ─────────────────────────────────────────
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.82,
                child: AnimatedBuilder(
                  animation: _glowAnim,
                  builder: (ctx, child) => _PostavaSeLabely(
                    svalyLvl: HerniData.svalyLvl,
                    aktivniSval: _aktivniSval,
                    glowIntensity: _glowAnim.value,
                  ),
                ),
              ),
            ),

            // ── OBLEČENÉ POD FOTKOU ──────────────────────────────
            _ObleceneRadek(),

            // ── TRUHLIČKY ────────────────────────────────────────
            _TruhlyPanel(onObnoveni: () => setState(() {})),

            // ── BATOH TLAČÍTKO ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BatohObrazovka()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _C.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _C.border),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/batoh.png',
                        width: 28,
                        height: 28,
                        errorBuilder: (_, __, ___) =>
                            const Text('🎒', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Batoh',
                        style: TextStyle(
                          color: _C.text,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${HerniData.vlastnene.length} předmětů',
                        style: const TextStyle(color: _C.textS, fontSize: 12),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.chevron_right,
                        color: _C.textS,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── TRÉNINKOVÉ CENTRUM ───────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TRÉNINKOVÉ CENTRUM (1 upgrade = 10 coinů)',
                    style: TextStyle(
                      color: _C.gold,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 3.2,
                        ),
                    itemCount: HerniData.svalyLvl.length,
                    itemBuilder: (ctx, i) {
                      final jmeno = HerniData.svalyLvl.keys.elementAt(i);
                      final lvl = HerniData.svalyLvl[jmeno] ?? 1;
                      return _SvalKarta(
                        nazev: jmeno,
                        lvl: lvl,
                        onUpgrade: () => _vylepsiSval(jmeno),
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

// ═══════════════ POSTAVA SE ŠTÍTKY ═══════════════════════
class _PostavaSeLabely extends StatelessWidget {
  final Map<String, int> svalyLvl;
  final String? aktivniSval;
  final double glowIntensity;
  const _PostavaSeLabely({
    required this.svalyLvl,
    this.aktivniSval,
    this.glowIntensity = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: [
          // Zlatý glow stín (zesílí při upgradu)
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: _C.gold.withValues(alpha: .28 + glowIntensity * .45),
                    blurRadius: 18 + glowIntensity * 30,
                    spreadRadius: 2 + glowIntensity * 8,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),

          // Zlatý rámeček (zesvětlí při upgradu)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      const Color(0xFFEDD47A),
                      Colors.white,
                      glowIntensity * .5,
                    )!,
                    const Color(0xFFC4974A),
                    const Color(0xFFAD7C2E),
                    const Color(0xFFD4A855),
                    Color.lerp(
                      const Color(0xFFEDD47A),
                      Colors.white,
                      glowIntensity * .5,
                    )!,
                  ],
                  stops: const [0.0, 0.3, 0.5, 0.75, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/postava_muz.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (c, e, s) => PostavaWidget(
                      svalyLvl: svalyLvl,
                      aktivniSval: aktivniSval,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Zlatý radial glow přes celou postavu
          if (glowIntensity > 0.01)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.85,
                        colors: [
                          const Color(
                            0xFFFFD700,
                          ).withValues(alpha: glowIntensity * .50),
                          const Color(
                            0xFFC4974A,
                          ).withValues(alpha: glowIntensity * .25),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Shimmer vlna zprava doleva
          if (glowIntensity > 0.01)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: IgnorePointer(
                  child: Transform.translate(
                    offset: Offset(-150 + glowIntensity * 500, 0),
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: glowIntensity * .40),
                            Colors.white.withValues(alpha: glowIntensity * .15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Rohové ozdoby (zlatější při upgradu)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _RohyPainter(
                  Color.lerp(
                    const Color(0xFFEDD47A),
                    Colors.white,
                    glowIntensity * .6,
                  )!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Kreslí rohové L-ozdoby přes celý widget
class _RohyPainter extends CustomPainter {
  final Color color;
  const _RohyPainter(this.color);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const len = 18.0;
    const off = 10.0;
    // Top-left
    canvas.drawLine(Offset(off, off + len), Offset(off, off), p);
    canvas.drawLine(Offset(off, off), Offset(off + len, off), p);
    // Top-right
    canvas.drawLine(
      Offset(s.width - off - len, off),
      Offset(s.width - off, off),
      p,
    );
    canvas.drawLine(
      Offset(s.width - off, off),
      Offset(s.width - off, off + len),
      p,
    );
    // Bottom-left
    canvas.drawLine(
      Offset(off, s.height - off - len),
      Offset(off, s.height - off),
      p,
    );
    canvas.drawLine(
      Offset(off, s.height - off),
      Offset(off + len, s.height - off),
      p,
    );
    // Bottom-right
    canvas.drawLine(
      Offset(s.width - off - len, s.height - off),
      Offset(s.width - off, s.height - off),
      p,
    );
    canvas.drawLine(
      Offset(s.width - off, s.height - off),
      Offset(s.width - off, s.height - off - len),
      p,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// Oblečené předměty v řádku pod fotkou
class _ObleceneRadek extends StatelessWidget {
  const _ObleceneRadek();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: TypPredmetu.values.map((typ) {
          final id = HerniData.oblecene[typ.nazev];
          final predmet = id != null
              ? _katalog.where((p) => p.id == id).firstOrNull
              : null;

          Widget ikonka;
          if (predmet != null) {
            ikonka = ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                'assets/obleceni/${predmet.id}.png',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    predmet.typ.emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
            );
          } else {
            ikonka = ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Container(
                color: _C.card2,
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  typ.ikonaPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(
                      typ.emoji,
                      style: const TextStyle(fontSize: 42),
                    ),
                  ),
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: predmet != null
                        ? predmet.vzacnost.barva.withValues(alpha: .40)
                        : _C.border,
                    width: predmet != null ? 1.3 : 1.0,
                  ),
                  boxShadow: predmet != null
                      ? [
                          BoxShadow(
                            color: predmet.vzacnost.barva.withValues(
                              alpha: .15,
                            ),
                            blurRadius: 5,
                          ),
                        ]
                      : null,
                ),
                child: ikonka,
              ),
              const SizedBox(height: 4),
              Text(
                typ.nazev,
                style: const TextStyle(color: _C.textS, fontSize: 9),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// Rohová ozdoba (L-tvar)
class _RohPainter extends CustomPainter {
  final Color color;
  final double stroke;
  final bool flipH, flipV;
  const _RohPainter(
    this.color,
    this.stroke, {
    this.flipH = false,
    this.flipV = false,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final len = s.width * .65;
    final x = flipH ? s.width : 0.0;
    final y = flipV ? s.height : 0.0;
    final dx = flipH ? -1.0 : 1.0;
    final dy = flipV ? -1.0 : 1.0;
    // Vodorovná čára
    canvas.drawLine(Offset(x, y), Offset(x + dx * len, y), p);
    // Svislá čára
    canvas.drawLine(Offset(x, y), Offset(x, y + dy * len), p);
    // Malý čtvereček v rohu
    canvas.drawCircle(
      Offset(x, y),
      stroke * 1.2,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ═════════════════ SVAL KARTA (animovaná) ════════════════
class _SvalKarta extends StatefulWidget {
  final String nazev;
  final int lvl;
  final VoidCallback onUpgrade;
  const _SvalKarta({
    required this.nazev,
    required this.lvl,
    required this.onUpgrade,
  });
  @override
  State<_SvalKarta> createState() => _SvalKartaState();
}

class _SvalKartaState extends State<_SvalKarta>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.80,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _btnColor() {
    final lvl = widget.lvl;
    if (lvl <= 1) return _C.gold.withValues(alpha: .13);
    if (lvl <= 3) return _C.gold.withValues(alpha: .28);
    if (lvl <= 5) return _C.gold.withValues(alpha: .48);
    return _C.gold.withValues(alpha: .68);
  }

  void _onTap() {
    _ctrl.forward().then((_) => _ctrl.reverse());
    widget.onUpgrade();
  }

  @override
  Widget build(BuildContext context) {
    final lvl = widget.lvl;
    final progress = lvl % 5 == 0 ? 1.0 : (lvl % 5) / 5.0;
    final cycle = (lvl - 1) % 5; // 0–4, opakuje se každých 5 levelů
    final tierColor = cycle <= 1
        ? const Color(0xFF8FA8B8) // šedá  (lvl 1-2, 6-7, 11-12...)
        : cycle <= 3
        ? const Color(0xFF5B9BD5) // modrá (lvl 3-4, 8-9, 13-14...)
        : const Color(0xFFAB47BC); // fialová (lvl 5, 10, 15...)

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: lvl > 1 ? tierColor.withValues(alpha: .35) : _C.border,
          ),
        ),
        child: Stack(
          children: [
            // Barevný levý pruh
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: tierColor.withValues(alpha: .8),
                ),
              ),
            ),
            // Obsah
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
              child: Row(
                children: [
                  // Text + progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.nazev,
                          style: const TextStyle(
                            color: _C.text,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              'Lvl $lvl',
                              style: TextStyle(
                                color: tierColor,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: progress == 0 && lvl > 1
                                      ? 1.0
                                      : progress,
                                  minHeight: 3,
                                  backgroundColor: _C.border,
                                  valueColor: AlwaysStoppedAnimation(tierColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  // + tlačítko
                  ScaleTransition(
                    scale: _scale,
                    child: GestureDetector(
                      onTap: _onTap,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _btnColor(),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _C.gold.withValues(
                              alpha: lvl > 1 ? .75 : .35,
                            ),
                          ),
                          boxShadow: lvl > 1
                              ? [
                                  BoxShadow(
                                    color: _C.gold.withValues(alpha: .20),
                                    blurRadius: 5,
                                  ),
                                ]
                              : null,
                        ),
                        child: const Icon(Icons.add, color: _C.gold, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════ POMÁHEJ ═══════════════════════════════
class PomahejObrazovka extends StatefulWidget {
  final VoidCallback onObnoveni;
  const PomahejObrazovka({super.key, required this.onObnoveni});
  @override
  State<PomahejObrazovka> createState() => _PomahejObrazovkaState();
}

class _PomahejObrazovkaState extends State<PomahejObrazovka> {
  final String _mujUcet = '123456789', _kodBanky = '0100';
  final List<Map<String, dynamic>> _sportyPomahej = [
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
  late Map<String, dynamic> _vybranySport;

  @override
  void initState() {
    super.initState();
    _vybranySport = _sportyPomahej[0];
  }

  void _otevriZadani() {
    final hlavniCtrl = TextEditingController();
    final kcCtrl = TextEditingController();
    Map<String, dynamic> sport = _vybranySport;

    void prepocti() {
      final v = double.tryParse(hlavniCtrl.text.replaceAll(',', '.'));
      if (v != null)
        kcCtrl.text = v.round().toString();
      else
        kcCtrl.clear();
    }

    hlavniCtrl.addListener(prepocti);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDS) {
          final jeKardio = sport['typ'] == 'kardio';
          return AlertDialog(
            backgroundColor: _C.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Zapiš aktivitu',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: _C.gold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _C.card2,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _C.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Map<String, dynamic>>(
                        value: sport,
                        dropdownColor: _C.card,
                        isExpanded: true,
                        items: _sportyPomahej
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Row(
                                  children: [
                                    Icon(s['ikona'], color: _C.gold, size: 18),
                                    const SizedBox(width: 10),
                                    Text(
                                      s['jmeno'],
                                      style: const TextStyle(color: _C.text),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (s) {
                          if (s != null) setDS(() => sport = s);
                          prepocti();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    jeKardio
                        ? 'Pravidlo: 1 km = 1 Kč'
                        : 'Pravidlo: 1 minuta = 1 Kč',
                    style: const TextStyle(
                      color: _C.gold,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: hlavniCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(color: _C.text),
                    decoration: InputDecoration(
                      labelText: jeKardio
                          ? 'Kolik jsi uběhl/ujel? (km)'
                          : 'Jak dlouho jsi cvičil? (min)',
                      labelStyle: const TextStyle(
                        color: _C.textS,
                        fontSize: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: _C.border),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: _C.gold),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: _C.card2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: kcCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: _C.text),
                    decoration: InputDecoration(
                      labelText: 'Kolik přispěješ? (Kč)',
                      labelStyle: const TextStyle(
                        color: _C.textS,
                        fontSize: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: _C.border),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: _C.gold),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: _C.card2,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Zrušit', style: TextStyle(color: _C.textS)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.gold,
                  foregroundColor: _C.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final h =
                      double.tryParse(hlavniCtrl.text.replaceAll(',', '.')) ??
                      0;
                  final kc = int.tryParse(kcCtrl.text) ?? 0;
                  if (h <= 0 || kc <= 0) return;
                  Navigator.pop(ctx);
                  _ukazQR(h, kc, sport);
                },
                child: const Text(
                  'Generovat QR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _ukazQR(double hodnota, int kc, Map<String, dynamic> sport) {
    final vs = (100000 + Random().nextInt(900000)).toString();
    final url =
        'https://api.paylibo.com/paylibo/generator/czech/image?accountNumber=$_mujUcet&bankCode=$_kodBanky&amount=$kc&currency=CZK&vs=$vs';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Příspěvek $kc Kč',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, color: _C.gold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Naskenuj QR ve své bance.',
              style: TextStyle(color: _C.textS, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Text(
              'VS: $vs',
              style: const TextStyle(
                color: _C.gold,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _C.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.border),
              ),
              child: Image.network(
                url,
                height: 180,
                width: 180,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Zrušit', style: TextStyle(color: _C.textS)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.gold,
              foregroundColor: _C.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _simulujOvereni(hodnota, kc, sport, vs);
            },
            child: const Text(
              'Mám zaplaceno',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _simulujOvereni(
    double hodnota,
    int kc,
    Map<String, dynamic> sport,
    String vs,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, _) {
          Future.delayed(const Duration(seconds: 3), () {
            if (!mounted) return;
            Navigator.pop(ctx);
            if (Random().nextDouble() < 0.85) {
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
                  backgroundColor: _C.green,
                  content: Text('✅ Platba potvrzena! +${kc * 10} coinů'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: _C.red,
                  duration: const Duration(seconds: 5),
                  content: Text('❌ Platba s VS $vs nebyla nalezena.'),
                ),
              );
            }
          });
          return AlertDialog(
            backgroundColor: _C.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(_C.gold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ověřování platby...',
                    style: TextStyle(
                      color: _C.text,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kontroluji VS: $vs',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _C.textS, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final proc = (HerniData.celkemVybranoKomunitou / HerniData.komunitniCil)
        .clamp(0.0, 1.0);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Pomáhej pohybem',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: _C.gold,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.favorite, color: _C.gold, size: 22),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _C.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: _C.red, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'MOJE KILOMETRY: ${HerniData.kilometry.toStringAsFixed(2)} km = ${HerniData.darovaneKoruny} Kč',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _C.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: (HerniData.kilometry % 10) / 10,
                      backgroundColor: _C.card2,
                      valueColor: const AlwaysStoppedAnimation(_C.gold),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _C.gold.withValues(alpha: .25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.public, color: _C.gold, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'KOMUNITA',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _C.textS,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${HerniData.celkemVybranoKomunitou} / ${HerniData.komunitniCil} Kč',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _C.gold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${HerniData.celkemVybranoKomunitou} Kč',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _C.text,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: proc,
                      backgroundColor: _C.card2,
                      valueColor: const AlwaysStoppedAnimation(_C.gold),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.gold,
                  foregroundColor: _C.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _otevriZadani,
                child: const Text(
                  'SPORTOVAT A POMOCT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'POSLEDNÍ AKTIVITA',
              style: TextStyle(
                color: _C.textS,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _C.border),
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _C.gold.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_run,
                    color: _C.gold,
                    size: 20,
                  ),
                ),
                title: Text(
                  HerniData.posledniSportJmeno,
                  style: const TextStyle(
                    color: _C.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  HerniData.posledniSportInfo,
                  style: const TextStyle(color: _C.textS),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════ TRUHLIČKY ═══════════════════════════

enum TypTruhly {
  bronz('Bronzová', '🪙', 0, [10, 30], [25, 75]),
  stribrna('Stříbrná', '💰', 100, [30, 80], [50, 150]),
  zlata('Zlatá', '👑', 250, [80, 200], [150, 400]);

  final String nazev;
  final String emoji;
  final int cena; // 0 = zdarma
  final List<int> coinRange;
  final List<int> xpRange;
  const TypTruhly(
    this.nazev,
    this.emoji,
    this.cena,
    this.coinRange,
    this.xpRange,
  );
}

class _TruhlyPanel extends StatefulWidget {
  final VoidCallback onObnoveni;
  const _TruhlyPanel({required this.onObnoveni});
  @override
  State<_TruhlyPanel> createState() => _TruhlyPanelState();
}

class _TruhlyPanelState extends State<_TruhlyPanel> {
  String _formatCas(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  void _otevrit(TypTruhly typ) {
    if (typ == TypTruhly.bronz && !HerniData.muzOtevritZdarma) return;
    if (typ != TypTruhly.bronz && HerniData.coiny < typ.cena) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nedostatek coinů! Potřebuješ ${typ.cena} coinů.'),
          backgroundColor: _C.red,
        ),
      );
      return;
    }

    final rnd = DateTime.now().millisecondsSinceEpoch;
    final coins =
        typ.coinRange[0] + rnd % (typ.coinRange[1] - typ.coinRange[0]);
    final xpGain = typ.xpRange[0] + rnd % (typ.xpRange[1] - typ.xpRange[0]);
    // Šance na předmět (~30% bronz, 50% stříbrná, 80% zlatá)
    final itemSance = typ == TypTruhly.bronz
        ? 30
        : typ == TypTruhly.stribrna
        ? 50
        : 80;
    PredmetObchodu? item;
    if ((rnd % 100) < itemSance) {
      final dostupne = _katalog
          .where((p) => !HerniData.vlastnene.contains(p.id))
          .toList();
      if (dostupne.isNotEmpty) item = dostupne[rnd % dostupne.length];
    }

    setState(() {
      if (typ == TypTruhly.bronz)
        HerniData.posledniVolnaTruhla = DateTime.now();
      else
        HerniData.coiny -= typ.cena;
      HerniData.coiny += coins.toInt();
      HerniData.pridejXP(xpGain.toInt());
      if (item != null) HerniData.vlastnene.add(item.id);
    });
    widget.onObnoveni();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Obrázek truhly
            Image.asset(
              'assets/ikony/truhla_${typ.name}.png',
              height: 80,
              errorBuilder: (_, __, ___) =>
                  Text(typ.emoji, style: const TextStyle(fontSize: 64)),
            ),
            const SizedBox(height: 8),
            Text(
              '${typ.nazev} truhla otevřena!',
              style: const TextStyle(
                color: _C.gold,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.card2,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _odmenaRadek(
                    Image.asset(
                      'assets/ikony/coiny_vyhrou.png',
                      width: 32,
                      height: 32,
                      errorBuilder: (_, __, ___) =>
                          const Text('🪙', style: TextStyle(fontSize: 26)),
                    ),
                    '+${coins.toInt()} coinů',
                    _C.gold,
                  ),
                  const SizedBox(height: 8),
                  _odmenaRadek(
                    Image.asset(
                      'assets/ikony/hvezda.png',
                      width: 32,
                      height: 32,
                      errorBuilder: (_, __, ___) =>
                          const Text('⭐', style: TextStyle(fontSize: 26)),
                    ),
                    '+${xpGain.toInt()} XP',
                    const Color(0xFF9B6BC7),
                  ),
                  if (item != null) ...[
                    const SizedBox(height: 8),
                    _odmenaRadek(
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          'assets/obleceni/${item.id}.png',
                          width: 22,
                          height: 22,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Text(
                            item!.typ.emoji,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      item.nazev,
                      _C.green,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.gold,
                foregroundColor: _C.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Skvělé!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _odmenaRadek(Widget ikona, String text, Color color) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ikona,
      const SizedBox(width: 8),
      Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/ikony/klic.png',
                width: 20,
                height: 20,
                errorBuilder: (_, __, ___) =>
                    const Text('🗝️', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 8),
              const Text(
                'TRUHLIČKY',
                style: TextStyle(
                  color: _C.textS,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: TypTruhly.values.map((typ) {
              final jeZdarma = typ == TypTruhly.bronz;
              final muze = jeZdarma
                  ? HerniData.muzOtevritZdarma
                  : HerniData.coiny >= typ.cena;
              final casZbyva = jeZdarma
                  ? HerniData.casDoVolneTruhly
                  : Duration.zero;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: muze
                        ? () {
                            _otevrit(typ);
                            setState(() {});
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: muze ? _C.gold.withValues(alpha: .08) : _C.card2,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: muze
                              ? _C.gold.withValues(alpha: .50)
                              : _C.border,
                          width: muze ? 1.4 : 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Opacity(
                            opacity: muze ? 1.0 : 0.4,
                            child: Image.asset(
                              'assets/ikony/truhla_${typ.name}.png',
                              width: 48,
                              height: 48,
                              errorBuilder: (_, __, ___) => Text(
                                typ.emoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            typ.nazev,
                            style: TextStyle(
                              color: muze ? _C.text : _C.textS,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (jeZdarma && !muze)
                            Text(
                              _formatCas(casZbyva),
                              style: const TextStyle(
                                color: _C.textS,
                                fontSize: 9,
                              ),
                            )
                          else if (jeZdarma)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _C.green.withValues(alpha: .15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'ZDARMA',
                                style: TextStyle(
                                  color: _C.green,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/ikony/coiny_vyhrou.png',
                                  width: 18,
                                  height: 18,
                                  errorBuilder: (_, __, ___) => const Text(
                                    '🪙',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${typ.cena}',
                                  style: TextStyle(
                                    color: muze ? _C.gold : _C.textS,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════ OBLEČENÍ IKONKA ═════════════════════
// Obrázky předmětů: přidej soubory do assets/obleceni/{id}.png
// Např. assets/obleceni/t1.png, assets/obleceni/k2.png, assets/obleceni/b3.png ...
// Pokud soubor neexistuje, zobrazí se emoji jako záloha.
class ObleceniIkonka extends StatelessWidget {
  final PredmetObchodu predmet;
  final double size;
  const ObleceniIkonka({super.key, required this.predmet, this.size = 58});

  @override
  Widget build(BuildContext context) {
    final c = predmet.vzacnost.barva;
    final q = predmet.vzacnost.hvezdicky;
    final isLeg = predmet.vzacnost == VzacnostTyp.legendarni;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * .20),
        border: Border.all(
          color: c.withValues(
            alpha: isLeg
                ? .85
                : q >= 3
                ? .60
                : .35,
          ),
          width: isLeg
              ? 2.0
              : q >= 3
              ? 1.6
              : 1.1,
        ),
        boxShadow: q >= 3
            ? [
                BoxShadow(
                  color: c.withValues(alpha: isLeg ? .35 : .18),
                  blurRadius: isLeg ? 10 : 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * .20 - 1),
        child: Image.asset(
          'assets/obleceni/${predmet.id}.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _Fallback(predmet: predmet, size: size),
        ),
      ),
    );
  }
}

// Záloha pokud obrázek neexistuje
class _Fallback extends StatelessWidget {
  final PredmetObchodu predmet;
  final double size;
  const _Fallback({required this.predmet, required this.size});

  @override
  Widget build(BuildContext context) {
    final c = predmet.vzacnost.barva;
    final q = predmet.vzacnost.hvezdicky;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c.withValues(alpha: .22), c.withValues(alpha: .07)],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              predmet.typ.emoji,
              style: TextStyle(fontSize: size * .62),
            ),
          ),
          if (q >= 2)
            Positioned(
              top: 3,
              left: 4,
              child: Text(
                '✦' * (q - 1),
                style: TextStyle(
                  fontSize: size * .13,
                  color: q == 4
                      ? const Color(0xFFFFD700)
                      : Colors.white.withValues(alpha: .8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Hvězdičky vzácnosti
// Hvězdičky vzácnosti
class _VzacnostBadge extends StatelessWidget {
  final VzacnostTyp vzacnost;
  const _VzacnostBadge(this.vzacnost);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: vzacnost.barva.withValues(alpha: .13),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: vzacnost.barva.withValues(alpha: .4),
        width: .8,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '★' * vzacnost.hvezdicky,
          style: TextStyle(
            color: vzacnost.barva,
            fontSize: 9,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          vzacnost.nazev,
          style: TextStyle(
            color: vzacnost.barva,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

// Panel oblečených předmětů (pod postavou na Avataru)
// ═══════════════════ ALIANCE ═════════════════════════════

class AlianceObrazovka extends StatefulWidget {
  final VoidCallback onObnoveni;
  const AlianceObrazovka({super.key, required this.onObnoveni});
  @override
  State<AlianceObrazovka> createState() => _AlianceObrazovkaState();
}

class _AlianceObrazovkaState extends State<AlianceObrazovka> {
  // Mock členové aliance
  static const List<String> _mockClenove = [
    'Martin K.',
    'Jana S.',
    'Tomáš V.',
    'Tereza V.',
  ];

  void _vytvorAlianci(String nazev) {
    setState(() {
      HerniData.jeVAlianci = true;
      HerniData.alianceNazev = nazev;
      HerniData.alianceClenove = [HerniData.jmeno, ..._mockClenove];
      HerniData.alianceFond = 150;
    });
    widget.onObnoveni();
  }

  void _pripojSeKAlianci(String nazev) {
    setState(() {
      HerniData.jeVAlianci = true;
      HerniData.alianceNazev = nazev;
      HerniData.alianceClenove = [HerniData.jmeno, ..._mockClenove];
      HerniData.alianceFond = 840;
    });
    widget.onObnoveni();
  }

  bool get _splnujePodminku => HerniData.level >= 3 || HerniData.xpUroven >= 3;

  void _prispetDoFondu(int castka) {
    if (HerniData.coiny < castka) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nedostatek coinů!'),
          backgroundColor: _C.red,
        ),
      );
      return;
    }
    setState(() {
      HerniData.coiny -= castka;
      HerniData.alianceFond += castka;
    });
    widget.onObnoveni();
  }

  void _vylepsitBudovu(String id) {
    final cena = HerniData.budovaCena(id);
    final lvl = HerniData.budovyLvl[id] ?? 1;
    if (lvl >= 5) return;
    if (HerniData.alianceFond < cena) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aliance potřebuje $cena coinů ve fondu!'),
          backgroundColor: _C.red,
        ),
      );
      return;
    }
    setState(() {
      HerniData.alianceFond -= cena;
      HerniData.budovyLvl[id] = lvl + 1;
    });
    widget.onObnoveni();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${HerniData.budovyNazvy[id]} vylepšena na Lvl ${lvl + 1}! 🏗️',
        ),
        backgroundColor: _C.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: _C.card,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  Text(
                    HerniData.jeVAlianci ? HerniData.alianceNazev : 'Aliance',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: _C.gold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.shield, color: _C.gold, size: 22),
                  const Spacer(),
                  _HexBadge(value: HerniData.coiny),
                ],
              ),
            ),
            Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    _C.gold.withValues(alpha: .5),
                    _C.gold.withValues(alpha: .5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.25, 0.75, 1.0],
                ),
              ),
            ),

            Expanded(
              child: HerniData.jeVAlianci
                  ? _AlianceDashboard(
                      onVylepsit: _vylepsitBudovu,
                      onPrispet: _prispetDoFondu,
                      onObnoveni: () => setState(() {}),
                    )
                  : _AlianceVstup(
                      splnujePodminku: _splnujePodminku,
                      onVytvorit: _vytvorAlianci,
                      onPridat: _pripojSeKAlianci,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Vstupní obrazovka (ještě není v alianci) ──────────────
class _AlianceVstup extends StatelessWidget {
  final bool splnujePodminku;
  final void Function(String) onVytvorit;
  final void Function(String) onPridat;
  const _AlianceVstup({
    required this.splnujePodminku,
    required this.onVytvorit,
    required this.onPridat,
  });

  @override
  Widget build(BuildContext context) {
    // Zamčeno — nesplněna podmínka
    if (!splnujePodminku) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: _C.textS),
              const SizedBox(height: 16),
              const Text(
                'Aliance je zamčena',
                style: TextStyle(
                  color: _C.text,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _C.gold.withValues(alpha: .3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Pro vstup do aliance potřebuješ:',
                      style: TextStyle(color: _C.textS, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PodminkaChip(
                          label: 'Lvl 3 postavy',
                          splneno: HerniData.level >= 3,
                          aktualni: HerniData.level,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'nebo',
                            style: TextStyle(color: _C.textS, fontSize: 12),
                          ),
                        ),
                        _PodminkaChip(
                          label: 'XP úroveň 3',
                          splneno: HerniData.xpUroven >= 3,
                          aktualni: HerniData.xpUroven,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Odemčeno — normální vstupní obrazovka
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/ikony/aliance.png',
            width: 80,
            height: 80,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.shield_outlined, color: _C.gold, size: 80),
          ),
          const SizedBox(height: 16),
          const Text(
            'Připoj se k alianci',
            style: TextStyle(
              color: _C.text,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Budujte sportovní centrum společně\na dosahujte cílů jako tým.',
            style: TextStyle(color: _C.textS, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Existující aliance
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'DOSTUPNÉ ALIANCE',
              style: TextStyle(
                color: _C.textS,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...['⚡ Blesk Team', '🔥 Fire Squad', '💪 Iron Will'].map(
            (n) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _C.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n,
                          style: const TextStyle(
                            color: _C.text,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Text(
                          '5 členů • Lvl centrum 2',
                          style: TextStyle(color: _C.textS, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => onPridat(n),
                    style: TextButton.styleFrom(
                      foregroundColor: _C.gold,
                      backgroundColor: _C.gold.withValues(alpha: .10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Připojit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          // Vytvoř vlastní
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: _C.gold,
                side: const BorderSide(color: _C.gold),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'Vytvořit vlastní alianci',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                final ctrl = TextEditingController();
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: _C.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text(
                      'Název aliance',
                      style: TextStyle(
                        color: _C.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: TextField(
                      controller: ctrl,
                      style: const TextStyle(color: _C.text),
                      decoration: InputDecoration(
                        hintText: 'Zadej název...',
                        hintStyle: const TextStyle(color: _C.textS),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: _C.card2,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          'Zrušit',
                          style: TextStyle(color: _C.textS),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _C.gold,
                          foregroundColor: _C.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (ctrl.text.trim().isNotEmpty) {
                            Navigator.pop(ctx);
                            onVytvorit(ctrl.text.trim());
                          }
                        },
                        child: const Text(
                          'Vytvořit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Chip zobrazující splněnost podmínky
class _PodminkaChip extends StatelessWidget {
  final String label;
  final bool splneno;
  final int aktualni;
  const _PodminkaChip({
    required this.label,
    required this.splneno,
    required this.aktualni,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: splneno ? _C.green.withValues(alpha: .12) : _C.card2,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: splneno ? _C.green : _C.border),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          splneno ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 14,
          color: splneno ? _C.green : _C.textS,
        ),
        const SizedBox(width: 5),
        Text(
          '$label ($aktualni/3)',
          style: TextStyle(
            color: splneno ? _C.green : _C.textS,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

// ── Dashboard aliance (je člen) ───────────────────────────
class _AlianceDashboard extends StatelessWidget {
  final void Function(String) onVylepsit;
  final void Function(int) onPrispet;
  final VoidCallback onObnoveni;
  const _AlianceDashboard({
    required this.onVylepsit,
    required this.onPrispet,
    required this.onObnoveni,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aliance fond
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _C.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _C.gold.withValues(alpha: .25)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/ikony/aliance.png',
                      width: 28,
                      height: 28,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.shield, color: _C.gold, size: 28),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            HerniData.alianceNazev,
                            style: const TextStyle(
                              color: _C.gold,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${HerniData.alianceClenove.length} členů',
                            style: const TextStyle(
                              color: _C.textS,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Fond aliance',
                          style: TextStyle(color: _C.textS, fontSize: 10),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/ikony/coiny_vyhrou.png',
                              width: 16,
                              height: 16,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.monetization_on,
                                color: _C.gold,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${HerniData.alianceFond}',
                              style: const TextStyle(
                                color: _C.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Příspěvek do fondu
                Row(
                  children: [50, 100, 250]
                      .map(
                        (c) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HerniData.coiny >= c
                                    ? _C.gold.withValues(alpha: .12)
                                    : _C.card2,
                                foregroundColor: HerniData.coiny >= c
                                    ? _C.gold
                                    : _C.textS,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                side: BorderSide(
                                  color: HerniData.coiny >= c
                                      ? _C.gold.withValues(alpha: .4)
                                      : _C.border,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: HerniData.coiny >= c
                                  ? () => onPrispet(c)
                                  : null,
                              child: Text(
                                '+$c',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'SPORTOVNÍ CENTRUM',
            style: TextStyle(
              color: _C.textS,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),

          // Budovy grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
            children: HerniData.budovyLvl.entries
                .map(
                  (e) => _BudovaKarta(
                    id: e.key,
                    nazev: HerniData.budovyNazvy[e.key] ?? e.key,
                    level: e.value,
                    fond: HerniData.alianceFond,
                    onVylepsit: () => onVylepsit(e.key),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 16),
          // Členové
          const Text(
            'ČLENOVÉ',
            style: TextStyle(
              color: _C.textS,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          ...HerniData.alianceClenove.map(
            (c) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: _C.gold.withValues(alpha: .15),
                    child: Text(
                      c[0],
                      style: const TextStyle(
                        color: _C.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(c, style: const TextStyle(color: _C.text, fontSize: 13)),
                  if (c == HerniData.jmeno) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _C.gold.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Ty',
                        style: TextStyle(
                          color: _C.gold,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Karta budovy ──────────────────────────────────────────
class _BudovaKarta extends StatelessWidget {
  final String id, nazev;
  final int level, fond;
  final VoidCallback onVylepsit;
  const _BudovaKarta({
    required this.id,
    required this.nazev,
    required this.level,
    required this.fond,
    required this.onVylepsit,
  });

  @override
  Widget build(BuildContext context) {
    final jeMax = level >= 5;
    final cena = HerniData.budovaCena(id);
    final muzeVylepsit = !jeMax && fond >= cena;
    // Level 5 = special image, jinak level-specific
    final imgPath = 'assets/aliance/${id}_$level.png';

    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: jeMax ? _C.gold.withValues(alpha: .5) : _C.border,
          width: jeMax ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          // Obrázek budovy
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
              child: Image.asset(
                imgPath,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: _C.card2,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.apartment_rounded,
                          size: 40,
                          color: jeMax ? _C.gold : _C.textS,
                        ),
                        Text(
                          'Lvl $level',
                          style: TextStyle(
                            color: jeMax ? _C.gold : _C.textS,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        nazev,
                        style: const TextStyle(
                          color: _C.text,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Level indikátor
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (i) => Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.only(left: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i < level ? _C.gold : _C.border,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (jeMax)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _C.gold.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'MAX LEVEL',
                        style: TextStyle(
                          color: _C.gold,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: muzeVylepsit ? _C.gold : _C.card2,
                        foregroundColor: muzeVylepsit ? _C.white : _C.textS,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: muzeVylepsit ? onVylepsit : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/ikony/coiny_vyhrou.png',
                            width: 12,
                            height: 12,
                            errorBuilder: (_, __, ___) => const SizedBox(),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '$cena  Lvl ${level + 1}',
                            style: const TextStyle(
                              fontSize: 10,
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
        ],
      ),
    );
  }
}

// ═══════════════════ VÝZVY ═══════════════════════════════

enum TypVyzvy {
  km('Uběhni km', Icons.directions_run, 'km'),
  treninky('Dokonči tréninků', Icons.fitness_center, 'tréninků'),
  svalLvl('Sval na level', Icons.trending_up, 'lvl'),
  xpZisk('Získej XP', Icons.star, 'XP');

  final String nazev;
  final IconData ikona;
  final String jednotka;
  const TypVyzvy(this.nazev, this.ikona, this.jednotka);
}

class Vyzva {
  final String id;
  final String souper;
  final TypVyzvy typ;
  final double cil;
  final DateTime konec;
  double mujProgress;
  double souperProgress;
  bool dokoncena;
  bool vyhral;

  Vyzva({
    required this.id,
    required this.souper,
    required this.typ,
    required this.cil,
    required this.konec,
    this.mujProgress = 0,
    this.souperProgress = 0,
    this.dokoncena = false,
    this.vyhral = false,
  });

  double get mujProcent => (mujProgress / cil).clamp(0.0, 1.0);
  double get souperProcent => (souperProgress / cil).clamp(0.0, 1.0);
  int get dniZbyva => konec.difference(DateTime.now()).inDays.clamp(0, 999);
}

// Mock soupeři ze žebříčku
final List<Map<String, dynamic>> _mockSouperi = [
  {'jmeno': 'Martin K.', 'level': 9, 'avatar': '🏆'},
  {'jmeno': 'Jana S.', 'level': 7, 'avatar': '⚡'},
  {'jmeno': 'Tomáš V.', 'level': 6, 'avatar': '🔥'},
  {'jmeno': 'Tereza V.', 'level': 4, 'avatar': '💪'},
  {'jmeno': 'Lukáš M.', 'level': 3, 'avatar': '🎯'},
];

class VyzvyObrazovka extends StatefulWidget {
  const VyzvyObrazovka({super.key});
  @override
  State<VyzvyObrazovka> createState() => _VyzvyObrazovkaState();
}

class _VyzvyObrazovkaState extends State<VyzvyObrazovka> {
  void _novaVyzva() {
    Map<String, dynamic>? vybranySOuper;
    TypVyzvy? vybranyTyp;
    double cil = 10;
    int pocetDni = 7;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDS) => AlertDialog(
          backgroundColor: _C.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/ikony/mece.png',
                width: 22,
                height: 22,
                errorBuilder: (_, __, ___) => const Text('⚔️'),
              ),
              const SizedBox(width: 8),
              const Text(
                'Nová výzva',
                style: TextStyle(
                  color: _C.text,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Výběr soupeře
                const Text(
                  'Vyber soupeře:',
                  style: TextStyle(color: _C.textS, fontSize: 12),
                ),
                const SizedBox(height: 8),
                ..._mockSouperi.map(
                  (s) => GestureDetector(
                    onTap: () => setDS(() => vybranySOuper = s),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: vybranySOuper == s
                            ? _C.gold.withValues(alpha: .12)
                            : _C.card2,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: vybranySOuper == s ? _C.gold : _C.border,
                          width: vybranySOuper == s ? 1.4 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            s['avatar'],
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              s['jmeno'],
                              style: TextStyle(
                                color: vybranySOuper == s ? _C.gold : _C.text,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            'Lvl ${s['level']}',
                            style: const TextStyle(
                              color: _C.textS,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),
                const Text(
                  'Typ výzvy:',
                  style: TextStyle(color: _C.textS, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: TypVyzvy.values
                      .map(
                        (t) => GestureDetector(
                          onTap: () => setDS(() => vybranyTyp = t),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: vybranyTyp == t
                                  ? _C.gold.withValues(alpha: .12)
                                  : _C.card2,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: vybranyTyp == t ? _C.gold : _C.border,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  t.ikona,
                                  size: 14,
                                  color: vybranyTyp == t ? _C.gold : _C.textS,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  t.nazev,
                                  style: TextStyle(
                                    color: vybranyTyp == t ? _C.gold : _C.textS,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 14),
                const Text(
                  'Cíl:',
                  style: TextStyle(color: _C.textS, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [10.0, 20.0, 50.0, 100.0]
                      .map(
                        (v) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: GestureDetector(
                              onTap: () => setDS(() => cil = v),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: cil == v
                                      ? _C.gold.withValues(alpha: .12)
                                      : _C.card2,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: cil == v ? _C.gold : _C.border,
                                  ),
                                ),
                                child: Text(
                                  '${v.toInt()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: cil == v ? _C.gold : _C.textS,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 14),
                const Text(
                  'Délka výzvy:',
                  style: TextStyle(color: _C.textS, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [3, 7, 14]
                      .map(
                        (d) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: GestureDetector(
                              onTap: () => setDS(() => pocetDni = d),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: pocetDni == d
                                      ? _C.gold.withValues(alpha: .12)
                                      : _C.card2,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: pocetDni == d ? _C.gold : _C.border,
                                  ),
                                ),
                                child: Text(
                                  '$d dní',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: pocetDni == d ? _C.gold : _C.textS,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Zrušit', style: TextStyle(color: _C.textS)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.gold,
                foregroundColor: _C.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: vybranySOuper == null || vybranyTyp == null
                  ? null
                  : () {
                      final v = Vyzva(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        souper: vybranySOuper!['jmeno'],
                        typ: vybranyTyp!,
                        cil: cil,
                        konec: DateTime.now().add(Duration(days: pocetDni)),
                        souperProgress:
                            (DateTime.now().millisecondsSinceEpoch %
                            (cil * 0.3)),
                      );
                      setState(() => HerniData.aktivniVyzvy.add(v));
                      Navigator.pop(ctx);
                    },
              child: const Text(
                'Vyzvat! ⚔️',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _splnitVyzvu(Vyzva v, double pridej) {
    setState(() {
      v.mujProgress = (v.mujProgress + pridej).clamp(0, v.cil);
      // Simulace soupeřova pokroku
      v.souperProgress =
          (v.souperProgress +
                  pridej * 0.7 +
                  (DateTime.now().millisecondsSinceEpoch % 3))
              .clamp(0, v.cil);

      if (v.mujProgress >= v.cil && !v.dokoncena) {
        v.dokoncena = true;
        v.vyhral = true;
        HerniData.coiny += 200;
        HerniData.pridejXP(300);
        HerniData.aktivniVyzvy.remove(v);
        HerniData.dokonceneVyzvy.add(v);
        _ukazVysledek(v);
      } else if (v.souperProgress >= v.cil && !v.dokoncena) {
        v.dokoncena = true;
        v.vyhral = false;
        HerniData.pridejXP(50); // útěšné XP
        HerniData.aktivniVyzvy.remove(v);
        HerniData.dokonceneVyzvy.add(v);
        _ukazVysledek(v);
      }
    });
  }

  void _ukazVysledek(Vyzva v) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            v.vyhral
                ? Image.asset(
                    'assets/ikony/trofej.png',
                    width: 80,
                    height: 80,
                    errorBuilder: (_, __, ___) =>
                        const Text('🏆', style: TextStyle(fontSize: 64)),
                  )
                : Image.asset(
                    'assets/ikony/prohra.png',
                    width: 80,
                    height: 80,
                    errorBuilder: (_, __, ___) =>
                        const Text('😞', style: TextStyle(fontSize: 64)),
                  ),
            const SizedBox(height: 8),
            Text(
              v.vyhral ? 'Vyhrál jsi!' : 'Tentokrát ne...',
              style: TextStyle(
                color: v.vyhral ? _C.gold : _C.textS,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              v.vyhral
                  ? '+200 coinů  +300 XP 🎉'
                  : 'Nevzdávej to! +50 XP za účast',
              style: const TextStyle(color: _C.textS, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.gold,
                foregroundColor: _C.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: _C.card,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  const Text(
                    'Výzvy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: _C.gold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.emoji_events, color: _C.gold, size: 22),
                  const Spacer(),
                  _HexBadge(value: HerniData.coiny),
                ],
              ),
            ),
            Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    _C.gold.withValues(alpha: .5),
                    _C.gold.withValues(alpha: .5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.25, 0.75, 1.0],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tlačítko nová výzva
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _C.gold,
                          foregroundColor: _C.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text(
                          'Vyzvat kamaráda',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _novaVyzva,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Aktivní výzvy
                    if (HerniData.aktivniVyzvy.isNotEmpty) ...[
                      const Text(
                        'AKTIVNÍ VÝZVY',
                        style: TextStyle(
                          color: _C.textS,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...HerniData.aktivniVyzvy.map(
                        (v) => _VyzvaKarta(
                          vyzva: v,
                          onProgress: (val) => _splnitVyzvu(v, val),
                          onDelete: () =>
                              setState(() => HerniData.aktivniVyzvy.remove(v)),
                        ),
                      ),
                    ],

                    if (HerniData.aktivniVyzvy.isEmpty &&
                        HerniData.dokonceneVyzvy.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/ikony/mece.png',
                                width: 56,
                                height: 56,
                                errorBuilder: (_, __, ___) => const Text(
                                  '⚔️',
                                  style: TextStyle(fontSize: 48),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Žádné aktivní výzvy',
                                style: TextStyle(
                                  color: _C.text,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Vyzvěte kamaráda a soutěžte!',
                                style: const TextStyle(
                                  color: _C.textS,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Dokončené výzvy
                    if (HerniData.dokonceneVyzvy.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'DOKONČENÉ',
                        style: TextStyle(
                          color: _C.textS,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...HerniData.dokonceneVyzvy.reversed
                          .take(3)
                          .map(
                            (v) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _C.card,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _C.border),
                              ),
                              child: Row(
                                children: [
                                  v.vyhral
                                      ? Image.asset(
                                          'assets/ikony/trofej.png',
                                          width: 30,
                                          height: 30,
                                          errorBuilder: (_, __, ___) =>
                                              const Text(
                                                '🏆',
                                                style: TextStyle(fontSize: 24),
                                              ),
                                        )
                                      : const Text(
                                          '😞',
                                          style: TextStyle(fontSize: 24),
                                        ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'vs. ${v.souper}',
                                          style: const TextStyle(
                                            color: _C.text,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          '${v.typ.nazev} · ${v.cil.toInt()} ${v.typ.jednotka}',
                                          style: const TextStyle(
                                            color: _C.textS,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    v.vyhral ? 'Výhra! 🎉' : 'Prohra',
                                    style: TextStyle(
                                      color: v.vyhral ? _C.gold : _C.textS,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VyzvaKarta extends StatelessWidget {
  final Vyzva vyzva;
  final void Function(double) onProgress;
  final VoidCallback onDelete;
  const _VyzvaKarta({
    required this.vyzva,
    required this.onProgress,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final v = vyzva;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.gold.withValues(alpha: .25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header výzvy
          Row(
            children: [
              Icon(v.typ.ikona, color: _C.gold, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'vs. ${v.souper}',
                  style: const TextStyle(
                    color: _C.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _C.card2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${v.dniZbyva}d zbývá',
                  style: const TextStyle(color: _C.textS, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${v.typ.nazev}: ${v.cil.toInt()} ${v.typ.jednotka}',
            style: const TextStyle(color: _C.textS, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // Můj progress
          Row(
            children: [
              const SizedBox(width: 4),
              const Text(
                'Ty  ',
                style: TextStyle(
                  color: _C.text,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: v.mujProcent,
                    minHeight: 10,
                    backgroundColor: _C.border,
                    valueColor: const AlwaysStoppedAnimation(_C.gold),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${v.mujProgress.toInt()}/${v.cil.toInt()}',
                style: const TextStyle(
                  color: _C.gold,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Soupeřův progress
          Row(
            children: [
              const SizedBox(width: 4),
              Text(
                '${v.souper.split(' ').first}  ',
                style: const TextStyle(color: _C.textS, fontSize: 11),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: v.souperProcent,
                    minHeight: 10,
                    backgroundColor: _C.border,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFE57373)),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${v.souperProgress.toInt()}/${v.cil.toInt()}',
                style: const TextStyle(color: Color(0xFFE57373), fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Akce tlačítka
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.gold,
                    foregroundColor: _C.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => onProgress(1),
                  child: Text(
                    '+1 ${v.typ.jednotka}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onDelete,
                style: TextButton.styleFrom(foregroundColor: _C.textS),
                child: const Text('Vzdát', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════ OBCHOD OBRAZOVKA ════════════════════
class ObchodObrazovka extends StatefulWidget {
  final VoidCallback onObnoveni;
  const ObchodObrazovka({super.key, required this.onObnoveni});
  @override
  State<ObchodObrazovka> createState() => _ObchodObrazovkaState();
}

class _ObchodObrazovkaState extends State<ObchodObrazovka> {
  TypPredmetu? _filtr;
  bool _zobrazCoiny = false;

  // Balíčky coinů k zakoupení
  static const List<Map<String, dynamic>> _balicky = [
    {
      'coiny': 100,
      'kc': 20,
      'bonus': '',
      'asset': 'assets/ikony/coin_bronze.png',
      'emoji': '🪙',
    },
    {
      'coiny': 300,
      'kc': 50,
      'bonus': '+20 zdarma',
      'asset': 'assets/ikony/coin_silver.png',
      'emoji': '💰',
    },
    {
      'coiny': 700,
      'kc': 100,
      'bonus': '+100 zdarma',
      'asset': 'assets/ikony/coin_gold.png',
      'emoji': '💎',
    },
    {
      'coiny': 1500,
      'kc': 200,
      'bonus': '+300 zdarma',
      'asset': 'assets/ikony/coin_diamond.png',
      'emoji': '👑',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final zobrazene = [
      ...(_filtr == null ? _katalog : _katalog.where((p) => p.typ == _filtr)),
    ];
    zobrazene.sort((a, b) {
      final aVlastni = HerniData.vlastnene.contains(a.id);
      final bVlastni = HerniData.vlastnene.contains(b.id);
      if (aVlastni && !bVlastni) return 1;
      if (!aVlastni && bVlastni) return -1;
      return a.cena.compareTo(b.cena);
    });

    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            color: _C.card,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                const Text(
                  'Obchod',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: _C.gold,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.store, color: _C.gold, size: 22),
                const Spacer(),
                _HexBadge(value: HerniData.coiny),
              ],
            ),
          ),
          Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  _C.gold.withValues(alpha: .5),
                  _C.gold.withValues(alpha: .5),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.25, 0.75, 1.0],
              ),
            ),
          ),

          // Filter chips
          Container(
            color: _C.card,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Dobít coiny chip
                  GestureDetector(
                    onTap: () => setState(() {
                      _zobrazCoiny = true;
                      _filtr = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _zobrazCoiny
                            ? _C.gold.withValues(alpha: .15)
                            : _C.card2,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _zobrazCoiny ? _C.gold : _C.border,
                          width: _zobrazCoiny ? 1.3 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/ikony/coiny.png',
                            width: 16,
                            height: 16,
                            errorBuilder: (_, __, ___) => const Text(
                              '💰',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Dobít coiny',
                            style: TextStyle(
                              fontSize: 12,
                              color: _zobrazCoiny ? _C.gold : _C.textS,
                              fontWeight: _zobrazCoiny
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Vše chip
                  GestureDetector(
                    onTap: () => setState(() {
                      _zobrazCoiny = false;
                      _filtr = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: !_zobrazCoiny && _filtr == null
                            ? _C.gold.withValues(alpha: .15)
                            : _C.card2,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: !_zobrazCoiny && _filtr == null
                              ? _C.gold
                              : _C.border,
                          width: !_zobrazCoiny && _filtr == null ? 1.3 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/ikony/vse.png',
                            width: 16,
                            height: 16,
                            errorBuilder: (_, __, ___) => const Text(
                              '🛍️',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Vše',
                            style: TextStyle(
                              fontSize: 12,
                              color: !_zobrazCoiny && _filtr == null
                                  ? _C.gold
                                  : _C.textS,
                              fontWeight: !_zobrazCoiny && _filtr == null
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...TypPredmetu.values.map(
                    (t) => GestureDetector(
                      onTap: () => setState(() {
                        _zobrazCoiny = false;
                        _filtr = t;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: !_zobrazCoiny && _filtr == t
                              ? _C.gold.withValues(alpha: .15)
                              : _C.card2,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: !_zobrazCoiny && _filtr == t
                                ? _C.gold
                                : _C.border,
                            width: !_zobrazCoiny && _filtr == t ? 1.3 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            t.ikonaWidget(size: 16),
                            const SizedBox(width: 5),
                            Text(
                              t.nazev,
                              style: TextStyle(
                                fontSize: 12,
                                color: !_zobrazCoiny && _filtr == t
                                    ? _C.gold
                                    : _C.textS,
                                fontWeight: !_zobrazCoiny && _filtr == t
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Obsah
          if (_zobrazCoiny)
            Expanded(child: _coinySekce())
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(14),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.78,
                ),
                itemCount: zobrazene.length,
                itemBuilder: (ctx, i) => _itemKarta(zobrazene[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _coinySekce() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Info banner
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _C.gold.withValues(alpha: .12),
                _C.gold.withValues(alpha: .04),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.gold.withValues(alpha: .35)),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/ikony/zarovka.png',
                width: 28,
                height: 28,
                errorBuilder: (_, __, ___) =>
                    const Text('💡', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Coiny získáš za tréninky zdarma,\nnebo si je můžeš rychle dobít přes QR platbu.',
                  style: TextStyle(color: _C.textS, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        // Balíčky
        ...(_balicky.map((b) => _balikCard(b))),
      ],
    );
  }

  Widget _balikCard(Map<String, dynamic> b) {
    final int coiny = b['coiny'];
    final int kc = b['kc'];
    final String bonus = b['bonus'];
    final String asset = b['asset'];
    final String emoji = b['emoji'];
    final bool jeNejlepsi = kc == 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: jeNejlepsi ? _C.gold.withValues(alpha: .07) : _C.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: jeNejlepsi ? _C.gold : _C.border,
          width: jeNejlepsi ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _otevriQR(coiny, kc),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Ikona — vlastní obrázek nebo emoji záloha
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _C.gold.withValues(alpha: .10),
                  shape: BoxShape.circle,
                  border: Border.all(color: _C.gold.withValues(alpha: .35)),
                ),
                child: ClipOval(
                  child: Image.asset(
                    asset,
                    width: 52,
                    height: 52,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$coiny coinů',
                          style: const TextStyle(
                            color: _C.gold,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if (bonus.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _C.green.withValues(alpha: .15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              bonus,
                              style: const TextStyle(
                                color: _C.green,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$kc Kč · platba QR kódem',
                      style: const TextStyle(color: _C.textS, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Šipka
              if (jeNejlepsi)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _C.gold.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Nejlepší',
                    style: TextStyle(
                      color: _C.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                const Icon(Icons.chevron_right, color: _C.textS, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _otevriQR(int coiny, int kc) {
    final vs = '${DateTime.now().millisecondsSinceEpoch % 9000000 + 1000000}';
    final qrData =
        'SPD*1.0*ACC:CZ6550510000001234567890*AM:${kc.toStringAsFixed(2)}*CC:CZK*MSG:Sport RPG Coiny*X-VS:$vs';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '$coiny coinů za $kc Kč',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, color: _C.gold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Naskenuj QR ve své bance.',
              style: TextStyle(color: _C.textS, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Text(
              'VS: $vs',
              style: const TextStyle(
                color: _C.gold,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // QR placeholder
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.gold.withValues(alpha: .4)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.qr_code_2,
                      size: 100,
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$kc Kč',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Po zaplacení klikni na Ověřit platbu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _C.textS, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Zrušit', style: TextStyle(color: _C.textS)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.gold,
              foregroundColor: _C.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _simulujOvereniCoin(coiny);
            },
            child: const Text(
              'Ověřit platbu',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _simulujOvereniCoin(int coiny) async {
    // Zobraz loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: _C.gold)),
    );
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pop(context);
    setState(() => HerniData.coiny += coiny);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Platba ověřena! +$coiny coinů připsáno.'),
        backgroundColor: _C.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _itemKarta(PredmetObchodu p) {
    final vlastni = HerniData.vlastnene.contains(p.id);
    final jeObleceny = HerniData.oblecene[p.typ.nazev] == p.id;
    final muzeSiKoupit = HerniData.coiny >= p.cena && !vlastni;
    final c = p.vzacnost.barva;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: jeObleceny ? c.withValues(alpha: .08) : _C.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: jeObleceny
              ? c
              : (vlastni ? c.withValues(alpha: .4) : _C.border),
          width: jeObleceny ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: ObleceniIkonka(predmet: p, size: 52)),
          const SizedBox(height: 6),
          _VzacnostBadge(p.vzacnost),
          const SizedBox(height: 4),
          Text(
            p.nazev,
            style: const TextStyle(
              color: _C.text,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            p.popis,
            style: const TextStyle(color: _C.textS, fontSize: 9),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${p.cena}',
                style: const TextStyle(
                  color: _C.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 3),
              const Text(
                'coinů',
                style: TextStyle(color: _C.textS, fontSize: 9),
              ),
              const Spacer(),
              _akceButton(p, vlastni, jeObleceny, muzeSiKoupit),
            ],
          ),
        ],
      ),
    );
  }

  Widget _akceButton(
    PredmetObchodu p,
    bool vlastni,
    bool jeObleceny,
    bool muze,
  ) {
    if (!vlastni) {
      return SizedBox(
        height: 30,
        child: ElevatedButton(
          onPressed: muze ? () => _koupit(p) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: muze ? _C.gold : _C.card2,
            foregroundColor: muze ? _C.white : _C.textS,
            disabledBackgroundColor: _C.card2,
            disabledForegroundColor: _C.textS,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: muze ? 2 : 0,
          ),
          child: const Text(
            'Koupit',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    if (jeObleceny) {
      return SizedBox(
        height: 30,
        child: TextButton(
          onPressed: () =>
              setState(() => HerniData.oblecene.remove(p.typ.nazev)),
          style: TextButton.styleFrom(
            backgroundColor: p.vzacnost.barva.withValues(alpha: .15),
            foregroundColor: p.vzacnost.barva,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Svléct',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return SizedBox(
      height: 30,
      child: TextButton(
        onPressed: () => setState(() => HerniData.oblecene[p.typ.nazev] = p.id),
        style: TextButton.styleFrom(
          backgroundColor: _C.gold.withValues(alpha: .12),
          foregroundColor: _C.gold,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          side: BorderSide(color: _C.gold.withValues(alpha: .4)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Obléct',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _koupit(PredmetObchodu p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Koupit ${p.nazev}?',
          style: const TextStyle(color: _C.text, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ObleceniIkonka(predmet: p, size: 72),
            const SizedBox(height: 12),
            _VzacnostBadge(p.vzacnost),
            const SizedBox(height: 8),
            Text(
              p.popis,
              style: const TextStyle(color: _C.textS, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Cena: ', style: TextStyle(color: _C.textS)),
                Text(
                  '${p.cena} coinů',
                  style: const TextStyle(
                    color: _C.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Zrušit', style: TextStyle(color: _C.textS)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.gold,
              foregroundColor: _C.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() {
                HerniData.coiny -= p.cena;
                HerniData.vlastnene.add(p.id);
              });
              widget.onObnoveni();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${p.nazev} přidáno do batohu! 🎉'),
                  backgroundColor: _C.green,
                ),
              );
            },
            child: const Text(
              'Koupit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════ BATOH OBRAZOVKA ═════════════════════
class BatohObrazovka extends StatefulWidget {
  const BatohObrazovka({super.key});
  @override
  State<BatohObrazovka> createState() => _BatohObrazovkaState();
}

class _BatohObrazovkaState extends State<BatohObrazovka> {
  @override
  Widget build(BuildContext context) {
    final vsechny = TypPredmetu.values;
    final vlastneneList = _katalog
        .where((p) => HerniData.vlastnene.contains(p.id))
        .toList();

    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.card,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _C.gold),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Batoh',
          style: TextStyle(
            color: _C.gold,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.5),
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  _C.gold.withValues(alpha: .5),
                  _C.gold.withValues(alpha: .5),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.25, 0.75, 1.0],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Oblečeno (5 slotů) ─────────────────────────
            const Text(
              'OBLEČENO',
              style: TextStyle(
                color: _C.gold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _C.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: vsechny.map((t) {
                  final predmetId = HerniData.oblecene[t.nazev];
                  final predmet = predmetId != null
                      ? _katalog.firstWhere(
                          (p) => p.id == predmetId,
                          orElse: () => _katalog.first,
                        )
                      : null;
                  return GestureDetector(
                    onTap: predmet != null
                        ? () =>
                              setState(() => HerniData.oblecene.remove(t.nazev))
                        : null,
                    child: Column(
                      children: [
                        predmet != null
                            ? ObleceniIkonka(predmet: predmet, size: 52)
                            : Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: _C.card2,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _C.border,
                                    width: 1.2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    t.emoji,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: _C.textS,
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 4),
                        Text(
                          t.nazev,
                          style: const TextStyle(color: _C.textS, fontSize: 9),
                        ),
                        if (predmet != null)
                          const Text(
                            '× svléct',
                            style: TextStyle(color: _C.red, fontSize: 8),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // ── Inventář ────────────────────────────────────
            Row(
              children: [
                const Text(
                  'V BATOHU',
                  style: TextStyle(
                    color: _C.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _C.gold.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${vlastneneList.length}',
                    style: const TextStyle(
                      color: _C.gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (vlastneneList.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _C.border),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/batoh.png',
                        width: 52,
                        height: 52,
                        errorBuilder: (_, __, ___) =>
                            const Text('🎒', style: TextStyle(fontSize: 36)),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Batoh je prázdný',
                        style: TextStyle(color: _C.textS, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Nakup předměty v Obchodě',
                        style: TextStyle(color: _C.textS, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: .82,
                ),
                itemCount: vlastneneList.length,
                itemBuilder: (ctx, i) {
                  final p = vlastneneList[i];
                  final jeObleceny = HerniData.oblecene[p.typ.nazev] == p.id;
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (jeObleceny)
                        HerniData.oblecene.remove(p.typ.nazev);
                      else
                        HerniData.oblecene[p.typ.nazev] = p.id;
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: jeObleceny
                            ? p.vzacnost.barva.withValues(alpha: .08)
                            : _C.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: jeObleceny ? p.vzacnost.barva : _C.border,
                          width: jeObleceny ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          ObleceniIkonka(predmet: p, size: 52),
                          const SizedBox(height: 6),
                          Text(
                            p.nazev,
                            style: const TextStyle(
                              color: _C.text,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            jeObleceny ? '✓ Oblečeno' : 'Klepni k obléknutí',
                            style: TextStyle(
                              color: jeObleceny ? p.vzacnost.barva : _C.textS,
                              fontSize: 8,
                              fontWeight: jeObleceny
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════ POSTAVA WIDGET ════════════════════════

class _SvalInfo {
  final String nazev;
  final Offset labelPos, anchorPos;
  final List<Rect> oblasti;
  const _SvalInfo({
    required this.nazev,
    required this.labelPos,
    required this.anchorPos,
    required this.oblasti,
  });
}

const Map<String, _SvalInfo> _svalInfo = {
  'Prsa': _SvalInfo(
    nazev: 'Prsa',
    labelPos: Offset(-35, 98),
    anchorPos: Offset(72, 100),
    oblasti: [
      Rect.fromLTRB(72, 82, 100, 118),
      Rect.fromLTRB(100, 82, 128, 118),
    ],
  ),
  'Ramena': _SvalInfo(
    nazev: 'Ramena',
    labelPos: Offset(242, 73),
    anchorPos: Offset(150, 77),
    oblasti: [Rect.fromLTRB(44, 65, 70, 93), Rect.fromLTRB(130, 65, 156, 93)],
  ),
  'Biceps': _SvalInfo(
    nazev: 'Biceps',
    labelPos: Offset(-35, 110),
    anchorPos: Offset(38, 110),
    oblasti: [Rect.fromLTRB(38, 90, 56, 132), Rect.fromLTRB(144, 90, 162, 132)],
  ),
  'Triceps': _SvalInfo(
    nazev: 'Triceps',
    labelPos: Offset(244, 117),
    anchorPos: Offset(162, 117),
    oblasti: [
      Rect.fromLTRB(36, 100, 50, 138),
      Rect.fromLTRB(150, 100, 164, 138),
    ],
  ),
  'Záda': _SvalInfo(
    nazev: 'Záda',
    labelPos: Offset(244, 127),
    anchorPos: Offset(133, 128),
    oblasti: [Rect.fromLTRB(67, 88, 80, 155), Rect.fromLTRB(120, 88, 133, 155)],
  ),
  'Přímý sval břišní': _SvalInfo(
    nazev: 'Břišní svaly',
    labelPos: Offset(-46, 133),
    anchorPos: Offset(81, 136),
    oblasti: [
      Rect.fromLTRB(85, 112, 98, 128),
      Rect.fromLTRB(102, 112, 115, 128),
      Rect.fromLTRB(85, 130, 98, 146),
      Rect.fromLTRB(102, 130, 115, 146),
      Rect.fromLTRB(85, 148, 98, 162),
      Rect.fromLTRB(102, 148, 115, 162),
    ],
  ),
  'Stehno (Quadriceps)': _SvalInfo(
    nazev: 'Čtyřhlavý sval',
    labelPos: Offset(-48, 234),
    anchorPos: Offset(71, 247),
    oblasti: [
      Rect.fromLTRB(72, 208, 97, 285),
      Rect.fromLTRB(103, 208, 128, 285),
    ],
  ),
  'Lýtko': _SvalInfo(
    nazev: 'Lýtko',
    labelPos: Offset(242, 322),
    anchorPos: Offset(128, 325),
    oblasti: [
      Rect.fromLTRB(73, 298, 94, 362),
      Rect.fromLTRB(106, 298, 127, 362),
    ],
  ),
  'Hýždě': _SvalInfo(
    nazev: 'Hýždě',
    labelPos: Offset(242, 194),
    anchorPos: Offset(130, 196),
    oblasti: [
      Rect.fromLTRB(70, 186, 90, 210),
      Rect.fromLTRB(110, 186, 130, 210),
    ],
  ),
  'Hamstrings': _SvalInfo(
    nazev: 'Hamstrings',
    labelPos: Offset(-46, 259),
    anchorPos: Offset(77, 263),
    oblasti: [
      Rect.fromLTRB(76, 234, 94, 287),
      Rect.fromLTRB(106, 234, 124, 287),
    ],
  ),
};

class PostavaWidget extends StatelessWidget {
  final Map<String, int> svalyLvl;
  final String? aktivniSval;
  const PostavaWidget({super.key, required this.svalyLvl, this.aktivniSval});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (ctx, c) => CustomPaint(
      size: Size(c.maxWidth, c.maxHeight),
      painter: _PostavaPainter(svalyLvl: svalyLvl, aktivniSval: aktivniSval),
    ),
  );
}

class _PostavaPainter extends CustomPainter {
  final Map<String, int> svalyLvl;
  final String? aktivniSval;
  _PostavaPainter({required this.svalyLvl, this.aktivniSval});

  static const double _rW = 200.0, _rH = 380.0;
  static const Color _sk = Color(0xFFE6D2A8);
  static const Color _skD = Color(0xFFCCB484);
  static const Color _skL = Color(0xFFF2E6CC);
  static const Color _ol = Color(0xFFBE9850);
  static const Color _au = Color(0xFFC4974A);
  static const Color _gl = Color(0xFFFFD080);

  late double _sc, _ox, _oy;
  Offset _t(double x, double y) => Offset(_ox + x * _sc, _oy + y * _sc);
  double _d(double v) => v * _sc;

  Paint _fp(Rect r) => Paint()
    ..shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: const [_skL, _sk, _skD],
    ).createShader(r);

  @override
  void paint(Canvas canvas, Size sz) {
    _sc = min(sz.width / _rW, sz.height / _rH) * 0.90;
    _ox = (sz.width - _rW * _sc) / 2;
    _oy = (sz.height - _rH * _sc) / 2;
    _bg(canvas, sz);
    _body(canvas);
    _glows(canvas);
    _contours(canvas);
    _labels(canvas);
  }

  void _bg(Canvas canvas, Size sz) {
    canvas.drawRect(
      Offset.zero & sz,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFF8F2EA), Color(0xFFE8DED0)],
        ).createShader(Offset.zero & sz),
    );
    canvas.drawOval(
      Rect.fromCenter(center: _t(100, 376), width: _d(108), height: _d(9)),
      Paint()
        ..color = const Color(0xFFB09050).withValues(alpha: .25)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _d(12)),
    );
  }

  void _body(Canvas canvas) {
    _circle(canvas, 100, 25, 21);
    _rr(canvas, 93, 44, 14, 20, 5);
    _torso(canvas);
    _ov(canvas, 57, 78, 26, 22);
    _ov(canvas, 143, 78, 26, 22);
    _rr(canvas, 38, 67, 19, 84, 8);
    _rr(canvas, 143, 67, 19, 84, 8);
    _rr(canvas, 31, 152, 17, 74, 7);
    _rr(canvas, 152, 152, 17, 74, 7);
    _rr(canvas, 29, 227, 15, 28, 5);
    _rr(canvas, 156, 227, 15, 28, 5);
    _rr(canvas, 70, 197, 28, 98, 9);
    _rr(canvas, 102, 197, 28, 98, 9);
    _rr(canvas, 72, 297, 23, 74, 8);
    _rr(canvas, 105, 297, 23, 74, 8);
    _rr(canvas, 67, 369, 28, 10, 4);
    _rr(canvas, 105, 369, 28, 10, 4);
  }

  void _circle(Canvas canvas, double cx, double cy, double r) {
    final rect = Rect.fromCircle(center: _t(cx, cy), radius: _d(r));
    canvas.drawCircle(_t(cx, cy), _d(r), _fp(rect));
  }

  void _ov(Canvas canvas, double cx, double cy, double w, double h) {
    final r = Rect.fromCenter(center: _t(cx, cy), width: _d(w), height: _d(h));
    canvas.drawOval(r, _fp(r));
  }

  void _rr(Canvas canvas, double x, double y, double w, double h, double r) {
    final rect = Rect.fromLTWH(_t(x, y).dx, _t(x, y).dy, _d(w), _d(h));
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(_d(r))),
      _fp(rect),
    );
  }

  Path _torsoPath() => Path()
    ..moveTo(_t(88, 63).dx, _t(88, 63).dy)
    ..lineTo(_t(112, 63).dx, _t(112, 63).dy)
    ..cubicTo(
      _t(120, 65).dx,
      _t(120, 65).dy,
      _t(138, 74).dx,
      _t(138, 74).dy,
      _t(140, 85).dx,
      _t(140, 85).dy,
    )
    ..cubicTo(
      _t(137, 115).dx,
      _t(137, 115).dy,
      _t(130, 148).dx,
      _t(130, 148).dy,
      _t(126, 165).dx,
      _t(126, 165).dy,
    )
    ..cubicTo(
      _t(125, 178).dx,
      _t(125, 178).dy,
      _t(127, 190).dx,
      _t(127, 190).dy,
      _t(124, 200).dx,
      _t(124, 200).dy,
    )
    ..lineTo(_t(76, 200).dx, _t(76, 200).dy)
    ..cubicTo(
      _t(73, 190).dx,
      _t(73, 190).dy,
      _t(75, 178).dx,
      _t(75, 178).dy,
      _t(74, 165).dx,
      _t(74, 165).dy,
    )
    ..cubicTo(
      _t(70, 148).dx,
      _t(70, 148).dy,
      _t(63, 115).dx,
      _t(63, 115).dy,
      _t(60, 85).dx,
      _t(60, 85).dy,
    )
    ..cubicTo(
      _t(62, 74).dx,
      _t(62, 74).dy,
      _t(80, 65).dx,
      _t(80, 65).dy,
      _t(88, 63).dx,
      _t(88, 63).dy,
    )
    ..close();

  void _torso(Canvas canvas) {
    final p = _torsoPath();
    canvas.drawPath(p, _fp(p.getBounds()));
  }

  void _glows(Canvas canvas) {
    svalyLvl.forEach((k, lvl) {
      final info = _svalInfo[k];
      if (info == null) return;
      final isAkt = k == aktivniSval, isUpgr = lvl > 1;
      if (!isAkt && !isUpgr) return;
      final alpha = isAkt ? 0.85 : 0.40;
      final blr = isAkt ? 14.0 : 6.0;
      for (final ob in info.oblasti) {
        final r = Rect.fromLTRB(
          _ox + ob.left * _sc,
          _oy + ob.top * _sc,
          _ox + ob.right * _sc,
          _oy + ob.bottom * _sc,
        );
        canvas.drawOval(
          r,
          Paint()
            ..color = _au.withValues(alpha: alpha * .5)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, _d(blr)),
        );
        canvas.drawOval(r, Paint()..color = _au.withValues(alpha: alpha * .4));
        if (isAkt)
          canvas.drawOval(
            r,
            Paint()
              ..color = _gl.withValues(alpha: .6)
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, _d(5)),
          );
      }
    });
  }

  void _contours(Canvas canvas) {
    final p = Paint()
      ..color = _ol.withValues(alpha: .38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _d(.9);
    canvas.drawCircle(_t(100, 25), _d(21), p);
    canvas.drawPath(_torsoPath(), p);
    void sr(double x, double y, double w, double h, double r) {
      final rect = Rect.fromLTWH(_t(x, y).dx, _t(x, y).dy, _d(w), _d(h));
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(_d(r))),
        p,
      );
    }

    sr(38, 67, 19, 84, 8);
    sr(143, 67, 19, 84, 8);
    sr(31, 152, 17, 74, 7);
    sr(152, 152, 17, 74, 7);
    sr(70, 197, 28, 98, 9);
    sr(102, 197, 28, 98, 9);
    sr(72, 297, 23, 74, 8);
    sr(105, 297, 23, 74, 8);
  }

  void _labels(Canvas canvas) {
    final line = Paint()
      ..color = _ol.withValues(alpha: .45)
      ..strokeWidth = _d(.8);
    final bg = Paint()..color = const Color(0xFFFAF7F2);
    final bord = Paint()
      ..color = const Color(0xFFE0D8CC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _d(.7);

    _svalInfo.forEach((k, info) {
      if (!svalyLvl.containsKey(k)) return;
      final lc = _t(info.labelPos.dx, info.labelPos.dy);
      final an = _t(info.anchorPos.dx, info.anchorPos.dy);
      final tp = TextPainter(
        text: TextSpan(
          text: info.nazev,
          style: TextStyle(
            fontSize: _d(11),
            color: const Color(0xFF2C2418),
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final pill = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: lc,
          width: tp.width + _d(10),
          height: tp.height + _d(6),
        ),
        Radius.circular(_d(4)),
      );
      canvas.drawLine(lc, an, line);
      canvas.drawCircle(
        an,
        _d(2.5),
        Paint()..color = _au.withValues(alpha: .7),
      );
      canvas.drawRRect(pill, bg);
      canvas.drawRRect(pill, bord);
      tp.paint(canvas, Offset(lc.dx - tp.width / 2, lc.dy - tp.height / 2));
    });
  }

  @override
  bool shouldRepaint(covariant _PostavaPainter o) =>
      o.aktivniSval != aktivniSval || o.svalyLvl != svalyLvl;
}
