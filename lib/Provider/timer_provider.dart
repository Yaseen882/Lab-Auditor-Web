// import 'dart:async';
//
// import 'package:cas_student_assignement/number_creater.dart';
// import 'package:flutter/cupertino.dart';
//
// class TimerProvider extends ChangeNotifier {
//   int counterSecond = 00;
//   int counterMinute = 00;
//   int counterHour = 00;
//   Timer? _timer;
//   var  subscription;
//
//   void timerCounter() {
//     final myStream = NumberCreator().stream;
//      subscription = myStream.listen((event) {
//       counterSecond = event;
//
//       if (event == 5) {
//         counterMinute = counterMinute + 1;
//
//         counterSecond = 0;
//         event = 0;
//
//         notifyListeners();
//       }
//       if (counterMinute == 2) {
//         counterHour = counterHour + 1;
//         counterMinute = 0;
//       }
//       notifyListeners();
//     });
//   }
// }
