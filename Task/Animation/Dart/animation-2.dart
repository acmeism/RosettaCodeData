import 'dart:html';
import 'dart:async';

const frameTime = const Duration(milliseconds: 100);

void main() {
  String text = "Hello World! ";
  bool rotateRight = true;

  Element writeHere =
      querySelector('#output'); // assumes you have a pre with that ID
  writeHere.onClick.listen((event) => rotateRight = !rotateRight);

  new Timer.periodic(frameTime, (_) {
    text = changeText(text, rotateRight);
    writeHere.text = text;
  });
}

String changeText(extt, rotateRight) {
  if (rotateRight) {
    return extt.substring(extt.length - 1) + extt.substring(0, extt.length - 1);
  } else {
    return extt.substring(1) + extt.substring(0, 1);
  }
}
