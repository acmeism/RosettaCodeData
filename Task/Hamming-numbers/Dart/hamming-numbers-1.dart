import 'dart:math';

final lb2of2 = 1.0;
final lb2of3 = log(3.0) / log(2.0);
final lb2of5 = log(5.0) / log(2.0);

class Trival {
  final double log2;
  final int twos;
  final int threes;
  final int fives;
  Trival mul2() {
    return Trival(this.log2 + lb2of2, this.twos + 1, this.threes, this.fives);
  }
  Trival mul3() {
    return Trival(this.log2 + lb2of3, this.twos, this.threes + 1, this.fives);
  }
  Trival mul5() {
    return Trival(this.log2 + lb2of5, this.twos, this.threes, this.fives + 1);
  }
  @override String toString() {
    return this.log2.toString() + " "
      + this.twos.toString() + " "
      + this.threes.toString() + " "
      + this.fives.toString();
  }
  const Trival(this.log2, this.twos, this.threes, this.fives);
}

Iterable<Trival> makeHammings() sync* {
  var one = Trival(0.0, 0, 0, 0);
  yield(one);
  var s532 = one.mul2();
  var mrg = one.mul3();
  var s53 = one.mul3().mul3(); // equivalent to 9 for advance step
  var s5 = one.mul5();
  var i = -1; var j = -1;
  List<Trival> h = [];
  List<Trival> m = [];
  Trival rslt;
  while (true) {
    if (s532.log2 < mrg.log2) {
      rslt = s532; h.add(s532); ++i; s532 = h[i].mul2();
    } else {
      rslt = mrg; h.add(mrg);
      if (s53.log2 < s5.log2) {
        mrg = s53; m.add(s53); ++j; s53 = m[j].mul3();
      } else {
        mrg = s5; m.add(s5); s5 = s5.mul5();
      }
      if (j > (m.length >> 1)) {m.removeRange(0, j); j = 0; }
    }
    if (i > (h.length >> 1)) {h.removeRange(0, i); i = 0; }
    yield(rslt);
  }
}

BigInt trival2Int(Trival tv) {
  return BigInt.from(2).pow(tv.twos)
           * BigInt.from(3).pow(tv.threes)
           * BigInt.from(5).pow(tv.fives);
}

void main() {
  final numhams = 1000000000000;
  var hamseqstr = "The first 20 Hamming numbers are:  ( ";
  makeHammings().take(20)
      .forEach((h) => hamseqstr += trival2BigInt(h).toString() + " ");
  print(hamseqstr + ")");
  var nthhamseqstr = "The first 20 Hamming numbers are:  ( ";
  for (var i = 1; i <= 20; ++i) {
    nthhamseqstr += trival2BigInt(nthHamming(i)).toString() + " ";
  }
  print(nthhamseqstr + ")");
  final strt = DateTime.now().millisecondsSinceEpoch;
  final answr = makeHammings().skip(999999).first;
  final elpsd = DateTime.now().millisecondsSinceEpoch - strt;
  print("The ${numhams}th Hamming number is:  $answr");
  print("in full as:  ${trival2BigInt(answr)}");
  print("This test took $elpsd milliseconds.");
}
