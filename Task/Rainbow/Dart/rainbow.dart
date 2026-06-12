import 'dart:io';

void main() {
  const rainbow = 'RAINBOW';
  const spectrum = [
    [255, 0, 0], // red
    [255, 165, 0], // orange
    [255, 255, 0], // yellow
    [0, 128, 0], // green
    [0, 0, 255], // blue
    [75, 0, 130], // indigo
    [238, 130, 238], // violet
  ];

  for (int i = 0; i < rainbow.length; i++) {
    final red = spectrum[i][0];
    final green = spectrum[i][1];
    final blue = spectrum[i][2];
    stdout.write('\x1B[38;2;${red};${green};${blue}m${rainbow[i]}\x1B[0m');
  }
}
