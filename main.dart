import 'dart:async';
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
  final String subtitle;
  final String lyrics;
  final String audioFile;
  final Color color;
  final String emoji;
  const SongItem({
    required this.title,
    required this.subtitle,
    required this.lyrics,
    required this.audioFile,
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
  final String moral;
  final String audioFile;
  final Color color;
  final List<StoryPageData> pages;
  const StoryBookItem({
    required this.title,
    required this.moral,
    required this.audioFile,
    required this.color,
    required this.pages,
  });
}

class QuizItem {
  final String question;
  final String emoji;
  final List<String> options;
  final int correctIndex;
  const QuizItem({
    required this.question,
    required this.emoji,
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
      title: 'عالم فصيح',
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
        child: FaseehWorldStage(),
      ),
    );
  }
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
  bool _isVideoExpanded = false; // للتحكم في تكبير شاشة الفيديو مع إمكانية إظهار/إخفاء القائمة

  int _screenIndex = 0; // 0: الرئيسية, 1: الأناشيد, 2: القصص, 3: الألعاب, 4: التفسير, 5: التلاوة
  int _stars = 30;
  bool _isPlaying = false;
  bool _owlBounce = false;
  String _currentTrack = 'welcome.mp3';
  String _owlBubble = 'أَهْلاً بِكَ فِي عَالَمِ فَصِيح! اخْتَرْ أَيَّ أَيْقُونَةٍ دَائِرِيَّةٍ لِنَبْدَأَ المَرَحَ!';

  int _selectedBookIndex = -1;
  int _currentPageIndex = 0;
  int _selectedTafsirIndex = 0;
  int _selectedRecitationIndex = 0;

  // قائمة سور تلاوة القرآن الكريم للاختيار المباشر
  final List<VideoSurahItem> _recitationVideos = const [
    VideoSurahItem(arabicTitle: '١. سورة الفاتحة', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'bP1jjGxwdEs', color: Color(0xFF0284C7)),
    VideoSurahItem(arabicTitle: '٢. سورة الناس', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'enlsnMoMAsI', color: Color(0xFF059669)),
    VideoSurahItem(arabicTitle: '٣. سورة الفلق', subtitle: 'تلاوة تعليمية للأطفال', videoId: '7ITyHlnzUkY', color: Color(0xFF7C3AED)),
    VideoSurahItem(arabicTitle: '٤. سورة الإخلاص', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'FN6R21YEyeA', color: Color(0xFFD97706)),
    VideoSurahItem(arabicTitle: '٥. سورة المسد', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'JI8z72h5sUA', color: Color(0xFFDC2626)),
    VideoSurahItem(arabicTitle: '٦. سورة النصر', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'gNaPoAU2ojg', color: Color(0xFF10B981)),
    VideoSurahItem(arabicTitle: '٧. سورة الكافرون', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'MORw76wrIMU', color: Color(0xFF2563EB)),
    VideoSurahItem(arabicTitle: '٨. سورة الكوثر', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'yjomUlM-MZU', color: Color(0xFFDB2777)),
    VideoSurahItem(arabicTitle: '٩. سورة الماعون', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'KBXMbrZijsM', color: Color(0xFF0D9488)),
    VideoSurahItem(arabicTitle: '١٠. سورة قريش', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'LRK987yfTPQ', color: Color(0xFF9333EA)),
    VideoSurahItem(arabicTitle: '١١. سورة الفيل', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'CS_86YCKaFY', color: Color(0xFFEA580C)),
    VideoSurahItem(arabicTitle: '١٢. سورة الهمزة', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'EYHSmenebc8', color: Color(0xFFE11D48)),
    VideoSurahItem(arabicTitle: '١٣. سورة العصر', subtitle: 'تلاوة تعليمية للأطفال', videoId: 'rKnOWbZ6OjA', color: Color(0xFF0891B2)),
    VideoSurahItem(arabicTitle: '١٤. سورة التكاثر', subtitle: 'تلاوة تعليمية للأطفال', videoId: '5DTT5UPnU9Q', color: Color(0xFF4F46E5)),
  ];

  // قائمة سور تفسير القرآن بالإنجليزية
  final List<VideoSurahItem> _tafsirVideos = const [
    VideoSurahItem(arabicTitle: '١. سورة الفاتحة', subtitle: 'Surah Al-Fatihah (The Opening)', videoId: '3gbEFfKW-UM', color: Color(0xFF059669)),
    VideoSurahItem(arabicTitle: '٢. سورة الناس', subtitle: 'Surah An-Nas (Mankind)', videoId: 'BqVobCoQv4I', color: Color(0xFF0284C7)),
    VideoSurahItem(arabicTitle: '٣. سورة الفلق', subtitle: 'Surah Al-Falaq (The Daybreak)', videoId: 'zav5SzRNPCs', color: Color(0xFF7C3AED)),
    VideoSurahItem(arabicTitle: '٤. سورة الإخلاص', subtitle: 'Surah Al-Ikhlas (The Purity)', videoId: 'FzPKrwNrh_A', color: Color(0xFFD97706)),
    VideoSurahItem(arabicTitle: '٥. سورة المسد', subtitle: 'Surah Al-Masad (The Palm Fiber)', videoId: 'JI8z72h5sUA', color: Color(0xFFDC2626)),
    VideoSurahItem(arabicTitle: '٦. سورة النصر', subtitle: 'Surah An-Nasr (The Victory)', videoId: 'gNaPoAU2ojg', color: Color(0xFF10B981)),
    VideoSurahItem(arabicTitle: '٧. سورة الكافرون', subtitle: 'Surah Al-Kafirun (The Disbelievers)', videoId: 'MORw76wrIMU', color: Color(0xFF2563EB)),
    VideoSurahItem(arabicTitle: '٨. سورة الكوثر', subtitle: 'Surah Al-Kawthar (Abundance)', videoId: 'yjomUlM-MZU', color: Color(0xFFDB2777)),
    VideoSurahItem(arabicTitle: '٩. سورة الماعون', subtitle: 'Surah Al-Maun (Small Kindnesses)', videoId: 'KBXMbrZijsM', color: Color(0xFF0D9488)),
    VideoSurahItem(arabicTitle: '١٠. سورة قريش', subtitle: 'Surah Quraysh (The Tribe of Quraysh)', videoId: 'LRK987yfTPQ', color: Color(0xFF9333EA)),
    VideoSurahItem(arabicTitle: '١١. سورة الفيل', subtitle: 'Surah Al-Fil (The Elephant)', videoId: 'CS_86YCKaFY', color: Color(0xFFEA580C)),
    VideoSurahItem(arabicTitle: '١٢. سورة الهمزة', subtitle: 'Surah Al-Humazah (The Slanderer)', videoId: 'EYHSmenebc8', color: Color(0xFFE11D48)),
    VideoSurahItem(arabicTitle: '١٣. سورة العصر', subtitle: 'Surah Al-Asr (The Time)', videoId: 'rKnOWbZ6OjA', color: Color(0xFF0891B2)),
    VideoSurahItem(arabicTitle: '١٤. سورة التكاثر', subtitle: 'Surah At-Takathur (Competition for More)', videoId: '5DTT5UPnU9Q', color: Color(0xFF4F46E5)),
  ];

  final List<SongItem> _songs = const [
    SongItem(
      title: 'أُنْشُودَةُ حُرُوفِ الهِجَاءِ',
      subtitle: 'أَلِفٌ أَرْنَبْ.. يَجْرِي يَلْعَبْ!',
      lyrics: 'أَلِفٌ أَرْنَبْ، يَجْرِي يَلْعَبْ، يَأْكُلُ جَزَراً كَيْ لَا يَتْعَبْ!\nبَاءٌ بَطَّةْ، نَطَّتْ نَطَّةْ، وَقَعَتْ ضَحِكَتْ مِنْهَا القِطَّةْ!',
      audioFile: 'song_alphabet.mp3',
      color: Color(0xFFEC4899),
      emoji: '🐰',
    ),
    SongItem(
      title: 'أُنْشُودَةُ شَمْسِ الصَّبَاحِ',
      subtitle: 'أَشْرَقَتِ الشَّمْسُ الذَّهَبِيَّةْ!',
      lyrics: 'أَشْرَقَتِ الشَّمْسُ الذَّهَبِيَّةْ، وَتَغَنَّتْ طَيْرُ الحُرِّيَّةْ!\nهَيَّا نَتَعَلَّمْ يَا أَطْفَالْ، لُغَتِي الفُصْحَى أَجْمَلُ حَالْ!',
      audioFile: 'song_morning.mp3',
      color: Color(0xFFF59E0B),
      emoji: '☀️',
    ),
    SongItem(
      title: 'أُنْشُودَةُ الأَرْقَامِ الفَصِيحَةِ',
      subtitle: 'وَاحِدٌ اثْنَانِ ثَلَاثَةْ!',
      lyrics: 'وَاحِدٌ اثْنَانِ ثَلَاثَةْ، نَتَعَلَّمُ بِذَكَاءٍ وَحَمَاسَةْ!\nأَرْبَعَةٌ خَمْسَةٌ سِتَّةْ، نَقْرَأُ فِي البُسْتَانِ القِصَّةْ!',
      audioFile: 'song_numbers.mp3',
      color: Color(0xFF8B5CF6),
      emoji: '🔢',
    ),
  ];

  // تقسيم توقيت الصوت لكل صفحة في القصة بدقة
  final List<StoryBookItem> _books = const [
    StoryBookItem(
      title: 'الأَرْنَبُ الصَّغِيرُ وَسِرُّ الجَزَرَةِ الذَّهَبِيَّةِ',
      moral: 'الحِكْمَةُ: بِالتَّعَاوُنِ وَالكَلِمَةِ الطَّيِّبَةِ نُنْجِزُ أَصْعَبَ المَهَامِّ!',
      audioFile: 'story_rabbit.mp3',
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
      title: 'البُومُ الحَكِيمُ وَطَائِرُ البُلْبُلِ المُغَرِّدِ',
      moral: 'الحِكْمَةُ: الثِّقَةُ بِالنَّفْسِ وَالمُحَاوَلَةُ المُسْتَمِرَّةُ تَصْنَعُ الإِبْدَاعَ!',
      audioFile: 'story_owl.mp3',
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
    QuizItem(question: 'مَا مَعْنَى كَلِمَةِ «غَدِيرٌ»؟', emoji: '💧', options: ['نَهْرٌ صَغِيرٌ عَذْبٌ 💧', 'جَبَلٌ كَبِيرٌ ⛰️', 'رِيَاحٌ قَوِيَّةٌ 🌪️'], correctIndex: 0),
    QuizItem(question: 'مَا صَوْتُ أَوْرَاقِ الشَّجَرِ؟', emoji: '🍃', options: ['زَئِيرٌ 🦁', 'حَفِيفٌ 🍃', 'خَرِيرٌ 🌊'], correctIndex: 1),
    QuizItem(question: 'أَيُّ جُمْلَةٍ بِالعَرَبِيَّةِ الفُصْحَى؟', emoji: '🌟', options: ['الولد راح بدري', 'ذَهَبَ الطِّفْلُ مُبَكِّراً 🌟', 'أيمتى رح نلعب؟'], correctIndex: 1),
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
    Future.delayed(const Duration(milliseconds: 500), () {
      _playMedia('welcome.mp3', _owlBubble, 0);
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

  // تشغيل مقطع الصوت الخاص بالصفحة الحالية فقط في القصة
  Future<void> _playStoryPageAudio(StoryBookItem book, int pageIndex) async {
    _storySegmentTimer?.cancel();
    final StoryPageData page = book.pages[pageIndex];
    setState(() {
      _currentTrack = book.audioFile;
      _owlBubble = 'تقرأ وتستمع الآن إلى صفحة ${pageIndex + 1} من: ${book.title}';
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

    // إيقاف الصوت تلقائياً عند انتهاء فقرة هذه الصفحة حتى ينتقل الطفل للصفحة التالية
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
    await _player.play(AssetSource('audio/$fileName'));
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _owlBounce = false;
        });
      }
    });
  }

  Future<void> _toggleStopPlay() async {
    _storySegmentTimer?.cancel();
    if (_isPlaying) {
      await _player.stop();
      setState(() {
        _isPlaying = false;
      });
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
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    final VideoPlayerController ctrl = _videoController!;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: ctrl.value.aspectRatio,
            child: VideoPlayer(ctrl),
          ),
        ),
        // زر علوي للتبديل بين الشاشة الكبيرة مع القائمة وبين ملء الشاشة
        Positioned(
          top: 8,
          left: 8,
          child: Material(
            color: Colors.black.withAlpha(170),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                setState(() {
                  _isVideoExpanded = !_isVideoExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_isVideoExpanded ? Icons.view_sidebar_rounded : Icons.fullscreen_rounded, color: Colors.white, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      _isVideoExpanded ? 'إظهار قائمة السور' : 'تكبير الشاشة ⛶',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
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
                onPressed: () {
                  setState(() {
                    if (ctrl.value.isPlaying) {
                      ctrl.pause();
                    } else {
                      ctrl.play();
                    }
                  });
                },
              ),
              Expanded(
                child: VideoProgressIndicator(
                  ctrl,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: borderColor,
                    bufferedColor: Colors.white54,
                    backgroundColor: Colors.white24,
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (_screenIndex != 0)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () async {
                  _storySegmentTimer?.cancel();
                  await _player.stop();
                  await _videoController?.pause();
                  setState(() {
                    _isPlaying = false;
                    _isVideoExpanded = false;
                    if (_screenIndex == 2 && _selectedBookIndex != -1) {
                      _selectedBookIndex = -1;
                    } else {
                      _screenIndex = 0;
                    }
                  });
                },
                icon: Icon((_screenIndex == 2 && _selectedBookIndex != -1) ? Icons.menu_book_rounded : Icons.home_rounded, size: 26),
                label: Text((_screenIndex == 2 && _selectedBookIndex != -1) ? 'المكتبة' : 'الرئيسية', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          GestureDetector(
            onTap: _toggleStopPlay,
            child: AnimatedScale(
              scale: _owlBounce ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFBBF24), width: 3.5),
                  color: Colors.white,
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: ClipOval(child: Image.asset('assets/images/owl_mascot.png', width: 54, height: 54, fit: BoxFit.cover)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(242),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF38BDF8), width: 2.5),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Text(
                _owlBubble,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF0F172A)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: _isPlaying ? const Color(0xFFEF4444) : const Color(0xFF10B981),
              padding: const EdgeInsets.all(10),
            ),
            onPressed: _toggleStopPlay,
            icon: Icon(_isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded, size: 28),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFD97706)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            child: Row(
              children: [
                const Text('⭐ ', style: TextStyle(fontSize: 20)),
                Text('$_stars', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStage() {
    if (_screenIndex == 1) return _buildSongsStage();
    if (_screenIndex == 2) {
      if (_selectedBookIndex == -1) return _buildBookshelfStage();
      return _buildOpenBookViewer(_books[_selectedBookIndex]);
    }
    if (_screenIndex == 3) return _buildGamesStage();
    if (_screenIndex == 4) {
      return _buildVideoWithSidebarStage(
        sectionTitle: '📖 Quran Tafsir in English',
        headerColor: const Color(0xFF059669),
        items: _tafsirVideos,
        selectedIndex: _selectedTafsirIndex,
        onSelect: (int idx) {
          setState(() {
            _selectedTafsirIndex = idx;
            _stars += 3;
            _owlBubble = 'تُشَاهِدُ الآنَ تَفْسِيرَ: ${_tafsirVideos[idx].arabicTitle} (${_tafsirVideos[idx].subtitle})';
          });
          _playDirectNativeVideo(_tafsirVideos[idx].videoId);
        },
      );
    }
    if (_screenIndex == 5) {
      return _buildVideoWithSidebarStage(
        sectionTitle: '🎧 سور تلاوة القرآن الكريم',
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
              label: '🎵 الأناشيد',
              subLabel: 'أغانٍ وألحان',
              imagePath: 'assets/images/card_songs.png',
              ringColor: const Color(0xFFEC4899),
              badgeBg: const Color(0xFFFDF2F8),
              onTap: () {
                setState(() => _screenIndex = 1);
                _playMedia('song_alphabet.mp3', 'هَيَّا نُغَنِّي مَعاً أَنَاشِيدَ عَالَمِ فَصِيح!', 2);
              },
            ),
            const SizedBox(width: 14),
            _buildCircularIconPortal(
              label: '📖 القصص',
              subLabel: 'حكايات مصوّرة',
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
              label: '🎮 الألعاب',
              subLabel: 'تحديات ونجوم',
              imagePath: 'assets/images/owl_mascot.png',
              ringColor: const Color(0xFFF59E0B),
              badgeBg: const Color(0xFFFFFBEB),
              onTap: () => setState(() => _screenIndex = 3),
            ),
            const SizedBox(width: 14),
            _buildCircularIconPortal(
              label: '🕌 تفسير القرآن',
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
              label: '🎧 تلاوة القرآن',
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 132,
            height: 132,
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

  // واجهة موحدة تجمع بين الفيديو الكبير وقائمة السور لكل من التفسير والتلاوة
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
          // شاشة الفيديو الكبيرة (72% من العرض، أو 100% عند الضغط على زر التكبير)
          Expanded(
            flex: 72,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(245),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: activeItem.color, width: 4),
                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 12)],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: Colors.black,
                        child: _buildNativeVideoPlayerBox(
                          borderColor: activeItem.color,
                          onRetry: () => _playDirectNativeVideo(activeItem.videoId),
                        ),
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
          // قائمة السور الجانبية المدمجة (28% من العرض)
          if (!_isVideoExpanded)
            Expanded(
              flex: 28,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(238),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: headerColor, width: 3.5),
                ),
                child: Column(
                  children: [
                    Text(sectionTitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: headerColor)),
                    const Divider(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
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
                                      Icon(
                                        isSelected ? Icons.play_circle_filled_rounded : Icons.play_circle_outline_rounded,
                                        color: isSelected ? Colors.white : surah.color,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              surah.arabicTitle,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? Colors.white : const Color(0xFF0F172A)),
                                            ),
                                            Text(
                                              surah.subtitle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? const Color(0xFFFEF08A) : const Color(0xFF475569)),
                                            ),
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

  Widget _buildBookshelfStage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
      child: Row(
        children: List.generate(_books.length, (int i) {
          final StoryBookItem book = _books[i];
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedBookIndex = i;
                    _currentPageIndex = 0;
                  });
                  _playStoryPageAudio(book, 0);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: book.color, width: 5),
                    boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 14, offset: Offset(0, 6))],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset('assets/images/card_stories.png', fit: BoxFit.cover),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: book.color, borderRadius: BorderRadius.circular(16)),
                                  child: Text('📖 ${book.pages.length} صفحات مصورة', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(book.title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: book.color)),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(backgroundColor: book.color, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                  onPressed: () {
                                    setState(() {
                                      _selectedBookIndex = i;
                                      _currentPageIndex = 0;
                                    });
                                    _playStoryPageAudio(book, 0);
                                  },
                                  icon: const Icon(Icons.auto_stories_rounded, size: 26),
                                  label: const Text('افتح الكتاب واقرأ القصة', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF7),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: book.color, width: 5),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 18, offset: Offset(0, 8))],
        ),
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
                    child: Text('صفحة ${_currentPageIndex + 1} من ${book.pages.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
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
                          ClipRRect(borderRadius: BorderRadius.circular(21), child: Opacity(opacity: 0.35, child: Image.asset('assets/images/card_stories.png', fit: BoxFit.cover))),
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
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                child: Text(page.text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 27, height: 1.7, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                              ),
                            ),
                          ),
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
                            final int prevPage = _currentPageIndex - 1;
                            setState(() => _currentPageIndex = prevPage);
                            _playStoryPageAudio(book, prevPage);
                          },
                    icon: const Icon(Icons.arrow_back_rounded, size: 28),
                    label: const Text('الصفحة السابقة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
                    onPressed: () => _playStoryPageAudio(book, _currentPageIndex),
                    icon: Icon(_isPlaying ? Icons.graphic_eq_rounded : Icons.volume_up_rounded, size: 26),
                    label: Text(_isPlaying ? 'يقرأ هذه الصفحة...' : 'إعادة قراءة الصفحة 🔊', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: isLastPage ? const Color(0xFF10B981) : const Color(0xFFF59E0B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
                    onPressed: () {
                      if (!isLastPage) {
                        final int nextPage = _currentPageIndex + 1;
                        setState(() => _currentPageIndex = nextPage);
                        _playStoryPageAudio(book, nextPage);
                      } else {
                        _storySegmentTimer?.cancel();
                        _playMedia('bravo.mp3', 'أَحْسَنْتَ! أَنْهَيْتَ قِرَاءَةَ القِصَّةِ بِبَرَاعَةٍ! +10 نُجُوم!', 10);
                        setState(() => _selectedBookIndex = -1);
                      }
                    },
                    icon: Icon(isLastPage ? Icons.star_rounded : Icons.arrow_forward_rounded, size: 28),
                    label: Text(isLastPage ? 'أنهيت القصة (+10 ⭐)' : 'الصفحة التالية', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongsStage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Row(
        children: List.generate(_songs.length, (int i) {
          final SongItem s = _songs[i];
          final bool active = _currentTrack == s.audioFile && _isPlaying;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: () => _playMedia(s.audioFile, s.subtitle, 5),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(245),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: active ? const Color(0xFFF59E0B) : s.color, width: active ? 5 : 3.5),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(s.emoji, style: const TextStyle(fontSize: 44)),
                      Text(s.title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: s.color)),
                      Text(s.lyrics, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14.5, height: 1.5, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: active ? const Color(0xFF10B981) : s.color, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10)),
                        onPressed: () => _playMedia(s.audioFile, s.subtitle, 5),
                        icon: Icon(active ? Icons.graphic_eq_rounded : Icons.play_arrow_rounded, size: 26),
                        label: Text(active ? 'تعمل الآن 🎵' : 'شغّل الأنشودة', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGamesStage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Row(
        children: List.generate(_quizzes.length, (int i) {
          final QuizItem q = _quizzes[i];
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(245),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFF59E0B), width: 3.5),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(q.emoji, style: const TextStyle(fontSize: 40)),
                    Text(q.question, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF0F172A))),
                    Column(
                      children: List.generate(q.options.length, (int optIdx) {
                        final String label = q.options[optIdx];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE0F2FE), foregroundColor: const Color(0xFF0369A1), padding: const EdgeInsets.symmetric(vertical: 9)),
                              onPressed: () {
                                if (optIdx == q.correctIndex) {
                                  _playMedia('bravo.mp3', 'أَحْسَنْتَ يَا بَطَلَ الفُصْحَى! +10 نُجُوم!', 10);
                                } else {
                                  _playMedia('try_again.mp3', 'لَا بَأْسَ يَا صَدِيقِي! حَاوِلْ مَرَّةً أُخْرَى!', 0);
                                }
                              },
                              child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
