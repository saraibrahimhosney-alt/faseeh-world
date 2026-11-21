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
  final String pageTitle, text, mainActor, actor2, actor3, skyElement;
  final List<Color> skyGradient;
  final Color hillColor;
  const StoryPageData({
    required this.pageTitle,
    required this.text,
    required this.mainActor,
    required this.actor2,
    required this.actor3,
    required this.skyElement,
    required this.skyGradient,
    required this.hillColor,
  });
}

class StoryBookItem {
  final String title, englishTitle, moral, imagePath;
  final Color color;
  final bool isOwlStory;
  final List<StoryPageData> pages;
  const StoryBookItem({
    required this.title,
    required this.englishTitle,
    required this.moral,
    required this.imagePath,
    required this.color,
    required this.isOwlStory,
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

class _FaseehWorldStageState extends State<FaseehWorldStage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _ambiencePlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final YoutubeExplode _yt = YoutubeExplode();
  VideoPlayerController? _videoController;
  late final AnimationController _natureAnimCtrl;

  bool _isVideoLoading = false;
  String? _videoError;
  bool _isVideoExpanded = false;
  bool _natureSoundEnabled = true;

  int _screenIndex = 0;
  int _stars = 30;
  bool _isPlaying = false;
  bool _owlBounce = false;
  String _currentTrack = 'bravo.mp3';
  String _owlBubble = 'أَهْلاً بِكَ يَا صَدِيقِي! اخْتَرْ أَيَّ أَيْقُونَةٍ دَائِرِيَّةٍ لِنَبْدَأَ!';

  int _selectedSongIndex = -1;
  int _selectedBookIndex = -1;
  int _currentPageIndex = 0;
  double _storyFontSize = 23.0;
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
      lyrics: 'أَلِفٌ أَرْنَبٌ، يَجْرِي يَلْعَبُ، يَأْكُلُ جَزَراً كَيْ لَا يَتْعَبَ!\nبَاءٌ بَطَّةٌ، نَطَّتْ نَطَّةً، وَقَعَتْ ضَحِكَتْ مِنْهَا القِطَّةُ!\nتَاءٌ تَاجٌ، فَوْقَ الرَّأْسِ، فِيهِ الذَّهَبُ وَفِيهِ المَاسُ!',
      audioFile: 'song_alphabet.mp3',
      imagePath: 'assets/images/card_songs.png',
      color: Color(0xFFEC4899),
      emoji: '🐰',
    ),
    SongItem(
      title: 'أُنْشُودَةُ الصَّبَاحِ',
      englishTitle: 'Morning Sun Song',
      subtitle: 'أَشْرَقَتِ الشَّمْسُ الذَّهَبِيَّةُ!',
      lyrics: 'أَشْرَقَتِ الشَّمْسُ الذَّهَبِيَّةُ، وَتَغَنَّتْ طَيْرُ الحُرِّيَّةِ!\nهَيَّا نَتَعَلَّمْ يَا أَطْفَالُ، لُغَتِي الفُصْحَى أَجْمَلُ حَالٍ!\nنَقْرَأُ، نَكْتُبُ، نَرْسُمُ فِيهَا، وَنُحِبُّ العِلْمَ وَنَحْمِيهَا!',
      audioFile: 'song_morning.mp3',
      imagePath: 'assets/images/owl_mascot.png',
      color: Color(0xFFF59E0B),
      emoji: '☀️',
    ),
    SongItem(
      title: 'أُنْشُودَةُ الأَرْقَامِ',
      englishTitle: 'Numbers Song',
      subtitle: 'وَاحِدٌ اثْنَانِ ثَلَاثَةٌ!',
      lyrics: 'وَاحِدٌ اثْنَانِ ثَلَاثَةٌ، نَتَعَلَّمُ بِذَكَاءٍ وَحَمَاسَةٍ!\nأَرْبَعَةٌ خَمْسَةٌ سِتَّةٌ، نَقْرَأُ فِي البُسْتَانِ القِصَّةَ!\nسَبْعَةٌ ثَمَانِيَةٌ تِسْعَةٌ عَشَرَةٌ، أَرْقَامِي الفُصْحَى مُبْتَهِجَةٌ!',
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
      moral: 'الحِكْمَةُ: بِالتَّعَاوُنِ وَالكَلِمَةِ الطَّيِّبَةِ نُنْجِزُ أَصْعَبَ المَهَامِّ، وَالفَرَحُ يَكْبُرُ عِنْدَمَا نَتَقَاسَمُهُ مَعَ الأَصْدِقَاءِ!',
      imagePath: 'assets/images/card_stories.png',
      color: Color(0xFF059669),
      isOwlStory: false,
      pages: [
        StoryPageData(
          pageTitle: 'الصَّبَاحُ المُشْرِقُ فِي الغَابَةِ',
          text: 'فِي صَبَاحٍ رَبِيعِيٍّ مُشْرِقٍ، تَسَلَّلَتْ أَشِعَّةُ الشَّمْسِ الذَّهَبِيَّةُ بَيْنَ أَغْصَانِ الأَشْجَارِ العَالِيَةِ، وَغَرَّدَتِ العَصَافِيرُ بِأَعْذَبِ الأَلْحَانِ.\nاسْتَيْقَظَ الأَرْنَبُ الصَّغِيرُ «فَصِيحٌ» نَشِيطاً، وَقَفَزَ بَيْنَ الأَشْجَارِ الخَضْرَاءِ لِيَبْحَثَ عَنْ فُطُورٍ لَذِيذٍ يَمْنَحُهُ الطَّاقَةَ وَالقُوَّةَ.',
          mainActor: '🐰',
          actor2: '🦋',
          actor3: '🌼',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFBAE6FD), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF4ADE80),
        ),
        StoryPageData(
          pageTitle: 'المُفَاجَأَةُ الكَبِيرَةُ فِي الحَقْلِ',
          text: 'سَارَ «فَصِيحٌ» بَيْنَ الأَزْهَارِ المُلَوَّنَةِ وَالفَرَاشَاتِ الرَّاقِصَةِ حَتَّى وَصَلَ إِلَى حَقْلٍ وَاسِعٍ أَخْضَرَ.\nوَفَجْأَةً، لَمَحَ أَوْرَاقاً خَضْرَاءَ كَثِيفَةً تَخْرُجُ مِنَ الأَرْضِ، وَتَحْتَهَا جَزَرَةٌ عِمْلَاقَةٌ تَلْمَعُ كَأَنَّهَا قِطْعَةٌ مِنَ الذَّهَبِ الخَالِصِ!',
          mainActor: '🥕',
          actor2: '🐰',
          actor3: '✨',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'المُحَاوَلَةُ الأُولَى',
          text: 'فَرِحَ «فَصِيحٌ» فَرَحاً شَدِيداً، وَأَمْسَكَ بِأَوْرَاقِ الجَزَرَةِ بِكِلْتَا يَدَيْهِ الصَّغِيرَتَيْنِ، وَبَدَأَ يَشُدُّ بِكُلِّ قُوَّتِهِ: «وَاحِدٌ.. اثْنَانِ.. ثَلَاثَةٌ!».\nلَكِنَّ الجَزَرَةَ الكَبِيرَةَ كَانَتْ مَغْرُوسَةً بِعُمْقٍ فِي التُّرْبَةِ، فَلَمْ تَتَحَرَّكْ مِنْ مَكَانِهَا قَيْدَ أُنْمُلَةٍ!',
          mainActor: '🐰',
          actor2: '🥕',
          actor3: '💦',
          skyElement: '⛅',
          skyGradient: [Color(0xFF93C5FD), Color(0xFFE0F2FE), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'طَلَبُ المُسَاعَدَةِ بِأَدَبٍ',
          text: 'فَكَّرَ «فَصِيحٌ» قَلِيلاً ثُمَّ قَالَ: «يَدٌ وَاحِدَةٌ لَا تُصَفِّقُ، سَأَطْلُبُ المُسَاعَدَةَ مِنْ أَصْدِقَائِي».\nرَأَى السِّنْجَابَ السَّرِيعَ يَقْفِزُ فَوْقَ الشَّجَرَةِ، فَنَادَاهُ بِابْتِسَامَةٍ لَطِيفَةٍ: «هَلْ يُمْكِنُكَ أَنْ تُسَاعِدَنِي فِي إِخْرَاجِ هَذِهِ الجَزَرَةِ الكَبِيرَةِ؟». فَرَحَّبَ السِّنْجَابُ بِسُرُورٍ.',
          mainActor: '🐿️',
          actor2: '🐰',
          actor3: '🌰',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFDE68A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'انْضِمَامُ السُّلَحْفَاةِ الحَكِيمَةِ',
          text: 'أَمْسَكَ الأَرْنَبُ بِالجَزَرَةِ، وَأَمْسَكَ السِّنْجَابُ بِالأَرْنَبِ، وَشَدَّا مَعاً بِحَمَاسٍ، فَتَحَرَّكَتِ الجَزَرَةُ قَلِيلاً لَكِنَّهَا بَقِيَتْ عَالِقَةً!\nمَرَّتْ السُّلَحْفَاةُ الطَّيِّبَةُ فَقَالَتْ: «أَنَا مَعَكُمَا يَا أَصْدِقَائِي، فَبِالتَّعَاوُنِ يَصِيرُ الصَّعْبُ سَهْلاً!».',
          mainActor: '🐢',
          actor2: '🐿️',
          actor3: '🐰',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF67E8F9), Color(0xFFCCFBF1), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF10B981),
        ),
        StoryPageData(
          pageTitle: 'مُسَاعَدَةُ القُنْفُذِ الصَّغِيرِ',
          text: 'شَاهَدَ القُنْفُذُ الصَّغِيرُ مَا يَحْدُثُ فَأَسْرَعَ إِلَيْهِمْ قَائِلاً: «سَأَحْفِرُ التُّرْبَةَ حَوْلَ الجَزَرَةِ بِأَظَافِرِي الصَّغِيرَةِ حَتَّى تَلِينَ الأَرْضُ!».\nبَدَأَ القُنْفُذُ يُزِيحُ التُّرَابَ بِنَشَاطٍ، بَيْنَمَا اصْطَفَّ الأَصْدِقَاءُ فِي صَفٍّ وَاحِدٍ مُتَمَاسِكٍ.',
          mainActor: '🦔',
          actor2: '🐢',
          actor3: '🥕',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'لَحْظَةُ النَّجَاحِ العَظِيمَةِ',
          text: 'صَاحَ الجَمِيعُ بِصَوْتٍ وَاحِدٍ مَلِيءٍ بِالحَمَاسِ: «هَيَّا مَعاً.. وَاحِدٌ.. اثْنَانِ.. ثَلَاثَةٌ!».\nوَفِي لَحْظَةٍ رَائِعَةٍ، انْتَزَعُوا الجَزَرَةَ الذَّهَبِيَّةَ العِمْلَاقَةَ مِنَ الأَرْضِ، وَتَعَالَتْ ضَحِكَاتُهُمْ وَتَصْفِيقُهُمْ فَرَحاً بِهَذَا الإِنْجَازِ الجَمَاعِيِّ!',
          mainActor: '🎉',
          actor2: '🥕',
          actor3: '🐰',
          skyElement: '🌈',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFFDE047), Color(0xFF86EFAC)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'وَلِيمَةُ المَحَبَّةِ وَالمُشَارَكَةِ',
          text: 'غَسَلَ «فَصِيحٌ» الجَزَرَةَ بِمَاءِ الغَدِيرِ الصَّافِي، وَقَطَّعَهَا إِلَى أَرْبَعِ قِطَعٍ مُتَسَاوِيَةٍ، وَقَدَّمَهَا لِأَصْدِقَائِهِ قَائِلاً: «هَذِهِ ثَمَرَةُ تَعَاوُنِنَا جَمِيعاً، تَفَضَّلُوا يَا أَحْبَابِي!».\nأَكَلَ الأَصْدِقَاءُ مَعاً فِي سَعَادَةٍ، وَتَعَلَّمُوا أَنَّ التَّعَاوُنَ أَجْمَلُ كَنْزٍ فِي الحَيَاةِ.',
          mainActor: '🐰',
          actor2: '🐿️',
          actor3: '❤️',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFBCFE8), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
      ],
    ),
    StoryBookItem(
      title: 'البُومُ الحَكِيمُ وَالبُلْبُلُ',
      englishTitle: 'The Wise Owl & Nightingale',
      moral: 'الحِكْمَةُ: الثِّقَةُ بِالنَّفْسِ وَالمُحَاوَلَةُ المُسْتَمِرَّةُ تَصْنَعُ الإِبْدَاعَ، وَالمُثَابَرَةُ تَجْعَلُ المَوْهِبَةَ تُزْهِرُ وَتُفْرِحُ الجَمِيعَ!',
      imagePath: 'assets/images/owl_mascot.png',
      color: Color(0xFF7C3AED),
      isOwlStory: true,
      pages: [
        StoryPageData(
          pageTitle: 'البُلْبُلُ الصَّغِيرُ فِي الغَابَةِ',
          text: 'فِي غَابَةٍ خَضْرَاءَ مُضِيئَةٍ تَمْلَؤُهَا الأَشْجَارُ البَاسِقَةُ وَالأَزْهَارُ الفَوَّاحَةُ، عَاشَ بُلْبُلٌ صَغِيرٌ جَمِيلُ الرِّيشِ يُدْعَى «شَادِي».\nكَانَ «شَادِي» يَمْلِكُ صَوْتاً عَذْباً رَقِيقاً، لَكِنَّهُ كَانَ شَدِيدَ الخَجَلِ، فَيَجْلِسُ وَحِيداً فَوْقَ غُصْنٍ عَالٍ بَعِيداً عَنْ بَقِيَّةِ الطُّيُورِ.',
          mainActor: '🐦',
          actor2: '🌸',
          actor3: '🦋',
          skyElement: '☀️',
          skyGradient: [Color(0xFF93C5FD), Color(0xFFE9D5FF), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'حَفْلُ الغَابَةِ السَّنَوِيُّ',
          text: 'فِي أَحَدِ الأَيَّامِ، أَعْلَنَ الهُدْهُدُ النَّشِيطُ فِي أَرْجَاءِ الغَابَةِ: «يَا طُيُورَ الغَابَةِ الكِرَامَ، غَداً سَيُقَامُ مِهْرَجَانُ التَّغْرِيدِ الجَمِيلِ عِنْدَ النَّبْعِ الكَبِيرِ!».\nفَرِحَتِ العَصَافِيرُ وَالحَمَامُ، وَبَدَأَ كُلُّ طَائِرٍ يَسْتَعِدُّ لِيُقَدِّمَ أَجْمَلَ مَا عِنْدَهُ أَمَامَ سُكَّانِ الغَابَةِ.',
          mainActor: '🕊️',
          actor2: '🐦',
          actor3: '🎊',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'حَيْرَةُ البُلْبُلِ وَخَوْفُهُ',
          text: 'تَمَنَّى «شَادِي» مِنْ كُلِّ قَلْبِهِ أَنْ يُشَارِكَ فِي المِهْرَجَانِ، لَكِنَّهُ هَمَسَ لِنَفْسِهِ بِحُزْنٍ: «مَاذَا لَوْ أَخْطَأْتُ فِي اللَّحْنِ؟ وَمَاذَا لَوْ ضَحِكَتْ مِنِّي الطُّيُورُ؟».\nأَطْرَقَ البُلْبُلُ الصَّغِيرُ رَأْسَهُ وَبَقِيَ صَامِتاً فَوْقَ الشَّجَرَةِ لَا يُغَرِّدُ كَعَادَتِهِ.',
          mainActor: '🐦',
          actor2: '💧',
          actor3: '🍃',
          skyElement: '⛅',
          skyGradient: [Color(0xFFCBD5E1), Color(0xFFE0F2FE), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF15803D),
        ),
        StoryPageData(
          pageTitle: 'زِيَارَةُ البُومِ الحَكِيمِ «فَصِيحٍ»',
          text: 'لَاحَظَ البُومُ الحَكِيمُ «فَصِيحٌ» حُزْنَ البُلْبُلِ الصَّغِيرِ، فَطَارَ بِهُدُوءٍ وَحَطَّ بِجَانِبِهِ عَلَى الغُصْنِ وَسَأَلَهُ بِلُطْفٍ: «لِمَاذَا أَرَاكَ حَزِيناً يَا بُنَيَّ، وَالغَابَةُ كُلُّهَا تَسْتَعِدُّ لِلْفَرَحِ؟».\nأَخْبَرَهُ «شَادِي» بِخَوْفِهِ مِنَ الخَطَأِ أَمَامَ الآخَرِينَ.',
          mainActor: '🦉',
          actor2: '🐦',
          actor3: '💬',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF93C5FD), Color(0xFFFEF3C7), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'دَرْسٌ فِي الثِّقَةِ بِالنَّفْسِ',
          text: 'ابْتَسَمَ «فَصِيحٌ» ابْتِسَامَةً دَافِئَةً وَقَالَ: «يَا صَدِيقِي الصَّغِيرَ، كُلُّ مَنْ تَرَاهُمْ يُغَرِّدُونَ بِبَرَاعَةٍ بَدَؤُوا بِمُحَاوَلَةٍ صَغِيرَةٍ! الخَطَأُ لَيْسَ عَيْباً، بَلْ هُوَ خُطْوَةٌ نَحْوَ الإِتْقَانِ. ثِقْ بِمَوْهِبَتِكَ الَّتِي وَهَبَهَا اللهُ لَكَ!».\nفَامْتَلَأَ قَلْبُ «شَادِي» بِالأَمَلِ.',
          mainActor: '🦉',
          actor2: '💛',
          actor3: '✨',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFDE68A), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF10B981),
        ),
        StoryPageData(
          pageTitle: 'التَّدْرِيبُ وَالمُثَابَرَةُ',
          text: 'قَالَ «فَصِيحٌ»: «هَيَّا نَتَدَرَّبُ مَعاً الآنَ هُنَا بَيْنَ الأَشْجَارِ!».\nأَغْمَضَ «شَادِي» عَيْنَيْهِ، وَأَخَذَ نَفَساً عَمِيقاً، ثُمَّ أَطْلَقَ نَغْمَةً صَغِيرَةً، فَشَجَّعَهُ «فَصِيحٌ»: «أَحْسَنْتَ! أَكْمِلْ يَا بَطَلُ!».\nتَدَرَّبَ البُلْبُلُ مَرَّةً بَعْدَ مَرَّةٍ حَتَّى أَصْبَحَ صَوْتُهُ قَوِيّاً وَعَذْباً.',
          mainActor: '🎵',
          actor2: '🐦',
          actor3: '🦉',
          skyElement: '☀️',
          skyGradient: [Color(0xFF60A5FA), Color(0xFFE9D5FF), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'يَوْمُ المِهْرَجَانِ الكَبِيرُ',
          text: 'فِي صَبَاحِ اليَوْمِ التَّالِي، اجْتَمَعَتْ طُيُورُ الغَابَةِ وَالأَرَانِبُ حَوْلَ النَّبْعِ الكَبِيرِ.\nوَقَفَ «شَادِي» عَلَى المِنَصَّةِ الخَشَبِيَّةِ، وَنَظَرَ إِلَى صَدِيقِهِ «فَصِيحٍ» الَّذِي أَوْمَأَ لَهُ مُشَجِّعاً، ثُمَّ انْطَلَقَ البُلْبُلُ يُغَرِّدُ بِأَعْذَبِ الأَلْحَانِ الفَصِيحَةِ!',
          mainActor: '🎶',
          actor2: '🐦',
          actor3: '🐰',
          skyElement: '🌈',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFFDE047), Color(0xFF86EFAC)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'التَّصْفِيقُ وَالفَرَحُ الجَمَاعِيُّ',
          text: 'مَا إِنْ أَنْهَى «شَادِي» أُنْشُودَتَهُ الرَّائِعَةَ حَتَّى ضَجَّتِ الغَابَةُ بِالتَّصْفِيقِ الحَارِّ وَالهُتَافِ: «أَحْسَنْتَ يَا شَادِي! مَا أَجْمَلَ صَوْتَكَ!».\nشَكَرَ البُلْبُلُ السَّعِيدُ البُومَ الحَكِيمَ «فَصِيحاً» عَلَى تَشْجِيعِهِ، وَأَدْرَكَ أَنَّ الشَّجَاعَةَ تَفْتَحُ أَبْوَابَ النَّجَاحِ.',
          mainActor: '👏',
          actor2: '🐦',
          actor3: '🦉',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFBCFE8), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
      ],
    ),
  ];

  final List<QuizItem> _quizzes = const [
    QuizItem(categoryTitle: 'تَحَدِّي المُفْرَدَاتِ', englishTitle: 'Vocabulary Challenge', question: 'مَا مَعْنَى كَلِمَةِ «غَدِيرٌ»؟', audioFile: 'welcome.mp3', emoji: '💧', imagePath: 'assets/images/card_stories.png', color: Color(0xFF0284C7), options: ['نَهْرٌ صَغِيرٌ عَذْبٌ 💧', 'جَبَلٌ كَبِيرٌ ⛰️', 'رِيَاحٌ قَوِيَّةٌ 🌪️'], correctIndex: 0),
    QuizItem(categoryTitle: 'تَحَدِّي الأَصْوَاتِ', englishTitle: 'Nature Sounds Game', question: 'مَا صَوْتُ أَوْرَاقِ الشَّجَرِ؟', audioFile: 'welcome.mp3', emoji: '🍃', imagePath: 'assets/images/card_songs.png', color: Color(0xFF059669), options: ['زَئِيرٌ 🦁', 'حَفِيفٌ 🍃', 'خَرِيرٌ 🌊'], correctIndex: 1),
    QuizItem(categoryTitle: 'تَحَدِّي الفُصْحَى', englishTitle: 'Classical Arabic Quiz', question: 'أَيُّ جُمْلَةٍ بِالعَرَبِيَّةِ الفُصْحَى؟', audioFile: 'welcome.mp3', emoji: '🌟', imagePath: 'assets/images/owl_mascot.png', color: Color(0xFFF59E0B), options: ['الولد راح بدري', 'ذَهَبَ الطِّفْلُ مُبَكِّراً 🌟', 'أيمتى رح نلعب؟'], correctIndex: 1),
  ];

  @override
  void initState() {
    super.initState();
    _natureAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _natureAnimCtrl.dispose();
    _videoController?.dispose();
    _yt.close();
    _player.dispose();
    _ambiencePlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  // تشغيل صوت الطبيعة الخفيف في الخلفية أثناء قراءة القصة
  Future<void> _startNatureAmbience() async {
    if (!_natureSoundEnabled) return;
    try {
      await _ambiencePlayer.stop();
      await _ambiencePlayer.setReleaseMode(ReleaseMode.loop);
      // يحاول أولاً تشغيل ملف الطبيعة، وإن لم يوجد يشغل نغمة الصباح بصوت هادئ جداً كخلفية
      try {
        await _ambiencePlayer.play(AssetSource('audio/nature_forest.mp3'), volume: 0.35);
      } catch (_) {
        await _ambiencePlayer.play(AssetSource('audio/song_morning.mp3'), volume: 0.14);
      }
    } catch (_) {}
  }

  Future<void> _stopNatureAmbience() async {
    try {
      await _ambiencePlayer.stop();
    } catch (_) {}
  }

  // مؤثر صوتي مسموع بوضوح عند تقليب الصفحات
  Future<void> _playPageFlipSound() async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      try {
        await _sfxPlayer.play(AssetSource('audio/page_flip.mp3'), volume: 0.9);
      } catch (_) {
        // بديل صوتي فوري ومسموع في حال عدم رفع page_flip.mp3 بعد
        await _sfxPlayer.play(AssetSource('audio/welcome.mp3'), volume: 0.25);
        Future.delayed(const Duration(milliseconds: 320), () {
          _sfxPlayer.stop();
        });
      }
    } catch (_) {}
  }

  Future<void> _playAudioTrack(String fileName, String bubbleText, {int bonusStars = 0}) async {
    setState(() {
      _currentTrack = fileName;
      _owlBubble = bubbleText;
      _isPlaying = true;
      _owlBounce = true;
      _stars += bonusStars;
    });
    await _player.stop();
    await _player.setReleaseMode(ReleaseMode.stop);
    try {
      await _player.play(AssetSource('audio/$fileName'), volume: 1.0);
    } catch (_) {
      try {
        await _player.play(AssetSource(fileName), volume: 1.0);
      } catch (_) {
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      }
    }
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _owlBounce = false);
    });
  }

  bool get _canGoBackOneStep {
    if (_screenIndex == 1 && _selectedSongIndex != -1) return true;
    if (_screenIndex == 2 && _selectedBookIndex != -1) return true;
    if (_screenIndex == 3 && _selectedQuizIndex != -1) return true;
    if ((_screenIndex == 4 || _screenIndex == 5) && _isVideoExpanded) return true;
    return false;
  }

  Future<void> _handleBackOneStep() async {
    await _player.stop();
    await _stopNatureAmbience();
    setState(() {
      _isPlaying = false;
      if (_screenIndex == 1 && _selectedSongIndex != -1) {
        _selectedSongIndex = -1;
        _owlBubble = 'اخْتَرْ أُنْشُودَةً مِنَ الدَّوَائِرِ الثَّلَاثَةِ لِتَسْتَمِعَ إِلَيْهَا!';
      } else if (_screenIndex == 2 && _selectedBookIndex != -1) {
        _selectedBookIndex = -1;
        _owlBubble = 'اخْتَرْ قِصَّةً مِنَ المَكْتَبَةِ الدَّائِرِيَّةِ لِتَقْرَأَهَا!';
      } else if (_screenIndex == 3 && _selectedQuizIndex != -1) {
        _selectedQuizIndex = -1;
        _owlBubble = 'اخْتَرْ لُعْبَةً مِنَ الأَلْعَابِ الدَّائِرِيَّةِ!';
      } else if ((_screenIndex == 4 || _screenIndex == 5) && _isVideoExpanded) {
        _isVideoExpanded = false;
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

  Future<void> _toggleStopPlay() async {
    if (_screenIndex == 2 && _selectedBookIndex != -1) {
      setState(() => _natureSoundEnabled = !_natureSoundEnabled);
      if (_natureSoundEnabled) {
        await _startNatureAmbience();
      } else {
        await _stopNatureAmbience();
      }
      return;
    }
    if (_isPlaying) {
      await _player.stop();
      setState(() => _isPlaying = false);
    } else {
      await _playAudioTrack(_currentTrack, _owlBubble);
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
    final bool isReadingOpenStory = _screenIndex == 2 && _selectedBookIndex != -1;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (!isReadingOpenStory) ...[
            Image.asset('assets/images/forest_bg.png', fit: BoxFit.cover),
            Container(color: Colors.black.withAlpha(35)),
          ],
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
    final bool isReadingOpenStory = _screenIndex == 2 && _selectedBookIndex != -1;
    return Container(
      color: isReadingOpenStory ? const Color(0xFF0F172A).withAlpha(170) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          if (_screenIndex != 0)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () async {
                  await _player.stop();
                  await _stopNatureAmbience();
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
                icon: const Icon(Icons.home_rounded, size: 22),
                label: const Text('الرَّئِيسِيَّةُ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          if (_screenIndex != 0)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () async {
                  if (_canGoBackOneStep) {
                    await _handleBackOneStep();
                  } else {
                    await _player.stop();
                    await _stopNatureAmbience();
                    await _videoController?.pause();
                    setState(() {
                      _isPlaying = false;
                      _screenIndex = 0;
                    });
                  }
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 22),
                label: const Text('رُجُوعٌ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          GestureDetector(
            onTap: _toggleStopPlay,
            child: AnimatedScale(
              scale: _owlBounce ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFBBF24), width: 3), color: Colors.white),
                child: ClipOval(child: Image.asset('assets/images/owl_mascot.png', width: 46, height: 46, fit: BoxFit.cover)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(color: Colors.white.withAlpha(242), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFF38BDF8), width: 2.5)),
              child: Text(_owlBubble, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF0F172A))),
            ),
          ),
          const SizedBox(width: 8),
          if (isReadingOpenStory)
            IconButton.filled(
              tooltip: 'صَوْتُ الطَّبِيعَةِ الخَفِيفُ',
              style: IconButton.styleFrom(
                backgroundColor: _natureSoundEnabled ? const Color(0xFF10B981) : Colors.grey.shade600,
                padding: const EdgeInsets.all(9),
              ),
              onPressed: _toggleStopPlay,
              icon: Icon(_natureSoundEnabled ? Icons.forest_rounded : Icons.volume_off_rounded, size: 24),
            )
          else
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: _isPlaying ? const Color(0xFFEF4444) : const Color(0xFF10B981), padding: const EdgeInsets.all(9)),
              onPressed: _toggleStopPlay,
              icon: Icon(_isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded, size: 24),
            ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFD97706)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 2.5),
            ),
            child: Row(
              children: [
                const Text('⭐ ', style: TextStyle(fontSize: 17)),
                Text('$_stars', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStage() {
    if (_screenIndex == 1) return _selectedSongIndex == -1 ? _buildSongsCircleHub() : _buildSingleSongPlayer(_songs[_selectedSongIndex]);
    if (_screenIndex == 2) return _selectedBookIndex == -1 ? _buildBooksCircleHub() : _buildPanoramicStoryViewer(_books[_selectedBookIndex]);
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
              subLabel: 'Arabic Chants',
              imagePath: 'assets/images/card_songs.png',
              ringColor: const Color(0xFFEC4899),
              badgeBg: const Color(0xFFFDF2F8),
              onTap: () async {
                await _player.stop();
                await _stopNatureAmbience();
                setState(() {
                  _isPlaying = false;
                  _screenIndex = 1;
                  _selectedSongIndex = -1;
                  _owlBubble = '👏 اخْتَرْ أُنْشُودَةً مِنَ الدَّوَائِرِ وَاضْغَطْ عَلَيْهَا لِتَبْدَأَ!';
                });
              },
            ),
            const SizedBox(width: 14),
            _buildCircularIconPortal(
              label: '📖 القِصَصُ المَقْرُوءَةُ',
              subLabel: 'Reading Stories',
              imagePath: 'assets/images/card_stories.png',
              ringColor: const Color(0xFF8B5CF6),
              badgeBg: const Color(0xFFF5F3FF),
              onTap: () async {
                await _player.stop();
                await _stopNatureAmbience();
                setState(() {
                  _isPlaying = false;
                  _screenIndex = 2;
                  _selectedBookIndex = -1;
                  _owlBubble = '📖 اخْتَرْ قِصَّةً مِنَ المَكْتَبَةِ لِتَقْرَأَهَا مَعَ مَشَاهِدِ الطَّبِيعَةِ المُتَحَرِّكَةِ!';
                });
              },
            ),
            const SizedBox(width: 14),
            _buildCircularIconPortal(
              label: '🎮 الأَلْعَابُ',
              subLabel: 'Fun Challenges',
              imagePath: 'assets/images/owl_mascot.png',
              ringColor: const Color(0xFFF59E0B),
              badgeBg: const Color(0xFFFFFBEB),
              onTap: () async {
                await _player.stop();
                await _stopNatureAmbience();
                setState(() {
                  _isPlaying = false;
                  _screenIndex = 3;
                  _selectedQuizIndex = -1;
                  _owlBubble = '👏 اخْتَرْ لُعْبَةً مِنَ التَّحَدِّيَاتِ الثَّلَاثَةِ!';
                });
              },
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
                await _stopNatureAmbience();
                final VideoSurahItem first = _tafsirVideos[_selectedTafsirIndex];
                setState(() {
                  _isPlaying = false;
                  _isVideoExpanded = false;
                  _screenIndex = 4;
                  _owlBubble = 'تَفْسِيرُ القُرْآنِ الكَرِيمِ بِاللُّغَةِ الإِنْجِلِيزِيَّةِ! اخْتَرِ السُّورَةَ!';
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
                await _stopNatureAmbience();
                final VideoSurahItem first = _recitationVideos[_selectedRecitationIndex];
                setState(() {
                  _isPlaying = false;
                  _isVideoExpanded = false;
                  _screenIndex = 5;
                  _owlBubble = 'تِلَاوَةُ القُرْآنِ الكَرِيمِ! اخْتَرِ السُّورَةَ مِنَ القَائِمَةِ!';
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
              _playAudioTrack(s.audioFile, s.subtitle, bonusStars: 5);
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
                    child: Text(s.lyrics, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, height: 1.75, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: active ? const Color(0xFF10B981) : s.color, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                    onPressed: () => _playAudioTrack(s.audioFile, s.subtitle, bonusStars: 2),
                    icon: Icon(active ? Icons.graphic_eq_rounded : Icons.volume_up_rounded, size: 30),
                    label: Text(active ? 'الأُنْشُودَةُ تَعْمَلُ الآنَ...' : 'إِعَادَةُ الأُنْشُودَةِ 🔊', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
            subLabel: '${book.pages.length} مَشَاهِدَ مُتَحَرِّكَةٍ',
            imagePath: book.imagePath,
            ringColor: book.color,
            badgeBg: Colors.white,
            onTap: () {
              _playPageFlipSound();
              _startNatureAmbience();
              setState(() {
                _selectedBookIndex = i;
                _currentPageIndex = 0;
                _owlBubble = 'أَنْتَ تَقْرَأُ الآنَ: ${book.title} (${book.pages[0].pageTitle})';
              });
            },
          );
        }),
      ),
    );
  }

  // عارض القصة السينمائي بالعرض الكامل مع حركة الأشجار والشخصيات وصوت الطبيعة
  Widget _buildPanoramicStoryViewer(StoryBookItem book) {
    final StoryPageData page = book.pages[_currentPageIndex];
    final bool isFirstPage = _currentPageIndex == 0;
    final bool isLastPage = _currentPageIndex == book.pages.length - 1;

    return AnimatedBuilder(
      animation: _natureAnimCtrl,
      builder: (BuildContext context, _) {
        final double t = _natureAnimCtrl.value;
        final double wave = math.sin(t * math.pi * 2);
        final double hop = (math.sin(t * math.pi * 4)).abs() * -18;
        final double floatY = math.cos(t * math.pi * 2) * 10;

        return Stack(
          fit: StackFit.expand,
          children: [
            // 1. خلفية الطبيعة الحية المتحركة بعرض الشاشة بالكامل
            CustomPaint(
              painter: _AnimatedForestLandscapePainter(
                progress: t,
                skyColors: page.skyGradient,
                hillColor: page.hillColor,
                isOwlStory: book.isOwlStory,
              ),
              size: Size.infinite,
            ),

            // 2. الشمس أو القوس قزح والطيور المحلقة في السماء
            Positioned(
              top: 10,
              left: 36 + (wave * 12),
              child: Transform.rotate(
                angle: wave * 0.12,
                child: Text(page.skyElement, style: const TextStyle(fontSize: 54)),
              ),
            ),

            // 3. الشخصيات المتحركة في المشهد (الأرنب يقفز، الطيور ترفرف، الأصدقاء يتفاعلون)
            Positioned(
              bottom: 66,
              right: 26 + (wave * 14),
              child: Transform.translate(
                offset: Offset(0, hop),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(200),
                        border: Border.all(color: book.color, width: 3),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                      ),
                      child: Text(page.mainActor, style: const TextStyle(fontSize: 52)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 72,
              left: 30 - (wave * 14),
              child: Transform.translate(
                offset: Offset(0, floatY),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(190),
                    border: Border.all(color: const Color(0xFFF59E0B), width: 2.5),
                  ),
                  child: Text(page.actor2, style: const TextStyle(fontSize: 44)),
                ),
              ),
            ),
            Positioned(
              top: 22 + floatY,
              right: 45 - (wave * 18),
              child: Text(page.actor3, style: const TextStyle(fontSize: 38)),
            ),

            // 4. القصة مكتوبة بالعرض في وسط الشاشة فوق الخلفية المتحركة
            Column(
              children: [
                // شريط عنوان المشهد العلوي
                Container(
                  margin: const EdgeInsets.fromLTRB(110, 6, 110, 4),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  decoration: BoxDecoration(
                    color: book.color.withAlpha(235),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '📖 ${book.title}  •  ${page.pageTitle}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(color: Colors.white.withAlpha(55), borderRadius: BorderRadius.circular(14)),
                        child: Text(
                          'صَفْحَةُ ${_currentPageIndex + 1} مِنْ ${book.pages.length}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                // صندوق النص العريض (Wide Landscape Story Card)
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 380),
                    child: Container(
                      key: ValueKey<String>('${book.title}_$_currentPageIndex'),
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 105, vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(232),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: book.color, width: 4),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 14, offset: Offset(0, 5))],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                child: Text(
                                  page.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _storyFontSize,
                                    height: 1.75,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isLastPage)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFF59E0B), width: 2.5),
                              ),
                              child: Text(
                                '🌟 ${book.moral}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // شريط أزرار التنقل السفلي
                Padding(
                  padding: const EdgeInsets.fromLTRB(105, 2, 105, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFirstPage ? Colors.grey.shade400 : const Color(0xFF0284C7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: Colors.white, width: 2)),
                        ),
                        onPressed: isFirstPage
                            ? null
                            : () {
                                _playPageFlipSound();
                                final int prev = _currentPageIndex - 1;
                                setState(() {
                                  _currentPageIndex = prev;
                                  _owlBubble = 'صَفْحَةُ ${prev + 1}: ${book.pages[prev].pageTitle}';
                                });
                              },
                        icon: const Icon(Icons.arrow_back_rounded, size: 24),
                        label: const Text('الصَّفْحَةُ السَّابِقَةُ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(235),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: book.color, width: 2.5),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              tooltip: 'تَصْغِيرُ الخَطِّ',
                              onPressed: () {
                                _playPageFlipSound();
                                if (_storyFontSize > 18) setState(() => _storyFontSize -= 2);
                              },
                              icon: Icon(Icons.text_decrease_rounded, color: book.color),
                            ),
                            Text(
                              '${_currentPageIndex + 1} / ${book.pages.length}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: book.color),
                            ),
                            IconButton(
                              tooltip: 'تَكْبِيرُ الخَطِّ',
                              onPressed: () {
                                _playPageFlipSound();
                                if (_storyFontSize < 32) setState(() => _storyFontSize += 2);
                              },
                              icon: Icon(Icons.text_increase_rounded, color: book.color),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLastPage ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: Colors.white, width: 2)),
                        ),
                        onPressed: () async {
                          if (!isLastPage) {
                            _playPageFlipSound();
                            final int next = _currentPageIndex + 1;
                            setState(() {
                              _currentPageIndex = next;
                              _owlBubble = 'صَفْحَةُ ${next + 1}: ${book.pages[next].pageTitle}';
                            });
                          } else {
                            await _stopNatureAmbience();
                            _playAudioTrack(
                              'bravo.mp3',
                              '🎉 أَحْسَنْتَ يَا قَارِئَ الفُصْحَى! أَتْمَمْتَ القِصَّةَ وَرَبِحْتَ 15 نَجْمَةً!',
                              bonusStars: 15,
                            );
                            setState(() {
                              _selectedBookIndex = -1;
                            });
                          }
                        },
                        icon: Icon(isLastPage ? Icons.star_rounded : Icons.arrow_forward_rounded, size: 24),
                        label: Text(isLastPage ? 'أَتْمَمْتُ القِرَاءَةَ (+15 ⭐)' : 'الصَّفْحَةُ التَّالِيَةُ', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
            onTap: () {
              setState(() => _selectedQuizIndex = i);
              _playAudioTrack(q.audioFile, 'أَجِبْ عَنِ السُّؤَالِ التَّالِي لِتَرْبَحَ 10 نُجُومٍ!');
            },
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
                            _playAudioTrack('bravo.mp3', '👏 أَحْسَنْتَ يَا بَطَلَ الفُصْحَى! +10 نُجُومٍ!', bonusStars: 10);
                          } else {
                            _playAudioTrack('try_again.mp3', 'لَا بَأْسَ يَا صَدِيقِي! حَاوِلْ مَرَّةً أُخْرَى!');
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

// رسام الخلفية الطبيعية المتحركة: سحب عائمة + أشجار تتمايل مع النسيم + تلال خضراء + أزهار
class _AnimatedForestLandscapePainter extends CustomPainter {
  final double progress;
  final List<Color> skyColors;
  final Color hillColor;
  final bool isOwlStory;

  _AnimatedForestLandscapePainter({
    required this.progress,
    required this.skyColors,
    required this.hillColor,
    required this.isOwlStory,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double sway = math.sin(progress * math.pi * 2);

    // 1. السماء المتدرجة
    final Paint skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: skyColors,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), skyPaint);

    // 2. سحب بيضاء تتحرك ببطء في السماء
    final Paint cloudPaint = Paint()..color = Colors.white.withAlpha(205);
    final double cloud1X = ((progress * w * 0.4) + w * 0.15) % (w + 160) - 80;
    final double cloud2X = ((progress * w * 0.25) + w * 0.65) % (w + 180) - 90;
    _drawCloud(canvas, Offset(cloud1X, h * 0.14), 1.0, cloudPaint);
    _drawCloud(canvas, Offset(cloud2X, h * 0.22), 0.85, cloudPaint);

    // 3. التلال الخلفية والأمامية
    final Path backHill = Path()
      ..moveTo(0, h * 0.68)
      ..quadraticBezierTo(w * 0.3, h * 0.54, w * 0.6, h * 0.66)
      ..quadraticBezierTo(w * 0.82, h * 0.74, w, h * 0.60)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backHill, Paint()..color = hillColor.withAlpha(155));

    final Path frontHill = Path()
      ..moveTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.25, h * 0.72, w * 0.55, h * 0.80)
      ..quadraticBezierTo(w * 0.80, h * 0.86, w, h * 0.75)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = hillColor);

    // 4. الأشجار الخضراء التي تتمايل أغصانها مع النسيم يميناً ويساراً
    _drawSwayingTree(canvas, Offset(w * 0.06, h * 0.78), 115, sway * 11, const Color(0xFF15803D));
    _drawSwayingTree(canvas, Offset(w * 0.94, h * 0.77), 125, -sway * 12, const Color(0xFF166534));
    _drawSwayingTree(canvas, Offset(w * 0.15, h * 0.72), 75, sway * 7, const Color(0xFF22C55E));
    _drawSwayingTree(canvas, Offset(w * 0.85, h * 0.71), 80, -sway * 8, const Color(0xFF22C55E));

    // 5. أزهار صغيرة متمايلة على العشب
    final Paint flowerPaint = Paint()..color = isOwlStory ? const Color(0xFFF472B6) : const Color(0xFFFACC15);
    for (int i = 1; i <= 7; i++) {
      final double fx = (w * i) / 8.0 + (sway * 4);
      final double fy = h * 0.88 + ((i % 2) * 14);
      canvas.drawCircle(Offset(fx, fy), 5.5, flowerPaint);
      canvas.drawCircle(Offset(fx, fy), 2.2, Paint()..color = Colors.white);
    }
  }

  void _drawCloud(Canvas canvas, Offset center, double scale, Paint paint) {
    canvas.drawCircle(center, 24 * scale, paint);
    canvas.drawCircle(center + Offset(22 * scale, 4 * scale), 20 * scale, paint);
    canvas.drawCircle(center + Offset(-22 * scale, 6 * scale), 18 * scale, paint);
  }

  void _drawSwayingTree(Canvas canvas, Offset base, double height, double swayOffset, Color leafColor) {
    // جذع الشجرة
    final Paint trunkPaint = Paint()..color = const Color(0xFF78350F);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(base.dx - 9, base.dy - height * 0.55, 18, height * 0.6),
        const Radius.circular(6),
      ),
      trunkPaint,
    );

    // تاج الشجرة المتمايل مع الرياح
    final Offset crownCenter = Offset(base.dx + swayOffset, base.dy - height * 0.68);
    final Paint leafPaint = Paint()..color = leafColor;
    final Paint highlightLeaf = Paint()..color = const Color(0xFF4ADE80).withAlpha(160);

    canvas.drawCircle(crownCenter, height * 0.34, leafPaint);
    canvas.drawCircle(crownCenter + Offset(-height * 0.22, height * 0.08), height * 0.26, leafPaint);
    canvas.drawCircle(crownCenter + Offset(height * 0.22, height * 0.08), height * 0.26, leafPaint);
    canvas.drawCircle(crownCenter + Offset(-height * 0.08, -height * 0.1), height * 0.18, highlightLeaf);
  }

  @override
  bool shouldRepaint(covariant _AnimatedForestLandscapePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.hillColor != hillColor;
}
