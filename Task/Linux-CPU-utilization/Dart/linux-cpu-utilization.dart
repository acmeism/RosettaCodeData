#!/usr/bin/env dart
import 'dart:io';

List<int> load() {
  File f = File('/proc/stat');
  List<String> lines = f.readAsLinesSync();

  List<int> loads = lines[0]
      .substring("cpu  ".length)
      .split(" ")
      .map((String token) => int.parse(token))
      .toList();

  int idle = loads[3];
  int total = loads.reduce((int a, int b) => a + b);

  return [idle, total];
}

void main() {
  List<int> idleTotalPrev = [0, 0];

  while (true) {
    List<int> idleTotal = load();
    int dTotal = idleTotal[0] - idleTotalPrev[0];
    int dLoad = idleTotal[1] - idleTotalPrev[1];
    idleTotalPrev = idleTotal;

    double percent = 100.0 * (1.0 - dTotal / dLoad);
    print("${percent.toStringAsFixed(2)}%");

    sleep(const Duration(seconds: 1));
  }
}
