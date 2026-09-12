import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:btrlyfe/appcolors.dart';

class StressPage extends StatefulWidget {
  const StressPage({super.key});

  @override
  State<StressPage> createState() => _StressPageState();
}


TextStyle mainfont ( value){
  return GoogleFonts.titanOne(textStyle: value);
}


class _StressPageState extends State<StressPage> {
  int selectedMood = -1;
  String journalText = '';

  final List<String> moods = [
    '😄',
    '🙂',
    '😐',
    '😟',
    '😣',
  ];

  final List<String> moodNames = [
    'Great',
    'Good',
    'Okay',
    'Stressed',
    'Very Stressed',
  ];

  String getRecommendation() {
    switch (selectedMood) {
      case 0:
        return 'You seem to be doing great! Keep your momentum going and remember to take regular breaks.';
      case 1:
        return 'You seem to be doing well. A short break can help you stay focused throughout the day.';
      case 2:
        return 'You seem to be feeling okay. Consider taking a few minutes to relax before continuing your work.';
      case 3:
        return 'You seem stressed. Try taking a 5-minute break, drinking some water, and doing a calming activity.';
      case 4:
        return 'You seem very stressed. Step away from your work for a moment and consider talking to someone you trust.';
      default:
        return 'Check in with your mood to receive a personalized recommendation.';
    }
  }

  void saveMood() {
    if (selectedMood == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose how you are feeling first.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Check-in saved 🌱'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColors>();
    Color primarycolor = colors.primaryColor;
    Color secondarycolor = colors.secondaryColor;
    Color tertiarycolor = colors.tertiaryColor;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primarycolor,
            tertiarycolor,
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stress & Well-being',
                style: mainfont(const TextStyle(color: Colors.white, fontSize: 28)),
              ),

              const SizedBox(height: 6),

              const Text(
                'Take a moment to check in with yourself.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              // =================================================
              // DAILY MOOD CHECK-IN
              // =================================================

              _sectionTitle(
                Icons.favorite_outline,
                'Daily Mood Check-in',
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    const Text(
                      'How are you feeling today?',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color:Colors.white
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: List.generate(
                        moods.length,
                        (index) {
                          final isSelected =
                              selectedMood == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMood = index;
                              });
                            },
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 200,
                                  ),
                                  padding:
                                      const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0x00FFFFFF),
                                    border: Border.all(
                                      color: isSelected
                                          ? secondarycolor
                                          : const Color(
                                              0x00000000,
                                            ),
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    moods[index],
                                    style: const TextStyle(
                                      fontSize: 29,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  moodNames[index],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:Colors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                            'Optional: What is making you feel this way?',
                            hintStyle: const TextStyle(color:Colors.white),
                        filled: true,
                        fillColor:
                            Colors.white.withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(
                            color: Color(0x00000000),
                          ),
                        ),
                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(
                            color: Color(0x00000000),
                          ),
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                          borderSide:
                              BorderSide(
                            color: secondarycolor,
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        journalText = value;
                      },
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: secondarycolor, 
                          foregroundColor: Colors.white, 
                        ),
                        onPressed: saveMood,
                        icon: const Icon(Icons.check),
                        label:
                            const Text('Save Check-in'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =================================================
              // RECOMMENDATION
              // =================================================

              _sectionTitle(
                Icons.auto_awesome,
                'BtrLyfe Recommendation',
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💡',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        getRecommendation(),
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.45,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =================================================
              // STRESS RELIEF GAMES
              // =================================================

              _sectionTitle(
                Icons.spa_outlined,
                'Take a Break',
              ),

              const SizedBox(height: 8),

              const Text(
                'Take a short break with one of these relaxing activities.',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 15),

              // ROW 1
              Row(
                children: [
                  Expanded(
                    child: _gameCard(
                      icon: Icons.air,
                      title: 'Breathing',
                      subtitle: '2 minutes',
                      onTap: _showBreathingGame,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _gameCard(
                      icon:
                          Icons.bubble_chart_outlined,
                      title: 'Bubble Pop',
                      subtitle: '30 seconds',
                      onTap: _showBubbleGame,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ROW 2
              Row(
                children: [
                  Expanded(
                    child: _gameCard(
                      icon: Icons.psychology_outlined,
                      title: 'Memory Match',
                      subtitle: '1–2 minutes',
                      onTap: _showMemoryGame,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _gameCard(
                      icon: Icons.palette_outlined,
                      title: 'Color Tap',
                      subtitle: '1 minute',
                      onTap: _showColorGame,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // =================================================
              // SUPPORT
              // =================================================

              _sectionTitle(
                Icons.people_outline,
                'Need Support?',
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "You don't have to handle everything alone.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Consider reaching out to a parent, guardian, teacher, counselor, or another trusted person.',
                      style: TextStyle(
                        color:Colors.white,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 15),

                    OutlinedButton.icon(
                      onPressed:
                          _showSupportDialog,
                      icon: Icon(
                        Icons.chat_bubble_outline,
                        color: secondarycolor,
                      ),
                      label: const Text(
                        'Find Someone to Talk To',
                        style: TextStyle(color:Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================
  Widget _sectionTitle(
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 23,
          color: context.watch<AppColors>().secondaryColor,
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: mainfont(const TextStyle(color: Colors.white, fontSize: 20))
        ),
      ],
    );
  }

  // ==========================================================
  // GAME CARD
  // ==========================================================

  Widget _gameCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: context.watch<AppColors>().secondaryColor,
              ),
            ),

            const SizedBox(height: 13),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color:Colors.white
              ),
            ),

            const SizedBox(height: 3),

            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CARD STYLE
  // ==========================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  // ==========================================================
  // BREATHING GAME
  // ==========================================================

  void _showBreathingGame() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const _BreathingDialog();
      },
    );
  }

  // ==========================================================
  // BUBBLE GAME
  // ==========================================================

  void _showBubbleGame() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const _BubbleDialog();
      },
    );
  }

  // ==========================================================
  // MEMORY GAME
  // ==========================================================

  void _showMemoryGame() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const _MemoryDialog();
      },
    );
  }

  // ==========================================================
  // COLOR GAME
  // ==========================================================

  void _showColorGame() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const _ColorTapDialog();
      },
    );
  }

  // ==========================================================
  // SUPPORT
  // ==========================================================

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.people_outline,
                color: context.watch<AppColors>().secondaryColor,
              ),

              const SizedBox(width: 10),

              const Text('Reach Out'),
            ],
          ),

          content: const Text(
            "You don't have to handle everything alone.\n\n"
            'Consider talking to a parent, guardian, teacher, school counselor, or another trusted adult.',
            style: TextStyle(
              height: 1.4,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// BREATHING DIALOG
// ============================================================

class _BreathingDialog extends StatefulWidget {
  const _BreathingDialog();

  @override
  State<_BreathingDialog> createState() =>
      _BreathingDialogState();
}

class _BreathingDialogState
    extends State<_BreathingDialog>
    with SingleTickerProviderStateMixin {

  late AnimationController animationController;

  Timer? timer;

  String instruction = 'Breathe In';
  int seconds = 4;
  int cycles = 0;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        setState(() {
          seconds--;

          if (seconds <= 0) {
            seconds = 4;

            if (instruction == 'Breathe In') {
              instruction = 'Breathe Out';
            } else {
              instruction = 'Breathe In';
              cycles++;
            }
          }
        });
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Breathing Exercise',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 15),

            const Text(
              'Follow the circle and breathe slowly.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 35),

            AnimatedBuilder(
              animation: animationController,
              builder: (_, __) {
                final scale =
                    0.75 +
                    animationController.value * 0.4;

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration:
                        const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEDE7F6),
                    ),
                    child: Center(
                      child: Text(
                        '$seconds',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: context.watch<AppColors>().secondaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            Text(
              instruction,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Cycles completed: $cycles',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Finish Break'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BUBBLE POP DIALOG
// ============================================================

class _BubbleDialog extends StatefulWidget {
  const _BubbleDialog();

  @override
  State<_BubbleDialog> createState() =>
      _BubbleDialogState();
}

class _BubbleDialogState extends State<_BubbleDialog> {

  Timer? timer;

  int score = 0;
  int timeLeft = 30;

  double x = 0.5;
  double y = 0.5;

  bool finished = false;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        setState(() {
          timeLeft--;

          if (timeLeft <= 0) {
            finished = true;
            timer?.cancel();
          }
        });
      },
    );
  }

  void popBubble() {
    if (finished) return;

    setState(() {
      score++;

      x = 0.1 +
          (0.8 * ((score * 37) % 100) / 100);

      y = 0.1 +
          (0.65 * ((score * 61) % 100) / 100);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: SizedBox(
        height: 550,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                15,
                10,
                10,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Bubble Pop',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time: $timeLeft',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'Score: $score',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bubbleX =
                      constraints.maxWidth * x;

                  final bubbleY =
                      constraints.maxHeight * y;

                  return Stack(
                    children: [
                      Positioned(
                        left: bubbleX,
                        top: bubbleY,
                        child: GestureDetector(
                          onTap: popBubble,
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration:
                                const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 211, 211, 211),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.touch_app,
                                color:
                                    context.watch<AppColors>().secondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),

                      if (finished)
                        Center(
                          child: _gameFinishedCard(
                            title: 'Nice break!',
                            message:
                                'You popped $score bubbles.',
                            emoji: '🌱',
                            onDone: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MEMORY MATCH DIALOG
// ============================================================

class _MemoryDialog extends StatefulWidget {
  const _MemoryDialog();

  @override
  State<_MemoryDialog> createState() =>
      _MemoryDialogState();
}

class _MemoryDialogState extends State<_MemoryDialog> {

  final List<String> symbols = [
    '🌸',
    '🌸',
    '🐱',
    '🐱',
    '⭐',
    '⭐',
    '🌈',
    '🌈',
  ];

  late List<String> cards;
  late List<bool> revealed;
  late List<bool> matched;

  int firstCard = -1;
  int matches = 0;
  bool busy = false;

  @override
  void initState() {
    super.initState();

    cards = List.from(symbols);
    cards.shuffle();

    revealed =
        List.filled(cards.length, false);

    matched =
        List.filled(cards.length, false);
  }

  Future<void> flipCard(int index) async {
    if (busy ||
        revealed[index] ||
        matched[index]) {
      return;
    }

    setState(() {
      revealed[index] = true;
    });

    if (firstCard == -1) {
      firstCard = index;
      return;
    }

    final secondCard = index;

    setState(() {
      busy = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    if (cards[firstCard] == cards[secondCard]) {
      setState(() {
        matched[firstCard] = true;
        matched[secondCard] = true;
        matches++;
        firstCard = -1;
        busy = false;
      });
    } else {
      setState(() {
        revealed[firstCard] = false;
        revealed[secondCard] = false;
        firstCard = -1;
        busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = matches == 4;

    return Dialog(
      insetPadding: const EdgeInsets.all(18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Memory Match',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const Text(
              'Match all the pairs.',
            ),

            const SizedBox(height: 15),

            Text(
              'Matches: $matches / 4',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: cards.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final visible =
                    revealed[index] ||
                    matched[index];

                return GestureDetector(
                  onTap: () => flipCard(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: visible
                          ? const Color(0xFFEDE7F6)
                          : context.watch<AppColors>().secondaryColor,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        visible
                            ? cards[index]
                            : '?',
                        style: TextStyle(
                          fontSize:
                              visible ? 28 : 25,
                          color: visible
                              ? const Color(
                                  0xFF333333,
                                )
                              : const Color(
                                  0xFFFFFFFF,
                                ),
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            if (completed)
              const Text(
                '🎉 Great job! You found them all!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: completed
                    ? () => Navigator.pop(context)
                    : null,
                child: const Text('Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// COLOR TAP DIALOG
// ============================================================

class _ColorTapDialog extends StatefulWidget {
  const _ColorTapDialog();

  @override
  State<_ColorTapDialog> createState() =>
      _ColorTapDialogState();
}

class _ColorTapDialogState
    extends State<_ColorTapDialog> {

  final Random random = Random();

  final List<Color> availableColors = [
    const Color(0xFFE53935),
    const Color(0xFF43A047),
    const Color(0xFF1E88E5),
    const Color(0xFFFDD835),
    const Color(0xFF8E24AA),
    const Color(0xFFFB8C00),
  ];

  final List<String> colorNames = [
    'RED',
    'GREEN',
    'BLUE',
    'YELLOW',
    'PURPLE',
    'ORANGE',
  ];

  int target = 0;
  int score = 0;
  int timeLeft = 30;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    generateRound();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        setState(() {
          timeLeft--;

          if (timeLeft <= 0) {
            timer?.cancel();
          }
        });
      },
    );
  }

  void generateRound() {
    target = random.nextInt(
      availableColors.length,
    );
  }

  void selectColor(int index) {
    if (timeLeft <= 0) return;

    if (index == target) {
      setState(() {
        score++;
        generateRound();
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text('Not quite! Try again.'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final finished = timeLeft <= 0;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Color Tap',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 5),

            if (!finished) ...[
              const Text(
                'Tap the requested color!',
              ),

              const SizedBox(height: 20),

              Text(
                colorNames[target],
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: availableColors[target],
                ),
              ),

              const SizedBox(height: 20),

              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () =>
                        selectColor(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: availableColors[index],
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time: $timeLeft',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'Score: $score',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],

            if (finished) ...[
              const Text(
                '🎨',
                style: TextStyle(
                  fontSize: 50,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Time is up!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'You scored $score points.',
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// GAME FINISHED CARD
// ============================================================

Widget _gameFinishedCard({
  required String title,
  required String message,
  required String emoji,
  required VoidCallback onDone,
}) {
  return Container(
    padding: const EdgeInsets.all(25),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x22000000),
          blurRadius: 15,
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          emoji,
          style: const TextStyle(
            fontSize: 42,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(message),

        const SizedBox(height: 18),

        FilledButton(
          onPressed: onDone,
          child: const Text('Done'),
        ),
      ],
    ),
  );
}