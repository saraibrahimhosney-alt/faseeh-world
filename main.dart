import 'package:flutter/material.dart';

void main() {
  runApp(const FaseehWorldApp());
}

class FaseehWorldApp extends StatelessWidget {
  const FaseehWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عالم فصيح',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
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
  State<FaseehMainScreen> createState() => _FaseehMainScreenState();
}

class _FaseehMainScreenState extends State<FaseehMainScreen> {
  int _currentIndex = 0;
  int _stars = 45;
  int _selectedAge = 1;
  String _speechText = 'مرحباً يا بطل الفصحى! اختر قسماً لنبدأ الرحلة!';

  final List<String> _ageGroups = [
    '٣ - ٥ سنوات 🌱',
    '٦ - ٨ سنوات 🚀',
    '٩ - ١٢ سنة 🌟'
  ];

  final List> _episodes = [
    {
      'title': 'فصيح في البُسْتان الجميل',
      'duration': '٠٣:٤٥ دقيقة',
      'description': 'يتجول فصيح بين الأشجار ليتعلم أسماء الفواكه والأشجار والطيور بالعربية الفصحى.',
      'words': [
        {'word': 'بُسْتان', 'meaning': 'حديقة واسعة غنّاء مليئة بالأشجار والأزهار', 'example': 'ذَهَبَ فَصِيحٌ إِلَى البُسْتانِ العَطِرِ.'},
        {'word': 'تُفَّاحَة', 'meaning': 'فاكهة مستديرة لذيذة غنية بالفيتامينات', 'example': 'قَطَفَ الطِّفْلُ تُفَّاحَةً حَمْرَاءَ نَاضِجَةً.'},
        {'word': 'غَدِير', 'meaning': 'نهر صغير أو مجرى ماء عذب وصافٍ', 'example': 'شَرِبَتِ العَصَافِيرُ مِنْ مَاءِ الغَدِيرِ.'},
      ]
    },
    {
      'title': 'مغامرة فصيح في الفضاء الخارجي',
      'duration': '٠٤:٣٠ دقيقة',
      'description': 'يركب فصيح مركبته الفضائية ليكتشف الكواكب والنجوم وأسرار المجرة الكبرى.',
      'words': [
        {'word': 'مَجَرَّة', 'meaning': 'نظام كوني هائل يضم مليارات النجوم والكواكب', 'example': 'كَوْكَبُ الأَرْضِ يَنْتَمِي لِمَجَرَّةِ دَرْبِ التَّبَّانَةِ.'},
        {'word': 'مِرْصَد', 'meaning': 'مبنى خاص مجهز لمراقبة النجوم والظواهر الفلكية', 'example': 'شَاهَدْنَا خُسُوفَ القَمَرِ عَبْرَ المِرْصَدِ.'},
      ]
    },
    {
      'title': 'مملكة النحل والعمل الدؤوب',
      'duration': '٠٥:١٠ دقيقة',
      'description': 'يتعلم فصيح كيف يتعاون النحل داخل الخلية لإنتاج العسل الصافي اللذيذ.',
      'words': [
        {'word': 'يَعْسُوب', 'meaning': 'أمير النحل أو ملكته التي ترعى الخلية', 'example': 'تَلْتَفُّ النَّحَلَاتُ حَوْلَ اليَعْسُوبِ بِحُبٍّ.'},
        {'word': 'شَهْد', 'meaning': 'عسل النحل وهو في شمعه النقي', 'example': 'تَذَوَّقَ الأَوْلَادُ شَهْداً لَذِيذاً كَالسُّكَّرِ.'},
      ]
    }
  ];

  final List> _quizzes = [
    {
      'question': 'ما المعنى الدقيق لكلمة «غَدِير» في لغتنا الجميلة؟',
      'options': ['مجرى ماء عذب وصغير 💧', 'جبل شاهق الارتفاع ⛰️', 'رياح قوية وعاصفة 🌪️'],
      'correct': 0,
      'explanation': 'الغدير هو قطعة ماء يتركها السيل أو النهر الصغير العذب!'
    },
    {
      'question': 'أيُّ الجمل الآتية مكتوبة بأسلوب عربي فصيح وصحيح؟',
      'options': ['قَرَأَ الأَوْلَادُ قِصَّةً شَيِّقَةً 📚', 'قرأوا الأولاد القصة الشيقة', 'الأولاد قرأ قصة شيقة'],
      'correct': 0,
      'explanation': 'الفعل في بداية الجملة الفصحى يظل مفرداً مع الفاعل الظاهر!'
    },
    {
      'question': 'ما الكلمة التي تعني «المبنى المجهز لمراقبة النجوم والكواكب»؟',
      'options': ['مِرْصَد 🔭', 'مِجْهَر 🔬', 'مِيزَان ⚖️'],
      'correct': 0,
      'explanation': 'المرصد الفلكي هو المكان المخصص لرصد الأجرام السماوية!'
    }
  ];

  final List> _stories = [
    {
      'title': 'الأرنب الصغير وسر الجزرة الذهبية',
      'pages': [
        'فِي صَبَاحِ يَوْمٍ رَبِيعِيٍّ جَمِيلٍ، خَرَجَ الأَرْنَبُ «سُكَّرُ» لِيَلْعَبَ فِي الحُقُولِ الخَضْرَاءِ الوَاسِعَةِ.',
        'وَفَجْأَةً، لَمَحَ جَزَرَةً ضَخْمَةً تَشِعُّ كَالذَّهَبِ الخَالِصِ تَحْتَ ظِلِّ شَجَرَةِ سِنْدِيَانٍ عَتِيقَةٍ.',
        'حَاوَلَ سُكَّرُ أَنْ يَجْذِبَهَا وَحْدَهُ، لَكِنَّهَا كَانَتْ عَمِيقَةً فِي الأَرْضِ وَلَمْ تَتَحَرَّكْ قَيْدَ أُنْمُلَةٍ.',
        'نَادَى سُكَّرُ صَدِيقَهُ القُنْفُذَ «شَوْكِي»، فَتَعَاوَنَا مَعاً بِكُلِّ عَزِيمَةٍ حَتَّى خَرَجَتِ الجَزَرَةُ العِمْلَاقَةُ!',
        'قَسَمَ الصَّدِيقَانِ الجَزَرَةَ بَيْنَهُمَا بِالإِنْصَافِ، وَعَلِمَا أَنَّ ثَمَرَةَ التَّعَاوُنِ أَلَذُّ مِنْ أَيِّ كَنْزٍ.'
      ],
      'moral': 'يَدُ اللهِ مَعَ الجَمَاعَةِ، وَبِالتَّعَاوُنِ تَهُونُ كُلُّ الصِّعَابِ.'
    },
    {
      'title': 'ساعة الحكيم وفصيح',
      'pages': [
        'قَدَّمَ الجَدُّ لِحَفِيدِهِ فَصِيحٍ سَاعَةً حَائِطِيَّةً صَنَعَهَا بِيَدَيْهِ، وَكَتَبَ عَلَيْهَا: «الوَّقْتُ كَنْزٌ»...',
        'قَالَ الجَدُّ: «يَا بُنَيَّ، إِنَّ السَّاعَةَ لَا تَعُودُ لِلْوَرَاءِ، فَمَنْ حَفِظَ سَاعَاتِهِ فِي القِرَاءَةِ وَالعَمَلِ صَارَ عَظِيماً.»',
        'جَعَلَ فَصِيحٌ لِكُلِّ سَاعَةٍ فِي يَوْمِهِ نَصِيباً: سَاعَةً لِلتَّعَلُّمِ، وَسَاعَةً لِلَّعِبِ، وَسَاعَةً لِمُسَاعَدَةِ الأَهْلِ.'
      ],
      'moral': 'تَنْظِيمُ الوَقْتِ هُوَ الطَّرِيقُ الأَوَّلُ لِلنَّجَاحِ وَالتَّفَوُّقِ.'
    }
  ];

  void _giveReward(int points, String feedback) {
    setState(() {
      _stars += points;
      _speechText = feedback;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feedback (+ $points ⭐)', textDirection: TextDirection.rtl),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(milliseconds: 2500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text('$_stars', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE0F2FE), Color(0xFFFEF3C7)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF38BDF8), width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0284C7),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('🦉', style: TextStyle(fontSize: 30)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _speechText,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(_ageGroups.length, (idx) {
                final isSelected = _selectedAge == idx;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(_ageGroups[idx]),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0284C7),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF334155),
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedAge = idx;
                        _speechText = 'تم ضبط المحتوى لمرحلة ${_ageGroups[idx]}!';
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
        onDestinationSelected: (val) => setState(() => _currentIndex = val),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.movie_creation_rounded), label: 'الكرتون'),
          NavigationDestination(icon: Icon(Icons.videogame_asset_rounded), label: 'الألعاب'),
          NavigationDestination(icon: Icon(Icons.auto_stories_rounded), label: 'القصص'),
          NavigationDestination(icon: Icon(Icons.family_restroom_rounded), label: 'ولي الأمر'),
        ],
      ),
    );
  }

  Widget _buildHomeView() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _buildBannerCard(
          title: '🎬 كرتون مغامرات فصيح',
          desc: 'حلقات ورسوم متحركة تنمي الحصيلة اللغوية بالفصحى السليمة.',
          color: const Color(0xFF0284C7),
          icon: Icons.play_arrow_rounded,
          onTap: () => setState(() => _currentIndex = 1),
        ),
        _buildBannerCard(
          title: '🎮 تحديات وألعاب الذكاء',
          desc: 'أسئلة تفاعلية ومسابقات تجمع من خلالها النجوم والأوسمة.',
          color: const Color(0xFF10B981),
          icon: Icons.sports_esports_rounded,
          onTap: () => setState(() => _currentIndex = 2),
        ),
        _buildBannerCard(
          title: '📖 مكتبة فصيح المصورة',
          desc: 'قصص مشكولة ومسموعة تغرس القيم والأخلاق الرفيعة.',
          color: const Color(0xFF8B5CF6),
          icon: Icons.menu_book_rounded,
          onTap: () => setState(() => _currentIndex = 3),
        ),
        _buildBannerCard(
          title: '👨‍👩‍👧 لوحة تحكم ولي الأمر',
          desc: 'متابعة مستوى الطفل، تقارير الوقت، وإدارة المفردات.',
          color: const Color(0xFFF59E0B),
          icon: Icons.admin_panel_settings_rounded,
          onTap: () => setState(() => _currentIndex = 4),
        ),
      ],
    );
  }

  Widget _buildBannerCard({required String title, required String desc, required Color color, required IconData icon, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.15), radius: 26, child: Icon(icon, color: color, size: 28)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(desc, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
        onTap: onTap,
      ),
    );
  }

  Widget _buildEpisodesView() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _episodes.length,
      itemBuilder: (ctx, i) {
        final ep = _episodes[i];
        final words = ep['words'] as List;
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF0369A1), Color(0xFF38BDF8)]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _giveReward(5, 'أحسنت بمشاهدة حلقة «${ep['title']}»!'),
                      icon: const Icon(Icons.play_circle_fill_rounded),
                      label: Text('تشغيل الحلقة (${ep['duration']})'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(ep['title'], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(ep['description'], style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                const Divider(height: 20),
                const Text('المفردات الفصيحة المكتسبة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0284C7))),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: words.map<Widget>((item) {
                    return ActionChip(
                      backgroundColor: const Color(0xFFF0F9FF),
                      label: Text('🔊 ${item['word']}: ${item['meaning']}'),
                      onPressed: () => _giveReward(2, 'مفردة: ${item['word']} — مثال: ${item['example']}'),
                    );
                  }).toList(),
                )
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
      itemBuilder: (ctx, i) {
        final q = _quizzes[i];
        final options = q['options'] as List<String>;
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
                    CircleAvatar(backgroundColor: const Color(0xFF10B981), radius: 14, child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
                    const SizedBox(width: 8),
                    Expanded(child: Text(q['question'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(options.length, (optIdx) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          if (optIdx == q['correct']) {
                            _giveReward(10, 'ممتاز! ${q['explanation']}');
                          } else {
                            setState(() => _speechText = 'حاول مجدداً يا بطل الفصحى!');
                          }
                        },
                        child: Text(options[optIdx]),
                      ),
                    ),
                  );
                }),
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
      itemBuilder: (ctx, i) {
        final story = _stories[i];
        final pages = story['pages'] as List<String>;
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📚 ${story['title']}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                const SizedBox(height: 10),
                ...pages.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(p, style: const TextStyle(fontSize: 14.5, height: 1.5, color: Color(0xFF1E293B))),
                )),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(10)),
                  child: Text('💡 القيمة المستفادة: ${story['moral']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B21A8), fontSize: 13.5)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), foregroundColor: Colors.white),
                    onPressed: () => _giveReward(8, 'أتممت قراءة قصة «${story['title']}» بالكامل!'),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('أنهيت القراءة (+ 8 ⭐)'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParentsView() {
    return ListView(
      padding: const EdgeInsets.all(14),
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
                    Text('تقرير إنجاز الطفل اللغوي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  ],
                ),
                const Divider(height: 24),
                _buildStatRow('رصيد النجوم الكلي', '$_stars نجمة ⭐'),
                _buildStatRow('الحلقات التعليمية المتوفرة', '${_episodes.length} حلقات 🎬'),
                _buildStatRow('المفردات الفصيحة المتاحة', '٨ مفردات مشروحة 📖'),
                _buildStatRow('تحديات الفصحى التفاعلية', '${_quizzes.length} أسئلة ذكاء 🎮'),
                _buildStatRow('معدل الاستيعاب التقديري', 'ممتاز (٩٥٪) 🏆'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF334155))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}
