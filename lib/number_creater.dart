import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
String? hours ;
String? minutes;
String? seconds;
class StopwatchTimer extends StatefulWidget {
  const StopwatchTimer({Key? key}) : super(key: key);

  @override
  _StopwatchTimerState createState() => _StopwatchTimerState();
}

class _StopwatchTimerState extends State<StopwatchTimer> {
  static const countDownDuration = Duration(seconds: 0);
  Duration duration = const Duration();
  bool countDown = true;
  Timer? timer;


  @override
  void initState() {
    super.initState();
    reset();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      addTime();
    });
  }

  void addTime() {
    final addSeconds = countDown ? 1 : -1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() {
      timer?.cancel();
    });
  }

  void reset() {
    if (countDown) {
      setState(() {
        duration = countDownDuration;
      });
    } else {
      duration = const Duration();
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference status = FirebaseFirestore.instance.collection(
        'dateTimeCounter');
    Future<void> addDateTime() {

      return status.add({'hours': hours, 'minutes': minutes, 'seconds': seconds}).then((
          value) => print('.................User Added...........')).catchError((error){
        print('..............error....................$error');

      });
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTime(),
        const SizedBox(height: 80,),
        buildButton(),
      ],
    );
  }

  Widget buildTime() {
    String twoDigits(int n) {
      return n.toString().padLeft(2, '0');
    }

    setState(() {
      hours = twoDigits(duration.inHours);
      minutes = twoDigits(duration.inMinutes.remainder(60));
      seconds = twoDigits(duration.inSeconds.remainder(60));
      print('..........................hours................$hours');
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildTimeCard(time: hours!, header: 'Hours'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildTimeCard(time: minutes!, header: 'Minutes'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildTimeCard(time: seconds!, header: 'Seconds'),
        ),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(224, 245, 255, 1), borderRadius: BorderRadius.circular(20)),
          child: Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 40,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          header,
          style: const TextStyle(color: Colors.black87),
        )
      ],
    );
  }

  Widget buildButton() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 1;
    return isRunning || isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (isRunning) {
                      stopTimer(resets: false);
                    }
                  },
                  child: const Text('PAUSE'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      stopTimer();
                    },
                    child: const Text('RESET')),
              )
            ],
          )
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
            ),
            onPressed: () {
              startTimer();
            },
            child: const Text('Start Timer'),
          );
  }
}
