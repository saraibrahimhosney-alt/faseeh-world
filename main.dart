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
        scaffoldBackgroundColor: const Color(0xFFFFFDF7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0EA5E9),
          primary: const Color(0xFF0EA5E9),
          secondary: const Color(0xFFF59E0B),
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: FaseehHomeScreen(),
      ),
    );
  }
}

class FaseehHomeScreen extends StatefulWidget {
  const FaseehHomeScreen({super.key});

  @override
  State<FaseehHomeScreen> createState() => _FaseehHomeScreenState();
}

class _FaseehHomeScreenState extends State<FaseehHomeScreen> {
  int _selectedIndex = 0;
  int _stars = 25;
  int _selectedAgeGroup = 0; // 0: 3-5, 1: 6-8, 2: 9-12
  String _faseehSpeech = 'أهلاً بك يا بطل الفصحى في عالم فصيح! اضغط على أي قسم لنبدأ المغامرة!';

  final List<String> _ageLabels = ['٣ - ٥ سنوات 🌱', '٦ - ٨ سنوات 🚀', '٩ - ١٢ سنة 🌟'];

  final List<Map<String, dynamic>> _episodes = [
    {
      'title': 'فصيح في البُسْتان الجميل',
      'age': 0,
      'duration': '٠٣:١٥',
      'summary': 'يتجول فصيح بين الأشجار ويتعلم أسماء الفواكه والألوان بالعربية الفصحى.',
      'words': [
        {'word': 'بُسْتان', 'meaning': 'حديقة واسعة مليئة بالأشجار والأزهار', 'example': 'ذَهَبَ فَصِيحٌ إِلَى البُسْتانِ الجَمِيلِ.'},
        {'word': 'تُفَّاحَة', 'meaning': 'فاكهة لذيذة حمراء أو خضراء', 'example': 'أَكَلَ الطِّفْلُ تُفَّاحَةً نَاضِجَةً.'},
        {'word': 'عُصْفُور', 'meaning': 'طائر صغير يغرد فوق الشجرة', 'example': 'غَرَّدَ العُصْفُورُ فَوْقَ الغُصْنِ.'},
      ]
    },
    {
      'title': 'رحلة الفضاء والكواكب',
      'age': 1,
      'duration': '٠٤:٢٠',
      'summary': 'ينطلق فصيح في مركبته الفضائية ليكتشف المجموعة الشمسية والنجوم المضيئة.',
      'words': [
        {'word': 'مَجَرَّة', 'meaning': 'تجمع هائل من النجوم والكواكب في الفضاء', 'example': 'نَحْنُ نَعِيشُ فِي مَجَرَّةِ دَرْبِ التَّبَّانَةِ.'},
        {'word': 'مِجْهَر', 'meaning': 'آلة تكبير الأشياء الدقيقة لرؤيتها بوضوح', 'example': 'فَحَصَ العَالِمُ العَيِّنَةَ بِالمِجْهَرِ.'},
      ]
    },
    {
      'title': 'كنز المكتبة القديمة',
      'age': 2,
      'duration': '٠٥:١٠',
      'summary': 'يكتشف فصيح مخطوطة عربية قديمة تحكي تاريخ العلماء والمخترعين العرب.',
      'words': [
        {'word': 'مَخْطُوطَة', 'meaning': 'كتاب قديم كُتب بخط اليد قبل الطباعة', 'example': 'وَجَدَ البَاحِثُ مَخْطُوطَةً نَادِرَةً.'},
        {'word': 'بَصِيرَة', 'meaning': 'فهم عميق وحكمة في إدراك الأمور', 'example': 'يَتَمَيَّزُ الحَكِيمُ بِالبَصِيرَةِ وَالعِلْمِ.'},
      ]
    },
  ];

  final List<Map<String, dynamic>> _stories = [
    {
      'title': 'الأرنب الذكي والجزرة الذهبية',
      'moral': 'التعاون والإيثار يجعلان السعادة مضاعفة.',
      'pages': [
        'فِي يَوْمٍ مُشْمِسٍ، خَرَجَ الأَرْنَبُ «أَبْيَضُ» يَبْحَثُ عَنْ طَعَامٍ فِي الغَابَةِ الخَضْرَاءِ.',
        'وَجَدَ الأَرْنَبُ جَزَرَةً كَبِيرَةً لَامِعَةً، لَكِنَّهَا كَانَتْ عَالِقَةً بَيْنَ الصُّخُورِ.',
        'نَادَى الأَرْنَبُ صَدِيقَهُ السِّنْجَابَ، فَتَعَاوَنَا مَعاً وَأَخْرَجَا الجَزَرَةَ وَتَقَاسَمَاهَا بِسَعَادَةٍ!'
      ]
    },
    {
      'title': 'سر الساعة العجيبة',
      'moral': 'الوقت كنز ثمين من ينظمه ينجح ويتفوق.',
      'pages': [
        'أَهْدَى الجَدُّ حَفِيدَهُ «فَصِيحاً» سَاعَةً ذَهَبِيَّةً تَنْطِقُ بِالحِكَمِ كُلَّ صَبَاحٍ.',
        'قَالَتِ السَّاعَةُ: «مَنْ يُنَظِّمْ وَقْتَهُ بَيْنَ العِلْمِ وَاللَّعِبِ يَبْلُغْ أَعْلَى المَرَاتِبِ!»',
        'وَظَبَ فَصِيحٌ عَلَى قِرَاءَةِ كِتَابٍ كُلَّ يَوْمٍ حَتَّى أَصْبَحَ أَفْصَحَ طُلَّابِ مَدْرَسَتِهِ.'
      ]
    }
  ];

  final List<Map<String, dynamic>> _questions = [
    {
      'q': 'ما معنى كلمة «بُسْتان» في اللغة العربية الفصحى؟',
      'options': ['حديقة واسعة مليئة بالأشجار 🌳', 'مركبة فضائية سريعة 🚀', 'سفينة في وسط البحر ⛵'],
      'correct': 0,
    },
    {
      'q': 'أيُّ جملةٍ من الجمل التالية صحيحةٌ بالفصحى؟',
      'options': ['قَرَأَ الطِّفْلُ قِصَّةً مُفِيدَةً 📖', 'قرأوا الطفل قصة مفيدة', 'يقرأون الطفل القصة'],
      'correct': 0,
    },
    {
      'q': 'ما الكلمة الفصحى التي تعني «آلة تكبير الأشياء الدقيقة»؟',
      'options': ['مِجْهَر 🔬', 'مِصْبَاح 💡', 'مِفْتَاح 🔑'],
      'correct': 0,
    }
  ];

  void _addStars(int amount, String message) {
    setState(() {
      _stars += amount;
      _faseehSpeech = message;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message (+$amount ⭐)', textDirection: TextDirection.rtl),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0EA5E9),
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Text('🦉 ', style: TextStyle(fontSize: 26)),
            Text('عالم فصيح', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text('⭐ ', style: TextStyle(fontSize: 18)),
                Text('$_stars نجمة', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Mascot Banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE0F2FE), Color(0xFFFEF3C7)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF38BDF8), width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0EA5E9),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('🦉', style: TextStyle(fontSize: 32)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _faseehSpeech,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ),
              ],
            ),
          ),
          // Age selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(_ageLabels.length, (i) {
                final selected = _selectedAgeGroup == i;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(_ageLabels[i]),
                    selected: selected,
                    selectedColor: const Color(0xFFF59E0B),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF1E293B),
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedAgeGroup = i;
                        _faseehSpeech = 'تم اختيار مرحلة ${_ageLabels[i]} بنجاح!';
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
              index: _selectedIndex,
              children: [
                _buildHomeTab(),
                _buildCartoonTab(),
                _buildGamesTab(),
                _buildStoriesTab(),
                _buildParentAdminTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.ondemand_video_rounded), label: 'الكرتون'),
          NavigationDestination(icon: Icon(Icons.videogame_asset_rounded), label: 'الألعاب'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'القصص'),
          NavigationDestination(icon: Icon(Icons.admin_panel_settings_rounded), label: 'الوالدين'),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _buildBigCard(
          title: '🎬 حلقات الكرتون التفاعلي',
          subtitle: 'شاهد مغامرات فصيح وتعلم كلمات عربية جديدة بالصوت والصورة',
          color: const Color(0xFF0EA5E9),
          onTap: () => setState(() => _selectedIndex = 1),
        ),
        _buildBigCard(
          title: '🎮 ألعاب التحدي والذكاء اللغوي',
          subtitle: 'اختبر حصيلتك اللغوية واجمع النجوم الذهبية والأوسمة',
          color: const Color(0xFF10B981),
          onTap: () => setState(() => _selectedIndex = 2),
        ),
        _buildBigCard(
          title: '📖 مكتبة القصص المصورة',
          subtitle: 'اقرأ واستمع إلى أجمل القصص العربية المشكولة صفحة بصفحة',
          color: const Color(0xFF8B5CF6),
          onTap: () => setState(() => _selectedIndex = 3),
        ),
        _buildBigCard(
          title: '👨‍👩‍👧 بوابة الوالدين وإدارة المحتوى',
          subtitle: 'متابعة تقدم الطفل وإضافة حلقات وكلمات وقصص جديدة فوراً',
          color: const Color(0xFFF59E0B),
          onTap: () => setState(() => _selectedIndex = 4),
        ),
      ],
    );
  }

  Widget _buildBigCard({
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border(right: BorderSide(color: color, width: 8)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                    const SizedBox(height: 6),
                    Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF475569))),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartoonTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _episodes.length,
      itemBuilder: (context, idx) {
        final ep = _episodes[idx];
        final words = ep['words'] as List;
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF0284C7), Color(0xFF38BDF8)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () => _addStars(5, 'أحسنت مشاهدة حلقة «${ep['title']}»!'),
                      icon: const Icon(Icons.play_circle_fill_rounded, size: 28),
                      label: Text('تشغيل الحلقة (${ep['duration']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(ep['title'], style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(ep['summary'], style: const TextStyle(color: Color(0xFF475569))),
                const Divider(height: 24),
                const Text('💎 كلمات الحلقة الفصيحة (اضغط على الكلمة لتعلمها):', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: words.map<Widget>((w) {
                    return ActionChip(
                      backgroundColor: const Color(0xFFE0F2FE),
                      label: Text('🔊 ${w['word']} — ${w['meaning']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () => _addStars(2, 'كلمة رائعة: «${w['word']}»! مِثَال: ${w['example']}'),
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

  Widget _buildGamesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _questions.length,
      itemBuilder: (context, idx) {
        final q = _questions[idx];
        final opts = q['options'] as List<String>;
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('سؤال التحدي ${idx + 1}:', style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(q['q'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...List.generate(opts.length, (optIdx) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                          alignment: Alignment.centerRight,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          if (optIdx == q['correct']) {
                            _addStars(10, 'إجابة صحيحة يا بطل الفصحى! أحسنت!');
                          } else {
                            setState(() {
                              _faseehSpeech = 'حاول مرة أخرى يا بطل! فكّر جيداً في معنى الكلمة.';
                            });
                          }
                        },
                        child: Text(opts[optIdx], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildStoriesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _stories.length,
      itemBuilder: (context, idx) {
        final st = _stories[idx];
        final pages = st['pages'] as List<String>;
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📖 ${st['title']}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                const SizedBox(height: 10),
                ...pages.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(p, style: const TextStyle(fontSize: 17, height: 1.6)),
                      ),
                    )),
                const SizedBox(height: 8),
                Text('💡 الحكمة المستفادة: ${st['moral']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => _addStars(8, 'أتممت قراءة قصة «${st['title']}» بنجاح!'),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('أنهيت قراءة القصة (+٨ نجوم ⭐)'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParentAdminTab() {
    final titleController = TextEditingController();
    final wordController = TextEditingController();
    final meaningController = TextEditingController();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📊 تقرير تقدم الطفل في عالم فصيح', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('• مجموع النجوم المكتسبة: $_stars نجمة ⭐', style: const TextStyle(fontSize: 16)),
                Text('• عدد الحلقات المتاحة: ${_episodes.length} حلقات 🎬', style: const TextStyle(fontSize: 16)),
                Text('• عدد القصص التفاعلية: ${_stories.length} قصص 📖', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('➕ إضافة حلقة وكلمة جديدة للتطبيق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'عنوان الحلقة الجديدة', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: wordController,
                  decoration: const InputDecoration(labelText: 'الكلمة الفصيحة المستهدفة', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: meaningController,
                  decoration: const InputDecoration(labelText: 'شرح معنى الكلمة للطفل', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      setState(() {
                        _episodes.add({
                          'title': titleController.text.trim(),
                          'age': _selectedAgeGroup,
                          'duration': '٠٣:٣٠',
                          'summary': 'حلقة تعليمية مضافة من لوحة الإدارة.',
                          'words': [
                            {
                              'word': wordController.text.trim().isEmpty ? 'فَصَاحَة' : wordController.text.trim(),
                              'meaning': meaningController.text.trim().isEmpty ? 'البيان ووضوح الكلام' : meaningController.text.trim(),
                              'example': 'تَعَلَّمْتُ كَلِمَةً جَدِيدَةً فِي عَالَمِ فَصِيحٍ.'
                            }
                          ]
                        });
                      });
                      _addStars(5, 'تمت إضافة الحلقة الجديدة إلى قسم الكرتون بنجاح!');
                    }
                  },
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  label: const Text('حفظ ونشر الحلقة في التطبيق فوراً'),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
