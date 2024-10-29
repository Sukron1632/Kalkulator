import 'dart:async';
import 'package:flutter/material.dart';

class StopWatchPage extends StatefulWidget {
  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  int initialHours = 0;
  int initialMinutes = 0;
  int initialSeconds = 0;

  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;
  bool isPaused = false;
  List<String> markers = [];

  void reset() {
    setState(() {
      duration = Duration(
        hours: initialHours,
        minutes: initialMinutes,
        seconds: initialSeconds,
      );
      isRunning = false;
      isPaused = false;
      markers.clear();
    });
    timer?.cancel();
  }

  void addTime() {
    setState(() {
      if (duration.inHours >= 24) {
        timer?.cancel();
        isRunning = false;
        isPaused = true;
      } else {
        duration = Duration(milliseconds: duration.inMilliseconds + 10);
      }
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

  void markTime() {
    String timeMarker = formatDuration(duration);
    setState(() {
      markers.add(timeMarker);
    });
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final milliseconds = (d.inMilliseconds % 1000) ~/ 10;
    String formattedMilliseconds = (milliseconds < 10) ? '0$milliseconds' : '$milliseconds'; 
    return '$hours:$minutes:$seconds:$formattedMilliseconds';
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
            const SizedBox(height: 24),
            buildMarkers(),
          ],
        ),
      );

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = twoDigits((duration.inMilliseconds % 1000) ~/ 10);

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
        buildTimeCard(time: milliseconds, header: 'MILI DETIK'),
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
          IconButton(
            icon: const Icon(Icons.flag_circle_rounded, size: 80, color: Colors.blue),
            onPressed: markTime,
            tooltip: 'Mark Time',
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
          IconButton(
            icon: const Icon(Icons.flag_circle_rounded, size: 80, color: Colors.blue),
            onPressed: markTime,
            tooltip: 'Mark Time',
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

  Widget buildMarkers() {
    if (markers.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: markers.asMap().entries.map((entry) {
        int index = entry.key;
        String marker = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            '${index + 1}. $marker',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
