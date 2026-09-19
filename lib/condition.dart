import 'package:flutter/material.dart';

class ConditionProvider extends ChangeNotifier {
  double calculateCondition(
    double sleepHours,
    int mood,
    int studyMinutes,
  ) {
    double sleepScore = (sleepHours / 8.0) * 100;

    if (sleepScore > 100) {
      sleepScore = 100;
    }

    if (sleepScore < 0) {
      sleepScore = 0;
    }


    double moodScore = ((mood + 1) / 5.0) * 100;

    if (moodScore > 100) {
      moodScore = 100;
    }

    if (moodScore < 0) {
      moodScore = 0;
    }


    double studyScore;

    if (studyMinutes <= 240) {
      // Up to 240 minutes = full score
      studyScore = 100;
    } else {
      // Score decreases after 240 minutes
      studyScore = 100 - ((studyMinutes - 240) / 2.4);

      if (studyScore < 0) {
        studyScore = 0;
      }
    }


    return (sleepScore * 0.5) +
        (moodScore * 0.3) +
        (studyScore * 0.2);
  }
}