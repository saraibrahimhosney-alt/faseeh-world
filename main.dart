import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const FaseehWorldApp());
}

class MediaItem {
  final String title;
  final String audioFile;
  final String imageFile;

  const MediaItem({
    required this.title,
    required this.audioFile,
    required this.imageFile,
  });
}

class FaseehWorldApp extends StatelessWidget {
  const FaseehWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عالم فصيح',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
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
  final AudioPlayer _mainPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  String _section = 'home'; // home, songs, stories, games
  String _speechText = 'أَهْلاً بِكُمْ فِي عَالَمِ فَصِيح! اخْتَرْ جَزِيرَةً لِنَبْدَأَ!';
  String? _playingFile;

  // الأناشيد الثلاثة المرفوعة في مستودعكِ
  final List<MediaItem> _songs = const [
    MediaItem(title: 'أُنْشُودَةُ الْحُرُوفِ', audioFile: 'song_alphabet.mp3', imageFile: 'card_songs.png'),
    MediaItem(title: 'أُنْشُودَةُ الصَّبَاحِ', audioFile: 'song_morning.mp3', imageFile: 'card_songs.png'),
    MediaItem(title: 'أُنْشُودَةُ الْأَرْقَامِ', audioFile: 'song_numbers.mp3', imageFile: 'card_songs.png'),
  ];

  // القصتان المرفوعتان في مستودعكِ
  final List<MediaItem> _stories = const [
    MediaItem(title: 'قِصَّةُ الْبُومَةِ فَصِيح', audioFile: 'story_owl.mp3', imageFile: 'card_stories.png'),
    MediaItem(title: 'قِصَّةُ الْأَرْنَبِ الذَّكِيّ', audioFile: 'story_rabbit.mp3', imageFile: 'card_stories.png'),
  ];

  @override
  void initState() {
    super.initState();
    // تشغيل صوت الترحيب تلقائياً عند فتح التطبيق
    Future.delayed(const Duration(milliseconds: 600), () {
      _playAudio('welcome.mp3', 'أَهْلاً بِكُمْ فِي عَالَمِ فَصِيح! 🦉✨');
    });
  }

  @override
  void dispose() {
    _mainPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSfx(String file) async {
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource(file));
  }

  Future<void> _playAudio(String file, String message) async {
    await _mainPlayer.stop();
    setState(() {
      _playingFile = file;
      _speechText = message;
    });
    await _mainPlayer.play(AssetSource(file));
    _mainPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _playingFile = null);
      }
    });
  }

  Future<void> _stopAudio() async {
    await _mainPlayer.stop();
    setState(() => _playingFile = null);
  }

  void _changeSection(String newSection, String message) {
    _stopAudio();
    setState(() {
      _section = newSection;
      _speechText = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('forest_bg.png', fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        _buildSideButtons(),
                        const SizedBox(width: 12),
                        Expanded(flex: 3, child: _buildMainBoard()),
                        const SizedBox(width: 10),
                        Expanded(flex: 2, child: _buildOwlMascot()),
                      ],
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: const Text(
            'عَالَمُ فَصِيح 🦉',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        InkWell(
          onTap: () => _changeSection('home', 'أَهْلاً بِكُمْ فِي عَالَمِ فَصِيح! اخْتَرْ جَزِيرَةً لِنَبْدَأَ!'),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5722),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(Icons.home_rounded, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildSideButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _islandCard(
          title: 'جَزِيرَةُ الْأَنَاشِيد',
          imagePath: 'card_songs.png',
          color: const Color(0xFF9C27B0),
          onTap: () => _changeSection('songs', 'اخْتَرْ أُنْشُودَةً لِنُغَنِّيَ مَعًا! 🎵'),
        ),
        _islandCard(
          title: 'جَزِيرَةُ الْقِصَص',
          imagePath: 'card_stories.png',
          color: const Color(0xFFFF9800),
          onTap: () => _changeSection('stories', 'اخْتَرْ قِصَّةً مُشَوِّقَةً لِتَسْتَمِعَ إِلَيْهَا! 📖'),
        ),
        _islandCard(
          title: 'جَزِيرَةُ الْأَلْعَاب',
          icon: Icons.extension_rounded,
          color: const Color(0xFF00C853),
          onTap: () => _changeSection('games', 'أَيْنَ حَرْفُ الْأَلِف (أ)؟ 🧩'),
        ),
      ],
    );
  }

  Widget _islandCard({
    required String title,
    String? imagePath,
    IconData? icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 135,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 3))],
        ),
        child: Column(
          children: [
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imagePath, width: 42, height: 42, fit: BoxFit.cover),
              )
            else
              Icon(icon, color: Colors.white, size: 36),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainBoard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.93),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF2196F3), width: 6),
      ),
      child: _buildBoardBody(),
    );
  }

  Widget _buildBoardBody() {
    if (_section == 'songs') {
      return _buildMediaList(_songs, const Color(0xFF7B1FA2));
    }
    if (_section == 'stories') {
      return _buildMediaList(_stories, const Color(0xFFE65100));
    }
    if (_section == 'games') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'أَيْنَ حَرْفُ (أ) أَرْنَب؟ 🐇',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _letterButton('ب', false),
              _letterButton('أ', true),
              _letterButton('ت', false),
            ],
          ),
        ],
      );
    }

    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('أَ   بُ   تُ', style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F))),
        SizedBox(height: 8),
        Text('أَرْنَبْ   •   أَسَدْ', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildMediaList(List<MediaItem> items, Color themeColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              final isThisPlaying = _playingFile == item.audioFile;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: themeColor, width: 2),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(item.imageFile, width: 46, height: 46, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeColor),
                      ),
                    ),
                    IconButton(
                      iconSize: 36,
                      color: isThisPlaying ? Colors.red : Colors.green,
                      icon: Icon(isThisPlaying ? Icons.stop_circle_rounded : Icons.play_circle_fill_rounded),
                      onPressed: () {
                        if (isThisPlaying) {
                          _stopAudio();
                        } else {
                          _playAudio(item.audioFile, 'نَسْتَمِعُ الْآنَ إِلَى ${item.title} 🎶');
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _letterButton(String letter, bool isCorrect) {
    return InkWell(
      onTap: () {
        if (isCorrect) {
          _playSfx('bravo.mp3');
          setState(() => _speechText = 'بِرَافُو! إِجَابَةٌ صَحِيحَةٌ يَا بَطَل! 🌟👏');
        } else {
          _playSfx('try_again.mp3');
          setState(() => _speechText = 'حَاوِلْ مَرَّةً أُخْرَى يَا ذَكِيّ! 🦉❤️');
        }
      },
      child: Container(
        width: 75,
        height: 75,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFFF7043),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Text(letter, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildOwlMascot() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF9C27B0), width: 3),
          ),
          child: Text(
            _speechText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: GestureDetector(
            onTap: () => _playAudio('welcome.mp3', 'أَهْلاً بِكُمْ فِي عَالَمِ فَصِيح! 🦉✨'),
            child: Image.asset('owl_mascot.png', fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}
