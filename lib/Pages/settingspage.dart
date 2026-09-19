import 'package:btrlyfe/condition.dart';
import 'package:btrlyfe/dailyvalue.dart';
import 'package:btrlyfe/items.dart';
import 'package:btrlyfe/sleepamount.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:btrlyfe/appcolors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  //SELECT THEME________________________________________________________________________________________________________________________________

  void _selectTheme(
    BuildContext context,
    Color color1,
    Color color2,
    Color color3,
  ) {
    context.read<AppColors>().setColors(
      primary: color1,
      secondary: color2,
      tertiary: color3,
    );
  }

  //THEME BUTTONS______________________________________________________________________________________________________________________

  Widget _colorButton(
    BuildContext context,
    Color color1,
    Color color2,
    Color color3,
    String name,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color1,
                color3,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              _selectTheme(
                context,
                color1,
                color2,
                color3,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
            ),
            child: const SizedBox(),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          name,
          style: TextStyle(
            color: color2,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  TextStyle mainfont(value) {
    return GoogleFonts.titanOne(textStyle: value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColors>();
    final brightness = colors.brightness;

    final sleepProvider = context.watch<SleepProvider>();
    final moodProvider = context.watch<DailyValueProvider>();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final sleepHours = sleepProvider.sleepHours[today] ?? 0.0;
    final mood = moodProvider.dailyValues[today] ?? -1;

    final items = context.watch<Items>();
    final studyMinutesByDate = items.getStudyMinutesByDate();

    final studyMinutes = studyMinutesByDate[today] ?? 0;

    final conditionScore = context
        .read<ConditionProvider>()
        .calculateCondition(
          sleepHours,
          mood,
          studyMinutes,
        );

    Color primarycolor = colors.primaryColor;
    Color secondarycolor = colors.secondaryColor;
    Color tertiarycolor = colors.tertiaryColor;

    

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
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

        child: SingleChildScrollView(
          child: Column(
            children: [


              Align(
                alignment: Alignment.center,
                child: Text(
                  "Status",
                  style: mainfont(
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 55,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //BRAIN BATTERY______________________________________________________________________________________________________________________________________-

              const Text(
                "Brain Battery",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 100,
                child: Image.asset(
                  'assets/brainpng.webp',
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    height: 30,
                    child: conditionScore.round() > 80
                        ? Image.asset('assets/FullBat.png')
                        : conditionScore.round() > 60
                            ? Image.asset('assets/HighBat.png')
                            : conditionScore.round() > 40
                                ? Image.asset('assets/MidBat.png')
                                : Image.asset('assets/LowBat.png'),
                  ),

                  const SizedBox(width: 20),

                  Text(
                    '${conditionScore.round()}%',
                    style: TextStyle(
                      color: conditionScore.round() > 80
                          ? const Color.fromARGB(
                              255,
                              107,
                              255,
                              112,
                            )
                          : conditionScore.round() > 60
                              ? const Color.fromARGB(
                                  255,
                                  203,
                                  255,
                                  135,
                                )
                              : conditionScore.round() > 40
                                  ? const Color.fromARGB(
                                      255,
                                      253,
                                      255,
                                      107,
                                    )
                                  : const Color.fromARGB(
                                      255,
                                      255,
                                      93,
                                      93,
                                    ),
                      fontSize: 30,
                    ),
                  ),
                ],
              ),

              Text(
                conditionScore.round() > 80
                    ? "Good job! Keep up the good habit!"
                    : conditionScore.round() > 60
                        ? "Decent, but you can do much better."
                        : conditionScore.round() > 40
                            ? "Get some rest and calm down on your load. Your health is just as important as your academics."
                            : "You are having an extremely unhealthy life. Please calm down and take rests.",
                style: TextStyle(
                  color: conditionScore.round() > 80
                      ? const Color.fromARGB(
                          255,
                          107,
                          255,
                          112,
                        )
                      : conditionScore.round() > 60
                          ? const Color.fromARGB(
                              255,
                              203,
                              255,
                              135,
                            )
                          : conditionScore.round() > 40
                              ? const Color.fromARGB(
                                  255,
                                  253,
                                  255,
                                  107,
                                )
                              : const Color.fromARGB(
                                  255,
                                  255,
                                  93,
                                  93,
                                ),
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              //SLEEP GRAPH_____________________________________________________________________________________________________________________________________

              const Text(
                "Sleep Graph",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Consumer<SleepProvider>(
                builder: (context, provider, child) {
                  final entries = provider.sleepHours.entries.toList();

                  entries.sort(
                    (a, b) => a.key.compareTo(b.key),
                  );

                  final spots = <FlSpot>[];

                  for (int i = 0; i < entries.length; i++) {
                    spots.add(
                      FlSpot(
                        i.toDouble(),
                        entries[i].value,
                      ),
                    );
                  }

                  return SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 12,

                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),

                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 1,

                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white,
                              strokeWidth: 0.5,
                            );
                          },

                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.white,
                              strokeWidth: 0.5,
                            );
                          },
                        ),

                        titlesData: FlTitlesData(

                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),

                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),

                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 1,

                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}h',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                );
                              },
                            ),
                          ),

                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 35,
                              interval: 1,

                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();

                                if (index < 0 ||
                                    index >= entries.length) {
                                  return const SizedBox();
                                }

                                final date = entries[index].key;

                                return Text(
                                  '${date.month}/${date.day}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            color: Colors.white,
                            isCurved: false,
                            barWidth: 3,

                            dotData: FlDotData(
                              show: true,
                            ),

                            belowBarData: BarAreaData(
                              show: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              //MOOD GRAPH_____________________________________________________________________________________________________________________________________

              const Text(
                "Mood Graph",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Consumer<DailyValueProvider>(
                builder: (context, provider, child) {
                  final data = provider.dailyValues;

                  final dates = data.keys.toList()..sort();

                  final spots = <FlSpot>[];

                  for (int i = 0; i < dates.length; i++) {
                    final value = data[dates[i]] ?? -1;

                    // Don't plot -1
                    if (value != -1) {
                      spots.add(
                        FlSpot(
                          i.toDouble(),
                          value.toDouble(),
                        ),
                      );
                    }
                  }

                  return SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 4,

                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),

                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 1,

                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white,
                              strokeWidth: 0.5,
                            );
                          },

                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.white,
                              strokeWidth: 0.5,
                            );
                          },
                        ),

                        titlesData: FlTitlesData(

                          // X-axis dates
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,

                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();

                                if (index < 0 ||
                                    index >= dates.length) {
                                  return const SizedBox();
                                }

                                final date = dates[index];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Text(
                                    '${date.month}/${date.day}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Y-axis numbers
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 35,

                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          ),

                          // Hide top
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),

                          // Hide right
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                        ),

                        // Graph line
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            color: Colors.white,
                            isCurved: false,

                            dotData: FlDotData(
                              show: true,
                            ),

                            barWidth: 3,

                            belowBarData: BarAreaData(
                              show: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              //STUDY GRAPH_____________________________________________________________________________________________________________________________________

              const Text(
                "Study Graph",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Consumer<Items>(
                builder: (context, items, child) {
                  final studyMinutes =
                      items.getStudyMinutesByDate();

                  final sortedDates =
                      studyMinutes.keys.toList()..sort();

                  // If there is no data, use today as a placeholder date
                  if (sortedDates.isEmpty) {
                    final today = DateTime.now();

                    sortedDates.add(
                      DateTime(
                        today.year,
                        today.month,
                        today.day,
                      ),
                    );
                  }

                  final spots = <FlSpot>[];

                  for (int i = 0;
                      i < sortedDates.length;
                      i++) {
                    final date = sortedDates[i];

                    final minutes =
                        studyMinutes[date] ?? 0;

                    spots.add(
                      FlSpot(
                        i.toDouble(),
                        minutes.toDouble(),
                      ),
                    );
                  }

                  // Minimum graph height/range even when there is no data
                  final maxMinutes = studyMinutes.isEmpty
                      ? 120
                      : studyMinutes.values.reduce(
                          (a, b) => a > b ? a : b,
                        );

                  final maxY =
                      ((maxMinutes / 30).ceil() * 30 + 30)
                          .toDouble();

                  return SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: maxY,

                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),

                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 30,

                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white,
                              strokeWidth: 0.5,
                            );
                          },

                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.white,
                              strokeWidth: 0.5,
                            );
                          },
                        ),

                        titlesData: FlTitlesData(

                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),

                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),

                          // Y-axis
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 30,
                              reservedSize: 45,

                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}m',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),

                          // X-axis
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,

                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();

                                if (index < 0 ||
                                    index >=
                                        sortedDates.length) {
                                  return const SizedBox();
                                }

                                final date =
                                    sortedDates[index];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Text(
                                    "${date.month}/${date.day}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            color: Colors.white,
                            isCurved: false,
                            barWidth: 3,

                            dotData: FlDotData(
                              show: true,
                            ),

                            belowBarData: BarAreaData(
                              show: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              //THEME_____________________________________________________________________________________________________________________________________

              const Text(
                "Theme Options",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [

                  // DEFAULT
                  _colorButton(
                    context,
                    const Color(0xFF4A90E2),
                    const Color(0xFF6FCF97),
                    const Color(0xFF9B8AFB),
                    "Default",
                  ),

                  // WARM
                  _colorButton(
                    context,
                    Colors.yellow,
                    Colors.red,
                    Colors.orange,
                    "Warm",
                  ),

                  // BLOSSOM
                  _colorButton(
                    context,
                    const Color.fromARGB(
                      255,
                      225,
                      255,
                      192,
                    ),
                    Colors.brown,
                    const Color.fromARGB(
                      255,
                      241,
                      155,
                      184,
                    ),
                    "Blossom",
                  ),

                  // DARK
                  _colorButton(
                    context,
                    const Color.fromARGB(
                      255,
                      56,
                      56,
                      56,
                    ),
                    const Color.fromARGB(
                      255,
                      126,
                      126,
                      126,
                    ),
                    const Color.fromARGB(
                      255,
                      56,
                      56,
                      56,
                    ),
                    "Dark",
                  ),
                ],
              ),

              //BRIGHTNESS_________________________________________________________________________________________________________________________________________

              const SizedBox(height: 30),

              const Text(
                "Brightness",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "${brightness.round()}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white54,
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withOpacity(0.15),
                  trackHeight: 5,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 9,
                  ),
                ),
                child: Slider(
                  value: brightness,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: brightness.round().toString(),

                  onChanged: (value) {
                    context.read<AppColors>().setBrightness(value);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Dark",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Normal",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "White",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}