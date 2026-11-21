import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const FaseehCartoonApp());
}

class SongItem {
  final String title, englishTitle, subtitle, lyrics, audioFile, imagePath, emoji;
  final Color color;
  const SongItem({
    required this.title,
    required this.englishTitle,
    required this.subtitle,
    required this.lyrics,
    required this.audioFile,
    required this.imagePath,
    required this.color,
    required this.emoji,
  });
}

class StoryPageData {
  final String pageTitle, text, mainEmoji, sideEmoji1, sideEmoji2;
  final Color bgTint;
  const StoryPageData({
    required this.pageTitle,
    required this.text,
    required this.mainEmoji,
    required this.sideEmoji1,
    required this.sideEmoji2,
    required this.bgTint,
  });
}

class StoryBookItem {
  final String title, englishTitle, moral, imagePath;
  final Color color;
  final List<StoryPageData> pages;
  const StoryBookItem({
    required this.title,
    required this.englishTitle,
    required this.moral,
    required this.imagePath,
    required this.color,
    required this.pages,
  });
}

class QuizItem {
  final String categoryTitle, englishTitle, question, audioFile, emoji, imagePath;
  final Color color;
  final List<String> options;
  final int correctIndex;
  const QuizItem({
    required this.categoryTitle,
    required this.englishTitle,
    required this.question,
    required this.audioFile,
    required this.emoji,
    required this.imagePath,
    required this.color,
    required this.options,
    required this.correctIndex,
  });
}

class VideoSurahItem {
  final String arabicTitle, subtitle, videoId;
  final Color color;
  const VideoSurahItem({
    required this.arabicTitle,
    required this.subtitle,
    required this.videoId,
    required this.color,
  });
}

class FaseehCartoonApp extends StatelessWidget {
  const FaseehCartoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عَالَمُ فَصِيحٍ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0284C7)),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: FaseehCelebrationSplash(),
      ),
    );
  }
}

class FaseehCelebrationSplash extends StatefulWidget {
  const FaseehCelebrationSplash({super.key});

  @override
  State<FaseehCelebrationSplash> createState() => _FaseehCelebrationSplashState();
}

class _FaseehCelebrationSplashState extends State<FaseehCelebrationSplash>
    with TickerProviderStateMixin {
  late final AnimationController _confettiCtrl;
  late final AnimationController _bounceCtrl;
  final AudioPlayer _splashPlayer = AudioPlayer();
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650))..repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 300), () async {
      await _playSplashAudio('welcome.mp3');
    });
  }

  Future<void> _playSplashAudio(String fileName) async {
    try {
      await _splashPlayer.stop();
      await _splashPlayer.setReleaseMode(ReleaseMode.stop);
      await _splashPlayer.play(AssetSource('audio/$fileName'), volume: 1.0);
    } catch (_) {
      try {
        await _splashPlayer.play(AssetSource(fileName), volume: 1.0);
      } catch (_) {}
    }
  }

  void _enterApp() async {
    if (_navigated || !mounted) return;
    _navigated = true;
    await _splashPlayer.stop();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const Directionality(
          textDirection: TextDirection.rtl,
          child: FaseehWorldStage(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _bounceCtrl.dispose();
    _splashPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/forest_bg.png', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFEC4899).withAlpha(95),
                  const Color(0xFF0284C7).withAlpha(105),
                  const Color(0xFFF59E0B).withAlpha(105),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _confettiCtrl,
            builder: (_, __) => CustomPaint(painter: _JoyCelebrationPainter(_confettiCtrl.value), size: Size.infinite),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF08A),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFD97706), width: 3.5),
                    ),
                    child: const Text(
                      '🎉👏 مَرْحَباً بِكُمْ فِي عَالَمِ البَهْجَةِ وَاللُّغَةِ العَرَبِيَّةِ 👏🎉',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedBuilder(
                    animation: _bounceCtrl,
                    builder: (_, child) => Transform.translate(offset: Offset(0, -10 * _bounceCtrl.value), child: child),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _charBadge('assets/images/card_songs.png', const Color(0xFFEC4899), 116, '👏', false),
                        const SizedBox(width: 20),
                        _charBadge('assets/images/owl_mascot.png', const Color(0xFFFBBF24), 160, '👑', true),
                        const SizedBox(width: 20),
                        _charBadge('assets/images/card_stories.png', const Color(0xFF10B981), 116, '🎈', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(248),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFF0284C7), width: 4.5),
                    ),
                    child: const Column(
                      children: [
                        Text('🦉 عَالَمُ فَصِيحٍ 🦉', style: TextStyle(fontSize: 33, fontWeight: FontWeight.w900, color: Color(0xFF0284C7))),
                        Text('FASEEH WORLD — أَنَاشِيدُ • قِصَصٌ • أَلْعَابٌ • قُرْآنٌ كَرِيمٌ', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.white, width: 3)),
                        ),
                        onPressed: () => _playSplashAudio('bravo.mp3'),
                        icon: const Text('👏', style: TextStyle(fontSize: 22)),
                        label: const Text('تَشْجِيعٌ!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 14),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.white, width: 3.5)),
                        ),
                        onPressed: _enterApp,
                        icon: const Icon(Icons.rocket_launch_rounded, size: 28),
                        label: const Text('اضْغَطْ هُنَا لِنَبْدَأَ! 🎉', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _charBadge(String img, Color color, double size, String emoji, bool center) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: color, width: center ? 6.5 : 4.5),
            boxShadow: [BoxShadow(color: color.withAlpha(190), blurRadius: center ? 24 : 14)],
          ),
          child: ClipOval(child: Image.asset(img, fit: BoxFit.cover)),
        ),
        Positioned(
          top: -15,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: color, width: 2.5)),
            child: Text(emoji, style: TextStyle(fontSize: center ? 23 : 18)),
          ),
        ),
      ],
    );
  }
}

class _JoyCelebrationPainter extends CustomPainter {
  final double p;
  _JoyCelebrationPainter(this.p);
  static const List<Color> _c = [Color(0xFFFBBF24), Color(0xFFEC4899), Color(0xFF10B981), Color(0xFF38BDF8), Color(0xFFA855F7), Color(0xFFF97316)];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    for (int i = 0; i < 42; i++) {
      final double x = (((i * 67) % 100) / 100.0 * size.width) + math.sin((p * math.pi * 2) + i) * 26;
      final double y = (((i *
