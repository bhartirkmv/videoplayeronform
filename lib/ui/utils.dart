import 'dart:ui';

import 'package:flutter/material.dart';

class UIUtils {
  static String durationToString(Duration duration) {
    int seconds = duration.inSeconds;
    String res = "";
    int hrs = (seconds / 3600).floor();
    seconds %= 3600;
    int mins = (seconds / 60).floor();
    seconds %= 60;

    return "$hrs:$mins:$seconds";
  }

  static String getDateOfUpload(int milliSecondsSinceEpoch) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(milliSecondsSinceEpoch);
    return "${dateTime.day} ${getMonth(dateTime.month)} ${dateTime.year}";
  }

  static String getMonth(int month) {
    switch (month) {
      case 1:
        return "Jan";
        break;
      case 2:
        return "Feb";
        break;
      case 3:
        return "Mar";
        break;
      case 4:
        return "Apr";
        break;
      case 5:
        return "May";
        break;
      case 6:
        return "June";
        break;
      case 7:
        return "July";
        break;
      case 8:
        return "Aug";
        break;
      case 9:
        return "Sept";
        break;
      case 10:
        return "Oct";
        break;
      case 11:
        return "Nov";
        break;
      case 12:
        return "Dec";
        break;
      default:
        return "--";
    }
  }

  static String getTimeOfUpload(int milliSecondsSinceEpoch) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(milliSecondsSinceEpoch);
    return "${dateTime.hour}:${dateTime.minute < 10 ? "0${dateTime.minute}" : "${dateTime.minute}"}";
  }

  static TextStyle cardStyle() {
    return const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    );
  }
  static TextStyle subtitleStyle() {
    return const TextStyle(
      color: Colors.black38,
      fontWeight: FontWeight.bold,
    );
  }
}
