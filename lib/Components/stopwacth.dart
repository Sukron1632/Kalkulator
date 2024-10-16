import 'dart:async';
import 'package:flutter/material.dart';

class StopWatchPage extends StatefulWidget {
  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;
  bool isPaused = false;

  void reset() {
    setState(() {
      duration = const Duration();
      isRunning = false;
      isPaused = false;
    });
    timer?.cancel();
  }

  void addTime() {
    setState(() {
      duration = Duration(milliseconds: duration.inMilliseconds + 10);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 10), (_) => addTime());
    setState(() {
      isRunning = true;
      isPaused = false;
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      isPaused = true;
    });
  }

  void resumeTimer() {
    startTimer();
    setState(() {
      isRunning = true;
      isPaused = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Stopwatch'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: buildTime()),
            const SizedBox(height: 24),
            buildButtons(),
          ],
        ),
      );

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = (duration.inMilliseconds % 1000) ~/ 10;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'JAM'),
        const SizedBox(width: 8),
        const Text(':', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        buildTimeCard(time: minutes, header: 'MENIT'),
        const SizedBox(width: 8),
        const Text(':', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        buildTimeCard(time: seconds, header: 'DETIK'),
        const SizedBox(width: 8),
        const Text(':', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        buildTimeCard(time: twoDigits(milliseconds), header: 'MILI DETIK'),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 48), 
            ),
          ),
          const SizedBox(height: 4),
          Text(header, style: const TextStyle(fontSize: 16)), 
        ],
      );

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isRunning) ...[
          ElevatedButton(
            onPressed: stopTimer,
            child: Text('Pause'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              textStyle: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: reset,
            child: Text('Reset'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              textStyle: const TextStyle(fontSize: 20),
            ),
          ),
        ] else if (isPaused) ...[
          ElevatedButton(
            onPressed: resumeTimer,
            child: Text('Continue'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              textStyle: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: reset,
            child: Text('Reset'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              textStyle: const TextStyle(fontSize: 20),
            ),
          ),
        ] else ...[
          ElevatedButton(
            onPressed: startTimer,
            child: Text('Start Timer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              textStyle: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
