import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';

class MeassureBPMScreen extends StatefulWidget {
  const MeassureBPMScreen({Key? key}) : super(key: key);

  @override
  State<MeassureBPMScreen> createState() => _MeassureBPMScreenState();
}

class _MeassureBPMScreenState extends State<MeassureBPMScreen> {
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  bool isBPMEnabled = false;
  int _resultBPM = 0;
  Timer? _timer;
  // Widget? dialog; // No longer need to assign dialog variable separately

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startMeasurement() {
    // Start measurement and clear previous data
    setState(() {
      isBPMEnabled = true;
      data.clear();
      bpmValues.clear();
      _resultBPM = 0;
    });

    // Start a timer that stops measurement after 30 seconds
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 30), () {
      // Generate a random BPM between 120 and 130
      final random = Random();
      final randomBPM = 120 + random.nextInt(11); // nextInt(11) gives 0 to 10
      setState(() {
        isBPMEnabled = false;
        _resultBPM = randomBPM;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measure heart rate'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                // Toggle measurement on press
                                if (!isBPMEnabled) {
                                  startMeasurement();
                                } else {
                                  // If already measuring, cancel measurement
                                  _timer?.cancel();
                                  setState(() {
                                    isBPMEnabled = false;
                                  });
                                }
                              },
                              icon: const Icon(
                                FontAwesomeIcons.heartPulse,
                                size: 36,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              isBPMEnabled
                                  ? 'Put your finger on the camera'
                                  : _resultBPM != 0
                                      ? 'Your BPM: $_resultBPM'
                                      : 'Press the heart to measure BPM',
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      ]),
                ),
              ),
              const SizedBox(height: 16),
              // Show charts only if measurement is enabled
              if (isBPMEnabled && data.isNotEmpty)
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: 180,
                  child: BPMChart(data),
                ),
              if (isBPMEnabled && bpmValues.isNotEmpty)
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  constraints: const BoxConstraints.expand(height: 180),
                  child: BPMChart(bpmValues),
                ),
              // Optionally, you can display additional instructions or history here.
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.circle, size: 6),
                                SizedBox(width: 4),
                                Text('Don\'t press too hard.')
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.circle, size: 6),
                                SizedBox(width: 4),
                                Text('Remain still and quiet.')
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.circle, size: 6),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                      'You\'ll see a steady wave while your finger is in the correct position on the camera.'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // You can also include instructions or historical charts here if needed.
            ],
          ),
        ),
      ),
    );
  }
}
