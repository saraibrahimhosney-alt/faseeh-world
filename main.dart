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

class StoryItem {
  final String title;
  final String moral;
  final String summary;
  final String audioFile;
  final Color color;
  const StoryItem({
    required this.title,
    required this.moral,
    required this.summary,
    required this.audioFile,
    required this.color,
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
  int _screenIndex = 0; // 0: الساحة الرئيسية, 1: الأناشيد, 2: القصص, 3: الألعاب
  int _stars = 30;
  bool _isPlaying = false;
  bool _owlBounce = false;
  String _currentTrack = 'welcome.mp3';
  String _owlBubble = 'أَهْلاً بِكَ فِي عَالَمِ فَصِيح! اخْتَرْ جَزِيرَةَ الأَنَاشِيدِ أَوِ القِصَصِ أَوِ الأَلْعَابِ!';

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

  final List _stories = const [
    StoryItem(
      title: 'الأَرْنَبُ الصَّغِيرُ وَسِرُّ الجَزَرَةِ الذَّهَبِيَّةِ',
      moral: 'بِالتَّعَاوُنِ وَالكَلِمَةِ الطَّيِّبَةِ نُنْجِزُ أَصْعَبَ المَهَامِّ',
      summary: 'حِكَايَةٌ مَرِحَةٌ عَنْ تَعَاوُنِ أَصْدِقَاءِ الغَابَةِ المَضِيئَةِ لإِخْرَاجِ الجَزَرَةِ الذَّهَبِيَّةِ.',
      audioFile: 'story_rabbit.mp3',
      color: Color(0xFF10B981),
    ),
    StoryItem(
      title: 'البُومُ الحَكِيمُ وَطَائِرُ البُلْبُلِ المُغَرِّدِ',
      moral: 'الثِّقَةُ بِالنَّفْسِ وَالمُحَاوَلَةُ المُسْتَمِرَّةُ تَصْنَعُ الإِبْدَاعَ',
      summary: 'كَيْفَ شَجَّعَ البُومُ الحَكِيمُ البُلْبُلَ الصَّغِيرَ حَتَّى غَرَّدَ بِأَعْذَبِ الأَلْحَانِ الفَصِيحَةِ.',
      audioFile: 'story_owl.mp3',
      color: Color(0xFF7C3AED),
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
    super.dispose();
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
            color: Colors.black.withAlpha(55),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  setState(() {
                    _screenIndex = 0;
                  });
                },
                icon: const Icon(Icons.home_rounded, size: 26),
                label: const Text('الرئيسية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                  border: Border.all(color: const Color(0xFFFBBF24), width: 3),
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/owl_mascot.png',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(235),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF38BDF8), width: 2),
              ),
              child: Text(
                _owlBubble,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: _isPlaying ? const Color(0xFFEF4444) : const Color(0xFF10B981),
            ),
            onPressed: _toggleStopPlay,
            icon: Icon(_isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded, size: 28),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 2),
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
      return _buildStoriesStage();
    } else if (_screenIndex == 3) {
      return _buildGamesStage();
    }
    return _buildMainLobby();
  }

  Widget _buildMainLobby() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildPortalCard(
              title: '🎵 أناشيد وأغاني فصيح',
              subtitle: 'أغانٍ مرحة بالألحان والحروف',
              imagePath: 'assets/images/card_songs.png',
              borderColor: const Color(0xFFEC4899),
              onTap: () {
                setState(() {
                  _screenIndex = 1;
                });
                _playMedia('song_alphabet.mp3', 'هَيَّا نُغَنِّي مَعاً أَنَاشِيدَ عَالَمِ فَصِيح!', 2);
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 3,
            child: _buildPortalCard(
              title: '📖 حكايات الغابة المسموعة',
              subtitle: 'قصص شيّقة بالصوت الدافئ',
              imagePath: 'assets/images/card_stories.png',
              borderColor: const Color(0xFF8B5CF6),
              onTap: () {
                setState(() {
                  _screenIndex = 2;
                });
                _playMedia('story_rabbit.mp3', 'اجْلِسْ بِهُدُوءٍ وَاسْتَمِعْ إِلَى حِكَايَاتِ الغَابَةِ المَضِيئَةِ!', 2);
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: _buildGamesPortalCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildPortalCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor, width: 4),
          boxShadow: const [
            BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withAlpha(210), Colors.transparent],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGamesPortalCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _screenIndex = 3;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0284C7), Color(0xFF059669)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFFBBF24), width: 4),
          boxShadow: const [
            BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/owl_mascot.png',
                width: 96,
                height: 96,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '🎮 تحديات فصيح',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'العب واجمع النجوم الذهبية!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFFEF08A), fontWeight: FontWeight.bold, fontSize: 13),
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
                    color: Colors.white.withAlpha(242),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: active ? const Color(0xFFF59E0B) : s.color, width: active ? 5 : 3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(s.emoji, style: const TextStyle(fontSize: 44)),
                      Text(
                        s.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: s.color),
                      ),
                      Text(
                        s.lyrics,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13.5, height: 1.45, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
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

  Widget _buildStoriesStage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Row(
        children: List.generate(_stories.length, (int i) {
          final StoryItem st = _stories[i] as StoryItem;
          final bool active = _currentTrack == st.audioFile && _isPlaying;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(245),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: st.color, width: 4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset('assets/images/card_stories.png', width: 84, height: 64, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            st.title,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: st.color),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      st.summary,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: st.color.withAlpha(30),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '💡 ${st.moral}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, color: st.color, fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: st.color,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          _playMedia(st.audioFile, 'تستمع الآن إلى: ${st.title}', 8);
                        },
                        icon: Icon(active ? Icons.graphic_eq_rounded : Icons.headphones_rounded, size: 26),
                        label: Text(active ? 'الراوي يحكي القصة...' : 'استمع للحكاية كاملة (+8 ⭐)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
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
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xFFF59E0B), width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(q.emoji, style: const TextStyle(fontSize: 38)),
                    Text(
                      q.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
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
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              onPressed: () {
                                if (optIdx == q.correctIndex) {
                                  _playMedia('bravo.mp3', 'أَحْسَنْتَ يَا بَطَلَ الفُصْحَى! +10 نُجُوم!', 10);
                                } else {
                                  _playMedia('try_again.mp3', 'لَا بَأْسَ يَا صَدِيقِي! حَاوِلْ مَرَّةً أُخْرَى!', 0);
                                }
                              },
                              child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
