import 'package:more/more.dart';

void main(List<String> args) {
  var lim = 1000000;
  var twos = [for (var i = 1; i < lim; i *= 2) i];
  var good = 1
      .to(lim, step: 2)
      .where((e) => twos
          .map((p) => e - p)
          .where((d) => d > 0)
          .every((d) => !d.isProbablyPrime))
      .toList();
  print("First fifty: ${good.take(50)}");
  print("Number 1000: ${good[999]}");
  print("Number 10,000: ${good[9999]}");
