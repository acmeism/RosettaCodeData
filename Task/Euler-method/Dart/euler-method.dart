import 'dart:math';
import "dart:io";

const double k = 0.07;
const double initialTemp = 100.0;
const double finalTemp = 20.0;
const int startTime = 0;
const int endTime = 100;

void ivpEuler(double Function(double, double) function, double initialValue, int step) {
  stdout.write(' Step ${step.toString().padLeft(2)}: ');
  var y = initialValue;
  for (int t = startTime; t <= endTime; t += step) {
    if (t % 10 == 0) {
      stdout.write(y.toStringAsFixed(3).padLeft(7));
    }
    y += step * function(t.toDouble(), y);
  }
  print('');
}

void analytic() {
  stdout.write('    Time: ');
  for (int t = startTime; t <= endTime; t += 10) {
    stdout.write(t.toString().padLeft(7));
  }
  stdout.write('\nAnalytic: ');
  for (int t = startTime; t <= endTime; t += 10) {
    var temp = finalTemp + (initialTemp - finalTemp) * exp(-k * t);
    stdout.write(temp.toStringAsFixed(3).padLeft(7));
  }
  print('');
}

double cooling(double t, double temp) {
  return -k * (temp - finalTemp);
}

void main() {
  analytic();
  ivpEuler(cooling, initialTemp, 2);
  ivpEuler(cooling, initialTemp, 5);
  ivpEuler(cooling, initialTemp, 10);
}
