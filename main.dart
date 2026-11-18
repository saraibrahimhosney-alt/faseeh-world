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
  final String text, emoji;
  final Color bgTint;
  final int startSec, durationSec;
  const StoryPageData({
    required this.text,
    required this.emoji,
    required this.bgTint,
    required this.startSec,
    required this.durationSec,
  });
}

class StoryBookItem {
  final String title, englishTitle, moral, audioFile, imagePath;
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
  final String categoryTitle, englishTitle, question, emoji, imagePath;
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
  late final AnimationController _pulseCtrl;
  final AudioPlayer _splashPlayer = AudioPlayer();
  Timer? _timer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 250), () async {
      try {
        await _splashPlayer.play(AssetSource('audio/welcome.mp3'));
      } catch (_) {}
    });
    _timer = Timer(const Duration(seconds: 5), _enterApp);
  }

  void _enterApp() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _timer?.cancel();
    _splashPlayer.stop();
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
    _timer?.cancel();
    _confettiCtrl.dispose();
    _pulseCtrl.dispose();
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
          AnimatedBuilder(
            animation: _confettiCtrl,
            builder: (_, __) => CustomPaint(painter: _ConfettiPainter(_confettiCtrl.value), size: Size.infinite),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF08A),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFD97706), width: 3),
                    ),
                    child: const Text(
                      '✨ مَرْحَباً بِكُمْ فِي عَالَمِ اللُّغَةِ العَرَبِيَّةِ وَالقُرْآنِ ✨',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.05).animate(
                      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _charBadge('assets/images/card_songs.png', const Color(0xFFEC4899), 112, '🎵', false),
                        const SizedBox(width: 18),
                        _charBadge('assets/images/owl_mascot.png', const Color(0xFFFBBF24), 156, '👑', true),
                        const SizedBox(width: 18),
                        _charBadge('assets/images/card_stories.png', const Color(0xFF10B981), 112, '📖', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(245),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFF0284C7), width: 4),
                    ),
                    child: const Column(
                      children: [
                        Text('🦉 عَالَمُ فَصِيحٍ 🦉', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0284C7))),
                        Text('FASEEH WORLD — أَنَاشِيدُ • قِصَصٌ • أَلْعَابٌ • قُرْآنٌ كَرِيمٌ', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.white, width: 3)),
                    ),
                    onPressed: _enterApp,
                    icon: const Icon(Icons.rocket_launch_rounded, size: 26),
                    label: const Text('هَيَّا نَبْدَأُ المَرَحَ! 🎉', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
            border: Border.all(color: color, width: center ? 6 : 4.5),
            boxShadow: [BoxShadow(color: color.withAlpha(180), blurRadius: center ? 22 : 12)],
          ),
          child: ClipOval(child: Image.asset(img, fit: BoxFit.cover)),
        ),
        Positioned(
          top: -14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: color, width: 2)),
            child: Text(emoji, style: TextStyle(fontSize: center ? 22 : 17)),
          ),
        ),
      ],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double p;
  _ConfettiPainter(this.p);
  static const List<Color> _c = [Color(0xFFFBBF24), Color(0xFFEC4899), Color(0xFF10B981), Color(0xFF38BDF8), Color(0xFFA855F7)];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    for (int i = 0; i < 36; i++) {
      final double x = (((i * 73) % 100) / 100.0 * size.width) + math.sin((p * math.pi * 2) + i) * 22;
      final double y = (((i * 0.09) + (p * (0.6 + (i % 5) * 0.16))) % 1.0) * size.height;
      paint.color = _c[i % _c.length].withAlpha(220);
      if (i % 2 == 0) {
        canvas.drawCircle(Offset(x, y), 7, paint);
      } else {
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(x, y), width: 14, height: 7), const Radius.circular(3)), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.p != p;
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
        StoryPageData(text: 'فِي صَبَاحٍ مُشْرِقٍ جَمِيلٍ، خَرَجَ الأَرْنَبُ الصَّغِيرُ «فَصِيحٌ» يَبْحَثُ عَنْ طَعَامٍ لَذِيذٍ فِي الحَقْلِ الأَخْضَرِ الوَاسِعِ.', emoji: '🐰🌞🌿', bgTint: Color(0xFFECFDF5), startSec: 0, durationSec: 8),
        StoryPageData(text: 'فَجْأَةً، وَجَدَ فَصِيحٌ جَزَرَةً كَبِيرَةً تَلْمَعُ تَحْتَ أَشِعَّةِ الشَّمْسِ، لَكِنَّهَا كَانَتْ عَالِقَةً بِقُوَّةٍ فِي التُّرْبَةِ!', emoji: '🥕✨😲', bgTint: Color(0xFFFFFBEB), startSec: 8, durationSec: 8),
        StoryPageData(text: 'نَادَى فَصِيحٌ أَصْدِقَاءَهُ السِّنْجَابَ وَالسُّلَحْفَاةَ، وَقَالَ بِلُطْفٍ وَأَدَبٍ: «هَلْ تُسَاعِدُونَنِي يَا أَصْدِقَائِي؟».', emoji: '🐿️🐢💬', bgTint: Color(0xFFF0F9FF), startSec: 16, durationSec: 8),
        StoryPageData(text: 'تَعَاوَنَ الجَمِيعُ بِهِمَّةٍ وَنَشَاطٍ حَتَّى أَخْرَجُوا الجَزَرَةَ الذَّهَبِيَّةَ، وَتَقَاسَمُوهَا بِسَعَادَةٍ وَمَحَبَّةٍ كَبِيرَةٍ!', emoji: '🎉🥕❤️', bgTint: Color(0xFFFDF2F8), startSec: 24, durationSec: 12),
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
        StoryPageData(text: 'فِي الغَابَةِ المَضِيئَةِ، كَانَ البُلْبُلُ الصَّغِيرُ يَخْجَلُ مِنَ الغِنَاءِ أَمَامَ طُيُورِ الغَابَةِ خَوْفاً مِنَ الخَطَأِ.', emoji: '🐦🙈🌳', bgTint: Color(0xFFF5F3FF), startSec: 0, durationSec: 9),
        StoryPageData(text: 'اقْتَرَبَ مِنْهُ البُومُ الحَكِيمُ «فَصِيحٌ» وَقَالَ لَهُ بِابْتِسَامَةٍ دَافِئَةٍ: «صَوْتُكَ جَمِيلٌ يَا بُنَيَّ، وَالتَّجْرِبَةُ هِيَ طَرِيقُ النَّجَاحِ!».', emoji: '🦉💛✨', bgTint: Color(0xFFFFFBEB), startSec: 9, durationSec: 10),
        StoryPageData(text: 'تَشَجَّعَ البُلْبُلُ وَانْطَلَقَ يُغَرِّدُ بِأَعْذَبِ الأَلْحَانِ الفَصِيحَةِ، فَصَفَّقَتْ لَهُ الطُّيُورُ بِإِعْجَابٍ وَفَرَحٍ شَدِيدٍ!', emoji: '🎶🐦👏', bgTint: Color(0xFFECFDF5), startSec: 19, durationSec: 12),
      ],
    ),
  ];

  final List<QuizItem> _quizzes = const [
    QuizItem(categoryTitle: 'تَحَدِّي المُفْرَدَاتِ', englishTitle: 'Vocabulary Challenge', question: 'مَا مَعْنَى كَلِمَةِ «غَدِيرٌ»؟', emoji: '💧', imagePath: 'assets/images/card_stories.png', color: Color(0xFF0284C7), options: ['نَهْرٌ صَغِيرٌ عَذْبٌ 💧', 'جَبَلٌ كَبِيرٌ ⛰️', 'رِيَاحٌ قَوِيَّةٌ 🌪️'], correctIndex: 0),
    QuizItem(categoryTitle: 'تَحَدِّي الأَصْوَاتِ', englishTitle: 'Nature Sounds Game', question: 'مَا صَوْتُ أَوْرَاقِ الشَّجَرِ؟', emoji: '🍃', imagePath: 'assets/images/card_songs.png', color: Color(0xFF059669), options: ['زَئِيرٌ 🦁', 'حَفِيفٌ 🍃', 'خَرِيرٌ 🌊'], correctIndex: 1),
    QuizItem(categoryTitle: 'تَحَدِّي الفُصْحَى', englishTitle: 'Classical Arabic Quiz', question: 'أَيُّ جُمْلَةٍ بِالعَرَبِيَّةِ الفُصْحَى؟', emoji: '🌟', imagePath: 'assets/images/owl_mascot.png', color: Color(0xFFF59E0B), options: ['الولد راح بدري', 'ذَهَبَ الطِّفْلُ مُبَكِّراً 🌟', 'أيمتى رح نلعب؟'], correctIndex: 1),
  ];

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      _storySegmentTimer?.cancel();
      if (mounted) setState(() => _isPlaying = false);
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
    if (page.startSec > 0) await _player.seek(Duration(seconds: page.startSec));
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _owlBounce = false);
    });
    _storySegmentTimer = Timer(Duration(seconds: page.durationSec), () async {
      await _player.pause();
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _owlBubble = 'انْتَهَتْ هَذِهِ الصَّفْحَةُ! اضْغَطْ عَلَى «الصَّفْحَةُ التَّالِيَةُ»!';
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
    } catch (_) {
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
    await _player.play(AssetSource('audio/$fileName'));
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _owlBounce = false);
    });
  }

  Future<void> _toggleStopPlay() async {
    _storySegmentTimer?.cancel();
    if (_isPlaying) {
      await _player.stop();
      setState(() => _isPlaying = false);
    } else if (_screenIndex == 2 && _selectedBookIndex != -1) {
      await _playStoryPageAudio(_books[_selectedBookIndex], _currentPageIndex);
    } else {
      await _playMedia(_currentTrack, _owlBubble, 0);
    }
  }

  Widget _buildNativeVideoPlayerBox({required Color borderColor, required VoidCallback onRetry}) {
    if (_isVideoLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(strokeWidth: 5, color: Colors.white),
            SizedBox(height: 12),
            Text('جَارِي تَجْهِيزُ الفِيدْيُو الآمِنِ...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          ],
        ),
      );
    }
    if (_videoError != null || _videoController == null || !_videoController!.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_videoError ?? 'اضْغَطْ لِتَشْغِيلِ الفِيدْيُو', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            const SizedBox(height: 10),
            FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('إِعَادَةُ المُحَاوَلَةِ')),
          ],
        ),
      );
    }
    final VideoPlayerController ctrl = _videoController!;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Center(child: AspectRatio(aspectRatio: ctrl.value.aspectRatio, child: VideoPlayer(ctrl))),
        Positioned(
          top: 8,
          left: 8,
          child: Material(
            color: Colors.black.withAlpha(170),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setState(() => _isVideoExpanded = !_isVideoExpanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_isVideoExpanded ? Icons.view_sidebar_rounded : Icons.fullscreen_rounded, color: Colors.white, size: 22),
                    const SizedBox(width: 6),
                    Text(_isVideoExpanded ? 'إِظْهَارُ قَائِمَةِ السُّوَرِ' : 'تَكْبِيرُ الشَّاشَةِ ⛶', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.black54,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              IconButton(
                color: Colors.white,
                icon: Icon(ctrl.value.isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded, size: 32),
                onPressed: () => setState(() => ctrl.value.isPlaying ? ctrl.pause() : ctrl.play()),
              ),
              Expanded(
                child: VideoProgressIndicator(
                  ctrl,
                  allowScrubbing: true,
                  colors: VideoProgressColors(playedColor: borderColor, bufferedColor: Colors.white54, backgroundColor: Colors.white24),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/forest_bg.png', fit: BoxFit.cover),
          Container(color: Colors.black.withAlpha(35)),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(child: _buildCurrentStage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          if (_screenIndex != 0)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () async {
                  _storySegmentTimer?.cancel();
                  await _player.stop();
                  await _videoController?.pause();
                  setState(() {
                    _isPlaying = false;
                    _isVideoExpanded = false;
                    _selectedSongIndex = -1;
                    _selectedBookIndex = -1;
                    _selectedQuizIndex = -1;
                    _screenIndex = 0;
                    _owlBubble = 'أَهْلاً بِكَ فِي عَالَمِ فَصِيحٍ! اخْتَرْ أَيَّ أَيْقُونَةٍ دَائِرِيَّةٍ!';
                  });
                },
                icon: const Icon(Icons.home_rounded, size: 24),
                label: const Text('الرَّئِيسِيَّةُ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          if (_screenIndex != 0)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () async {
                  if (_canGoBackOneStep) {
                    await _handleBackOneStep();
                  } else {
                    _storySegmentTimer?.cancel();
                    await _player.stop();
                    await _videoController?.pause();
                    setState(() {
                      _isPlaying = false;
                      _screenIndex = 0;
                    });
                  }
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 24),
                label: const Text('رُجُوعٌ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          GestureDetector(
            onTap: _toggleStopPlay,
            child: AnimatedScale(
              scale: _owlBounce ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFBBF24), width: 3.5), color: Colors.white),
                child: ClipOval(child: Image.asset('assets/images/owl_mascot.png', width: 52, height: 52, fit: BoxFit.cover)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: Colors.white.withAlpha(242), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFF38BDF8), width: 2.5)),
              child: Text(_owlBubble, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: _isPlaying ? const Color(0xFFEF4444) : const Color(0xFF10B981), padding: const EdgeInsets.all(10)),
            onPressed: _toggleStopPlay,
            icon: Icon(_isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded, size: 26),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFD97706)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 2.5),
            ),
            child: Row(
              children: [
                const Text('⭐ ', style: TextStyle(fontSize: 19)),
                Text('$_stars', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStage() {
    if (_screenIndex == 1) return _selectedSongIndex == -1 ? _buildSongsCircleHub() : _buildSingleSongPlayer(_songs[_selectedSongIndex]);
    if (_screenIndex == 2) return _selectedBookIndex == -1 ? _buildBooksCircleHub() : _buildOpenBookViewer(_books[_selectedBookIndex]);
    if (_screenIndex == 3) return _selectedQuizIndex == -1 ? _buildGamesCircleHub() : _buildSingleGameStage(_quizzes[_selectedQuizIndex]);
    if (_screenIndex == 4) {
      return _buildVideoWithSidebarStage(
        sectionTitle: '📖 تَفْسِيرُ القُرْآنِ الكَرِيمِ',
        headerColor: const Color(0xFF059669),
        items: _tafsirVideos,
        selectedIndex: _selectedTafsirIndex,
        onSelect: (int idx) {
          setState(() {
            _selectedTafsirIndex = idx;
            _stars += 3;
            _owlBubble = 'تُشَاهِدُ الآنَ تَفْسِيرَ: ${_tafsirVideos[idx].arabicTitle}';
          });
          _playDirectNativeVideo(_tafsirVideos[idx].videoId);
        },
      );
    }
    if (_screenIndex == 5) {
      return _buildVideoWithSidebarStage(
        sectionTitle: '🎧 سُوَرُ تِلَاوَةِ القُرْآنِ',
        headerColor: const Color(0xFF0284C7),
        items: _recitationVideos,
        selectedIndex: _selectedRecitationIndex,
        onSelect: (int idx) {
          setState(() {
            _selectedRecitationIndex = idx;
            _stars += 3;
            _owlBubble = 'تَسْتَمِعُ الآنَ إِلَى تِلَاوَةِ: ${_recitationVideos[idx].arabicTitle}';
          });
          _playDirectNativeVideo(_recitationVideos[idx].videoId);
        },
      );
    }
    return _buildMainLobby();
  }

  Widget _buildMainLobby() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircularIconPortal(
              label: '🎵 الأَنَاشِيدُ',
              subLabel: 'Arabic Songs',
              imagePath: 'assets/images/card_songs.png',
              ringColor: const Color(0xFFEC4899),
              badgeBg: const Color(0xFFFDF2F8),
              onTap: () {
                setState(() {
                  _screenIndex = 1;
                  _selectedSongIndex = -1;
                });
                _playMedia('song_alphabet.mp3', 'اخْتَرْ أُنْشُودَةً مِنَ الأَيْقُونَاتِ الدَّائِرِيَّةِ!', 2);
              },
            ),
            const SizedBox(width: 14),
            _buildCircularIconPortal(
              label: '📖 القِصَصُ',
              subLabel: 'Interactive Stories',
              imagePath: 'assets/images/card_stories.png',
              ringColor: const Color(0xFF8B5CF6),
              badgeBg: const Color(0xFFF5F3FF),
              onTap: () {
                setState(() {
                  _screenIndex = 2;
                  _selectedBookIndex = -1;
                });
                _playMedia('story_rabbit.mp3', 'اخْتَرْ قِصَّةً مِنَ المَكْتَبَةِ لِتَفْتَحَ صَفَحَاتِهَا الكَبِيرَةَ!', 2);
              },
            ),
            const SizedBox(width: 14),
            _buildCircularIconPortal(
              label: '🎮 الأَلْعَابُ',
              subLabel: 'Fun Challenges',
              imagePath: 'assets/images/owl_mascot.png',
              ringColor: const Color(0xFFF59E0B),
              badgeBg: const Color(0xFFFFFBEB),
              onTap: () => setState(() {
                _screenIndex = 3;
                _selectedQuizIndex = -1;
                _owlBubble = 'اخْتَرْ لُعْبَةً مِنَ التَّحَدِّيَاتِ الثَّلَاثَةِ لِتَرْبَحَ النُّجُومَ!';
              }),
            ),
            const SizedBox(width: 14),
            _buildCircularIconPortal(
              label: '🕌 تَفْسِيرُ القُرْآنِ',
              subLabel: 'Tafsir in English',
              imagePath: 'assets/images/card_stories.png',
              ringColor: const Color(0xFF059669),
              badgeBg: const Color(0xFFECFDF5),
              onTap: () async {
                await _player.stop();
                final VideoSurahItem first = _tafsirVideos[_selectedTafsirIndex];
                setState(() {
                  _isPlaying = false;
                  _isVideoExpanded = false;
                  _screenIndex = 4;
                  _owlBubble = 'تَفْسِيرُ القُرْآنِ الكَرِيمِ بِاللُّغَةِ الإِنْجِلِيزِيَّةِ! اخْتَرِ السُّورَةَ لِلْمُشَاهَدَةِ!';
                  _stars += 5;
                });
                _playDirectNativeVideo(first.videoId);
              },
            ),
            const SizedBox(width: 14),
            _buildCircularIconPortal(
              label: '🎧 تِلَاوَةُ القُرْآنِ',
              subLabel: 'Quran Recitation',
              imagePath: 'assets/images/card_songs.png',
              ringColor: const Color(0xFF0284C7),
              badgeBg: const Color(0xFFF0F9FF),
              onTap: () async {
                await _player.stop();
                final VideoSurahItem first = _recitationVideos[_selectedRecitationIndex];
                setState(() {
                  _isPlaying = false;
                  _isVideoExpanded = false;
                  _screenIndex = 5;
                  _owlBubble = 'اسْتَمِعْ وَرَدِّدْ تِلَاوَةَ القُرْآنِ الكَرِيمِ! اخْتَرِ السُّورَةَ مِنَ القَائِمَةِ!';
                  _stars += 5;
                });
                _playDirectNativeVideo(first.videoId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIconPortal({
    required String label,
    required String subLabel,
    required String imagePath,
    required Color ringColor,
    required Color badgeBg,
    required VoidCallback onTap,
    double circleSize = 132,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: ringColor, width: 5),
              boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 6))],
            ),
            child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.cover)),
          ),
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: ringColor, width: 3),
              boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: Column(
              children: [
                Text(label, style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: ringColor)),
                Text(subLabel, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongsCircleHub() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_songs.length, (int i) {
          final SongItem s = _songs[i];
          return _buildCircularIconPortal(
            circleSize: 155,
            label: '${s.emoji} ${s.title}',
            subLabel: s.englishTitle,
            imagePath: s.imagePath,
            ringColor: s.color,
            badgeBg: Colors.white,
            onTap: () {
              setState(() => _selectedSongIndex = i);
              _playMedia(s.audioFile, s.subtitle, 5);
            },
          );
        }),
      ),
    );
  }

  Widget _buildSingleSongPlayer(SongItem s) {
    final bool active = _currentTrack == s.audioFile && _isPlaying;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white.withAlpha(248), borderRadius: BorderRadius.circular(32), border: Border.all(color: s.color, width: 5)),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: s.color, width: 5), color: Colors.white),
                    child: ClipOval(child: Image.asset(s.imagePath, fit: BoxFit.cover)),
                  ),
                  const SizedBox(height: 12),
                  Text('${s.emoji} ${s.title}', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: s.color)),
                  Text(s.englishTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(24), border: Border.all(color: s.color.withAlpha(100), width: 2.5)),
                    child: Text(s.lyrics, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, height: 1.8, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: active ? const Color(0xFF10B981) : s.color, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                    onPressed: () => _playMedia(s.audioFile, s.subtitle, 5),
                    icon: Icon(active ? Icons.graphic_eq_rounded : Icons.play_arrow_rounded, size: 30),
                    label: Text(active ? 'الأُنْشُودَةُ تَعْمَلُ الآنَ 🎵' : 'شَغِّلِ الأُنْشُودَةَ 🔊', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksCircleHub() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_books.length, (int i) {
          final StoryBookItem book = _books[i];
          return _buildCircularIconPortal(
            circleSize: 165,
            label: '📖 ${book.title}',
            subLabel: book.englishTitle,
            imagePath: book.imagePath,
            ringColor: book.color,
            badgeBg: Colors.white,
            onTap: () {
              setState(() {
                _selectedBookIndex = i;
                _currentPageIndex = 0;
              });
              _playStoryPageAudio(book, 0);
            },
          );
        }),
      ),
    );
  }

  Widget _buildOpenBookViewer(StoryBookItem book) {
    final StoryPageData page = book.pages[_currentPageIndex];
    final bool isFirstPage = _currentPageIndex == 0;
    final bool isLastPage = _currentPageIndex == book.pages.length - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFFFFFDF7), borderRadius: BorderRadius.circular(32), border: Border.all(color: book.color, width: 5)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(color: book.color, borderRadius: const BorderRadius.vertical(top: Radius.circular(26))),
              child: Row(
                children: [
                  const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 26),
                  const SizedBox(width: 10),
                  Expanded(child: Text(book.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withAlpha(50), borderRadius: BorderRadius.circular(16)),
                    child: Text('صَفْحَةُ ${_currentPageIndex + 1} مِنْ ${book.pages.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: page.bgTint, borderRadius: BorderRadius.circular(24), border: Border.all(color: book.color.withAlpha(110), width: 3)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(borderRadius: BorderRadius.circular(21), child: Opacity(opacity: 0.35, child: Image.asset(book.imagePath, fit: BoxFit.cover))),
                          Center(child: Text(page.emoji, style: const TextStyle(fontSize: 64))),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 3, margin: const EdgeInsets.symmetric(vertical: 16), color: book.color.withAlpha(60)),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Center(child: SingleChildScrollView(child: Text(page.text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 27, height: 1.7, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))))),
                          if (isLastPage)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF59E0B), width: 2)),
                              child: Text('🌟 ${book.moral}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: isFirstPage ? Colors.grey.shade300 : const Color(0xFF0284C7), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
                    onPressed: isFirstPage
                        ? null
                        : () {
                            final int prev = _currentPageIndex - 1;
                            setState(() => _currentPageIndex = prev);
                            _playStoryPageAudio(book, prev);
                          },
                    icon: const Icon(Icons.arrow_back_rounded, size: 28),
                    label: const Text('الصَّفْحَةُ السَّابِقَةُ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
                    onPressed: () => _playStoryPageAudio(book, _currentPageIndex),
                    icon: Icon(_isPlaying ? Icons.graphic_eq_rounded : Icons.volume_up_rounded, size: 26),
                    label: Text(_isPlaying ? 'يَقْرَأُ هَذِهِ الصَّفْحَةَ...' : 'إِعَادَةُ قِرَاءَةِ الصَّفْحَةِ 🔊', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: isLastPage ? const Color(0xFF10B981) : const Color(0xFFF59E0B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
                    onPressed: () {
                      if (!isLastPage) {
                        final int next = _currentPageIndex + 1;
                        setState(() => _currentPageIndex = next);
                        _playStoryPageAudio(book, next);
                      } else {
                        _storySegmentTimer?.cancel();
                        _playMedia('bravo.mp3', 'أَحْسَنْتَ! أَنْهَيْتَ قِرَاءَةَ القِصَّةِ بِبَرَاعَةٍ! +10 نُجُومٍ!', 10);
                        setState(() => _selectedBookIndex = -1);
                      }
                    },
                    icon: Icon(isLastPage ? Icons.star_rounded : Icons.arrow_forward_rounded, size: 28),
                    label: Text(isLastPage ? 'أَنْهَيْتُ القِصَّةَ (+10 ⭐)' : 'الصَّفْحَةُ التَّالِيَةُ', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamesCircleHub() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_quizzes.length, (int i) {
          final QuizItem q = _quizzes[i];
          return _buildCircularIconPortal(
            circleSize: 155,
            label: '${q.emoji} ${q.categoryTitle}',
            subLabel: q.englishTitle,
            imagePath: q.imagePath,
            ringColor: q.color,
            badgeBg: Colors.white,
            onTap: () => setState(() {
              _selectedQuizIndex = i;
              _owlBubble = 'أَجِبْ عَنِ السُّؤَالِ التَّالِي لِتَرْبَحَ 10 نُجُومٍ ذَهَبِيَّةٍ!';
            }),
          );
        }),
      ),
    );
  }

  Widget _buildSingleGameStage(QuizItem q) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 18),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(color: Colors.white.withAlpha(248), borderRadius: BorderRadius.circular(32), border: Border.all(color: q.color, width: 5)),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(q.emoji, style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 10),
                  Text(q.categoryTitle, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: q.color)),
                  Text(q.englishTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  const SizedBox(height: 14),
                  Text(q.question, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF0F172A))),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(q.options.length, (int optIdx) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE0F2FE), foregroundColor: const Color(0xFF0369A1), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
                        onPressed: () {
                          if (optIdx == q.correctIndex) {
                            _playMedia('bravo.mp3', 'أَحْسَنْتَ يَا بَطَلَ الفُصْحَى! +10 نُجُومٍ!', 10);
                          } else {
                            _playMedia('try_again.mp3', 'لَا بَأْسَ يَا صَدِيقِي! حَاوِلْ مَرَّةً أُخْرَى!', 0);
                          }
                        },
                        child: Text(q.options[optIdx], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoWithSidebarStage({
    required String sectionTitle,
    required Color headerColor,
    required List<VideoSurahItem> items,
    required int selectedIndex,
    required ValueChanged<int> onSelect,
  }) {
    final VideoSurahItem activeItem = items[selectedIndex];
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 10),
      child: Row(
        children: [
          Expanded(
            flex: 72,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withAlpha(245), borderRadius: BorderRadius.circular(24), border: Border.all(color: activeItem.color, width: 4)),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: Colors.black,
                        child: _buildNativeVideoPlayerBox(borderColor: activeItem.color, onRetry: () => _playDirectNativeVideo(activeItem.videoId)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(activeItem.arabicTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: activeItem.color)),
                      Text(activeItem.subtitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!_isVideoExpanded) const SizedBox(width: 10),
          if (!_isVideoExpanded)
            Expanded(
              flex: 28,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withAlpha(238), borderRadius: BorderRadius.circular(24), border: Border.all(color: headerColor, width: 3.5)),
                child: Column(
                  children: [
                    Text(sectionTitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: headerColor)),
                    const Divider(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (_, int index) {
                          final VideoSurahItem surah = items[index];
                          final bool isSelected = index == selectedIndex;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Material(
                              color: isSelected ? surah.color : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => onSelect(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                  child: Row(
                                    children: [
                                      Icon(isSelected ? Icons.play_circle_filled_rounded : Icons.play_circle_outline_rounded, color: isSelected ? Colors.white : surah.color, size: 24),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(surah.arabicTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? Colors.white : const Color(0xFF0F172A))),
                                            Text(surah.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? const Color(0xFFFEF08A) : const Color(0xFF475569))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
}
