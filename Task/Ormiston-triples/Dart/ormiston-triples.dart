import 'package:collection/collection.dart';
import 'package:more/more.dart';

void main(List<String> args) {
  var ts = DateTime.now();
  const start = 10000000;
  final limit = 1000000000;
  ormTriple(List e) =>
      e.map((t) => "$t".split('').sorted().join()).toSet().length == 1;
  var triples = start
      .to(limit)
      .where((e) => e.isProbablyPrime)
      .window(3)
      .where(ormTriple)
      .toList();
  print("Found ${triples.length} triples");
  print("First 25: ${triples.take(25)} ");
  print(DateTime.now().difference(ts).inMilliseconds); // 189 sec
}
