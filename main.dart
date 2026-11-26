import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        fontFamily: 'Amiri',
        colorSchemeSeed: const Color(0xFF10B981),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: FaseehHomeScreen(),
      ),
    );
  }
}

class SongItem {
  final String title;
  final String englishTitle;
  final String subtitle;
  final String audioFile;
  final String emoji;
  final String imagePath;
  final Color color;
  final List<String> verses;

  const SongItem({
    required this.title,
    required this.englishTitle,
    required this.subtitle,
    required this.audioFile,
    required this.emoji,
    required this.imagePath,
    required this.color,
    required this.verses,
  });
}

class StoryPageData {
  final String pageTitle;
  final String text;
  final String mainActor;
  final String actor2;
  final String actor3;
  final String skyElement;
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

class StoryQuestionData {
  final String question;
  final List<String> options;
  final int correctIndex;

  const StoryQuestionData({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class StoryBookItem {
  final String title;
  final String englishTitle;
  final String moral;
  final String imagePath;
  final Color color;
  final StoryQuestionData quiz;
  final List<StoryPageData> pages;

  const StoryBookItem({
    required this.title,
    required this.englishTitle,
    required this.moral,
    required this.imagePath,
    required this.color,
    required this.quiz,
    required this.pages,
  });
}

class QuizItem {
  final String categoryTitle;
  final String englishTitle;
  final String question;
  final String audioFile;
  final String emoji;
  final String imagePath;
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

class FaseehHomeScreen extends StatefulWidget {
  const FaseehHomeScreen({super.key});

  @override
  State<FaseehHomeScreen> createState() => _FaseehHomeScreenState();
}

class _FaseehHomeScreenState extends State<FaseehHomeScreen>
    with TickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _ambiencePlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  WebViewController? _webController;
  bool _hasActiveVideo = false;

  late final AnimationController _natureAnimCtrl;
  late final AnimationController _pageTurnCtrl;

  int _screenIndex = 0;

  int _selectedSongIndex = -1;
  int _selectedBookIndex = -1;
  int _currentPageIndex = 0;
  bool _isStoryQuizMode = false;
  int? _storyQuizSelectedOption;
  int _selectedQuizIndex = -1;

  int _selectedTafsirIndex = 0;
  int _selectedRecitationIndex = 0;
  bool _isVideoExpanded = false;

  int _stars = 25;
  bool _isPlaying = false;
  bool _natureSoundEnabled = true;
  String _currentTrack = 'welcome.mp3';
  String _owlBubble = 'أَهْلاً بِكَ فِي عَالَمِ فَصِيحٍ! اخْتَرْ أَيَّ أَيْقُونَةٍ دَائِرِيَّةٍ!';
  bool _owlBounce = false;
  double _storyFontSize = 19.5;

  final List<VideoSurahItem> _tafsirVideos = const [
    VideoSurahItem(arabicTitle: 'سُورَةُ الفَاتِحَةِ', subtitle: 'Surah Al-Fatihah • Tafsir', videoId: 'n3fX2c8Z7mU', color: Color(0xFF059669)),
    VideoSurahItem(arabicTitle: 'سُورَةُ الإِخْلَاصِ', subtitle: 'Surah Al-Ikhlas • Tafsir', videoId: '1A7W9s8k2pY', color: Color(0xFF0284C7)),
    VideoSurahItem(arabicTitle: 'سُورَةُ الفَلَقِ', subtitle: 'Surah Al-Falaq • Tafsir', videoId: '4R9x8m2nQ1w', color: Color(0xFF7C3AED)),
    VideoSurahItem(arabicTitle: 'سُورَةُ النَّاسِ', subtitle: 'Surah An-Nas • Tafsir', videoId: '8K2m9p4xL5v', color: Color(0xFFD97706)),
    VideoSurahItem(arabicTitle: 'سُورَةُ الكَوْثَرِ', subtitle: 'Surah Al-Kawthar • Tafsir', videoId: '3M7v2n9qR8t', color: Color(0xFFDB2777)),
    VideoSurahItem(arabicTitle: 'سُورَةُ العَصْرِ', subtitle: 'Surah Al-Asr • Tafsir', videoId: '6P4w9k2mN7x', color: Color(0xFF0D9488)),
  ];

  final List<VideoSurahItem> _recitationVideos = const [
    VideoSurahItem(arabicTitle: 'سُورَةُ الفَاتِحَةِ', subtitle: 'تِلَاوَةٌ خَاشِعَةٌ لِلْأَطْفَالِ', videoId: 'ZYaZ6IgFOx0', color: Color(0xFF0284C7)),
    VideoSurahItem(arabicTitle: 'سُورَةُ الإِخْلَاصِ', subtitle: 'تِلَاوَةٌ وَتَكْرَارٌ لِلْحِفْظِ', videoId: 'w5jG2x9mL4q', color: Color(0xFF059669)),
    VideoSurahItem(arabicTitle: 'سُورَةُ الفَلَقِ', subtitle: 'تِلَاوَةٌ وَتَكْرَارٌ لِلْحِفْظِ', videoId: '9L4n7k2pR5w', color: Color(0xFF7C3AED)),
    VideoSurahItem(arabicTitle: 'سُورَةُ النَّاسِ', subtitle: 'تِلَاوَةٌ وَتَكْرَارٌ لِلْحِفْظِ', videoId: '2T8m5v9xQ3y', color: Color(0xFFD97706)),
    VideoSurahItem(arabicTitle: 'سُورَةُ الفِيلِ', subtitle: 'تِلَاوَةٌ وَتَكْرَارٌ لِلْحِفْظِ', videoId: '7H3k9p2mW6z', color: Color(0xFFDB2777)),
    VideoSurahItem(arabicTitle: 'سُورَةُ قُرَيْشٍ', subtitle: 'تِلَاوَةٌ وَتَكْرَارٌ لِلْحِفْظِ', videoId: '5N8r2m7vK4p', color: Color(0xFF0D9488)),
  ];

  final List<SongItem> _songs = const [
    SongItem(
      title: 'أُنْشُودَةُ الحُرُوفِ الهِجَائِيَّةِ',
      englishTitle: 'Arabic Alphabet Chant',
      subtitle: 'هَيَّا نُنْشِدُ حُرُوفَ لُغَتِنَا الجَمِيلَةِ!',
      audioFile: 'song_alphabet.mp3',
      emoji: '🔤',
      imagePath: 'assets/images/card_songs.png',
      color: Color(0xFFEC4899),
      verses: [
        'أَلِفٌ أَرْنَبٌ يَجْرِي يَلْعَبْ 🐰',
        'بَاءٌ بَطَّةٌ نَطَّتْ نَطَّةً 🦆',
        'تَاءٌ تَاجٌ فَوْقَ الرَّأْسِ 👑',
        'ثَاءٌ ثَعْلَبٌ صَادَ دَجَاجَةً 🦊',
        'جِيمٌ جَمَلٌ فِي الصَّحْرَاءِ 🐪',
        'حَاءٌ حَجٌّ أَسْمَى رَغْبَةً 🕋',
        'خَاءٌ خُبْزٌ عِنْدَ البَائِعِ 🥖',
        'دَالٌ دِيكٌ حَسَنُ الصَّوْتِ 🐓',
        'ذَالٌ ذِئْبٌ وَحْشٌ صَلْبٌ 🐺',
        'رَاءٌ رَجُلٌ عَرَفَ الدِّينَ 🌟',
        'زَايٌ زَهْرَةٌ أَصْفَرُ أَحْمَرُ 🌺',
        'سِينٌ سَاعَةٌ تَحْفَظُ وَقْتِي ⏰',
        'شِينٌ شَمْسٌ صُنْعُ قَدِيرٍ ☀️',
        'صَادٌ صَائِدٌ أَلْقَى الشَّبَكَةَ 🎣',
        'ضَادٌ ضَابِطٌ يَحْمِي وَطَنِي 🛡️',
        'طَاءٌ طِفْلٌ أَجْمَلُ طِفْلٍ 👶',
        'ظَاءٌ ظُفْرٌ نَظَّفْنَاهُ ✨',
        'عَيْنٌ عَيْنٌ تَخْشَى اللهَ 👁️',
        'غَيْنٌ غَارٌ غَارُ حِرَاءَ ⛰️',
        'فَاءٌ فِيلٌ ذُو أَنْيَابٍ 🐘',
        'قَافٌ قَمَرٌ فِيهِ مَنَازِلُ 🌙',
        'كَافٌ كَلْبٌ عَاشَ جِوَارِي 🐕',
        'لَامٌ لَحْمٌ يَنْمُو جِسْمِي 🍖',
        'مِيمٌ مَسْجِدُ بَيْتِ اللهِ 🕌',
        'نُونٌ نَهْرٌ نَهْرُ النِّيلِ 🌊',
        'هَاءٌ هَرَمٌ عَالِي القِمَّةِ 🔺',
        'وَاوٌ وَجْهٌ لِلْإِنْسَانِ 😊',
        'يَاءٌ يَدٌ تَرْسُمُ زَهْرَةً 🎨',
      ],
    ),
    SongItem(
      title: 'أُنْشُودَةُ الأَرْقَامِ المَرِحَةِ',
      englishTitle: 'Numbers Song (1 - 10)',
      subtitle: 'تَعَلَّمِ العَدَّ بِالعَرَبِيَّةِ الفُصْحَى!',
      audioFile: 'song_numbers.mp3',
      emoji: '🔢',
      imagePath: 'assets/images/owl_mascot.png',
      color: Color(0xFF0284C7),
      verses: [
        'الوَاحِدُ هُوَ رَبِّي ☝️',
        'وَالِاثْنَانِ مَامَا وَبَابَا 👨‍👩‍👦',
        'وَالثَّلَاثَةُ هُمْ إِخْوَانِي 👧👦👶',
        'وَالأَرْبَعَةُ هُمْ أَصْحَابِي 🤝',
        'وَالخَمْسَةُ أَصَابِعُ يَدِي 🖐️',
        'وَالسِّتَّةُ أَيَّامُ العَمَلِ 📚',
        'وَالسَّبْعَةُ أَيَّامُ الأُسْبُوعِ 📅',
        'وَالثَّمَانِيَةُ أَبْوَابُ الجَنَّةِ 🌿',
        'وَالتِّسْعَةُ أَرْقَامٌ جَمِيلَةٌ ✨',
        'وَالعَشَرَةُ أَصَابِعُ اليَدَيْنِ 🙌',
      ],
    ),
    SongItem(
      title: 'أُنْشُودَةُ الطَّبِيعَةِ وَالصَّبَاحِ',
      englishTitle: 'Nature & Morning Song',
      subtitle: 'أُنْشُودَةُ الأَشْجَارِ وَالعَصَافِيرِ!',
      audioFile: 'song_morning.mp3',
      emoji: '🌳',
      imagePath: 'assets/images/card_stories.png',
      color: Color(0xFF059669),
      verses: [
        'فِي غَابَتِنَا الخَضْرَاءِ الجَمِيلَةِ 🌳',
        'تَشْدُو الطُّيُورُ بِأَحْلَى الأَلْحَانِ 🐦',
        'وَالشَّمْسُ تُشْرِقُ كُلَّ صَبَاحٍ ☀️',
        'تَمْلَأُ الدُّنْيَا نُوراً وَأَمَاناً ✨',
        'النَّهْرُ يَجْرِي بِمَاءٍ عَذْبٍ 💧',
        'يَسْقِي الأَزْهَارَ وَالأَغْصَانَ 🌺',
        'وَالفَرَاشَاتُ تَطِيرُ بِفَرَحٍ 🦋',
        'بَيْنَ الوُرُودِ فِي البُسْتَانِ 🌷',
        'مَا أَجْمَلَ خَلْقَ اللهِ لَنَا 🌍',
        'نَحْمَدُ رَبَّنَا كُلَّ أَوَانٍ 🤲',
      ],
    ),
  ];

  final List<StoryBookItem> _books = const [
    StoryBookItem(
      title: 'مُغَامَرَةُ الأَرْنَبِ الفَصِيحِ',
      englishTitle: 'الصِّدْقُ وَحُبُّ القِرَاءَةِ',
      moral: 'الحِكْمَةُ: القِرَاءَةُ تُنِيرُ العَقْلَ، وَالتَّعَاوُنُ يَجْعَلُ الغَابَةَ سَعِيدَةً!',
      imagePath: 'assets/images/card_stories.png',
      color: Color(0xFF8B5CF6),
      quiz: StoryQuestionData(
        question: 'مَاذَا وَجَدَ الأَرْنَبُ «فَصِيحٌ» تَحْتَ شَجَرَةِ البَلُّوطِ الكَبِيرَةِ؟',
        options: [
          'كِتَاباً ذَهَبِيّاً جَمِيلاً مَكْتُوباً بِالعَرَبِيَّةِ الفُصْحَى 📖✨',
          'سَلَّةً مَلِيئَةً بِالحَلْوَى 🍬',
          'كُرَةً حَمْرَاءَ كَبِيرَةً ⚽',
        ],
        correctIndex: 0,
      ),
      pages: [
        StoryPageData(
          pageTitle: 'صَبَاحٌ جَمِيلٌ فِي الغَابَةِ',
          text: 'فِي غَابَةٍ خَضْرَاءَ وَاسِعَةٍ، عَاشَ أَرْنَبٌ صَغِيرٌ ذَكِيٌّ اسْمُهُ «فَصِيحٌ».\nكَانَ «فَصِيحٌ» يُحِبُّ اللُّغَةَ العَرَبِيَّةَ الفُصْحَى وَيَسْتَيْقِظُ مُبَكِّراً لِيَسْتَمِعَ إِلَى زَقْزَقَةِ العَصَافِيرِ.',
          mainActor: '🐰',
          actor2: '🐦',
          actor3: '🦋',
          skyElement: '☀️',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFBAE6FD), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'الكِتَابُ الذَّهَبِيُّ العَجِيبُ',
          text: 'بَيْنَمَا كَانَ «فَصِيحٌ» يَقْفِزُ بِمَرَحٍ بَيْنَ الأَزْهَارِ المُلَوَّنَةِ، وَجَدَ كِتَاباً ذَهَبِيّاً جَمِيلاً تَحْتَ شَجَرَةِ البَلُّوطِ الكَبِيرَةِ!\nفَتَحَ الكِتَابَ بِفُضُولٍ، فَوَجَدَ فِيهِ قِصَصاً مُمْتِعَةً مَكْتُوبَةً بِالعَرَبِيَّةِ الفُصْحَى.',
          mainActor: '📖',
          actor2: '🐰',
          actor3: '✨',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'لِقَاءُ البُومَةِ الحَكِيمَةِ',
          text: 'رَآهُ البُومَةُ الحَكِيمَةُ «حَكِيمٌ» فَوْقَ الغُصْنِ العَالِي وَقَالَ لَهُ: «مَا أَجْمَلَ حُبَّكَ لِلْقِرَاءَةِ يَا فَصِيحُ! هَلْ تَعْرِفُ قِرَاءَةَ الكَلِمَاتِ بِالتَّشْكِيلِ؟».\nابْتَسَمَ «فَصِيحٌ» وَقَالَ: «نَعَمْ يَا أُسْتَاذِي، القِرَاءَةُ تُنِيرُ عَقْلِي!»',
          mainActor: '🦉',
          actor2: '🐰',
          actor3: '📚',
          skyElement: '☀️',
          skyGradient: [Color(0xFF60A5FA), Color(0xFFDBEAFE), Color(0xFFD1FAE5)],
          hillColor: Color(0xFF15803D),
        ),
        StoryPageData(
          pageTitle: 'عِنْدَ الغَدِيرِ الصَّافِي',
          text: 'سَارَ «فَصِيحٌ» إِلَى الغَدِيرِ الصَّافِي لِيَشْرَبَ المَاءَ العَذْبَ.\nرَأَى أَسْمَاكاً مُلَوَّنَةً تَسْبَحُ بِسُرُورٍ، فَقَرَأَ لَهَا نَشِيداً عَنِ المَاءِ وَالحَيَاةِ، فَقَفَزَتِ الأَسْمَاكُ فَرِحَةً!',
          mainActor: '🐟',
          actor2: '🐰',
          actor3: '💧',
          skyElement: '⛅',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFE0F2FE), Color(0xFFCCFBF1)],
          hillColor: Color(0xFF10B981),
        ),
        StoryPageData(
          pageTitle: 'مُسَاعَدَةُ السُّلَحْفَاةِ الصَّغِيرَةِ',
          text: 'فِي الطَّرِيقِ، وَجَدَ سُلَحْفَاةً صَغِيرَةً تَبْحَثُ عَنْ بَيْتِهَا.\nسَاعَدَهَا «فَصِيحٌ» بِلُطْفٍ وَأَرْشَدَهَا إِلَى الطَّرِيقِ الصَّحِيحِ، فَشَكَرَتْهُ السُّلَحْفَاةُ وَدَعَتْ لَهُ بِالخَيْرِ.',
          mainActor: '🐢',
          actor2: '🐰',
          actor3: '💛',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFDE68A), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'حَلْقَةُ القِرَاءَةِ مَعَ الأَصْدِقَاءِ',
          text: 'اجْتَمَعَتْ حَيَوَانَاتُ الغَابَةِ حَوْلَ «فَصِيحٍ»: الغَزَالُ وَالسِّنْجَابُ وَالقُنْفُذُ.\nبَدَأَ «فَصِيحٌ» يَقْرَأُ لَهُمْ مِنَ الكِتَابِ الذَّهَبِيِّ بِصَوْتٍ وَاضِحٍ وَفَصِيحٍ، وَالجَمِيعُ يُنْصِتُونَ بِإِعْجَابٍ.',
          mainActor: '🐿️',
          actor2: '🦌',
          actor3: '📖',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF93C5FD), Color(0xFFFEF9C3), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'مَسَابَقَةُ الكَلِمَاتِ الجَمِيلَةِ',
          text: 'طَرَحَ «فَصِيحٌ» سُؤَالاً عَلَى أَصْدِقَائِهِ: «مَا أَجْمَلُ كَلِمَةٍ نَبْدَأُ بِهَا يَوْمَنَا؟».\nأَجَابَ العُصْفُورُ: «بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ!» فَصَفَّقَ الجَمِيعُ بِحَمَاسٍ كَبِيرٍ.',
          mainActor: '🐦',
          actor2: '👏',
          actor3: '🌟',
          skyElement: '🌈',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFFDE047), Color(0xFF86EFAC)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'وِسَامُ التَّمَيُّزِ وَالسَّعَادَةِ',
          text: 'عَادَ «فَصِيحٌ» إِلَى بَيْتِهِ مَسَاءً وَهُوَ سَعِيدٌ لِأَنَّهُ نَشَرَ العِلْمَ وَالفَرَحَ بَيْنَ أَصْدِقَائِهِ.\nوَتَعَلَّمَ الجَمِيعُ أَنَّ القِرَاءَةَ وَالتَّعَاوُنَ يَجْعَلَانِ الحَيَاةَ أَجْمَلَ!',
          mainActor: '🏆',
          actor2: '🐰',
          actor3: '❤️',
          skyElement: '🌙',
          skyGradient: [Color(0xFF1E3A8A), Color(0xFF60A5FA), Color(0xFF166534)],
          hillColor: Color(0xFF15803D),
        ),
      ],
    ),
    StoryBookItem(
      title: 'حِكَايَةُ المَطَرِ وَالبُذُورِ',
      englishTitle: 'الشُّكْرُ وَنِعَمُ اللهِ',
      moral: 'الحِكْمَةُ: المَاءُ نِعْمَةٌ عَظِيمَةٌ مِنَ اللهِ تُحْيِي الأَرْضَ وَتُنْبِتُ الزَّرْعَ!',
      imagePath: 'assets/images/card_songs.png',
      color: Color(0xFF059669),
      quiz: StoryQuestionData(
        question: 'مَاذَا حَدَثَ لِلْبُذُورِ الصَّغِيرَةِ بَعْدَ أَنْ نَزَلَ عَلَيْهَا المَطَرُ العَذْبُ؟',
        options: [
          'نَمَتْ وَأَخْرَجَتْ أَوْرَاقاً خَضْرَاءَ وَأَزْهَاراً مُلَوَّنَةً 🌱🌺',
          'ذَهَبَتْ إِلَى الصَّحْرَاءِ 🐪',
          'نَامَتْ وَلَمْ تَكْبُرْ أَبَداً 😴',
        ],
        correctIndex: 0,
      ),
      pages: [
        StoryPageData(
          pageTitle: 'بُذُورٌ صَغِيرَةٌ فِي التُّرْبَةِ',
          text: 'فِي حَدِيقَةٍ جَمِيلَةٍ، نَامَتْ بُذُورٌ صَغِيرَةٌ تَحْتَ التُّرَابِ الدَّافِئِ تَنْتَظِرُ رَحْمَةَ اللهِ.\nقَالَتْ بَذْرَةُ القَمْحِ لِأُخْتِهَا بَذْرَةِ الزَّهْرَةِ: «مَتَى سَنَكْبُرُ وَنَرَى ضَوْءَ الشَّمْسِ الجَمِيلَ؟»',
          mainActor: '🌱',
          actor2: '🪱',
          actor3: '✨',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF93C5FD), Color(0xFFE0F2FE), Color(0xFFD97706)],
          hillColor: Color(0xFFB45309),
        ),
        StoryPageData(
          pageTitle: 'الغَيْمَةُ البَيْضَاءُ الكَرِيمَةُ',
          text: 'فِي السَّمَاءِ العَالِيَةِ، تَجَمَّعَتْ غُيُومٌ بَيْضَاءُ كَبِيرَةٌ تَحْمِلُ المَاءَ العَذْبَ.\nنَادَتِ الغَيْمَةُ البُذُورَ بِلُطْفٍ: «اسْتَعِدِّي يَا بُذُورُ، سَأُرْسِلُ لَكِ قَطَرَاتِ المَطَرِ بِإِذْنِ اللهِ!»',
          mainActor: '☁️',
          actor2: '💧',
          actor3: '🕊️',
          skyElement: '⛅',
          skyGradient: [Color(0xFF64748B), Color(0xFFCBD5E1), Color(0xFFE2E8F0)],
          hillColor: Color(0xFF78350F),
        ),
        StoryPageData(
          pageTitle: 'نُزُولُ قَطَرَاتِ المَطَرِ',
          text: 'بَدَأَتْ قَطَرَاتُ المَطَرِ تَنْزِلُ بِهُدُوءٍ: «تِكْ.. تِكْ.. تِكْ» فَوْقَ الأَرْضِ العَطْشَى!\nفَرِحَتِ البُذُورُ كَثِيراً وَشَرِبَتْ مِنَ المَاءِ النَّقِيِّ وَقَالَتْ: «الحَمْدُ لِلَّهِ عَلَى نِعْمَةِ المَطَرِ!»',
          mainActor: '🌧️',
          actor2: '🌱',
          actor3: '💦',
          skyElement: '🌧️',
          skyGradient: [Color(0xFF475569), Color(0xFF94A3B8), Color(0xFF15803D)],
          hillColor: Color(0xFF166534),
        ),
        StoryPageData(
          pageTitle: 'إِشْرَاقُ الشَّمْسِ الدَّافِئَةِ',
          text: 'تَوَقَّفَ المَطَرُ، وَأَشْرَقَتِ الشَّمْسُ الذَّهَبِيَّةُ تَنْشُرُ الدِّفْءَ وَالنُّورَ فِي كُلِّ مَكَانٍ.\nأَحَسَّتِ البُذُورُ بِالنَّشَاطِ وَالقُوَّةِ، فَبَدَأَتْ تَشُقُّ التُّرْبَةَ إِلَى الأَعْلَى!',
          mainActor: '☀️',
          actor2: '🌿',
          actor3: '✨',
          skyElement: '☀️',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFFEF08A), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'مِيلَادُ الأَوْرَاقِ الخَضْرَاءِ',
          text: 'خَرَجَتِ البَرَاعِمُ الخَضْرَاءُ الصَّغِيرَةُ فَوْقَ سَطْحِ الأَرْضِ تُحَيِّي السَّمَاءَ!\nتَمَايَلَتْ مَعَ النَّسِيمِ العَلِيلِ وَهِيَ تَقُولُ: «مَا أَجْمَلَ الدُّنْيَا! سُبْحَانَ اللهِ الخَالِقِ!»',
          mainActor: '🌿',
          actor2: '🍃',
          actor3: '🐞',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFBAE6FD), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'تَفَتُّحُ الأَزْهَارِ المُلَوَّنَةِ',
          text: 'كَبُرَتِ النَّبْتَاتُ وَأَخْرَجَتْ أَزْهَاراً حَمْرَاءَ وَصَفْرَاءَ وَبَنَفْسَجِيَّةً تَفُوحُ بِالعِطْرِ الزَّكِيِّ!\nجَاءَتِ الفَرَاشَاتُ المُلَوَّنَةُ وَالنَّحْلَاتُ النَّشِيطَةُ لِتَزُورَ الحَدِيقَةَ السَّعِيدَةَ.',
          mainActor: '🌺',
          actor2: '🦋',
          actor3: '🐝',
          skyElement: '☀️',
          skyGradient: [Color(0xFF60A5FA), Color(0xFFFDE68A), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'قَوْسُ قُزَحَ فِي السَّمَاءِ',
          text: 'ظَهَرَ قَوْسُ قُزَحَ بِأَلْوَانِهِ السَّبْعَةِ الرَّائِعَةِ يَزِينُ السَّمَاءَ بَعْدَ المَطَرِ.\nغَنَّتِ العَصَافِيرُ فَوْقَ الأَغْصَانِ أُنْشُودَةَ الشُّكْرِ لِلَّهِ عَلَى جَمَالِ الطَّبِيعَةِ.',
          mainActor: '🌈',
          actor2: '🐦',
          actor3: '🌷',
          skyElement: '🌈',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFFBCFE8), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF10B981),
        ),
        StoryPageData(
          pageTitle: 'حِفْظُ النِّعْمَةِ وَالمُحَافَظَةُ عَلَى البِيئَةِ',
          text: 'جَاءَ الأَطْفَالُ إِلَى الحَدِيقَةِ، فَسَقَوُا الأَشْجَارَ وَلَمْ يَقْطِفُوا الأَزْهَارَ، بَلْ حَافَظُوا عَلَى نَظَافَتِهَا.\nوَهَكَذَا تَعَلَّمْنَا أَنَّ شُكْرَ اللهِ يَكُونُ بِالحِفَاظِ عَلَى نِعَمِهِ!',
          mainActor: '🌻',
          actor2: '👧',
          actor3: '💚',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFF86EFAC)],
          hillColor: Color(0xFF16A34A),
        ),
      ],
    ),
    StoryBookItem(
      title: 'النَّمْلَةُ النَّشِيطَةُ وَحَبَّةُ القَمْحِ',
      englishTitle: 'الاجْتِهَادُ وَالتَّعَاوُنُ',
      moral: 'الحِكْمَةُ: العَمَلُ الجَمَاعِيُّ وَالتَّعَاوُنُ يَجْعَلَانِ الصَّعْبَ سَهْلاً!',
      imagePath: 'assets/images/owl_mascot.png',
      color: Color(0xFFD97706),
      quiz: StoryQuestionData(
        question: 'كَيْفَ اسْتَطَاعَتْ «نَمُولَةُ» حَمْلَ حَبَّةِ القَمْحِ الكَبِيرَةِ إِلَى البَيْتِ؟',
        options: [
          'تَرَكَتْهَا فِي الطَّرِيقِ وَذَهَبَتْ لِتَلْعَبَ 🦗',
          'تَعَاوَنَتْ مَعَ أَخَوَاتِهَا النَّمْلَاتِ وَرَفَعْنَهَا مَعاً 🐜🤝',
          'قَالَتْ إِنَّ حَبَّةَ القَمْحِ لَا تُؤْكَلُ 🌾',
        ],
        correctIndex: 1,
      ),
      pages: [
        StoryPageData(
          pageTitle: 'قَرْيَةُ النَّمْلِ النَّشِيطَةِ',
          text: 'فِي أَسْفَلِ تَلَّةٍ خَضْرَاءَ جَمِيلَةٍ، عَاشَتْ نَمْلَةٌ صَغِيرَةٌ نَشِيطَةٌ تُدْعَى «نَمُولَةُ».\nكَانَتْ «نَمُولَةُ» تَسْتَيْقِظُ كُلَّ صَبَاحٍ بَاكِراً لِتَجْمَعَ الطَّعَامَ مَعَ أُسْرَتِهَا قَبْلَ قُدُومِ فَصْلِ الشِّتَاءِ البَارِدِ.',
          mainActor: '🐜',
          actor2: '🌾',
          actor3: '☀️',
          skyElement: '☀️',
          skyGradient: [Color(0xFFFEF08A), Color(0xFFBAE6FD), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'حَبَّةُ القَمْحِ الذَّهَبِيَّةُ',
          text: 'بَيْنَمَا كَانَتْ «نَمُولَةُ» تَبْحَثُ بَيْنَ الأَعْشَابِ، وَجَدَتْ حَبَّةَ قَمْحٍ كَبِيرَةً تَلْمَعُ تَحْتَ الشَّمْسِ!\nفَرِحَتْ «نَمُولَةُ» كَثِيراً وَقَالَتْ: «هَذِهِ الحَبَّةُ تَكْفِي أُسْرَتِي أُسْبُوعاً كَامِلاً، سَأَحْمِلُهَا إِلَى البَيْتِ!»',
          mainActor: '🌾',
          actor2: '🐜',
          actor3: '✨',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFDE68A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'ثِقَلُ الحَمْلِ وَالتَّعَبُ',
          text: 'حَاوَلَتْ «نَمُولَةُ» رَفْعَ حَبَّةِ القَمْحِ عَلَى ظَهْرِهَا الصَّغِيرِ، لَكِنَّ الحَبَّةَ كَانَتْ أَثْقَلَ مِنْهَا بِكَثِيرٍ!\nسَقَطَتِ الحَبَّةُ عَلَى الأَرْضِ، فَقَالَتْ «نَمُولَةُ» بِعَزِيمَةٍ: «لَنْ أَسْتَسْلِمَ، سَأُفَكِّرُ فِي حَلٍّ ذَكِيٍّ!»',
          mainActor: '🐜',
          actor2: '💦',
          actor3: '🌾',
          skyElement: '⛅',
          skyGradient: [Color(0xFF93C5FD), Color(0xFFE0F2FE), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF15803D),
        ),
        StoryPageData(
          pageTitle: 'سُخْرِيَةُ الجَرَادَةِ الكَسُولَةِ',
          text: 'رَأَتْهَا الجَرَادَةُ الكَسُولَةُ وَهِيَ تَلْعَبُ وَتَضْحَكُ قَائِلَةً: «لِمَاذَا تُتْعِبِينَ نَفْسَكِ يَا نَمُولَةُ؟ الجَوُّ جَمِيلٌ، تَعَالَيِ العَبِي مَعِي!».\nأَجَابَتْ «نَمُولَةُ» بِأَدَبٍ: «اللَّعِبُ جَمِيلٌ بَعْدَ العَمَلِ، أَمَّا الآنَ فَوَقْتُ الاجْتِهَادِ».',
          mainActor: '🦗',
          actor2: '🐜',
          actor3: '🌿',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'نِدَاءُ التَّعَاوُنِ',
          text: 'أَسْرَعَتْ «نَمُولَةُ» إِلَى أَخَوَاتِهَا النَّمْلَاتِ وَأَخْبَرَتْهُنَّ بِمَكَانِ حَبَّةِ القَمْحِ الكَبِيرَةِ.\nاصْطَفَّتْ خَمْسُ نَمْلَاتٍ نَشِيطَاتٍ فِي نِظَامٍ دَقِيقٍ، وَتَقَدَّمْنَ مَعاً نَحْوَ الحَبَّةِ بِحَمَاسٍ.',
          mainActor: '🐜',
          actor2: '🐜',
          actor3: '🤝',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF67E8F9), Color(0xFFFDE68A), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF10B981),
        ),
        StoryPageData(
          pageTitle: 'قُوَّةُ الفَرِيقِ الوَاحِدِ',
          text: 'رَفَعَتِ النَّمْلَاتُ الخَمْسُ حَبَّةَ القَمْحِ مَعاً فِي وَقْتٍ وَاحِدٍ، فَأَصْبَحَتْ خَفِيفَةً كَالرِّيشَةِ!\nسِرْنَ فِي صَفٍّ مُنْتَظِمٍ وَهُنَّ يُنْشِدْنَ: «بِالعَمَلِ وَالنِّظَامِ.. نَحْيَا فِي سَلَامٍ!»',
          mainActor: '🌾',
          actor2: '🐜',
          actor3: '🎶',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'فِي بَيْتِ النَّمْلِ الدَّافِئِ',
          text: 'وَصَلَتِ النَّمْلَاتُ إِلَى مَخْزَنِ القَرْيَةِ وَوَضَعْنَ حَبَّةَ القَمْحِ بِأَمَانٍ.\nشَكَرَتْ مَلِكَةُ النَّمْلِ «نَمُولَةَ» عَلَى ذَكَائِهَا وَنَشَاطِهَا، وَأَعْطَتْهَا وِسَامَ الاجْتِهَادِ.',
          mainActor: '🏅',
          actor2: '🐜',
          actor3: '❤️',
          skyElement: '🌈',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFFDE047), Color(0xFF86EFAC)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'دَرْسٌ لِلْجَرَادَةِ',
          text: 'وَعِنْدَمَا جَاءَ المَطَرُ، شَعَرَتِ الجَرَادَةُ بِالجُوعِ، فَقَدَّمَتْ لَهَا «نَمُولَةُ» بَعْضَ القَمْحِ بِكَرَمٍ.\nتَعَلَّمَتِ الجَرَادَةُ أَنَّ الاجْتِهَادَ وَالتَّخْطِيطَ هُمَا سِرُّ السَّعَادَةِ وَالأَمَانِ.',
          mainActor: '🐜',
          actor2: '🦗',
          actor3: '🌟',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFBCFE8), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
      ],
    ),
    StoryBookItem(
      title: 'السُّلَحْفَاةُ الأَمِينَةُ وَالكَنْزُ',
      englishTitle: 'الصِّدْقُ وَالأَمَانَةُ',
      moral: 'الحِكْمَةُ: الأَمَانَةُ صِفَةٌ عَظِيمَةٌ تُحِبُّهَا القُلُوبُ، وَمَنْ يَرُدُّ الحَقَّ إِلَى أَصْحَابِهِ يُبَارِكُ اللهُ لَهُ!',
      imagePath: 'assets/images/card_stories.png',
      color: Color(0xFF0284C7),
      quiz: StoryQuestionData(
        question: 'مَاذَا فَعَلَتِ السُّلَحْفَاةُ «سَلْمَى» عِنْدَمَا وَجَدَتْ كِيسَ البُنْدُقِ المَفْقُودَ؟',
        options: [
          'أَكَلَتِ البُنْدُقَ كُلَّهُ وَحْدَهَا 🌰',
          'بَحَثَتْ عَنْ صَاحِبِهِ بِأَمَانَةٍ وَرَدَّتْهُ إِلَى السِّنْجَابِ كَامِلاً 🐢🎒',
          'رَمَتِ الكِيسَ فِي النَّهْرِ 🌊',
        ],
        correctIndex: 1,
      ),
      pages: [
        StoryPageData(
          pageTitle: 'نُزْهَةٌ بِجَانِبِ النَّهْرِ',
          text: 'كَانَتِ السُّلَحْفَاةُ الطَّيِّبَةُ «سَلْمَى» تَمْشِي بِهُدُوءٍ عَلَى ضِفَّةِ النَّهْرِ الصَّافِي تَتَأَمَّلُ السَّمَكَ الصَّغِيرَ.\nكَانَتْ «سَلْمَى» مَعْرُوفَةً بَيْنَ جَمِيعِ حَيَوَانَاتِ الغَابَةِ بِصِدْقِهَا وَأَمَانَتِهَا وَحُبِّهَا لِلْخَيْرِ.',
          mainActor: '🐢',
          actor2: '🐟',
          actor3: '🌊',
          skyElement: '☀️',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFBAE6FD), Color(0xFFCCFBF1)],
          hillColor: Color(0xFF10B981),
        ),
        StoryPageData(
          pageTitle: 'الكِيسُ المُلَوَّنُ المَفْقُودُ',
          text: 'فَجْأَةً، رَأَتْ «سَلْمَى» كِيساً مُلَوَّناً جَمِيلاً مَلِيئاً بِالبُنْدُقِ وَاللَّوْزِ اللَّذِيذِ مَوْضُوعاً تَحْتَ شَجَرَةِ البَلُّوطِ!\nنَظَرَتْ حَوْلَهَا فَلَمْ تَجِدْ أَحَداً، فَقَالَتْ: «لَقَدْ نَسِيَهُ أَحَدُ الأَصْدِقَاءِ هُنَا، يَجِبُ أَنْ أَبْحَثَ عَنْ صَاحِبِهِ!»',
          mainActor: '🎒',
          actor2: '🐢',
          actor3: '🌰',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'سُؤَالُ البَطَّةِ البَيْضَاءِ',
          text: 'حَمَلَتِ السُّلَحْفَاةُ الكِيسَ بِأَمَانَةٍ وَسَارَتْ تَبْحَثُ عَنْ صَاحِبِهِ.\nقَابَلَتِ البَطَّةَ البَيْضَاءَ فَسَأَلَتْهَا: «هَلْ هَذَا الكِيسُ لَكِ يَا بَطَّةُ؟».\nقَالَتِ البَطَّةُ: «لَا يَا سَلْمَى، جَزَاكِ اللهُ خَيْراً عَلَى أَمَانَتِكِ!»',
          mainActor: '🦆',
          actor2: '🐢',
          actor3: '💬',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFE0F2FE), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'سُؤَالُ الغَزَالِ السَّرِيعِ',
          text: 'ثُمَّ قَابَلَتْ «سَلْمَى» الغَزَالَ السَّرِيعَ فَسَأَلَتْهُ: «هَلْ أَضَعْتَ كِيسَ طَعَامٍ يَا صَدِيقِي؟».\nابْتَسَمَ الغَزَالُ وَقَالَ: «لَا يَا سَلْمَى، أَنَا آكُلُ العُشْبَ الأَخْضَرَ، رُبَّمَا يَكُونُ لِلسِّنْجَابِ الصَّغِيرِ!»',
          mainActor: '🦌',
          actor2: '🐢',
          actor3: '🌿',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF67E8F9), Color(0xFFFDE68A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'بُكَاءُ السِّنْجَابِ الصَّغِيرِ',
          text: 'تَابَعَتِ السُّلَحْفَاةُ المَسِيرَ حَتَّى سَمِعَتْ صَوْتَ بُكَاءٍ خَفِيفٍ عِنْدَ الشَّجَرَةِ الكَبِيرَةِ!\nكَانَ السِّنْجَابُ الصَّغِيرُ يَبْحَثُ بِحُزْنٍ وَيَقُولُ: «أَيْنَ ذَهَبَ كِيسُ البُنْدُقِ الَّذِي جَمَعْتُهُ لِإِخْوَتِي الصِّغَارِ؟»',
          mainActor: '🐿️',
          actor2: '💧',
          actor3: '🌳',
          skyElement: '⛅',
          skyGradient: [Color(0xFF93C5FD), Color(0xFFE0F2FE), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF15803D),
        ),
        StoryPageData(
          pageTitle: 'رَدُّ الأَمَانَةِ إِلَى صَاحِبِهَا',
          text: 'اقْتَرَبَتْ «سَلْمَى» بِابْتِسَامَةٍ دَافِئَةٍ وَقَالَتْ: «لَا تَحْزَنْ يَا صَدِيقِي، هَا هُوَ كِيسُكَ كَامِلاً لَمْ يَنْقُصْ مِنْهُ شَيْءٌ!».\nقَفَزَ السِّنْجَابُ مِنَ الفَرَحِ وَاحْتَضَنَ السُّلَحْفَاةَ شَاكِراً لَهَا أَمَانَتَهَا العَظِيمَةَ.',
          mainActor: '🐢',
          actor2: '🐿️',
          actor3: '🎒',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'مُكَافَأَةُ الصِّدْقِ وَالأَمَانَةِ',
          text: 'فَتَحَ السِّنْجَابُ الكِيسَ وَقَدَّمَ لِلسُّلَحْفَاةِ أَطْيَبَ الثِّمَارِ وَقَالَ: «أَنْتِ أَصْدَقُ صَدِيقَةٍ فِي الغَابَةِ يَا سَلْمَى!».\nفَرِحَتْ «سَلْمَى» لِأَنَّهَا أَدْخَلَتِ السُّرُورَ عَلَى قَلْبِ صَدِيقِهَا.',
          mainActor: '🌰',
          actor2: '🐢',
          actor3: '❤️',
          skyElement: '🌈',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFFDE047), Color(0xFF86EFAC)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'قُدْوَةٌ لِلْجَمِيعِ',
          text: 'انْتَشَرَتْ قِصَّةُ أَمَانَةِ «سَلْمَى» فِي كُلِّ الغَابَةِ، وَأَصْبَحَ الجَمِيعُ يَثِقُونَ بِهَا وَيُحِبُّونَهَا.\nوَتَعَلَّمَ الصِّغَارُ أَنَّ الأَمَانَةَ تَجْعَلُ الإِنْسَانَ مَحْبُوباً عِنْدَ اللهِ وَعِنْدَ النَّاسِ.',
          mainActor: '🏆',
          actor2: '🐢',
          actor3: '🌟',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFBCFE8), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
      ],
    ),
    StoryBookItem(
      title: 'العُصْفُورُ النَّظِيفُ وَالغَابَةُ',
      englishTitle: 'النَّظَافَةُ وَحِمَايَةُ البِيئَةِ',
      moral: 'الحِكْمَةُ: النَّظَافَةُ مِنَ الإِيمَانِ، وَالمُحَافَظَةُ عَلَى بِيئَتِنَا تَجْعَلُ الدُّنْيَا جَمِيلَةً وَصِحِّيَّةً لِلْجَمِيعِ!',
      imagePath: 'assets/images/card_songs.png',
      color: Color(0xFF10B981),
      quiz: StoryQuestionData(
        question: 'أَيْنَ يَجِبُ أَنْ نَضَعَ القُشُورَ وَالأَوْرَاقَ لِنُحَافِظَ عَلَى نَظَافَةِ البِيئَةِ؟',
        options: [
          'نَرْمِيهَا عَلَى العُشْبِ وَفِي الشَّارِعِ 🍂',
          'نَضَعُهَا فِي سَلَّةِ المُهْمَلَاتِ المُخَصَّصَةِ لَهَا 🗑️✨',
          'نَتْرُكُهَا تَحْتَ الأَشْجَارِ 🌳',
        ],
        correctIndex: 1,
      ),
      pages: [
        StoryPageData(
          pageTitle: 'عُشُّ العُصْفُورِ الجَمِيلُ',
          text: 'فَوْقَ غُصْنٍ أَخْضَرَ مُزْهِرٍ، عَاشَ العُصْفُورُ الصَّغِيرُ «زَقْزُوقٌ» فِي عُشٍّ نَظِيفٍ وَمُرَتَّبٍ.\nكَانَ «زَقْزُوقٌ» يُحِبُّ النَّظَافَةَ كَثِيراً، فَيُرَتِّبُ رِيشَهُ كُلَّ صَبَاحٍ وَيُحَافِظُ عَلَى جَمَالِ حَدِيقَتِهِ.',
          mainActor: '🐤',
          actor2: '🌺',
          actor3: '✨',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFDCFCE7), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'مَنْظَرٌ مُحْزِنٌ عِنْدَ البُحَيْرَةِ',
          text: 'طَارَ «زَقْزُوقٌ» إِلَى البُحَيْرَةِ الزَّرْقَاءِ، فَرَأَى بَعْضَ الأَوْرَاقِ وَالقُشُورِ مَرْمِيَّةً عَلَى العُشْبِ الأَخْضَرِ!\nحَزِنَ العُصْفُورُ وَقَالَ: «مَنْ رَمَى هَذِهِ القُمَامَةَ هُنَا؟ إِنَّهَا تُشَوِّهُ جَمَالَ غَابَتِنَا!»',
          mainActor: '🐤',
          actor2: '🍂',
          actor3: '💧',
          skyElement: '⛅',
          skyGradient: [Color(0xFFCBD5E1), Color(0xFFE0F2FE), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF15803D),
        ),
        StoryPageData(
          pageTitle: 'نَصِيحَةٌ لَطِيفَةٌ لِلثَّعْلَبِ الصَّغِيرِ',
          text: 'شَاهَدَ «زَقْزُوقٌ» الثَّعْلَبَ الصَّغِيرَ يَأْكُلُ مَوْزَةً ثُمَّ يَرْمِي قِشْرَتَهَا عَلَى الأَرْضِ!\nنَزَلَ العُصْفُورُ وَقَالَ لَهُ بِلُطْفٍ: «يَا صَدِيقِي، رَمْيُ القُشُورِ عَلَى الأَرْضِ قَدْ يُؤْذِي مَنْ يَمْشِي، وَيُفْسِدُ نَظَافَةَ المَكَانِ!»',
          mainActor: '🦊',
          actor2: '🐤',
          actor3: '🍌',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'اعْتِذَارُ الثَّعْلَبِ الصَّغِيرِ',
          text: 'خَجِلَ الثَّعْلَبُ الصَّغِيرُ وَقَالَ: «أَنْتَ عَلَى حَقٍّ يَا زَقْزُوقُ، لَمْ أَنْتَبِهْ لِذَلِكَ! سَأَرْفَعُ القِشْرَةَ فَوْراً وَأَضَعُهَا فِي سَلَّةِ المُهْمَلَاتِ».\nفَرِحَ العُصْفُورُ بِاسْتِجَابَةِ صَدِيقِهِ السَّرِيعَةِ.',
          mainActor: '🦊',
          actor2: '🗑️',
          actor3: '👏',
          skyElement: '☀️',
          skyGradient: [Color(0xFF67E8F9), Color(0xFFCCFBF1), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF10B981),
        ),
        StoryPageData(
          pageTitle: 'حَمْلَةُ نَظَافَةِ الغَابَةِ',
          text: 'اتَّفَقَ «زَقْزُوقٌ» وَالثَّعْلَبُ وَالأَرْنَبُ عَلَى تَنْظِيفِ ضِفَّةِ البُحَيْرَةِ مَعاً.\nجَمَعُوا كُلَّ الأَوْرَاقِ وَالأَغْصَانِ اليَابِسَةِ، وَوَضَعُوهَا فِي الأَمَاكِنِ المُخَصَّصَةِ لَهَا بِنَشَاطٍ وَسُرُورٍ.',
          mainActor: '🐤',
          actor2: '🐰',
          actor3: '🦊',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFDE68A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'زِرَاعَةُ الأَزْهَارِ المُلَوَّنَةِ',
          text: 'وَبَعْدَ أَنْ أَصْبَحَ المَكَانُ نَظِيفاً لَامِعاً، زَرَعَ الأَصْدِقَاءُ أَزْهَاراً حَمْرَاءَ وَصَفْرَاءَ حَوْلَ البُحَيْرَةِ، وَسَقَوْهَا بِالمَاءِ العَذْبِ.',
          mainActor: '🌷',
          actor2: '🌻',
          actor3: '🦋',
          skyElement: '🌈',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFFDE047), Color(0xFF86EFAC)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'عَوْدَةُ الفَرَاشَاتِ وَالنَّحْلِ',
          text: 'فَرِحَتِ الفَرَاشَاتُ وَالنَّحْلَاتُ بِالأَزْهَارِ الجَدِيدَةِ وَالمَاءِ الصَّافِي، وَعَادَتْ تُحَلِّقُ فَوْقَ البُحَيْرَةِ فِي مَنْظَرٍ يَسُرُّ النَّاظِرِينَ!',
          mainActor: '🐝',
          actor2: '🦋',
          actor3: '🌸',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'شِعَارُ الغَابَةِ الجَمِيلَةِ',
          text: 'وَضَعَ الأَصْدِقَاءُ لَافِتَةً جَمِيلَةً كُتِبَ عَلَيْهَا: «النَّظَافَةُ مِنَ الإِيمَانِ.. حَافِظُوا عَلَى جَمَالِ غَابَتِنَا!».\nوَعَاشَ الجَمِيعُ فِي بِيئَةٍ نَظِيفَةٍ صِحِّيَّةٍ مَلِيئَةٍ بِالسَّعَادَةِ.',
          mainActor: '🌍',
          actor2: '🐤',
          actor3: '❤️',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFBCFE8), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
      ],
    ),
    StoryBookItem(
      title: 'القِطُّ الصَّغِيرُ وَآدَابُ الطَّعَامِ',
      englishTitle: 'الآدَابُ اليَوْمِيَّةُ وَالاحْتِرَامُ',
      moral: 'الحِكْمَةُ: التَّسْمِيَةُ قَبْلَ الطَّعَامِ وَالحَمْدُ بَعْدَهُ وَالأَكْلُ بِأَدَبٍ تَجْعَلُ الطِّفْلَ مُهَذَّباً وَمَحْبُوباً!',
      imagePath: 'assets/images/owl_mascot.png',
      color: Color(0xFFEC4899),
      quiz: StoryQuestionData(
        question: 'مَاذَا نَقُولُ قَبْلَ أَنْ نَبْدَأَ بِتَنَاوُلِ الطَّعَامِ؟',
        options: [
          'نَقُولُ: بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ، وَنَأْكُلُ بِاليَمِينِ 🤲✨',
          'نَبْدَأُ الأَكْلَ بِسُرْعَةٍ دُونَ غَسْلِ اليَدَيْنِ 🍽️',
          'نَأْخُذُ الطَّعَامَ مِنْ طَبَقِ أُخْتِنَا 🐱',
        ],
        correctIndex: 0,
      ),
      pages: [
        StoryPageData(
          pageTitle: 'مَائِدَةُ الغَدَاءِ الشَّهِيَّةُ',
          text: 'عَادَ القِطُّ الصَّغِيرُ «مِشْمِشٌ» مِنَ المَدْرَسَةِ جَائِعاً بَعْدَ يَوْمٍ مَلِيءٍ بِالعِلْمِ وَاللَّعِبِ.\nأَعَدَّتْ لَهُ أُمُّهُ مَائِدَةً لَذِيذَةً مِنَ السَّمَكِ المَشْوِيِّ وَالحَلِيبِ الدَّافِئِ وَالفَوَاكِهِ الطَّازَجَةِ.',
          mainActor: '🐱',
          actor2: '🐟',
          actor3: '🥛',
          skyElement: '☀️',
          skyGradient: [Color(0xFFFBCFE8), Color(0xFFFEF08A), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'غَسْلُ اليَدَيْنِ أَوَّلاً',
          text: 'أَرَادَ «مِشْمِشٌ» أَنْ يَبْدَأَ الأَكْلَ بِسُرْعَةٍ، فَذَكَّرَتْهُ أُمُّهُ بِلُطْفٍ: «يَا بُنَيَّ، هَلْ غَسَلْتَ يَدَيْكَ بِالمَاءِ وَالصَّابُونِ قَبْلَ الطَّعَامِ؟».\nابْتَسَمَ «مِشْمِشٌ» وَأَسْرَعَ لِيَغْسِلَ يَدَيْهِ جَيِّداً لِيَحْمِيَ نَفْسَهُ مِنَ الجَرَاثِيمِ.',
          mainActor: '🧼',
          actor2: '🐱',
          actor3: '💧',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFE0F2FE), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'قَوْلُ «بِسْمِ اللهِ»',
          text: 'جَلَسَ «مِشْمِشٌ» بِأَدَبٍ عَلَى الكُرْسِيِّ وَقَالَ بِصَوْتٍ وَاضِحٍ: «بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ».\nقَالَتِ الأُمُّ: «أَحْسَنْتَ يَا بُنَيَّ، التَّسْمِيَةُ تَجْلِبُ البَرَكَةَ فِي الطَّعَامِ!»',
          mainActor: '🐱',
          actor2: '✨',
          actor3: '💛',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFDE68A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'الأَكْلُ بِاليَمِينِ وَمِمَّا يَلِينَا',
          text: 'بَدَأَ «مِشْمِشٌ» يَأْكُلُ بِيَدِهِ اليُمْنَى بِهُدُوءٍ، وَيَأْخُذُ مِنَ الطَّعَامِ الَّذِي أَمَامَهُ دُونَ أَنْ يَمُدَّ يَدَهُ إِلَى طَبَقِ أُخْتِهِ الصَّغِيرَةِ.',
          mainActor: '🍽️',
          actor2: '🐱',
          actor3: '🍎',
          skyElement: '🌤️',
          skyGradient: [Color(0xFF67E8F9), Color(0xFFCCFBF1), Color(0xFFDCFCE7)],
          hillColor: Color(0xFF10B981),
        ),
        StoryPageData(
          pageTitle: 'عَدَمُ الإِسْرَافِ فِي الطَّعَامِ',
          text: 'وَضَعَ «مِشْمِشٌ» فِي طَبَقِهِ كَمِّيَّةً مُنَاسِبَةً عَلَى قَدْرِ حَاجَتِهِ، فَأَكَلَهَا كُلَّهَا وَلَمْ يَتْرُكْ شَيْئاً يُرْمَى، لِأَنَّ الطَّعَامَ نِعْمَةٌ كَبِيرَةٌ مِنَ اللهِ.',
          mainActor: '🐱',
          actor2: '🍌',
          actor3: '🌟',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'شُكْرُ الأُمِّ وَحَمْدُ اللهِ',
          text: 'وَبَعْدَ أَنِ انْتَهَى «مِشْمِشٌ» مِنْ طَعَامِهِ، رَفَعَ يَدَيْهِ وَقَالَ: «الحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا»، ثُمَّ قَالَ لِأُمِّهِ: «شُكْراً يَا أُمِّي عَلَى الطَّعَامِ اللَّذِيذِ!»',
          mainActor: '🤲',
          actor2: '🐱',
          actor3: '❤️',
          skyElement: '🌈',
          skyGradient: [Color(0xFF38BDF8), Color(0xFFFDE047), Color(0xFF86EFAC)],
          hillColor: Color(0xFF16A34A),
        ),
        StoryPageData(
          pageTitle: 'مُسَاعَدَةُ الأُمِّ فِي التَّرْتِيبِ',
          text: 'لَمْ يَتْرُكْ «مِشْمِشٌ» طَبَقَهُ عَلَى المَائِدَةِ، بَلْ حَمَلَهُ بِأَدَبٍ إِلَى المَطْبَخِ لِيُسَاعِدَ أُمَّهُ فِي تَرْتِيبِ المَكَانِ.',
          mainActor: '🐱',
          actor2: '👏',
          actor3: '✨',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFBCFE8), Color(0xFFBBF7D0)],
          hillColor: Color(0xFF22C55E),
        ),
        StoryPageData(
          pageTitle: 'وِسَامُ الطِّفْلِ المُهَذَّبِ',
          text: 'قَبَّلَتِ الأُمُّ «مِشْمِشاً» وَقَالَتْ لَهُ بِفَخْرٍ: «أَنْتَ طِفْلٌ مُهَذَّبٌ وَرَائِعٌ تَلْتَزِمُ بِآدَابِ الإِسْلَامِ الجَمِيلَةِ!».\nوَتَعَلَّمَ الصِّغَارُ أَنَّ الآدَابَ الجَمِيلَةَ تَزِيدُ الطِّفْلَ جَمَالاً وَحُبّاً.',
          mainActor: '👑',
          actor2: '🐱',
          actor3: '🌟',
          skyElement: '☀️',
          skyGradient: [Color(0xFF7DD3FC), Color(0xFFFEF08A), Color(0xFFBBF7D0)],
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
    AudioPlayer.global.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: true,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.none,
        ),
      ),
    );
    _natureAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _pageTurnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _playAudioTrack('welcome.mp3', _owlBubble);
    });
  }

  @override
  void dispose() {
    _natureAnimCtrl.dispose();
    _pageTurnCtrl.dispose();
    _player.dispose();
    _ambiencePlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  Uint8List _generatePaperFlipWav() {
    const int sampleRate = 22050;
    final int numSamples = (sampleRate * 0.22).toInt();
    final ByteData buffer = ByteData(44 + numSamples);

    void writeStr(int offset, String s) {
      for (int i = 0; i < s.length; i++) {
        buffer.setUint8(offset + i, s.codeUnitAt(i));
      }
    }

    writeStr(0, 'RIFF');
    buffer.setUint32(4, 36 + numSamples, Endian.little);
    writeStr(8, 'WAVE');
    writeStr(12, 'fmt ');
    buffer.setUint32(16, 16, Endian.little);
    buffer.setUint16(20, 1, Endian.little);
    buffer.setUint16(22, 1, Endian.little);
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, sampleRate, Endian.little);
    buffer.setUint16(32, 1, Endian.little);
    buffer.setUint16(34, 8, Endian.little);
    writeStr(36, 'data');
    buffer.setUint32(40, numSamples, Endian.little);

    final math.Random rng = math.Random(42);
    double prev = 0.0;
    for (int i = 0; i < numSamples; i++) {
      final double progress = i / numSamples;
      final double envelope = math.sin(progress * math.pi);
      final double white = (rng.nextDouble() * 2.0 - 1.0);
      prev = prev * 0.65 + white * 0.35;
      final int sample = (128 + (prev * envelope * 115)).clamp(0, 255).toInt();
      buffer.setUint8(44 + i, sample);
    }
    return buffer.buffer.asUint8List();
  }

  Future<void> _startNatureAmbience() async {
    if (!_natureSoundEnabled) return;
    try {
      await _ambiencePlayer.stop();
      await _ambiencePlayer.setReleaseMode(ReleaseMode.loop);
      await _ambiencePlayer.play(AssetSource('audio/song_morning.mp3'), volume: 0.35);
    } catch (_) {}
  }

  Future<void> _stopNatureAmbience() async {
    try {
      await _ambiencePlayer.stop();
    } catch (_) {}
  }

  Future<void> _playPageFlipSound() async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.play(BytesSource(_generatePaperFlipWav()), volume: 1.0);
    } catch (_) {}
  }

  void _triggerBookPageFlip() {
    _pageTurnCtrl.forward(from: 0.0);
    _playPageFlipSound();
  }

  Future<void> _playAudioTrack(String fileName, String bubbleText, {int bonusStars = 0}) async {
    setState(() {
      _currentTrack = fileName;
      _owlBubble = bubbleText;
      _isPlaying = true;
      _owlBounce = true;
      _stars += bonusStars;
    });
    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.play(AssetSource('audio/$fileName'), volume: 1.0);
    } catch (_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _owlBubble = '⚠️ تعذر تشغيل الصوت (audio/$fileName)';
        });
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
        if (_isStoryQuizMode) {
          _isStoryQuizMode = false;
          _storyQuizSelectedOption = null;
        } else {
          _selectedBookIndex = -1;
          _owlBubble = 'اخْتَرْ قِصَّةً مِنَ المَكْتَبَةِ لِتَقْرَأَهَا فِي الكِتَابِ المُتَحَرِّكِ!';
        }
      } else if (_screenIndex == 3 && _selectedQuizIndex != -1) {
        _selectedQuizIndex = -1;
        _owlBubble = 'اخْتَرْ لُعْبَةً مِنَ الأَلْعَابِ الدَّائِرِيَّةِ!';
      } else if ((_screenIndex == 4 || _screenIndex == 5) && _isVideoExpanded) {
        _isVideoExpanded = false;
      }
    });
  }

  String _buildEmbedHtml(String videoId) {
    final String embedUrl =
        'https://www.youtube-nocookie.com/embed/$videoId?autoplay=1&rel=0&modestbranding=1&playsinline=1&iv_load_policy=3&loop=1&playlist=$videoId';
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { width: 100%; height: 100%; background-color: #000000; overflow: hidden; }
    iframe { width: 100%; height: 100%; border: 0; }
  </style>
</head>
<body>
  <iframe
    src="$embedUrl"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen>
  </iframe>
</body>
</html>
''';
  }

  void _playDirectNativeVideo(String videoId) {
    final WebViewController ctrl = _webController ??
        (WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0xFF000000)));
    _webController = ctrl;
    ctrl.loadHtmlString(
      _buildEmbedHtml(videoId),
      baseUrl: 'https://www.youtube-nocookie.com',
    );
    setState(() {
      _hasActiveVideo = true;
    });
  }

  void _pauseVideoIfAny() {
    _webController?.loadRequest(Uri.parse('about:blank'));
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
    final WebViewController? ctrl = _webController;
    if (!_hasActiveVideo || ctrl == null) {
      return Center(
        child: FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('تَشْغِيلُ الفِيدْيُو'),
        ),
      );
    }
    return Stack(
      children: [
        WebViewWidget(controller: ctrl),
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
                  _pauseVideoIfAny();
                  setState(() {
                    _isPlaying = false;
                    _isVideoExpanded = false;
                    _hasActiveVideo = false;
                    _selectedSongIndex = -1;
                    _selectedBookIndex = -1;
                    _isStoryQuizMode = false;
                    _storyQuizSelectedOption = null;
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
                    _pauseVideoIfAny();
                    setState(() {
                      _isPlaying = false;
                      _hasActiveVideo = false;
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
          if (!isReadingOpenStory)
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
    if (_screenIndex == 2) return _selectedBookIndex == -1 ? _buildBooksCircleHub() : _buildInteractiveFlipBookViewer(_books[_selectedBookIndex]);
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
            _isVideoExpanded = true;
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
            _isVideoExpanded = true;
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
              subLabel: '6 Books + Quizzes',
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
                  _isStoryQuizMode = false;
                  _storyQuizSelectedOption = null;
                  _owlBubble = '📖 اخْتَرْ قِصَّةً مِنَ الكُتُبِ السِّتَّةِ لِتَقْرَأَهَا وَتُجِيبَ عَنْ سُؤَالِهَا!';
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
                  _isVideoExpanded = true;
                  _screenIndex = 4;
                  _owlBubble = 'تَفْسِيرُ القُرْآنِ الكَرِيمِ! تُشَاهِدُ الآنَ: ${first.arabicTitle}';
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
                  _isVideoExpanded = true;
                  _screenIndex = 5;
                  _owlBubble = 'تِلَاوَةُ القُرْآنِ الكَرِيمِ! تَسْتَمِعُ الآنَ إِلَى: ${first.arabicTitle}';
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
                Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ringColor)),
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
    final int half = (s.verses.length / 2).ceil();
    final List<String> rightCol = s.verses.sublist(0, half);
    final List<String> leftCol = s.verses.sublist(half);
    final bool isLongSong = s.verses.length > 12;
    final double verseFontSize = isLongSong ? 13.0 : 17.5;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(248),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: s.color, width: 4.5),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 190,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: s.color, width: 4), color: Colors.white),
                    child: ClipOval(child: Image.asset(s.imagePath, fit: BoxFit.cover)),
                  ),
                  const SizedBox(height: 8),
                  Text('${s.emoji} ${s.title}', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: s.color)),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: active ? const Color(0xFF10B981) : s.color,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => _playAudioTrack(s.audioFile, s.subtitle, bonusStars: 2),
                    icon: Icon(active ? Icons.graphic_eq_rounded : Icons.volume_up_rounded, size: 22),
                    label: Text(active ? 'تَعْمَلُ الآنَ' : 'اسْتَمِعْ 🔊', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: s.color.withAlpha(110), width: 2.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: rightCol
                            .map((String line) => Text(
                                  line,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: verseFontSize, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                                ))
                            .toList(),
                      ),
                    ),
                    Container(width: 2, margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), color: s.color.withAlpha(70)),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: leftCol
                            .map((String line) => Text(
                                  line,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: verseFontSize, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksCircleHub() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_books.length, (int i) {
            final StoryBookItem book = _books[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildCircularIconPortal(
                circleSize: 138,
                label: '📖 ${book.title}',
                subLabel: '${book.englishTitle} • ٨ صَفَحَاتٍ + سُؤَالٌ',
                imagePath: book.imagePath,
                ringColor: book.color,
                badgeBg: Colors.white,
                onTap: () {
                  _triggerBookPageFlip();
                  _startNatureAmbience();
                  setState(() {
                    _selectedBookIndex = i;
                    _currentPageIndex = 0;
                    _isStoryQuizMode = false;
                    _storyQuizSelectedOption = null;
                    _owlBubble = 'أَنْتَ تَقْرَأُ الآنَ: ${book.title} (${book.pages[0].pageTitle})';
                  });
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInteractiveFlipBookViewer(StoryBookItem book) {
    final StoryPageData page = book.pages[_currentPageIndex];
    final bool isFirstPage = _currentPageIndex == 0;
    final bool isLastPage = _currentPageIndex == book.pages.length - 1;

    return AnimatedBuilder(
      animation: Listenable.merge([_natureAnimCtrl, _pageTurnCtrl]),
      builder: (BuildContext context, _) {
        final double t = _natureAnimCtrl.value;
        final double wave = math.sin(t * math.pi * 2);
        final double hop = (math.sin(t * math.pi * 4)).abs() * -14;
        final double floatY = math.cos(t * math.pi * 2) * 8;

        final double flipProgress = _pageTurnCtrl.isAnimating ? _pageTurnCtrl.value : 1.0;
        final double flipAngle = (1.0 - flipProgress) * (math.pi / 2.4);

        return Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _AnimatedForestLandscapePainter(
                progress: t,
                skyColors: page.skyGradient,
                hillColor: page.hillColor,
              ),
              size: Size.infinite,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(34, 8, 34, 12),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0008)
                  ..rotateY(flipAngle),
                child: Container(
                  decoration: BoxDecoration(
                    color: book.color,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 18, offset: Offset(0, 8)),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF7),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            color: book.color.withAlpha(235),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isStoryQuizMode
                                        ? '${book.title}  •  🌟 تَحَدِّي فَهْمِ القِصَّةِ'
                                        : '${book.title}  •  ${page.pageTitle}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                decoration: BoxDecoration(color: Colors.white.withAlpha(50), borderRadius: BorderRadius.circular(14)),
                                child: Text(
                                  _isStoryQuizMode
                                      ? 'سُؤَالُ القِصَّةِ'
                                      : 'صَفْحَةُ ${_currentPageIndex + 1} مِنْ ${book.pages.length}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _isStoryQuizMode
                              ? _buildStoryEndQuizPage(book)
                              : Row(
                                  children: [
                                    Expanded(
                                      flex: 52,
                                      child: Container(
                                        margin: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: book.color.withAlpha(90), width: 2.5),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(18),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              CustomPaint(
                                                painter: _AnimatedForestLandscapePainter(
                                                  progress: t,
                                                  skyColors: page.skyGradient,
                                                  hillColor: page.hillColor,
                                                ),
                                              ),
                                              Positioned(
                                                top: 12,
                                                left: 18 + (wave * 10),
                                                child: Transform.rotate(
                                                  angle: wave * 0.1,
                                                  child: Text(page.skyElement, style: const TextStyle(fontSize: 42)),
                                                ),
                                              ),
                                              Positioned(
                                                top: 18 + floatY,
                                                right: 22 - (wave * 12),
                                                child: Text(page.actor3, style: const TextStyle(fontSize: 34)),
                                              ),
                                              Positioned(
                                                bottom: 22,
                                                right: 36 + (wave * 14),
                                                child: Transform.translate(
                                                  offset: Offset(0, hop),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white.withAlpha(215),
                                                      border: Border.all(color: book.color, width: 2.5),
                                                    ),
                                                    child: Text(page.mainActor, style: const TextStyle(fontSize: 48)),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 26,
                                                left: 36 - (wave * 14),
                                                child: Transform.translate(
                                                  offset: Offset(0, floatY),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white.withAlpha(200),
                                                      border: Border.all(color: const Color(0xFFF59E0B), width: 2),
                                                    ),
                                                    child: Text(page.actor2, style: const TextStyle(fontSize: 40)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 10,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withAlpha(15),
                                            Colors.black.withAlpha(55),
                                            Colors.black.withAlpha(15),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 48,
                                      child: Center(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: book.color.withAlpha(140), width: 2.5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: book.color.withAlpha(35),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: SingleChildScrollView(
                                                  child: Text(
                                                    page.text,
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                      fontSize: _storyFontSize,
                                                      height: 1.75,
                                                      fontWeight: FontWeight.bold,
                                                      color: const Color(0xFF1E293B),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (isLastPage)
                                                Container(
                                                  width: double.infinity,
                                                  margin: const EdgeInsets.only(top: 10),
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFEF3C7),
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(color: const Color(0xFFF59E0B), width: 2),
                                                  ),
                                                  child: Text(
                                                    '🌟 ${book.moral}',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
                          child: _isStoryQuizMode
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0284C7),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      ),
                                      onPressed: () {
                                        _triggerBookPageFlip();
                                        setState(() {
                                          _isStoryQuizMode = false;
                                          _storyQuizSelectedOption = null;
                                        });
                                      },
                                      icon: const Icon(Icons.arrow_back_rounded, size: 22),
                                      label: const Text('العَوْدَةُ لِلْقِصَّةِ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF10B981),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      ),
                                      onPressed: () async {
                                        await _stopNatureAmbience();
                                        setState(() {
                                          _isStoryQuizMode = false;
                                          _storyQuizSelectedOption = null;
                                          _selectedBookIndex = -1;
                                          _owlBubble = 'اخْتَرْ قِصَّةً أُخْرَى مِنَ المَكْتَبَةِ السِّتَّةِ!';
                                        });
                                      },
                                      icon: const Icon(Icons.library_books_rounded, size: 22),
                                      label: const Text('اخْتِيَارُ قِصَّةٍ جَدِيدَةٍ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isFirstPage ? Colors.grey.shade300 : const Color(0xFF0284C7),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      ),
                                      onPressed: isFirstPage
                                          ? null
                                          : () {
                                              _triggerBookPageFlip();
                                              final int prev = _currentPageIndex - 1;
                                              setState(() {
                                                _currentPageIndex = prev;
                                                _owlBubble = 'صَفْحَةُ ${prev + 1}: ${book.pages[prev].pageTitle}';
                                              });
                                            },
                                      icon: const Icon(Icons.arrow_back_rounded, size: 22),
                                      label: const Text('الصَّفْحَةُ السَّابِقَةُ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    ),
                                    Row(
                                      children: [
                                        IconButton.filledTonal(
                                          tooltip: 'تَصْغِيرُ الخَطِّ',
                                          onPressed: () {
                                            if (_storyFontSize > 16) setState(() => _storyFontSize -= 1.5);
                                          },
                                          icon: const Icon(Icons.text_decrease_rounded, size: 20),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${_currentPageIndex + 1} / ${book.pages.length}',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: book.color),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton.filledTonal(
                                          tooltip: 'تَكْبِيرُ الخَطِّ',
                                          onPressed: () {
                                            if (_storyFontSize < 26) setState(() => _storyFontSize += 1.5);
                                          },
                                          icon: const Icon(Icons.text_increase_rounded, size: 20),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isLastPage ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      ),
                                      onPressed: () {
                                        if (!isLastPage) {
                                          _triggerBookPageFlip();
                                          final int next = _currentPageIndex + 1;
                                          setState(() {
                                            _currentPageIndex = next;
                                            _owlBubble = 'صَفْحَةُ ${next + 1}: ${book.pages[next].pageTitle}';
                                          });
                                        } else {
                                          _triggerBookPageFlip();
                                          setState(() {
                                            _isStoryQuizMode = true;
                                            _storyQuizSelectedOption = null;
                                            _owlBubble = '🌟 أَجِبْ عَنْ سُؤَالِ القِصَّةِ لِتَرْبَحَ 20 نَجْمَةً!';
                                          });
                                        }
                                      },
                                      icon: Icon(isLastPage ? Icons.quiz_rounded : Icons.arrow_forward_rounded, size: 22),
                                      label: Text(isLastPage ? 'سُؤَالُ القِصَّةِ (+20 ⭐)' : 'الصَّفْحَةُ التَّالِيَةُ', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStoryEndQuizPage(StoryBookItem book) {
    final StoryQuestionData q = book.quiz;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 45,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: book.color.withAlpha(22),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: book.color, width: 2.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🦉❓', style: TextStyle(fontSize: 44)),
                  const SizedBox(height: 8),
                  Text(
                    'سُؤَالُ الفَهْمِ وَالاسْتِيعَابِ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: book.color),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    q.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 19, height: 1.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            flex: 55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(q.options.length, (int idx) {
                final bool isSelected = _storyQuizSelectedOption == idx;
                final bool isCorrect = idx == q.correctIndex;
                Color bgColor = const Color(0xFFE0F2FE);
                Color fgColor = const Color(0xFF0369A1);

                if (isSelected) {
                  if (isCorrect) {
                    bgColor = const Color(0xFF10B981);
                    fgColor = Colors.white;
                  } else {
                    bgColor = const Color(0xFFEF4444);
                    fgColor = Colors.white;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bgColor,
                        foregroundColor: fgColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () {
                        final bool alreadyAnsweredCorrectly = _storyQuizSelectedOption == q.correctIndex;
                        setState(() {
                          _storyQuizSelectedOption = idx;
                        });
                        if (isCorrect) {
                          _playAudioTrack(
                            'bravo.mp3',
                            '🎉👏 إِجَابَةٌ صَحِيحَةٌ يَا بَطَلَ القِرَاءَةِ! +20 نَجْمَةً!',
                            bonusStars: alreadyAnsweredCorrectly ? 0 : 20,
                          );
                        } else {
                          _playAudioTrack(
                            'try_again.mp3',
                            'لَا بَأْسَ يَا صَدِيقِي! فَكِّرْ مَرَّةً أُخْرَى وَاخْتَرِ الإِجَابَةَ الصَّحِيحَةَ!',
                          );
                        }
                      },
                      child: Text(
                        q.options[idx],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
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

class _AnimatedForestLandscapePainter extends CustomPainter {
  final double progress;
  final List<Color> skyColors;
  final Color hillColor;

  _AnimatedForestLandscapePainter({
    required this.progress,
    required this.skyColors,
    required this.hillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double sway = math.sin(progress * math.pi * 2);

    final Paint skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: skyColors,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), skyPaint);

    final Paint cloudPaint = Paint()..color = Colors.white.withAlpha(205);
    final double cloud1X = ((progress * w * 0.4) + w * 0.15) % (w + 160) - 80;
    final double cloud2X = ((progress * w * 0.25) + w * 0.65) % (w + 180) - 90;
    _drawCloud(canvas, Offset(cloud1X, h * 0.16), 0.9, cloudPaint);
    _drawCloud(canvas, Offset(cloud2X, h * 0.24), 0.75, cloudPaint);

    final Path backHill = Path()
      ..moveTo(0, h * 0.66)
      ..quadraticBezierTo(w * 0.3, h * 0.52, w * 0.6, h * 0.64)
      ..quadraticBezierTo(w * 0.82, h * 0.72, w, h * 0.58)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backHill, Paint()..color = hillColor.withAlpha(155));

    final Path frontHill = Path()
      ..moveTo(0, h * 0.76)
      ..quadraticBezierTo(w * 0.25, h * 0.70, w * 0.55, h * 0.78)
      ..quadraticBezierTo(w * 0.80, h * 0.84, w, h * 0.73)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = hillColor);

    _drawSwayingTree(canvas, Offset(w * 0.12, h * 0.76), 95, sway * 9, const Color(0xFF15803D));
    _drawSwayingTree(canvas, Offset(w * 0.88, h * 0.75), 105, -sway * 10, const Color(0xFF166534));
    _drawSwayingTree(canvas, Offset(w * 0.28, h * 0.70), 65, sway * 6, const Color(0xFF22C55E));

    final Paint flowerPaint = Paint()..color = const Color(0xFFFACC15);
    for (int i = 1; i <= 6; i++) {
      final double fx = (w * i) / 7.0 + (sway * 3);
      final double fy = h * 0.86 + ((i % 2) * 12);
      canvas.drawCircle(Offset(fx, fy), 4.5, flowerPaint);
      canvas.drawCircle(Offset(fx, fy), 1.8, Paint()..color = Colors.white);
    }
  }

  void _drawCloud(Canvas canvas, Offset center, double scale, Paint paint) {
    canvas.drawCircle(center, 22 * scale, paint);
    canvas.drawCircle(center + Offset(20 * scale, 4 * scale), 18 * scale, paint);
    canvas.drawCircle(center + Offset(-20 * scale, 5 * scale), 16 * scale, paint);
  }

  void _drawSwayingTree(Canvas canvas, Offset base, double height, double swayOffset, Color leafColor) {
    final Paint trunkPaint = Paint()..color = const Color(0xFF78350F);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(base.dx - 7, base.dy - height * 0.55, 14, height * 0.6),
        const Radius.circular(5),
      ),
      trunkPaint,
    );

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
