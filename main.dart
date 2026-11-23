import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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
  final YoutubeExplode _yt = YoutubeExplode();

  VideoPlayerController? _videoController;
  bool _isVideoLoading = false;
  String? _videoError;

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
      audioFile: 'alphabet.mp3',
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
      audioFile: 'numbers.mp3',
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
      title: 'أُنْشُودَةُ الطَّبِيعَةِ وَالغَابَةِ',
      englishTitle: 'Nature & Forest Song',
      subtitle: 'أُنْشُودَةُ الأَشْجَارِ وَالعَصَافِيرِ!',
      audioFile: 'nature.mp3',
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
