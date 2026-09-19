import 'package:btrlyfe/appstate.dart';
import 'package:btrlyfe/condition.dart';
import 'package:btrlyfe/dailyvalue.dart';
import 'package:btrlyfe/items.dart';
import 'package:btrlyfe/screen.dart';
import 'package:btrlyfe/sleepamount.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appcolors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppColors(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppState(),
        ),
        ChangeNotifierProvider( 
          create: (_) => Items(), 
        ),
        ChangeNotifierProvider( 
          create: (_) => DailyValueProvider(), 
        ),
        ChangeNotifierProvider( 
          create: (_) => SleepProvider(), 
        ),
        ChangeNotifierProvider( 
          create: (_) => ConditionProvider(), 
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  
  const MainApp({super.key});


  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Screen(),
    );
  }
}
