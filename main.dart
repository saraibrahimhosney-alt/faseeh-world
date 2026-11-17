import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  const StoryPageData({
    required this.text,
    required this.emoji,
    required this.bgTint,
  });
}

class StoryBookItem {
  final String title;
  final String moral;
  final String audioFile;
  final Color color;
  final List pages;
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
  final List options;
  final int correctIndex;
  const QuizItem({
    required this.question,
    required this.emoji,
    required this.options,
    required this.correctIndex,
  });
}

class TafsirVideoItem {
  final String arabicTitle;
  final String englishTitle;
  final String videoId;
  final Color color;
  const TafsirVideoItem({
    required this.arabicTitle,
    required this.englishTitle,
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
  State createState() {
    return _FaseehWorldStageState();
  }
}

class _FaseehWorldStageState extends State {
  final AudioPlayer _player = AudioPlayer();
  YoutubePlayerController? _ytController;

  int _screenIndex = 0; // 0: الرئيسية, 1: الأناشيد, 2: القصص, 3: الألعاب, 4: تفسير القرآن بالإنجليزية
  int _stars = 30;
  bool _isPlaying = false;
  bool _owlBounce = false;
  String _currentTrack = 'welcome.mp3';
  String _owlBubble = 'أَهْلاً بِكَ فِي عَالَمِ فَصِيح! اخْتَرْ أَيَّ أَيْقُونَةٍ دَائِرِيَّةٍ لِنَبْدَأَ المَرَحَ!';

  int _selectedBookIndex = -1;
  int _currentPageIndex = 0;
  int _selectedTafsirIndex = 0;

  final List _tafsirVideos = const [
    TafsirVideoItem(
      arabicTitle: '١. سورة الفاتحة',
      englishTitle: 'Surah Al-Fatihah (The Opening)',
      videoId: '3gbEFfKW-UM',
      color: Color(0xFF059669),
    ),
    TafsirVideoItem(
      arabicTitle: '٢. سورة الناس',
      englishTitle: 'Surah An-Nas (Mankind)',
      videoId: 'BqVobCoQv4I',
      color: Color(0xFF0284C7),
    ),
    TafsirVideoItem(
      arabicTitle: '٣. سورة الفلق',
      englishTitle: 'Surah Al-Falaq (The Daybreak)',
      videoId: 'zav5SzRNPCs',
      color: Color(0xFF7C3AED),
    ),
    TafsirVideoItem(
      arabicTitle: '٤. سورة الإخلاص',
      englishTitle: 'Surah Al-Ikhlas (The Purity)',
      videoId: 'FzPKrwNrh_A',
      color: Color(0xFFD97706),
    ),
    TafsirVideoItem(
      arabicTitle: '٥. سورة المسد',
      englishTitle: 'Surah Al-Masad (The Palm Fiber)',
      videoId: 'JI8z72h5sUA',
      color: Color(0xFFDC2626),
    ),
    TafsirVideoItem(
      arabicTitle: '٦. سورة النصر',
      englishTitle: 'Surah An-Nasr (The Victory)',
      videoId: 'gNaPoAU2ojg',
      color: Color(0xFF10B981),
    ),
    TafsirVideoItem(
      arabicTitle: '٧. سورة الكافرون',
      englishTitle: 'Surah Al-Kafirun (The Disbelievers)',
      videoId: 'MORw76wrIMU',
      color: Color(0xFF2563EB),
    ),
    TafsirVideoItem(
      arabicTitle: '٨. سورة الكوثر',
      englishTitle: 'Surah Al-Kawthar (Abundance)',
      videoId: 'yjomUlM-MZU',
      color: Color(0xFFDB2777),
    ),
    TafsirVideoItem(
      arabicTitle: '٩. سورة الماعون',
      englishTitle: 'Surah Al-Maun (Small Kindnesses)',
      videoId: 'KBXMbrZijsM',
      color: Color(0xFF0D9488),
    ),
    TafsirVideoItem(
      arabicTitle: '١٠. سورة قريش',
      englishTitle: 'Surah Quraysh (The Tribe of Quraysh)',
      videoId: 'LRK987yfTPQ',
      color: Color(0xFF9333EA),
    ),
    TafsirVideoItem(
      arabicTitle: '١١. سورة الفيل',
      englishTitle: 'Surah Al-Fil (The Elephant)',
      videoId: 'CS_86YCKaFY',
      color: Color(0xFFEA580C),
    ),
    TafsirVideoItem(
      arabicTitle: '١٢. سورة الهمزة',
      englishTitle: 'Surah Al-Humazah (The Slanderer)',
      videoId: 'EYHSmenebc8',
      color: Color(0xFFE11D48),
    ),
    TafsirVideoItem(
      arabicTitle: '١٣. سورة العصر',
      englishTitle: 'Surah Al-Asr (The Time)',
      videoId: 'rKnOWbZ6OjA',
      color: Color(0xFF0891B2),
    ),
    TafsirVideoItem(
      arabicTitle: '١٤. سورة التكاثر',
      englishTitle: 'Surah At-Takathur (Competition for More)',
      videoId: '5DTT5UPnU9Q',
      color: Color(0xFF4F46E5),
    ),
  ];

  final List _songs = const [
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

  final List _books = const [
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
        ),
        StoryPageData(
          text: 'فَجْأَةً، وَجَدَ فَصِيحٌ جَزَرَةً كَبِيرَةً تَلْمَعُ تَحْتَ أَشِعَّةِ الشَّمْسِ، لَكِنَّهَا كَانَتْ عَالِقَةً بِقُوَّةٍ فِي التُّرْبَةِ!',
          emoji: '🥕✨😲',
          bgTint: Color(0xFFFFFBEB),
        ),
        StoryPageData(
          text: 'نَادَى فَصِيحٌ أَصْدِقَاءَهُ السِّنْجَابَ وَالسُّلَحْفَاةَ، وَقَالَ بِلُطْفٍ وَأَدَبٍ: «هَلْ تُسَاعِدُونَنِي يَا أَصْدِقَائِي؟».',
          emoji: '🐿️🐢💬',
          bgTint: Color(0xFFF0F9FF),
        ),
        StoryPageData(
          text: 'تَعَاوَنَ الجَمِيعُ بِهِمَّةٍ وَنَشَاطٍ حَتَّى أَخْرَجُوا الجَزَرَةَ الذَّهَبِيَّةَ، وَتَقَاسَمُوهَا بِسَعَادَةٍ وَمَحَبَّةٍ كَبِيرَةٍ!',
          emoji: '🎉🥕❤️',
          bgTint: Color(0xFFFDF2F8),
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
        ),
        StoryPageData(
          text: 'اقْتَرَبَ مِنْهُ البُومُ الحَكِيمُ «فَصِيحٌ» وَقَالَ لَهُ بِابْتِسَامَةٍ دَافِئَةٍ: «صَوْتُكَ جَمِيلٌ يَا بُنَيَّ، وَالتَّجْرِبَةُ هِيَ طَرِيقُ النَّجَاحِ!».',
          emoji: '🦉💛✨',
          bgTint: Color(0xFFFFFBEB),
        ),
        StoryPageData(
          text: 'تَشَجَّعَ البُلْبُلُ وَانْطَلَقَ يُغَرِّدُ بِأَعْذَبِ الأَلْحَانِ الفَصِيحَةِ، فَصَفَّقَتْ لَهُ الطُّيُورُ بِإِعْجَابٍ وَفَرَحٍ شَدِيدٍ!',
          emoji: '🎶🐦👏',
          bgTint: Color(0xFFECFDF5),
        ),
      ],
    ),
  ];

  final List _quizzes = const [
    QuizItem(
      question: 'مَا مَعْنَى كَلِمَةِ «غَدِيرٌ»؟',
      emoji: '💧',
      options: ['نَهْرٌ صَغِيرٌ عَذْبٌ 💧', 'جَبَلٌ كَبِيرٌ ⛰️', 'رِيَاحٌ قَوِيَّةٌ 🌪️'],
      correctIndex: 0,
    ),
    QuizItem(
      question: 'مَا صَوْتُ أَوْرَاقِ الشَّجَرِ؟',
      emoji: '🍃',
      options: ['زَئِيرٌ 🦁', 'حَفِيفٌ 🍃', 'خَرِيرٌ 🌊'],
      correctIndex: 1,
    ),
    QuizItem(
      question: 'أَيُّ جُمْلَةٍ بِالعَرَبِيَّةِ الفُصْحَى؟',
      emoji: '🌟',
      options: ['الولد راح بدري', 'ذَهَبَ الطِّفْلُ مُبَكِّراً 🌟', 'أيمتى رح نلعب؟'],
      correctIndex: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
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
    _player.dispose();
    _ytController?.dispose();
    super.dispose();
  }

  void _initYoutubeForIndex(int index) {
    final TafsirVideoItem item = _tafsirVideos[index] as TafsirVideoItem;
    if (_ytController == null) {
      _ytController = YoutubePlayerController(
        initialVideoId: item.videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
        ),
      );
    } else {
      _ytController!.load(item.videoId);
    }
  }

  Future _playMedia(String fileName, String bubbleText, int bonusStars) async {
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

  Future _toggleStopPlay() async {
    if (_isPlaying) {
      await _player.stop();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _playMedia(_currentTrack, _owlBubble, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/forest_bg.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withAlpha(35),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: _buildCurrentStage(),
                ),
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
                onPressed: () {
                  _ytController?.pause();
                  setState(() {
                    if (_screenIndex == 2 && _selectedBookIndex != -1) {
                      _selectedBookIndex = -1;
                    } else {
                      _screenIndex = 0;
                    }
                  });
                },
                icon: Icon(
                  (_screenIndex == 2 && _selectedBookIndex != -1) ? Icons.menu_book_rounded : Icons.home_rounded,
                  size: 26,
                ),
                label: Text(
                  (_screenIndex == 2 && _selectedBookIndex != -1) ? 'المكتبة' : 'الرئيسية',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              _playMedia(_currentTrack, _owlBubble, 0);
            },
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
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/owl_mascot.png',
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                  ),
                ),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.5,
                  color: Color(0xFF0F172A),
                ),
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
                Text(
                  '$_stars',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStage() {
    if (_screenIndex == 1) {
      return _buildSongsStage();
    } else if (_screenIndex == 2) {
      if (_selectedBookIndex == -1) {
        return _buildBookshelfStage();
      }
      return _buildOpenBookViewer(_books[_selectedBookIndex] as StoryBookItem);
    } else if (_screenIndex == 3) {
      return _buildGamesStage();
    } else if (_screenIndex == 4) {
      return _buildTafsirStage();
    }
    return _buildMainLobby();
  }

  // الشاشة الرئيسية بالأيقونات الدائرية الأربع
  Widget _buildMainLobby() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                setState(() {
                  _screenIndex = 1;
                });
                _playMedia('song_alphabet.mp3', 'هَيَّا نُغَنِّي مَعاً أَنَاشِيدَ عَالَمِ فَصِيح!', 2);
              },
            ),
            const SizedBox(width: 20),
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
            const SizedBox(width: 20),
            _buildCircularIconPortal(
              label: '🎮 الألعاب',
              subLabel: 'تحديات ونجوم',
              imagePath: 'assets/images/owl_mascot.png',
              ringColor: const Color(0xFFF59E0B),
              badgeBg: const Color(0xFFFFFBEB),
              onTap: () {
                setState(() {
                  _screenIndex = 3;
                });
              },
            ),
            const SizedBox(width: 20),
            _buildCircularIconPortal(
              label: '🕌 تفسير القرآن',
              subLabel: 'Quran Tafsir in English',
              imagePath: 'assets/images/card_stories.png',
              ringColor: const Color(0xFF059669),
              badgeBg: const Color(0xFFECFDF5),
              onTap: () async {
                await _player.stop();
                setState(() {
                  _isPlaying = false;
                  _screenIndex = 4;
                  _owlBubble = 'تَفْسِيرُ القُرْآنِ الكَرِيمِ بِاللُّغَةِ الإِنْجِلِيزِيَّةِ لِلْأَطْفَالِ! اخْتَرِ السُّورَةَ لِلْمُشَاهَدَةِ!';
                  _stars += 5;
                });
                _initYoutubeForIndex(_selectedTafsirIndex);
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
            width: 146,
            height: 146,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: ringColor, width: 5.5),
              boxShadow: const [
                BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 6)),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: ringColor, width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ringColor,
                  ),
                ),
                Text(
                  subLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // شاشة تفسير القرآن بالإنجليزية (فيديو يوتيوب يمين + قائمة السور يسار)
  Widget _buildTafsirStage() {
    final TafsirVideoItem activeItem = _tafsirVideos[_selectedTafsirIndex] as TafsirVideoItem;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(245),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: activeItem.color, width: 4),
                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 12)],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: _ytController != null
                          ? YoutubePlayer(
                              controller: _ytController!,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: const Color(0xFF059669),
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        activeItem.arabicTitle,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: activeItem.color),
                      ),
                      Text(
                        activeItem.englishTitle,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(235),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: const Color(0xFF059669), width: 3.5),
              ),
              child: Column(
                children: [
                  const Text(
                    '📖 Quran Tafsir in English',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                  ),
                  const Divider(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _tafsirVideos.length,
                      itemBuilder: (BuildContext context, int index) {
                        final TafsirVideoItem surah = _tafsirVideos[index] as TafsirVideoItem;
                        final bool isSelected = index == _selectedTafsirIndex;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Material(
                            color: isSelected ? surah.color : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                setState(() {
                                  _selectedTafsirIndex = index;
                                  _stars += 3;
                                  _owlBubble = 'تُشَاهِدُ الآنَ تَفْسِيرَ: ${surah.arabicTitle} (${surah.englishTitle})';
                                });
                                _initYoutubeForIndex(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected ? Icons.play_circle_filled_rounded : Icons.play_circle_outline_rounded,
                                      color: isSelected ? Colors.white : surah.color,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            surah.arabicTitle,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: isSelected ? Colors.white : const Color(0xFF0F172A),
                                            ),
                                          ),
                                          Text(
                                            surah.englishTitle,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isSelected ? const Color(0xFFFEF08A) : const Color(0xFF475569),
                                            ),
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
          final StoryBookItem book = _books[i] as StoryBookItem;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedBookIndex = i;
                    _currentPageIndex = 0;
                  });
                  _playMedia(book.audioFile, 'تقرأ وتستمع الآن إلى: ${book.title}', 5);
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
                                  decoration: BoxDecoration(
                                    color: book.color,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '📖 ${book.pages.length} صفحات مصورة',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
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
                              Text(
                                book.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: book.color),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: book.color,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedBookIndex = i;
                                      _currentPageIndex = 0;
                                    });
                                    _playMedia(book.audioFile, 'تقرأ وتستمع الآن إلى: ${book.title}', 5);
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
    final StoryPageData page = book.pages[_currentPageIndex] as StoryPageData;
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
              decoration: BoxDecoration(
                color: book.color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      book.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'صفحة ${_currentPageIndex + 1} من ${book.pages.length}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
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
                      decoration: BoxDecoration(
                        color: page.bgTint,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: book.color.withAlpha(110), width: 3),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(21),
                            child: Opacity(
                              opacity: 0.35,
                              child: Image.asset('assets/images/card_stories.png', fit: BoxFit.cover),
                            ),
                          ),
                          Center(
                            child: Text(
                              page.emoji,
                              style: const TextStyle(fontSize: 64),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 3,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    color: book.color.withAlpha(60),
                  ),
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
                                child: Text(
                                  page.text,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 27,
                                    height: 1.7,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isLastPage)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFF59E0B), width: 2),
                              ),
                              child: Text(
                                '🌟 ${book.moral}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF92400E),
                                ),
                              ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFirstPage ? Colors.grey.shade300 : const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    ),
                    onPressed: isFirstPage
                        ? null
                        : () {
                            setState(() {
                              _currentPageIndex -= 1;
                            });
                          },
                    icon: const Icon(Icons.arrow_back_rounded, size: 28),
                    label: const Text('الصفحة السابقة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    ),
                    onPressed: () {
                      _playMedia(book.audioFile, 'تستمع الآن إلى: ${book.title}', 0);
                    },
                    icon: Icon(_isPlaying ? Icons.graphic_eq_rounded : Icons.volume_up_rounded, size: 26),
                    label: Text(_isPlaying ? 'الصوت يعمل...' : 'استمع للقصة 🔊', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLastPage ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    ),
                    onPressed: () {
                      if (!isLastPage) {
                        setState(() {
                          _currentPageIndex += 1;
                        });
                      } else {
                        _playMedia('bravo.mp3', 'أَحْسَنْتَ! أَنْهَيْتَ قِرَاءَةَ القِصَّةِ بِبَرَاعَةٍ! +10 نُجُوم!', 10);
                        setState(() {
                          _selectedBookIndex = -1;
                        });
                      }
                    },
                    icon: Icon(isLastPage ? Icons.star_rounded : Icons.arrow_forward_rounded, size: 28),
                    label: Text(
                      isLastPage ? 'أنهيت القصة (+10 ⭐)' : 'الصفحة التالية',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildSongsStage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Row(
        children: List.generate(_songs.length, (int i) {
          final SongItem s = _songs[i] as SongItem;
          final bool active = _currentTrack == s.audioFile && _isPlaying;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: () {
                  _playMedia(s.audioFile, s.subtitle, 5);
                },
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
                      Text(
                        s.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: s.color),
                      ),
                      Text(
                        s.lyrics,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14.5, height: 1.5, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                      ),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: active ? const Color(0xFF10B981) : s.color,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        ),
                        onPressed: () {
                          _playMedia(s.audioFile, s.subtitle, 5);
                        },
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
          final QuizItem q = _quizzes[i] as QuizItem;
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
                    Text(
                      q.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF0F172A)),
                    ),
                    Column(
                      children: List.generate(q.options.length, (int optIdx) {
                        final String label = q.options[optIdx].toString();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE0F2FE),
                                foregroundColor: const Color(0xFF0369A1),
                                padding: const EdgeInsets.symmetric(vertical: 9),
                              ),
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
