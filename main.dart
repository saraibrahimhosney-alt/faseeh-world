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
  final String title;
  final String englishTitle;
  final String subtitle;
  final String lyrics;
  final String audioFile;
  final String imagePath;
  final Color color;
  final String emoji;
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
  final String text;
  final String emoji;
  final Color bgTint;
  final int startSec;
  final int durationSec;
  const StoryPageData({
    required this.text,
    required this.emoji,
    required this.bgTint,
    required this.startSec,
    required this.durationSec,
  });
}

class StoryBookItem {
  final String title;
  final String englishTitle;
  final String moral;
  final String audioFile;
  final String imagePath;
  final Color color;
  final List<StoryPageData> pages;
  const StoryBookItem({
    required this.title,
    required this.englishTitle,
    required this.moral,
    required this.audioFile,
    required this.imagePath,
    required this.color,
    required this.pages,
  });
}

class QuizItem {
  final String categoryTitle;
  final String englishTitle;
  final String question;
  final String emoji;
  final String imagePath;
  final Color color;
  final List<String> options;
  final int correctIndex;
  const QuizItem({
    required this.categoryTitle,
    required this.englishTitle,
    required this.question,
    required this.emoji,
    required this.imagePath,
    required this.color,
    required this.options,
    required this.correctIndex,
  });
}

class VideoSurahItem {
  final String arabicTitle;
  final String subtitle;
  final String videoId;
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          primary: const Color(0xFF0284C7),
          secondary: const Color(0xFFF59E0B),
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: FaseehCelebrationSplash(),
      ),
    );
  }
}

// ============================================================================
// شاشة البداية الاحتفالية المتحركة بالعلامة البصرية والشخصيات الرئيسية
// ============================================================================
class FaseehCelebrationSplash extends StatefulWidget {
  const FaseehCelebrationSplash({super.key});

  @override
  State<FaseehCelebrationSplash> createState() => _FaseehCelebrationSplashState();
}

class _FaseehCelebrationSplashState extends State<FaseehCelebrationSplash>
    with TickerProviderStateMixin {
  late final AnimationController _confettiController;
  late final AnimationController _pulseController;
  final AudioPlayer _splashPlayer = AudioPlayer();
  Timer? _autoEnterTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 250), () async {
      try {
        await _splashPlayer.play(AssetSource('audio/welcome.mp3'));
      } catch (_) {}
    });

    // الانتقال التلقائي بعد 5 ثوانٍ إذا لم يضغط الطفل على زر البدء
    _autoEnterTimer = Timer(const Duration(seconds: 5), _goToMainStage);
  }

  void _goToMainStage() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _autoEnterTimer?.cancel();
    _splashPlayer.stop();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (_, __, ___) => const Directionality(
          textDirection: TextDirection.rtl,
          child: FaseehWorldStage(),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _autoEnterTimer?.cancel();
    _confettiController.dispose();
    _pulseController.dispose();
    _splashPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية الكرتونية مع تدرج لوني احتفالي مبهج
          Image.asset('assets/images/forest_bg.png', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0284C7).withAlpha(110),
                  const Color(0xFF7C3AED).withAlpha(90),
                  const Color(0xFFF59E0B).withAlpha(110),
                ],
              ),
            ),
          ),

          // طبقة الاحتفال المتحركة (نجوم، بالونات، وأوراق زينة ملونة)
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, _) {
              return CustomPaint(
                painter: _CelebrationConfettiPainter(_confettiController.value),
                size: Size.infinite,
              );
            },
          ),

          // محتوى الهوية البصرية والشخصيات الرئيسية في المنتصف
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // شارة الترحيب العلوية
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF08A),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFD97706), width: 3),
                      boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: const Text(
                      '✨ مَرْحَباً بِكُمْ فِي عَالَمِ اللُّغَةِ العَرَبِيَّةِ وَالقُرْآنِ ✨',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // الشخصيات الرئيسية الثلاث بحركة نبضية احتفالية
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.96, end: 1.05).animate(
                      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // شخصية الأناشيد
                        _buildCharacterBadge(
                          imagePath: 'assets/images/card_songs.png',
                          ringColor: const Color(0xFFEC4899),
                          size: 118,
                          emoji: '🎵',
                        ),
                        const SizedBox(width: 18),
                        // الشخصية المركزية: البوم الحكيم فصيح
                        _buildCharacterBadge(
                          imagePath: 'assets/images/owl_mascot.png',
                          ringColor: const Color(0xFFFBBF24),
                          size: 162,
                          emoji: '👑',
                          isCenter: true,
                        ),
                        const SizedBox(width: 18),
                        // شخصية القصص
                        _buildCharacterBadge(
                          imagePath: 'assets/images/card_stories.png',
                          ringColor: const Color(0xFF10B981),
                          size: 118,
                          emoji: '📖',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // عنوان التطبيق الكبير (العلامة البصرية)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(245),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0xFF0284C7), width: 4.5),
                      boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 6))],
                    ),
                    child: const Column(
                      children: [
                        Text(
                          '🦉 عَالَمُ فَصِيحٍ 🦉',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0284C7),
                            height: 1.15,
                          ),
                        ),
                        Text(
                          'FASEEH WORLD — أَنَاشِيدُ • قِصَصٌ • أَلْعَابٌ • قُرْآنٌ كَرِيمٌ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // زر الانطلاق الفوري
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.white, width: 3.5),
                      ),
                    ),
                    onPressed: _goToMainStage,
                    icon: const Icon(Icons.rocket_launch_rounded, size: 28),
                    label: const Text(
                      'هَيَّا نَبْدَأُ المَرَحَ! 🎉',
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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

  Widget _buildCharacterBadge({
    required String imagePath,
    required Color ringColor,
    required double size,
    required String emoji,
    bool isCenter = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: ringColor, width: isCenter ? 7 : 5),
            boxShadow: [
              BoxShadow(
                color: ringColor.withAlpha(180),
                blurRadius: isCenter ? 24 : 14,
                spreadRadius: isCenter ? 4 : 1,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: -16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ringColor, width: 2.5),
            ),
            child: Text(emoji, style: TextStyle(fontSize: isCenter ? 24 : 19)),
          ),
        ),
      ],
    );
  }
}

class _CelebrationConfettiPainter extends CustomPainter {
  final double progress;
  _CelebrationConfettiPainter(this.progress);

  static const List<Color> _colors = [
    Color(0xFFFBBF24),
    Color(0xFFEC4899),
    Color(0xFF10B981),
    Color(0xFF38BDF8),
    Color(0xFFA855F7),
    Color(0xFFF97316),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 42; i++) {
      final double seedX = ((i * 73) % 100) / 100.0;
      final double speed = 0.6 + ((i % 5) * 0.18);
      final double yNorm = ((i * 0.09) + (progress * speed)) % 1.0;
      final double sway = math.sin((progress * math.pi * 2) + i) * 24;

      final double dx = (seedX * size.width) + sway;
      final double dy = yNorm * size.height;

      paint.color = _colors[i % _colors.length].withAlpha(220);

      if (i % 3 == 0) {
        // دوائر مضيئة
        canvas.drawCircle(Offset(dx, dy), 7.5, paint);
      } else if (i % 3 == 1) {
        // أشرطة احتفالية مائلة
        canvas.save();
        canvas.translate(dx, dy);
        canvas.rotate((progress * math.pi * 4) + i);
        canvas.drawRRect(
          RRect.fromRectAndRadius(const Rect.fromLTWH(-8, -4, 16, 8), const Radius.circular(3)),
          paint,
        );
        canvas.restore();
      } else {
        // نجوم خماسية صغيرة
        _drawStar(canvas, Offset(dx, dy), 9, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final Path path = Path();
    for (int i = 0; i < 5; i++) {
      final double outerAngle = (i * 72 - 90) * math.pi / 180;
      final double innerAngle = ((i * 72) + 36 - 90) * math.pi / 180;
      final Offset outer = Offset(
        center.dx + math.cos(outerAngle) * radius,
        center.dy + math.sin(outerAngle) * radius,
      );
      final Offset inner = Offset(
        center.dx + math.cos(innerAngle) * (radius * 0.45),
        center.dy + math.sin(innerAngle) * (radius * 0.45),
      );
      if (i == 0) {
        path.moveTo(outer.dx, outer.dy);
      } else {
        path.lineTo(outer.dx, outer.dy);
      }
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CelebrationConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// ============================================================================
// الشاشة الرئيسية والأقسام التفاعلية للتطبيق
// ============================================================================
class FaseehWorldStage extends StatefulWidget {
  const FaseehWorldStage({super.key});

  @override
  State<FaseehWorldStage> createState() => _FaseehWorldStageState();
}

class _FaseehWorldStageState extends State<FaseehWorldStage> {
  final AudioPlayer _player = AudioPlayer();
  final YoutubeExplode _yt = YoutubeExplode();
  VideoPlayerController? _videoController;
  Timer? _storySegmentTimer;

  bool _isVideoLoading = false;
  String? _videoError;
  bool _isVideoExpanded = false;

  int _screenIndex = 0;
  int _stars = 30;
  bool _isPlaying = false;
  bool _owlBounce = false;
  String _currentTrack = 'welcome.mp3';
  String _owlBubble = 'أَهْلاً بِكَ فِي عَالَمِ فَصِيحٍ! اخْتَرْ أَيَّ أَيْقُونَةٍ دَائِرِيَّةٍ لِنَبْدَأَ المَرَحَ!';

  int _selectedSongIndex = -1;
  int _selectedBookIndex = -1;
  int _currentPageIndex = 0;
  int _selectedQuizIndex = -1;

  int _selectedTafsirIndex = 0;
  int _selectedRecitationIndex = 0;

  final List<VideoSurahItem> _recitationVideos = const [
    VideoSurahItem(arabicTitle: '١. سُورَةُ الفَاتِحَةِ', subtitle: 'Surah Al-Fatihah Recitation', videoId: 'bP1jjGxwdEs', color: Color(0xFF0284C7)),
    VideoSurahItem(arabicTitle: '٢. سُورَةُ النَّاسِ', subtitle: 'Surah An-Nas Recitation', videoId: 'enlsnMoMAsI', color: Color(0xFF059669)),
    VideoSurahItem(arabicTitle: '٣. سُورَةُ الفَلَقِ', subtitle: 'Surah Al-Falaq Recitation', videoId: '7ITyHlnzUkY', color: Color(0xFF7C3AED)),
    VideoSurahItem(arabicTitle: '٤. سُورَةُ الإِخْلَاصِ', subtitle: 'Surah Al-Ikhlas Recitation', videoId: 'FN6R21YEyeA', color: Color(0xFFD97706)),
    VideoSurahItem(arabicTitle: '٥. سُورَةُ المَسَدِ', subtitle: 'Surah Al-Masad Recitation', videoId: 'JI8z72h5sUA', color: Color(0xFFDC2626)),
    VideoSurahItem(arabicTitle: '٦. سُورَةُ النَّصْرِ', subtitle: 'Surah An-Nasr Recitation', videoId: 'gNaPoAU2ojg', color: Color(0xFF10B981)),
    VideoSurahItem(arabicTitle: '٧. سُورَةُ الكَافِرُونَ', subtitle: 'Surah Al-Kafirun Recitation', videoId: 'MORw76wrIMU', color: Color(0xFF2563EB)),
    VideoSurahItem(arabicTitle: '٨. سُورَةُ الكَوْثَرِ', subtitle: 'Surah Al-Kawthar Recitation', videoId: 'yjomUlM-MZU', color: Color(0xFFDB2777)),
    VideoSurahItem(arabicTitle: '٩. سُورَةُ المَاعُونِ', subtitle: 'Surah Al-Maun Recitation', videoId: 'KBXMbrZijsM', color: Color(0xFF0D9488)),
    VideoSurahItem(arabicTitle: '١٠. سُورَةُ قُرَيْشٍ', subtitle: 'Surah Quraysh Recitation', videoId: 'LRK987yfTPQ', color: Color(0xFF9333EA)),
    VideoSurahItem(arabicTitle: '١١. سُورَةُ الفِيلِ', subtitle: 'Surah Al-Fil Recitation', videoId: 'CS_86YCKaFY', color: Color(0xFFEA580C)),
    VideoSurahItem(arabicTitle: '١٢. سُورَةُ الهُمَزَةِ', subtitle: 'Surah Al-Humazah Recitation', videoId: 'EYHSmenebc8', color: Color(0xFFE11D48)),
    VideoSurahItem(arabicTitle: '١٣. سُورَةُ العَصْرِ', subtitle: 'Surah Al-Asr Recitation', videoId: 'rKnOWbZ6OjA', color: Color(0xFF0891B2)),
    VideoSurahItem(arabicTitle: '١٤. سُورَةُ التَّكَاثُرِ', subtitle: 'Surah At-Takathur Recitation', videoId: '5DTT5UPnU9Q', color: Color(0xFF4F46E5)),
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
    VideoSurahItem(arabicTitle: '١٤. سُورَةُ التَّكَاثُرِ', subtitle: 'Surah At-Takathur (Competition for More)', videoId: '5DTT5UPnU9Q', color: Color(0xFF4F46E5)),
  ];

  final List<SongItem> _songs = const [
    SongItem(
      title: 'أُنْشُودَةُ الحُرُوفِ',
      englishTitle: 'Alphabet Song',
      subtitle: 'أَلِفٌ أَرْنَبٌ.. يَجْرِي يَلْعَبُ!',
      lyrics: 'أَلِفٌ أَرْنَبٌ، يَجْرِي يَلْعَبُ، يَأْكُلُ جَزَراً كَيْ لَا يَتْعَبَ!\nبَاءٌ بَطَّةٌ، نَطَّتْ نَطَّةً، وَقَعَتْ ضَحِكَتْ مِنْهَا القِطَّةُ!',
      audioFile: 'song_alphabet.mp3',
      imagePath: 'assets/images/card_songs.png',
      color: Color(0xFFEC4899),
      emoji: '🐰',
    ),
    SongItem(
      title: 'أُنْشُودَةُ الصَّبَاحِ',
      englishTitle: 'Morning Sun Song',
      subtitle: 'أَشْرَقَتِ الشَّمْسُ الذَّهَبِيَّةُ!',
      lyrics: 'أَشْرَقَتِ الشَّمْسُ الذَّهَبِيَّةُ، وَتَغَنَّتْ طَيْرُ الحُرِّيَّةِ!\nهَيَّا نَتَعَلَّمْ يَا أَطْفَالُ، لُغَتِي الفُصْحَى أَجْمَلُ حَالٍ!',
      audioFile: 'song_morning.mp3',
      imagePath: 'assets/images/owl_mascot.png',
      color: Color(0xFFF59E0B),
      emoji: '☀️',
    ),
    SongItem(
      title: 'أُنْشُودَةُ الأَرْقَامِ',
      englishTitle: 'Numbers Song',
      subtitle: 'وَاحِدٌ اثْنَانِ ثَلَاثَةٌ!',
      lyrics: 'وَاحِدٌ اثْنَانِ ثَلَاثَةٌ، نَتَعَلَّمُ بِذَكَاءٍ وَحَمَاسَةٍ!\nأَرْبَعَةٌ خَمْسَةٌ سِتَّةٌ، نَقْرَأُ فِي البُسْتَانِ القِصَّةَ!',
      audioFile: 'song_numbers.mp3',
      imagePath: 'assets/images/card_stories.png',
      color: Color(0xFF8B5CF6),
      emoji: '🔢',
    ),
  ];

  final List<StoryBookItem> _books = const [
    StoryBookItem(
      title: 'الأَرْنَبُ وَالجَزَرَةُ الذَّهَبِيَّةُ',
      englishTitle: 'The Rabbit & Golden Carrot',
      moral: 'الحِكْمَةُ: بِالتَّعَاوُنِ وَالكَلِمَةِ الطَّيِّبَةِ نُنْجِزُ أَصْعَبَ المَهَامِّ!',
      audioFile: 'story_rabbit.mp3',
      imagePath: 'assets/images/card_stories.png',
      color: Color(0xFF059669),
      pages: [
        StoryPageData(
          text: 'فِي صَبَاحٍ مُشْرِقٍ جَمِيلٍ، خَرَجَ الأَرْنَبُ الصَّغِيرُ «فَصِيحٌ» يَبْحَثُ عَنْ طَعَامٍ لَذِيذٍ فِي الحَقْلِ الأَخْضَرِ الوَاسِعِ.',
          emoji: '🐰🌞🌿',
          bgTint: Color(0xFFECFDF5),
          startSec: 0,
          durationSec: 8,
        ),
        StoryPageData(
          text: 'فَجْأَةً، وَجَدَ فَصِيحٌ جَزَرَةً كَبِيرَةً تَلْمَعُ تَحْتَ أَشِعَّةِ الشَّمْسِ، لَكِنَّهَا كَانَتْ عَالِقَةً بِقُوَّةٍ فِي التُّرْبَةِ!',
          emoji: '🥕✨😲',
          bgTint: Color(0xFFFFFBEB),
          startSec: 8,
          durationSec: 8,
        ),
        StoryPageData(
          text: 'نَادَى فَصِيحٌ أَصْدِقَاءَهُ السِّنْجَابَ وَالسُّلَحْفَاةَ، وَقَالَ بِلُطْفٍ وَأَدَبٍ: «هَلْ تُسَاعِدُونَنِي يَا أَصْدِقَائِي؟».',
          emoji: '🐿️🐢💬',
          bgTint: Color(0xFFF0F9FF),
          startSec: 16,
          durationSec: 8,
        ),
        StoryPageData(
          text: 'تَعَاوَنَ الجَمِيعُ بِهِمَّةٍ وَنَشَاطٍ حَتَّى أَخْرَجُوا الجَزَرَةَ الذَّهَبِيَّةَ، وَتَقَاسَمُوهَا بِسَعَادَةٍ وَمَحَبَّةٍ كَبِيرَةٍ!',
          emoji: '🎉🥕❤️',
          bgTint: Color(0xFFFDF2F8),
          startSec: 24,
          durationSec: 12,
        ),
      ],
    ),
    StoryBookItem(
      title: 'البُومُ الحَكِيمُ وَالبُلْبُلُ',
      englishTitle: 'The Wise Owl & Nightingale',
      moral: 'الحِكْمَةُ: الثِّقَةُ بِالنَّفْسِ وَالمُحَاوَلَةُ المُسْتَمِرَّةُ تَصْنَعُ الإِبْدَاعَ!',
      audioFile: 'story_owl.mp3',
      imagePath: 'assets/images/owl_mascot.png',
      color: Color(0xFF7C3AED),
      pages: [
        StoryPageData(
          text: 'فِي الغَابَةِ المَضِيئَةِ، كَانَ البُلْبُلُ الصَّغِيرُ يَخْجَلُ مِنَ الغِنَاءِ أَمَامَ طُيُورِ الغَابَةِ خَوْفاً مِنَ الخَطَأِ.',
          emoji: '🐦🙈🌳',
          bgTint: Color(0xFFF5F3FF),
          startSec: 0,
          durationSec: 9,
        ),
        StoryPageData(
          text: 'اقْتَرَبَ مِنْهُ البُومُ الحَكِيمُ «فَصِيحٌ» وَقَالَ لَهُ بِابْتِسَامَةٍ دَافِئَةٍ: «صَوْتُكَ جَمِيلٌ يَا بُنَيَّ، وَالتَّجْرِبَةُ هِيَ طَرِيقُ النَّجَاحِ!».',
          emoji: '🦉💛✨',
          bgTint: Color(0xFFFFFBEB),
          startSec: 9,
          durationSec: 10,
        ),
        StoryPageData(
          text: 'تَشَجَّعَ البُلْبُلُ وَانْطَلَقَ يُغَرِّدُ بِأَعْذَبِ الأَلْحَانِ الفَصِيحَةِ، فَصَفَّقَتْ لَهُ الطُّيُورُ بِإِعْجَابٍ وَفَرَحٍ شَدِيدٍ!',
          emoji: '🎶🐦👏',
          bgTint: Color(0xFFECFDF5),
          startSec: 19,
          durationSec: 12,
        ),
      ],
    ),
  ];

  final List<QuizItem> _quizzes = const [
    QuizItem(
      categoryTitle: 'تَحَدِّي المُفْرَدَاتِ',
      englishTitle: 'Vocabulary Challenge',
      question: 'مَا مَعْنَى كَلِمَةِ «غَدِيرٌ»؟',
      emoji: '💧',
      imagePath: 'assets/images/card_stories.png',
      color: Color(0xFF0284C7),
      options: ['نَهْرٌ صَغِيرٌ عَذْبٌ 💧', 'جَبَلٌ كَبِيرٌ ⛰️', 'رِيَاحٌ قَوِيَّةٌ 🌪️'],
      correctIndex: 0,
    ),
    QuizItem(
      categoryTitle: 'تَحَدِّي الأَصْوَاتِ',
      englishTitle: 'Nature Sounds Game',
      question: 'مَا صَوْتُ أَوْرَاقِ الشَّجَرِ؟',
      emoji: '🍃',
      imagePath: 'assets/images/card_songs.png',
      color: Color(0xFF059669),
      options: ['زَئِيرٌ 🦁', 'حَفِيفٌ 🍃', 'خَرِيرٌ 🌊'],
      correctIndex: 1,
    ),
    QuizItem(
      categoryTitle: 'تَحَدِّي الفُصْحَى',
      englishTitle: 'Classical Arabic Quiz',
      question: 'أَيُّ جُمْلَةٍ بِالعَرَبِيَّةِ الفُصْحَى؟',
      emoji: '🌟',
      imagePath: 'assets/images/owl_mascot.png',
      color: Color(0xFFF59E0B),
      options: ['الولد راح بدري', 'ذَهَبَ الطِّفْلُ مُبَكِّراً 🌟', 'أيمتى رح نلعب؟'],
      correctIndex: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      _storySegmentTimer?.cancel();
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _storySegmentTimer?.cancel();
    _videoController?.dispose();
    _yt.close();
    _player.dispose();
    super.dispose();
  }

  bool get _canGoBackOneStep {
    if (_screenIndex == 1 && _selectedSongIndex != -1) return true;
    if (_screenIndex == 2 && _selectedBookIndex != -1) return true;
    if (_screenIndex == 3 && _selectedQuizIndex != -1) return true;
    if ((_screenIndex == 4 || _screenIndex == 5) && _isVideoExpanded) return true;
    return false;
  }

  Future<void> _handleBackOneStep() async {
    _storySegmentTimer?.cancel();
    await _player.stop();
    setState(() {
      _isPlaying = false;
      if (_screenIndex == 1 && _selectedSongIndex != -1) {
        _selectedSongIndex = -1;
        _owlBubble = 'اخْتَرْ أُنْشُودَةً مِنَ الأَيْقُونَاتِ الدَّائِرِيَّةِ!';
      } else if (_screenIndex == 2 && _selectedBookIndex != -1) {
        _selectedBookIndex = -1;
        _owlBubble = 'اخْتَرْ قِصَّةً مِنَ المَكْتَبَةِ الدَّائِرِيَّةِ!';
      } else if (_screenIndex == 3 && _selectedQuizIndex != -1) {
        _selectedQuizIndex = -1;
        _owlBubble = 'اخْتَرْ لُعْبَةً مِنَ الأَلْعَابِ الدَّائِرِيَّةِ!';
      } else if ((_screenIndex == 4 || _screenIndex == 5) && _isVideoExpanded) {
        _isVideoExpanded = false;
      }
    });
  }

  Future<void> _playStoryPageAudio(StoryBookItem book, int pageIndex) async {
    _storySegmentTimer?.cancel();
    final StoryPageData page = book.pages[pageIndex];
    setState(() {
      _currentTrack = book.audioFile;
      _owlBubble = 'تَقْرَأُ وَتَسْتَمِعُ الآنَ إِلَى صَفْحَةِ ${pageIndex + 1} مِنْ: ${book.title}';
      _isPlaying = true;
      _owlBounce = true;
    });
    await _player.stop();
    await _player.play(AssetSource('audio/${book.audioFile}'));
    if (page.startSec > 0) {
      await _player.seek(Duration(seconds: page.startSec));
    }
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() => _owlBounce = false);
      }
    });

    _storySegmentTimer = Timer(Duration(seconds: page.durationSec), () async {
      await _player.pause();
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _owlBubble = 'انْتَهَتْ هَذِهِ الصَّفْحَةُ! اضْغَطْ عَلَى «الصَّفْحَةُ التَّالِيَةُ» لِنُكْمِلَ القِصَّةَ!';
        });
      }
    });
  }

  Future<void> _playDirectNativeVideo(String videoId) async {
    setState(() {
      _isVideoLoading = true;
      _videoError = null;
    });
    await _videoController?.dispose();
    _videoController = null;

    try {
      final StreamManifest manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final MuxedStreamInfo streamInfo = manifest.muxed.withHighestBitrate();
      final VideoPlayerController ctrl = VideoPlayerController.networkUrl(streamInfo.url);
      await ctrl.initialize();
      await ctrl.play();
      if (mounted) {
        setState(() {
          _videoController = ctrl;
          _isVideoLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVideoLoading = false;
          _videoError = 'تَعَذَّرَ تَحْمِيلُ الفِيدْيُو حَالِيّاً، تَأَكَّدْ مِنَ الاتِّصَالِ بِالإِنْتَرْنِت.';
        });
      }
    }
  }

  Future<void> _playMedia(String fileName, String bubbleText, int bonusStars) async {
    _storySegmentTimer?.cancel();
    setState(() {
      _currentTrack = fileName;
      _owlBubble = bubbleText;
      _isPlaying = true;
      _owlBounce = true;
      _stars += bonusStars;
    });
    await _player.stop();
    await _player.play(Asset
