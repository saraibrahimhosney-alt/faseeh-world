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
  final String text, emoji, audioFile;
  final Color bgTint;
  const StoryPageData({
    required this.text,
    required this.emoji,
    required this.audioFile,
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
    Future.delayed(const Duration(milliseconds: 250), () async {
      try {
        await _splashPlayer.play(AssetSource('audio/welcome.mp3'));
      } catch (_) {}
    });
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
                        onPressed: () async {
                          await _splashPlayer.stop();
                          await _splashPlayer.play(AssetSource('audio/applause.mp3'));
                        },
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
      final double y = (((i * 0.08) + (p * (0.7 + (i % 5) * 0.18))) % 1.0) * size.height;
      paint.color = _c[i % _c.length].withAlpha(230);
      if (i % 3 == 0) {
        canvas.drawOval(Rect.fromCenter(center: Offset(x, size.height - y), width: 18, height: 24), paint);
      } else if (i % 3 == 1) {
        canvas.drawCircle(Offset(x, y), 7.5, paint);
      } else {
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(x, y), width: 15, height: 8), const Radius.circular(3)), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _JoyCelebrationPainter oldDelegate) => oldDelegate.p != p;
}

class FaseehWorldStage extends StatefulWidget {
  const FaseehWorldStage({super.key});

  @override
  State<FaseehWorldStage> createState() => _FaseehWorldStageState();
}

class _FaseehWorldStageState extends State<FaseehWorldStage> {
  final AudioPlayer _player = AudioPlayer();
  final YoutubeExplode _yt = YoutubeExplode();
  VideoPlayerController? _videoController;

  bool _isVideoLoading = false;
  String? _videoError;
  bool _isVideoExpanded = false;

  int _screenIndex = 0;
  int _stars = 30;
  bool _isPlaying = false;
  bool _owlBounce = false;
  String _currentTrack = 'applause.mp3';
  String _owlBubble = 'أَهْلاً بِكَ يَا صَدِيقِي! اخْتَرْ أَيَّ أَيْقُونَةٍ دَائِرِيَّةٍ لِنَبْدَأَ!';

  int _selectedSongIndex = -1;
  int _selectedBookIndex = -1;
  int _currentPageIndex = 0;
  int _selectedQuizIndex = -1;
  int _selectedTafsirIndex = 0;
  int _selectedRecitationIndex = 0;

  final List<VideoSurahItem> _recitationVideos = const [
    VideoSurahItem(arabicTitle: '١. سُورَةُ الفَاتِحَةِ', subtitle: 'Surah Al-Fatihah', videoId: 'bP1jjGxwdEs', color: Color(0xFF0284C7)),
    VideoSurahItem(arabicTitle: '٢. سُورَةُ النَّاسِ', subtitle: 'Surah An-Nas', videoId: 'enlsnMoMAsI', color: Color(0xFF059669)),
    VideoSurahItem(arabicTitle: '٣. سُورَةُ الفَلَقِ', subtitle: 'Surah Al-Falaq', videoId: '7ITyHlnzUkY', color: Color(0xFF7C3AED)),
    VideoSurahItem(arabicTitle: '٤. سُورَةُ الإِخْلَاصِ', subtitle: 'Surah Al-Ikhlas', videoId: 'FN6R21YEyeA', color: Color(0xFFD97706)),
    VideoSurahItem(arabicTitle: '٥. سُورَةُ المَسَدِ', subtitle: 'Surah Al-Masad', videoId: 'JI8z72h5sUA', color: Color(0xFFDC2626)),
    VideoSurahItem(arabicTitle: '٦. سُورَةُ النَّصْرِ', subtitle: 'Surah An-Nasr', videoId: 'gNaPoAU2ojg', color: Color(0xFF10B981)),
    VideoSurahItem(arabicTitle: '٧. سُورَةُ الكَافِرُونَ', subtitle: 'Surah Al-Kafirun', videoId: 'MORw76wrIMU', color: Color(0xFF2563EB)),
    VideoSurahItem(arabicTitle: '٨. سُورَةُ الكَوْثَرِ', subtitle: 'Surah Al-Kawthar', videoId: 'yjomUlM-MZU', color: Color(0xFFDB2777)),
    VideoSurahItem(arabicTitle: '٩. سُورَةُ المَاعُونِ', subtitle: 'Surah Al-Maun', videoId: 'KBXMbrZijsM', color: Color(0xFF0D9488)),
    VideoSurahItem(arabicTitle: '١٠. سُورَةُ قُرَيْشٍ', subtitle: 'Surah Quraysh', videoId: 'LRK987yfTPQ', color: Color(0xFF9333EA)),
    VideoSurahItem(arabicTitle: '١١. سُورَةُ الفِيلِ', subtitle: 'Surah Al-Fil', videoId: 'CS_86YCKaFY', color: Color(0xFFEA580C)),
    VideoSurahItem(arabicTitle: '١٢. سُورَةُ الهُمَزَةِ', subtitle: 'Surah Al-Humazah', videoId: 'EYHSmenebc8', color: Color(0xFFE11D48)),
    VideoSurahItem(arabicTitle: '١٣. سُورَةُ العَصْرِ', subtitle: 'Surah Al-Asr', videoId: 'rKnOWbZ6OjA', color: Color(0xFF0891B2)),
    VideoSurahItem(arabicTitle: '١٤. سُورَةُ التَّكَاثُرِ', subtitle: 'Surah At-Takathur', videoId: '5DTT5UPnU9Q', color: Color(0xFF4F46E5)),
  ];

  final List<VideoSurahItem> _tafsirVideos = const [
    VideoSurahItem(arabicTitle: '١. سُورَةُ الفَاتِحَةِ', subtitle: 'Surah Al-Fatihah (The Opening)', videoId: '3gbEFfKW-UM', color: Color(0xFF059669)),
    VideoSurahItem(arabicTitle: '٢. سُورَةُ النَّاسِ', subtitle: 'Surah An-Nas (Mankind)', videoId: 'BqVobCoQv4I', color: Color(0xFF0284C7)),
    VideoSurahItem(arabicTitle: '٣. سُورَةُ الفَلَقِ', subtitle: 'Surah Al-Falaq (The Daybreak)', videoId: 'zav5SzRNPCs', color: Color(0xFF7C3AED)),
    VideoSurahItem(arabicTitle: '٤. سُورَةُ الإِخْلَاصِ', subtitle: 'Surah Al-Ikhlas (The Purity)', videoId: 'FzPKrwNrh_A', color: Color(0xFFD97706)),
    VideoSurahItem(arabicTitle: '٥. سُورَةُ المَسَدِ', subtitle: 'Surah Al-Masad (The Palm Fiber)', videoId: 'JI8z72h5sUA', color: Color(0xFFDC2626)),
    VideoSurahItem(arabicTitle: '٦. سُورَةُ النَّصْرِ', subtitle: 'Surah An-Nasr (The Victory)', videoId: 'gNaPoAU2ojg', color: Color(0xFF10B981)),
    VideoSurahItem(arabicTitle: '٧. سُورَةُ الكَافِرُونَ', subtitle: 'Surah Al-Kafirun (The Disbelievers)', videoId: 'MORw76wrIMU', color: Color(0xFF2563EB)),
    VideoSurahItem(arabicTitle: '٨. سُورَةُ الكَوْثَرِ', subtitle: 'Surah Al-Kawthar (Abundance)', videoId: 'yjomUlM-MZU', color: Color(0xFFDB2777)),
    VideoSurahItem(arabicTitle: '٩. سُورَةُ المَاعُونِ', subtitle: 'Surah Al-Maun (Small Kindnesses)', videoId: 'KBXMbrZijsM', color: Color(0xFF0D9488)),
    VideoSurahItem(arabicTitle: '١٠. سُورَةُ قُرَيْشٍ', subtitle: 'Surah Quraysh (The Tribe of Quraysh)', videoId: 'LRK987yfTPQ', color: Color(0xFF9333EA)),
    VideoSurahItem(arabicTitle: '١١. سُورَةُ الفِيلِ', subtitle: 'Surah Al-Fil (The Elephant)', videoId: 'CS_86YCKaFY', color: Color(0xFFEA580C)),
    VideoSurahItem(arabicTitle: '١٢. سُورَةُ الهُمَزَةِ', subtitle: 'Surah Al-Humazah (The Slanderer)', videoId: 'EYHSmenebc8', color: Color(0xFFE11D48)),
    VideoSurahItem(arabicTitle: '١٣. سُورَةُ العَصْرِ', subtitle: 'Surah Al-Asr (The Time)', videoId: 'rKnOWbZ6OjA', color: Color(0xFF0891B2)),
    VideoSurahItem(arabicTitle: '١٤. سُورَةُ التَّكَاثُرِ', subtitle: 'Surah At-Takathur (Competition)', videoId: '5DTT5UPnU9Q', color: Color(0xFF4F46E5)),
  ];

  final List<SongItem> _songs = const [
    SongItem(
      title: 'أُنْشُودَةُ الحُرُوفِ',
      englishTitle: 'Alphabet Song',
      subtitle: 'أَلِفٌ أَرْنَبٌ.. يَجْرِي يَلْعَبُ!',
      lyrics: 'أَلِفٌ أَرْنَبٌ، يَجْرِي يَلْعَبُ، يَأْكُلُ جَزَراً
