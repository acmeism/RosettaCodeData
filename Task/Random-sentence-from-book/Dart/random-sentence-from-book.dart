import 'dart:io';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

var heading = RegExp(r'^[ ABCDEFGHIJKLMNOPQRSTUVWXYZ\-\.?“”]+$');
Function eq = const ListEquality().equals;

main() {
  var text = File('bin/_other/war_of_the_worlds.txt')
      .readAsLinesSync()
      .skipTo('BOOK ONE')
      .where((e) => e.isNotEmpty)
      .where((e) => !heading.hasMatch(e))
      .takeWhile((e) => !e.startsWith('*** END OF THE PROJECT'))
      .join(' ')
      .replaceAll(RegExp(r'; |, |: '), ' ')
      .replaceAll(RegExp(r'“|”|(|)'), '')
      .replaceAll('. ', ' . ');
  var tokens = '. $text'.split(' ');
  var pairs = Multiset.from(tokens.window(2));
  var triples = Multiset.from(tokens.window(3));
  var gen = ['.'];
  var cands = pairs.entrySet.where((e) => e.key.first == gen.last).toList();
  gen.add(cands[getWeightedNext(cands)].key.last);
  for (var _ in 0.to(200)) {
    var cands = triples.entrySet
        .where((e) => eq(e.key.take(2).toList(), gen.takeLast(2).toList()))
        .toList();
    gen.add(cands[getWeightedNext(cands)].key.last);
  }
  var sentences = gen
      .splitAfter((e) => e == '.')
      .skip(1)
      .map((e) => '${(e..removeLast()).join(' ')}.')
      .toList()
    ..removeLast();
  sentences.forEach((e) => print(e));
}

int getWeightedNext(List<MapEntry<List<String>, int>> cands) {
  var offsets = cands.fold([0], (s, t) => s..add(s.last + t.value));
  var pick = 0.to(offsets.last).atRandom();
  return offsets.skipWhile((e) => e < pick).first;
}
