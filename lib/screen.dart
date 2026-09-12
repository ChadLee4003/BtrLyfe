import 'package:btrlyfe/Pages/homepage.dart';
import 'package:btrlyfe/Pages/settingspage.dart';
import 'package:btrlyfe/Pages/sleeppage.dart';
import 'package:btrlyfe/Pages/stresspage.dart';
import 'package:btrlyfe/Pages/studypage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btrlyfe/appcolors.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int selectedIndex = 0;

  // The screens for each navigation button
  final List<Widget> pages = [
    const HomePage(),
    const SleepPage(),
    const StressPage(),
    const StudyPage(),
    const SettingsPage(),

  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColors>();
    Color primarycolor = colors.primaryColor;
    Color secondarycolor = colors.secondaryColor;
    Color tertiarycolor = colors.tertiaryColor;
    return Scaffold(
      body: pages[selectedIndex],
      appBar: AppBar(
        backgroundColor: tertiarycolor,
        title: const Text("BtrLyfe",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: tertiarycolor,
        selectedItemColor: secondarycolor,
        unselectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bed),
            label: "Sleep",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sentiment_very_dissatisfied),
            label: "Stress",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: "Study",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
