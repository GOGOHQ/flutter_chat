import 'dart:math';

import 'package:date_format/date_format.dart';

class TimeUtil {
  static String getRandomTime() {
    int rand = Random().nextInt(1000000000);
    DateTime now = DateTime.now();
    DateTime randTime =
        DateTime.fromMillisecondsSinceEpoch(now.millisecondsSinceEpoch - rand);
    Duration diff = now.difference(randTime);

    switch (diff.inDays) {
      case 0:
        return randTime.minute < 10
            ? "${randTime.hour}:0${randTime.minute}"
            : "${randTime.hour}:${randTime.minute}";
      case 1:
        return "昨天";
      case 2:
        return "前天";
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
        return "星期${weekDayFormat(randTime.weekday)}";
      default:
        return "${randTime.year}/${randTime.month}/${randTime.day}";
    }
    // if (diff.inDays == 0) {
    //   return "${diff.inDays}天前";
    // } else if (diff.inDays == 0 && diff.inHours > 0) {
    //   return "${diff.inHours}小时前";
    // } else if (diff.inDays == 0 && diff.inHours == 0 && diff.inMinutes > 5) {
    //   return "${diff.inHours}分钟前";
    // } else {
    //   return "刚刚";
    // }
  }

  static String weekDayFormat(int weekday) {
    switch (weekday) {
      case 1:
        return "一";
      case 2:
        return "二";
      case 3:
        return "三";
      case 4:
        return "四";
      case 5:
        return "五";
      case 6:
        return "六";
      case 7:
        return "日";
      default:
        return "";
    }
  }

  static String convertDurationToString(Duration time) {
    if (time.inHours == 0 && time.inMinutes == 0 && time.inSeconds != 0) {
      return "${time.inSeconds}\"";
    } else if (time.inHours == 0 &&
        time.inMinutes != 0 &&
        time.inSeconds != 0) {
      return "${time.inMinutes}:${time.inSeconds % 60}\"";
    } else if (time.inHours != 0 &&
        time.inMinutes != 0 &&
        time.inSeconds != 0) {
      return "${time.inHours}:${time.inSeconds}:${time.inSeconds % 60}\"";
    } else {
      return "0\"";
    }
  }
}
