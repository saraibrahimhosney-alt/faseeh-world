import 'package:flutter/material.dart';

void main() {
  runApp(const FaseehWorldApp());
}

class WordData {
  final String word;
  final String meaning;
  final String example;
  const WordData(this.word, this.meaning, this.example);
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
  const QuizData({
    required this.question,
    required this.options,
    required this.correct,
    required this.explanation,
  });
}

class StoryData {
  final String title;
  final List pages;
  final String moral;
  const StoryData({
    required this.title,
    required this.pages,
    required this.moral,
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
  int _currentIndex = 0;
  int _stars = 25;
  int _selectedAgeGroup = 0;
  String _speechText = 'أهلاً بك يا صديقي في عالم فصيح! اضغط على أي كلمة أو حلقة أو لعبة لنبدأ المغامرة معاً!';

  final List _ageGroups = [
    '4-6 سنوات (براعم)',
    '7-9 سنوات (فرسان)',
    '10-12 سنة (أدباء)',
  ];

  final List _episodes = const [
    EpisodeData(
      title: 'الحلقة 1: سرّ الغابة المضيئة',
      subtitle: 'مغامرة البحث عن الكنز اللغوي',
      duration: '12 دقيقة',
      description: 'يرافقنا البوم فصيح في رحلة ممتعة داخل الغابة المضيئة لنتعلم أسماء الطبيعة والأفعال العربية الفصيحة.',
      words: [
        WordData('وَهَج', 'ضوء ساطع وجميل', 'رأى فصيحُ وَهَجَ النجومِ في السماء.'),
        WordData('غَدِير', 'نهر صغير عذب الماء', 'شرب الأرنبُ من ماءِ الغَدِيرِ الصافي.'),
        WordData('حَفِيف', 'صوت أوراق الشجر', 'سمعنا حَفِيفَ الأشجارِ مع نسيم الصباح.'),
        WordData('تَآزُر', 'تعاون واتحاد القوة', 'بالتَّآزُرِ نجح الأصدقاءُ في عبور الجسر.'),
      ],
    ),
    EpisodeData(
      title: 'الحلقة 2: مدينة الحروف الذهبية',
      subtitle: 'أبطال الفصحى ينقذون كتاب الحكايات',
      duration: '15 دقيقة',
      description: 'تحدٍّ شيّق لاستعادة الحروف المفقودة من مكتبة المدينة القديمة وتكوين جمل عربية بليغة.',
      words: [
        WordData('فَصَاحَة', 'بيان ووضوح في الكلام', 'يتحدث البطلُ بِفَصَاحَةٍ وثقةٍ أمام الجميع.'),
        WordData('مِحْبَرَة', 'وعاء يوضع فيه الحبر للكتابة', 'كتب الجدُّ الحكايةَ بقلمٍ من المِحْبَرَةِ الذهبية.'),
        WordData('شَغَف', 'حب شديد وإقبال على التعلم', 'يقرأ الطفلُ القصصَ بِشَغَفٍ كبيرٍ كل مساء.'),
        WordData('إِثْرَاء', 'زيادة وتنمية المعرفة', 'تهدف القراءةُ إلى إِثْرَاءِ حصيلتنا اللغوية.'),
      ],
    ),
    EpisodeData(
      title: 'الحلقة 3: رحلة الفضاء العربي',
      subtitle: 'علماء الفلك الصغار بين الكواكب',
      duration: '14 دقيقة',
      description: 'ننطلق بمركبة فصيح الفضائية لاكتشاف أسماء النجوم والمجرات وتاريخ العلماء العرب.',
      words: [
        WordData('مَجَرَّة', 'تجمع هائل من النجوم والكواكب', 'تسبح مجموعتنا الشمسية في مَجَرَّةِ درب التبانة.'),
        WordData('مِجْهَر', 'آلة لتكبير الأشياء الدقيقة', 'فحص العالمُ العيناتِ باستخدام المِجْهَر.'),
        WordData('مِسْبَار', 'مركبة فضائية لاستكشاف الكواكب', 'هبط المِسْبَارُ على سطح كوكب المريخ بنجاح.'),
      ],
    ),
  ];

  final List _quizzes = const [
    QuizData(
      question: 'ما المعنى الدقيق لكلمة «غَدِير» في لغتنا الجميلة؟',
      options: [
        'مجرى ماء عذب وصغير 💧',
        'جبل شاهق الارتفاع ⛰️',
        'رياح قوية وعاصفة 🌪️',
      ],
      correct: 0,
      explanation: 'الغدير هو قطعة ماء يتركها السيل أو النهر الصغير العذب!',
    ),
    QuizData(
      question: 'أيّ جملة من الجمل التالية مكتوبة بالعربية الفصحى السليمة؟',
      options: [
        'الولد راح عالمدرسة بدري',
        'ذَهَبَ الطِّفْلُ إِلَى المَدْرَسَةِ مُبَكِّراً 🌟',
        'أيمتى رح نبلش اللعب؟',
      ],
      correct: 1,
      explanation: 'أحسنت! «ذَهَبَ الطِّفْلُ إِلَى المَدْرَسَةِ مُبَكِّراً» جملة فصيحة سليمة.',
    ),
    QuizData(
      question: 'ماذا نسمّي صوت حَرَكة أوراق الشجر عندما يمرّ بها الهواء؟',
      options: [
        'زئير',
        'خرير',
        'حَفِيف 🍃',
      ],
      correct: 2,
      explanation: 'حفيف هو صوت أوراق الشجر، بينما الخرير للماء والزئير للأسد!',
    ),
    QuizData(
      question: 'ما ضدّ كلمة «شُجَاع» في اللغة العربية؟',
      options: [
        'كَرِيم',
        'جَبَان',
        'سَرِيع',
      ],
      correct: 1,
      explanation: 'ضدّ شجاع هو جبان، والشجاعة صفة جميلة يتحلى بها أبطال فصيح!',
    ),
  ];

  final List _stories = const [
    StoryData(
      title: 'الأرنب الصغير وسر الجزرة الذهبية',
      pages: [
        'في صباحٍ مُشْرِقٍ، خَرَجَ الأرنبُ «فَصِيح» يَبْحَثُ عن طعامٍ في الحَقْلِ الأَخْضَرِ الوَاسِع.',
        'وَجَدَ فصيحُ جَزَرَةً كَبِيرَةً تَلْمَعُ تحتَ أَشِعَّةِ الشَّمْسِ، لكنَّها كانتْ عَالِقَةً في التُّرْبَة.',
        'نَادَى فصيحُ أَصْدِقَاءَهُ السِّنْجَابَ وَالسُّلَحْفَاةَ، وَقَالَ بِلُطْفٍ: «هَلْ تُسَاعِدُونَنِي يَا أَصْدِقَائِي؟».',
        'تَعَاوَنَ الجَمِيعُ بِهِمَّةٍ وَنَشَاطٍ حتَّى أَخْرَجُوا الجَزَرَةَ، وَتَقَاسَمُوهَا بِسَعَادَةٍ وَمَحَبَّة!',
      ],
      moral: 'الحكمة المستفادة: بالتعاون والكلمة الطيبة ننجز أصعب المهام.',
    ),
    StoryData(
      title: 'البوم الحكيم وطائر البلبل المغرّد',
      pages: [
        'كانَ البُلْبُلُ الصَّغِيرُ يَخْجَلُ من الغِنَاءِ أَمَامَ طُيُورِ الغَابَةِ خَوْفاً من الخَطَأ.',
        'اقْتَرَبَ منهُ البُومُ الحَكِيمُ وَقَالَ لَهُ: «صَوْتُكَ جَمِيلٌ يَا بُنَيَّ، وَالتَّجْرِبَةُ هِيَ طَرِيقُ النَّجَاح!».',
        'انْطَلَقَ البُلْبُلُ يُغَرِّدُ بِأَعْذَبِ الأَلْحَانِ الفَصِيحَةِ، فَصَفَّقَتْ لَهُ الطُّيُورُ بِإِعْجَابٍ شَدِيد.',
      ],
      moral: 'الحكمة المستفادة: الثقة بالنفس والمحاولة المستمرة تصنع الإبداع.',
    ),
  ];

  void _giveReward(int points, String message) {
    setState(() {
      _stars += points;
      _speechText = message;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
        content: Text(
          '🌟 أحسنت! +$points نجوم — $message',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            Text('🦉 ', style: TextStyle(fontSize: 26)),
            Text('عالم فصيح', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text('⭐ ', style: TextStyle(fontSize: 16)),
                Text(
                  '$_stars',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE0F2FE), Color(0xFFFEF3C7)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF7DD3FC), width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🦉', style: TextStyle(fontSize: 32)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'البوم فصيح يقول لك:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0369A1),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _speechText,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                      setState(() {
                        _selectedAgeGroup = idx;
                        _speechText = 'اخترت مستوى: $groupLabel — هيا ننطلق!';
                      });
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
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
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.play_lesson_rounded), label: 'الحلقات'),
          NavigationDestination(icon: Icon(Icons.extension_rounded), label: 'الألعاب'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'القصص'),
          NavigationDestination(icon: Icon(Icons.family_restroom_rounded), label: 'ركن الأهل'),
        ],
      ),
    );
  }

  Widget _buildHomeView() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _buildBannerCard(
          title: '🎬 الحلقات الكرتونية التفاعلية',
          subtitle: 'شاهد مغامرات فصيح واضغط على المفردات الفصيحة لتتعلمها',
          color: const Color(0xFF0284C7),
          icon: Icons.ondemand_video_rounded,
          onTap: () {
            setState(() {
              _currentIndex = 1;
            });
          },
        ),
        _buildBannerCard(
          title: '🎮 ألعاب وتحديات الفصحى',
          subtitle: 'اختبر ذكاءك اللغوي واجمع النجوم الذهبية مع كل إجابة صحيحة',
          color: const Color(0xFFD97706),
          icon: Icons.emoji_events_rounded,
          onTap: () {
            setState(() {
              _currentIndex = 2;
            });
          },
        ),
        _buildBannerCard(
          title: '📖 مكتبة القصص المصوّرة والمشكولة',
          subtitle: 'اقرأ قصصاً عربية مشوّقة بالحركات الكاملة واستفد من حكمتها',
          color: const Color(0xFF7C3AED),
          icon: Icons.auto_stories_rounded,
          onTap: () {
            setState(() {
              _currentIndex = 3;
            });
          },
        ),
        _buildBannerCard(
          title: '👨‍👩‍👧‍👦 لوحة متابعة الوالدين والمربين',
          subtitle: 'نصائح تربوية وتقرير تقدم الطفل في اكتساب اللغة العربية السليمة',
          color: const Color(0xFF059669),
          icon: Icons.verified_user_rounded,
          onTap: () {
            setState(() {
              _currentIndex = 4;
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  ep.description,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const Divider(height: 20),
                const Text(
                  'اضغط على الكلمات الفصيحة لتعلّمها وكسب النجوم:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF0284C7),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(ep.words.length, (int wIdx) {
                    final WordData item = ep.words[wIdx] as WordData;
                    return ActionChip(
                      backgroundColor: const Color(0xFFF0F9FF),
                      label: Text('🔊 ${item.word}: ${item.meaning}'),
                      onPressed: () {
                        _giveReward(2, 'مفردة: ${item.word} — مثال: ${item.example}');
                      },
                    );
                  }),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      _giveReward(5, 'أحسنت مشاهدة وتعلّم ${ep.title}!');
                    },
                    icon: const Icon(Icons.play_circle_fill_rounded),
                    label: const Text('إتمام الحلقة التفاعلية (+5 ⭐)'),
                  ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: List.generate(q.options.length, (int optIdx) {
                    final String optionText = q.options[optIdx].toString();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            if (optIdx == q.correct) {
                              _giveReward(10, 'ممتاز! ${q.explanation}');
                            } else {
                              setState(() {
                                _speechText = 'حاول مجدداً يا بطل الفصحى!';
                              });
                            }
                          },
                          child: Text(optionText),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📚 ${story.title}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C3AED),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(story.pages.length, (int pIdx) {
                    final String pageText = story.pages[pIdx].toString();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        pageText,
                        style: const TextStyle(
                          fontSize: 14.5,
                          height: 1.5,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    );
                  }),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '💡 ${story.moral}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D28D9),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      _giveReward(8, 'قرأت قصة «${story.title}» ببراعة!');
                    },
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('أنهيت قراءة القصة (+8 ⭐)'),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      'تقرير إنجاز الطفل اللغوي',
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
                  '🎯 الفئة العمرية المختارة: ${_ageGroups[_selectedAgeGroup]}',
                  style: const TextStyle(fontSize: 14),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 نصائح تربوية لتعزيز الفصحى في المنزل:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF0284C7),
                  ),
                ),
                SizedBox(height: 10),
                Text('1. خصصوا 15 دقيقة يومياً لمشاهدة حلقة من «عالم فصيح» ومناقشة كلماتها الجديدة.'),
                SizedBox(height: 6),
                Text('2. شجعوا الطفل على استخدام الكلمات الفصيحة المكتسبة في جمل من تأليفه على مائدة الطعام.'),
                SizedBox(height: 6),
                Text('3. اقرؤوا القصص المشكولة معاً بصوت معبّر لترسيخ مخارج الحروف السليمة.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
