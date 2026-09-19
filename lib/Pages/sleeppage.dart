import 'dart:async';
import 'package:btrlyfe/appstate.dart';
import 'package:btrlyfe/sleepamount.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'package:btrlyfe/appcolors.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {

  DateTime currentTime = DateTime.now();

  Timer? timer;

  

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    // Update current time
    timer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        setState(() {
          currentTime = DateTime.now();
        });
      },
    );

    // Website controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          'https://www.caffeineinformer.com/the-caffeine-database',
        ),
      );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  TextStyle mainFont(TextStyle value) {
    return GoogleFonts.titanOne(textStyle: value);
  }

  // Convert sleep time into hours
  double get sleepHour {
    return context.read<AppState>().sleepTime.hour + context.read<AppState>().sleepTime.minute / 60.0;
  }

  // Convert current time into hours
  double get currentHour {
    return currentTime.hour + currentTime.minute / 60.0;
  }

  // Hours from now until sleep
  double get hoursUntilSleep {
    double difference = sleepHour - currentHour;

    if (difference < 0) {
      difference += 24;
    }

    return difference;
  }

  String get status {
    if (hoursUntilSleep <= 5) {
      return "Danger";
    } else if (hoursUntilSleep <= 6) {
      return "Warning";
    } else {
      return "Good";
    }
  }

  Color get statusColor {
    switch (status) {
      case "Danger":
        return Colors.redAccent;

      case "Warning":
        return Colors.amber;

      default:
        return Colors.greenAccent;
    }
  }

  String get statusMessage {
    switch (status) {
      case "Danger":
        return "The 5-hour window has reached your sleep time.";

      case "Warning":
        return "The caffeine window is within 1 hour of your sleep time.";

      default:
        return "You are outside the 5-hour caffeine window.";
    }
  }

  Future<void> selectSleepTime() async {
  final picked = await showTimePicker(
    context: context,
    initialTime: context.read<AppState>().sleepTime,
  );

  if (picked != null) {
    context.read<AppState>().setTime(picked);
  }
}

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    final sleepProvider = context.watch<SleepProvider>();
    final colors = context.watch<AppColors>();
    Color primarycolor = colors.primaryColor;
    Color secondarycolor = colors.secondaryColor;
    Color tertiarycolor = colors.tertiaryColor;
    final sleepTime = context.watch<AppState>().sleepTime;
    return Scaffold(
      body: Container(
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
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                // TITLE
                Text(
                  "Sleep",
                  style: mainFont(
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 55,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ElevatedButton(
                            onPressed: sleepProvider.isSleeping
                                ? null
                                : () {
                                    context.read<SleepProvider>().startSleep();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: secondarycolor,
                              shape: const CircleBorder(),
                              elevation: 3,
                              padding: EdgeInsets.zero,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bed,
                                  color: secondarycolor,
                                  size: 42,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Sleep',
                                  style: TextStyle(
                                    color: secondarycolor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ElevatedButton(
                            onPressed: sleepProvider.isSleeping
                                ? () {
                                    context.read<SleepProvider>().wakeUp();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: secondarycolor,
                              shape: const CircleBorder(),
                              elevation: 3,
                              padding: EdgeInsets.zero,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.wb_sunny,
                                  color: secondarycolor,
                                  size: 42,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Wake up',
                                  style: TextStyle(
                                    color: secondarycolor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                //Sleep Time Input_______________________________________________________________________________________________________________________________________

                GestureDetector(
                  onTap: selectSleepTime,

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Row(
                      children: [

                        const Icon(
                          Icons.bedtime,
                          color: Colors.white,
                          size: 35,
                        ),

                        const SizedBox(width: 15),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "I usually sleep at",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              formatTime(sleepTime),

                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Status_____________________________________________________________________________________________________________________________________________

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    children: [

                      // COLORED STATUS CIRCLE
                      Container(
                        width: 45,
                        height: 45,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusColor,

                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withOpacity(0.5),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              status,

                              style: TextStyle(
                                color: statusColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              statusMessage,

                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Timeline Title______________________________________________________________________________________________________________________________________________________

                const Text(
                  "Your Sleep Timeline",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Timeline_______________________________________________________________________________________________________________________________________________________________

                Container(
                  height: 200,
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(25),
                  ),

                  child: CustomPaint(
                    painter: SleepTimelinePainter(
                      sleepHour: sleepHour,
                      currentHour: currentHour,
                    ),

                    child: const SizedBox.expand(),
                  ),
                ),

                const SizedBox(height: 40),

                // Caffeine Data Title___________________________________________________________________________________________________________________________________________

                const Text(
                  "Caffeine Database",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Search for drinks and see how much caffeine they contain.",

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 20),

                // Webview____________________________________________________________________________________________________________________________________________________________

                Container(
                  height: 600,
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  clipBehavior: Clip.hardEdge,

                  child: WebViewWidget(
                    controller: controller,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Data from Caffeine Informer, https://www.caffeineinformer.com/the-caffeine-database",

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// =============================================================
// TIMELINE PAINTER
// =============================================================

class SleepTimelinePainter extends CustomPainter {
  final double sleepHour;
  final double currentHour;

  SleepTimelinePainter({
    required this.sleepHour,
    required this.currentHour,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPadding = 40;
    const double rightPadding = 40;

    final timelineWidth =
        size.width - leftPadding - rightPadding;

    // Middle of the timeline vertically
    final y = size.height / 2;

    // Convert hour into horizontal position
    double hourToX(double hour) {
      return leftPadding +
          (hour / 24) * timelineWidth;
    }

    // =========================================================
    // RED 5 HOUR WINDOW
    // =========================================================

    double endHour = currentHour + 5;

    final redPaint = Paint()
      ..color = Colors.red.withOpacity(0.30);

    if (endHour <= 24) {
      canvas.drawRect(
        Rect.fromLTRB(
          hourToX(currentHour),
          y - 40,
          hourToX(endHour),
          y + 40,
        ),
        redPaint,
      );
    } else {
      // Current time → midnight
      canvas.drawRect(
        Rect.fromLTRB(
          hourToX(currentHour),
          y - 40,
          hourToX(24),
          y + 40,
        ),
        redPaint,
      );

      // Midnight → remaining hours
      canvas.drawRect(
        Rect.fromLTRB(
          hourToX(0),
          y - 40,
          hourToX(endHour - 24),
          y + 40,
        ),
        redPaint,
      );
    }

    // =========================================================
    // MAIN TIMELINE
    // =========================================================

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(leftPadding, y),
      Offset(size.width - rightPadding, y),
      linePaint,
    );

    // =========================================================
    // HOUR MARKERS
    // =========================================================

    for (int hour = 0; hour <= 24; hour++) {
      final x = hourToX(hour.toDouble());

      final tickPaint = Paint()
        ..color = Colors.white.withOpacity(
          hour % 2 == 0 ? 0.8 : 0.35,
        )
        ..strokeWidth = 2;

      final tickLength =
          hour % 2 == 0 ? 18.0 : 10.0;

      // Vertical ticks instead of horizontal
      canvas.drawLine(
        Offset(x, y - tickLength),
        Offset(x, y),
        tickPaint,
      );

      // Show numbers every 2 hours
      if (hour % 2 == 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: hour.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        textPainter.paint(
          canvas,
          Offset(
            x - textPainter.width / 2,
            y + 15,
          ),
        );
      }
    }

    // =========================================================
    // CURRENT TIME LINE
    // =========================================================

    final currentX = hourToX(currentHour);

    final currentPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(currentX, y - 40),
      Offset(currentX, y + 40),
      currentPaint,
    );

    canvas.drawCircle(
      Offset(currentX, y),
      7,
      Paint()..color = Colors.white,
    );

    // =========================================================
    // SLEEP TIME LINE
    // =========================================================

    final sleepX = hourToX(sleepHour);

    final sleepPaint = Paint()
      ..color = const Color(0xFF64B5FF)
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(sleepX, y - 40),
      Offset(sleepX, y + 40),
      sleepPaint,
    );

    canvas.drawCircle(
      Offset(sleepX, y),
      7,
      Paint()
        ..color = const Color(0xFF64B5FF),
    );

    // =========================================================
    // LABELS
    // =========================================================

    drawLabel(
      canvas,
      "NOW",
      Offset(currentX - 18, y - 65),
      Colors.white,
    );

    drawLabel(
      canvas,
      "SLEEP",
      Offset(sleepX - 22, y - 65),
      const Color(0xFF64B5FF),
    );
  }

  void drawLabel(
    Canvas canvas,
    String text,
    Offset position,
    Color color,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(
    SleepTimelinePainter oldDelegate,
  ) {
    return oldDelegate.sleepHour != sleepHour ||
        oldDelegate.currentHour != currentHour;
  }
}