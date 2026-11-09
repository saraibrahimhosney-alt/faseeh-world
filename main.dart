import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const FaseehWorldApp());
}

class WordData {
  final String word;
  final String meaning;
  final String example;
  final String audioKey;
  const WordData(this.word, this.meaning, this.example, this.audioKey);
}

class SongData {
  final String title;
  final String lyrics;
  final String audioKey;
  final String emoji;
  final Color color;
  const SongData({
    required this.title,
    required this.lyrics,
    required this.audioKey,
    required this.emoji,
    required this.color,
  });
}

class EpisodeData {
  final String title;
  final String subtitle;
  final String duration;
  final String description;
  final List words;
  const EpisodeData({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.description,
    required this.words,
  });
}

class QuizData {
  final String question;
  final List options;
  final int correct;
  final String explanation;
  final String audioKey;
  const QuizData({
    required this.question,
    required this.options,
    required this.correct,
    required this.explanation,
    required this.audioKey,
  });
}

class StoryData {
  final String title;
  final List pages;
  final String moral;
  final String audioKey;
  const StoryData({
    required this.title,
    required this.pages,
    required this.moral,
    required this.audioKey,
  });
}

class FaseehWorldApp extends StatelessWidget {
  const FaseehWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عالم فصيح - Faseeh World',
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
        child: FaseehMainScreen(),
      ),
    );
  }
}

class FaseehMainScreen extends StatefulWidget {
  const FaseehMainScreen({super.key});

  @override
  State createState() {
    return _FaseehMainScreenState();
  }
}

class _FaseehMainScreenState extends State {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  int _stars = 30;
  int _selectedAgeGroup = 0;
  bool _owlBig = false;
  String _owlEmoji = '🦉';
  String _lastAudioKey = 'welcome';
  String _speechText = 'أَهْلاً بِكَ يَا صَدِيقِي البَطَلَ فِي عَالَمِ فَصِيح! اضْغَطْ عَلَى أَيِّ بِطَاقَةٍ أَوْ أُنْشُودَةٍ لِتَسْمَعَ صَوْتِي!';

  final List _ageGroups = [
    '4-6 سنوات (براعم)',
    '7-9 سنوات (فرسان)',
    '10-12 سنة (أدباء)',
  ];

  final List _songs = const [
    SongData(
      title: 'أُنْشُودَةُ حُرُوفِ الهِجَاءِ',
      lyrics: 'أَلِفٌ أَرْنَبْ، يَجْرِي يَلْعَبْ، يَأْكُلُ جَزَراً كَيْ لَا يَتْعَبْ!\nبَاءٌ بَطَّةْ، نَطَّتْ نَطَّةْ، وَقَعَتْ ضَحِكَتْ مِنْهَا القِطَّةْ!\nتَاءٌ تَاجْ، فَوْقَ الرَّأْسْ، فِيهِ الذَّهَبُ وَفِيهِ المَاسْ!',
      audioKey: 'song_alphabet',
      emoji: '🐰',
      color: Color(0xFFEC4899),
    ),
    SongData(
      title: 'أُنْشُودَةُ شَمْسِ الصَّبَاحِ',
      lyrics: 'أَشْرَقَتِ الشَّمْسُ الذَّهَبِيَّةْ، وَتَغَنَّتْ طَيْرُ الحُرِّيَّةْ!\nهَيَّا نَتَعَلَّمْ يَا أَطْفَالْ، لُغَتِي الفُصْحَى أَجْمَلُ حَالْ!',
      audioKey: 'song_morning',
      emoji: '☀️',
      color: Color(0xFFF59E0B),
    ),
    SongData(
      title: 'أُنْشُودَةُ الأَرْقَامِ الفَصِيحَةِ',
      lyrics: 'وَاحِدٌ اثْنَانِ ثَلَاثَةْ، نَتَعَلَّمُ بِذَكَاءٍ وَحَمَاسَةْ!\nأَرْبَعَةٌ خَمْسَةٌ سِتَّةْ، نَقْرَأُ فِي البُسْتَانِ القِصَّةْ!',
      audioKey: 'song_numbers',
      emoji: '🔢',
      color: Color(0xFF8B5CF6),
    ),
  ];

  final List _episodes = const [
    EpisodeData(
      title: 'الحلقة 1: سرّ الغابة المضيئة',
      subtitle: 'مغامرة البحث عن الكنز اللغوي',
      duration: '12 دقيقة',
      description: 'يرافقنا البوم فصيح في رحلة ممتعة داخل الغابة المضيئة لنتعلم أسماء الطبيعة والأفعال العربية الفصيحة بالصوت الطبيعي.',
      words: [
        WordData('وَهَجٌ', 'ضوء ساطع وجميل', 'رَأَى فَصِيحٌ وَهَجَ النُّجُومِ فِي السَّمَاءِ.', 'word_wahaj'),
        WordData('غَدِيرٌ', 'نهر صغير عذب الماء', 'شَرِبَ الأَرْنَبُ مِنْ مَاءِ الغَدِيرِ الصَّافِي.', 'word_ghadeer'),
        WordData('حَفِيفٌ', 'صوت أوراق الشجر', 'سَمِعْنَا حَفِيفَ الأَشْجَارِ مَعَ نَسِيمِ الصَّبَاحِ.', 'word_hafeef'),
        WordData('تَآزُرٌ', 'تعاون واتحاد القوة', 'بِالتَّآزُرِ نَجَحَ الأَصْدِقَاءُ فِي عُبُورِ الجِسْرِ.', 'word_taazur'),
      ],
    ),
    EpisodeData(
      title: 'الحلقة 2: مدينة الحروف الذهبية',
      subtitle: 'أبطال الفصحى ينقذون كتاب الحكايات',
      duration: '15 دقيقة',
      description: 'تحدٍّ شيّق لاستعادة الحروف المفقودة من مكتبة المدينة القديمة وتكوين جمل عربية بليغة.',
      words: [
        WordData('فَصَاحَةٌ', 'بيان ووضوح في الكلام', 'يَتَحَدَّثُ البَطَلُ بِفَصَاحَةٍ وَثِقَةٍ أَمَامَ الجَمِيعِ.', 'word_fasaha'),
        WordData('مِحْبَرَةٌ', 'وعاء يوضع فيه الحبر للكتابة', 'كَتَبَ الجَدُّ الحِكَايَةَ بِقَلَمٍ مِنَ المِحْبَرَةِ الذَّهَبِيَّةِ.', 'word_mihbara'),
        WordData('شَغَفٌ', 'حب شديد وإقبال على التعلم', 'يَقْرَأُ الطِّفْلُ القِصَصَ بِشَغَفٍ كَبِيرٍ كُلَّ مَسَاءٍ.', 'word_shaghaf'),
      ],
    ),
    EpisodeData(
      title: 'الحلقة 3: رحلة الفضاء العربي',
      subtitle: 'علماء الفلك الصغار بين الكواكب',
      duration: '14 دقيقة',
      description: 'ننطلق بمركبة فصيح الفضائية لاكتشاف أسماء النجوم والمجرات وتاريخ العلماء العرب.',
      words: [
        WordData('مَجَرَّةٌ', 'تجمع هائل من النجوم والكواكب', 'تَسْبَحُ الأَرْضُ فِي مَجَرَّةِ دَرْبِ التَّبَّانَةِ.', 'word_majarra'),
        WordData('مِسْبَارٌ', 'مركبة فضائية لاستكشاف الكواكب', 'هَبَطَ المِسْبَارُ عَلَى سَطْحِ كَوْكَبِ المِرِّيخِ بِنَجَاحٍ.', 'word_misbar'),
      ],
    ),
  ];

  final List _quizzes = const [
    QuizData(
      question: 'مَا المَعْنَى الدَّقِيقُ لِكَلِمَةِ «غَدِير» فِي لُغَتِنَا الجَمِيلَةِ؟',
      options: [
        'مَجْرَى مَاءٍ عَذْبٍ وَصَغِيرٍ 💧',
        'جَبَلٌ شَاهِقُ الارْتِفَاعِ ⛰️',
        'رِيَاحٌ قَوِيَّةٌ وَعَاصِفَةٌ 🌪️',
      ],
      correct: 0,
      explanation: 'الغَدِيرُ هُوَ نَهْرٌ صَغِيرٌ عَذْبُ المَاءِ!',
      audioKey: 'quiz_1',
    ),
    QuizData(
      question: 'أَيُّ جُمْلَةٍ مِنَ الجُمَلِ التَّالِيَةِ مَكْتُوبَةٌ بِالعَرَبِيَّةِ الفُصْحَى السَّلِيمَةِ؟',
      options: [
        'الولد راح عالمدرسة بدري',
        'ذَهَبَ الطِّفْلُ إِلَى المَدْرَسَةِ مُبَكِّراً 🌟',
        'أيمتى رح نبلش اللعب؟',
      ],
      correct: 1,
      explanation: 'أَحْسَنْتَ! «ذَهَبَ الطِّفْلُ إِلَى المَدْرَسَةِ مُبَكِّراً» جُمْلَةٌ فَصِيحَةٌ سَلِيمَةٌ.',
      audioKey: 'quiz_2',
    ),
    QuizData(
      question: 'مَاذَا نُسَمِّي صَوْتَ حَرَكَةِ أَوْرَاقِ الشَّجَرِ عِنْدَمَا يَمُرُّ بِهَا الهَوَاءُ؟',
      options: [
        'زَئِيرٌ',
        'خَرِيرٌ',
        'حَفِيفٌ 🍃',
      ],
      correct: 2,
      explanation: 'حَفِيفٌ هُوَ صَوْتُ أَوْرَاقِ الشَّجَرِ!',
      audioKey: 'quiz_3',
    ),
    QuizData(
      question: 'مَا ضِدُّ كَلِمَةِ «شُجَاع» فِي اللُّغَةِ العَرَبِيَّةِ؟',
      options: [
        'كَرِيمٌ',
        'جَبَانٌ',
        'سَرِيعٌ',
      ],
      correct: 1,
      explanation: 'ضِدُّ شُجَاعٍ هُوَ جَبَانٌ، وَالشَّجَاعَةُ صِفَةٌ جَمِيلَةٌ!',
      audioKey: 'quiz_4',
    ),
  ];

  final List _stories = const [
    StoryData(
      title: 'الأَرْنَبُ الصَّغِيرُ وَسِرُّ الجَزَرَةِ الذَّهَبِيَّةِ',
      pages: [
        'فِي صَبَاحٍ مُشْرِقٍ، خَرَجَ الأَرْنَبُ «فَصِيحٌ» يَبْحَثُ عَنْ طَعَامٍ فِي الحَقْلِ الأَخْضَرِ الوَاسِعِ.',
        'وَجَدَ فَصِيحٌ جَزَرَةً كَبِيرَةً تَلْمَعُ تَحْتَ أَشِعَّةِ الشَّمْسِ، لَكِنَّهَا كَانَتْ عَالِقَةً فِي التُّرْبَةِ.',
        'نَادَى فَصِيحٌ أَصْدِقَاءَهُ السِّنْجَابَ وَالسُّلَحْفَاةَ، وَقَالَ بِلُطْفٍ: «هَلْ تُسَاعِدُونَنِي يَا أَصْدِقَائِي؟».',
        'تَعَاوَنَ الجَمِيعُ بِهِمَّةٍ وَنَشَاطٍ حَتَّى أَخْرَجُوا الجَزَرَةَ، وَتَقَاسَمُوهَا بِسَعَادَةٍ وَمَحَبَّةٍ!',
      ],
      moral: 'الحِكْمَةُ المُسْتَفَادَةُ: بِالتَّعَاوُنِ وَالكَلِمَةِ الطَّيِّبَةِ نُنْجِزُ أَصْعَبَ المَهَامِّ.',
      audioKey: 'story_rabbit',
    ),
    StoryData(
      title: 'البُومُ الحَكِيمُ وَطَائِرُ البُلْبُلِ المُغَرِّدِ',
      pages: [
        'كَانَ البُلْبُلُ الصَّغِيرُ يَخْجَلُ مِنَ الغِنَاءِ أَمَامَ طُيُورِ الغَابَةِ خَوْفاً مِنَ الخَطَأِ.',
        'اقْتَرَبَ مِنْهُ البُومُ الحَكِيمُ وَقَالَ لَهُ: «صَوْتُكَ جَمِيلٌ يَا بُنَيَّ، وَالتَّجْرِبَةُ هِيَ طَرِيقُ النَّجَاحِ!».',
        'انْطَلَقَ البُلْبُلُ يُغَرِّدُ بِأَعْذَبِ الأَلْحَانِ الفَصِيحَةِ، فَصَفَّقَتْ لَهُ الطُّيُورُ بِإِعْجَابٍ شَدِيدٍ.',
      ],
      moral: 'الحِكْمَةُ المُسْتَفَادَةُ: الثِّقَةُ بِالنَّفْسِ وَالمُحَاوَلَةُ المُسْتَمِرَّةُ تَصْنَعُ الإِبْدَاعَ.',
      audioKey: 'story_owl',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () {
      _playAudioClip('welcome', _speechText, '🦉');
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future _playAudioClip(String audioKey, String textToShow, String emoji) async {
    setState(() {
      _speechText = textToShow;
      _owlEmoji = emoji;
      _lastAudioKey = audioKey;
      _owlBig = true;
    });
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('audio/$audioKey.mp3'));
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        setState(() {
          _owlBig = false;
        });
      }
    });
  }

  void _giveReward(int points, String message, String audioKey, String emoji) {
    setState(() {
      _stars += points;
    });
    _playAudioClip(audioKey, message, emoji);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 2),
        content: Text(
          '🌟 رائع يا بطل! +$points نجوم — $message',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0284C7),
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Text('🦉 ', style: TextStyle(fontSize: 28)),
            Text('عالم فصيح', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'إعادة سماع الصوت',
            onPressed: () {
              _playAudioClip(_lastAudioKey, _speechText, '🎵');
            },
            icon: const Icon(Icons.volume_up_rounded, size: 28),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text('⭐ ', style: TextStyle(fontSize: 17)),
                Text(
                  '$_stars',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              _playAudioClip(_lastAudioKey, _speechText, '🤩');
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE0F2FE), Color(0xFFFEF3C7)],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF38BDF8), width: 2),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    padding: EdgeInsets.all(_owlBig ? 14 : 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _owlEmoji,
                      style: TextStyle(fontSize: _owlBig ? 42 : 34),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.record_voice_over_rounded, size: 16, color: Color(0xFF0369A1)),
                            SizedBox(width: 6),
                            Text(
                              'فصيح يتحدث معك (اضغط للسماع):',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0369A1),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _speechText,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(_ageGroups.length, (int idx) {
                final bool selected = _selectedAgeGroup == idx;
                final String groupLabel = _ageGroups[idx].toString();
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(groupLabel),
                    selected: selected,
                    selectedColor: const Color(0xFF0284C7),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF0F172A),
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (bool _) {
                      _playAudioClip(
                        'welcome',
                        'اخترت مرحلة: $groupLabel — هيا نغني ونتعلم الفصحى!',
                        '🦉',
                      );
                      setState(() {
                        _selectedAgeGroup = idx;
                      });
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildHomeView(),
                _buildEpisodesView(),
                _buildGamesView(),
                _buildStoriesView(),
                _buildParentsView(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int val) {
          setState(() {
            _currentIndex = val;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.music_note_rounded), label: 'الرئيسية والأغاني'),
          NavigationDestination(icon: Icon(Icons.play_lesson_rounded), label: 'الحلقات'),
          NavigationDestination(icon: Icon(Icons.extension_rounded), label: 'الألعاب'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'القصص المسموعة'),
          NavigationDestination(icon: Icon(Icons.family_restroom_rounded), label: 'ركن الأهل'),
        ],
      ),
    );
  }

  Widget _buildHomeView() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            '🎵 أناشيد وأغاني عالم فصيح (على طريقة لولو كيدز):',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        Column(
          children: List.generate(_songs.length, (int sIdx) {
            final SongData song = _songs[sIdx] as SongData;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: song.color.withAlpha(90), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: song.color.withAlpha(35),
                          child: Text(song.emoji, style: const TextStyle(fontSize: 28)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            song.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: song.color,
                            ),
                          ),
                        ),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(backgroundColor: song.color),
                          onPressed: () {
                            _giveReward(5, song.lyrics, song.audioKey, '🎵');
                          },
                          icon: const Icon(Icons.volume_up_rounded),
                          label: const Text('استمع 🔊'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      song.lyrics,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            '🚀 أقسام المغامرات التفاعلية:',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        _buildBannerCard(
          title: '🎬 الحلقات والمفردات الناطقة',
          subtitle: 'اضغط على أي كلمة عربية لتسمع نطقها الفصيح مع مثال كامل',
          color: const Color(0xFF0284C7),
          icon: Icons.ondemand_video_rounded,
          onTap: () {
            setState(() {
              _currentIndex = 1;
            });
          },
        ),
        _buildBannerCard(
          title: '🎮 ألعاب وتحديات الفصحى الصوتية',
          subtitle: 'استمع إلى السؤال بصوت فصيح واختر الإجابة الصحيحة لتفوز بالنجوم',
          color: const Color(0xFFD97706),
          icon: Icons.emoji_events_rounded,
          onTap: () {
            setState(() {
              _currentIndex = 2;
            });
          },
        ),
        _buildBannerCard(
          title: '📖 مكتبة القصص المسموعة والمشكولة',
          subtitle: 'استمع إلى الحكايات العربية المشوّقة بصوت طبيعي دافئ',
          color: const Color(0xFF7C3AED),
          icon: Icons.auto_stories_rounded,
          onTap: () {
            setState(() {
              _currentIndex = 3;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBannerCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(38),
          radius: 26,
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle, style: const TextStyle(fontSize: 13.5)),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 18),
        onTap: onTap,
      ),
    );
  }

  Widget _buildEpisodesView() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _episodes.length,
      itemBuilder: (BuildContext ctx, int i) {
        final EpisodeData ep = _episodes[i] as EpisodeData;
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(ep.subtitle),
                      backgroundColor: const Color(0xFFE0F2FE),
                    ),
                    Text(
                      '⏱️ ${ep.duration}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  ep.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  ep.description,
                  style: const TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
                ),
                const Divider(height: 20),
                const Text(
                  '🔊 اضغط على أي كلمة لسماع نطقها الطبيعي ومثالها:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF0284C7),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(ep.words.length, (int wIdx) {
                    final WordData item = ep.words[wIdx] as WordData;
                    return ActionChip(
                      backgroundColor: const Color(0xFFE0F2FE),
                      label: Text(
                        '🔊 ${item.word} (${item.meaning})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      onPressed: () {
                        _giveReward(
                          3,
                          '${item.word}: ${item.meaning} — ${item.example}',
                          item.audioKey,
                          '🦉',
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGamesView() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _quizzes.length,
      itemBuilder: (BuildContext ctx, int i) {
        final QuizData q = _quizzes[i] as QuizData;
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFFEF3C7),
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        q.question,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5),
                      ),
                    ),
                    IconButton(
                      tooltip: 'سماع السؤال بالصوت',
                      onPressed: () {
                        _playAudioClip(q.audioKey, q.question, '🤔');
                      },
                      icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF0284C7)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: List.generate(q.options.length, (int optIdx) {
                    final String optionText = q.options[optIdx].toString();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            if (optIdx == q.correct) {
                              _giveReward(10, q.explanation, 'bravo', '🥳');
                            } else {
                              _playAudioClip('try_again', 'حاول مرة أخرى يا بطل الفصحى!', '💪');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              optionText,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoriesView() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _stories.length,
      itemBuilder: (BuildContext ctx, int i) {
        final StoryData story = _stories[i] as StoryData;
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '📚 ${story.title}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                      ),
                      onPressed: () {
                        _giveReward(
                          8,
                          'تستمع الآن إلى: ${story.title}',
                          story.audioKey,
                          '📖',
                        );
                      },
                      icon: const Icon(Icons.volume_up_rounded),
                      label: const Text('استمع للقصة 🔊'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(story.pages.length, (int pIdx) {
                    final String pageText = story.pages[pIdx].toString();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        pageText,
                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.6,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    );
                  }),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '💡 ${story.moral}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D28D9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParentsView() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.insights_rounded, color: Color(0xFFF59E0B)),
                    SizedBox(width: 8),
                    Text(
                      'تقرير إنجاز الطفل اللغوي والصوتي',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Text(
                  '⭐ مجموع النجوم المكتسبة: $_stars نجمة ذهبية',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  '🎯 المرحلة العمرية الحالية: ${_ageGroups[_selectedAgeGroup]}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 6),
                const Text(
                  '🔊 نظام الصوت: ملفات صوتية عربية فصيحة طبيعية مدمجة تعمل بدون إنترنت.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF0284C7)),
                ),
                const SizedBox(height: 6),
                const Text(
                  '🛡️ بيئة آمنة 100% خالية من الإعلانات والمحتوى غير المناسب.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF059669)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 نصائح تربوية لتعزيز الفصحى بأسلوب لولو كيدز:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF0284C7),
                  ),
                ),
                SizedBox(height: 10),
                Text('1. ابدؤوا بتشغيل أناشيد فصيح اليومية وترديدها مع الطفل بحركات مرحة.'),
                SizedBox(height: 6),
                Text('2. اضغطوا على الكلمات الناطقة في قسم الحلقات وشجعوا الطفل على تقليد النطق السليم.'),
                SizedBox(height: 6),
                Text('3. استمعوا معاً إلى القصص المسموعة قبل النوم لتعزيز الخيال والحصيلة اللغوية.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
