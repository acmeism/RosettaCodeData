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

BigInt trival2BigInt(Trival tv) {
  return BigInt.from(2).pow(tv.twos)
           * BigInt.from(3).pow(tv.threes)
           * BigInt.from(5).pow(tv.fives);
}

Trival nthHamming(int n) {
  if (n < 1) throw Exception("nthHamming:  argument must be higher than 0!!!");
  if (n < 7) {
    if (n & (n - 1) == 0) {
      final bts = n.bitLength - 1;
      return Trival(bts.toDouble(), bts, 0, 0);
    }
    switch (n) {
      case 3: return Trival(lb2of3, 0, 1, 0);
      case 5: return Trival(lb2of5, 0, 0, 1);
      case 6: return Trival(lb2of2 + lb2of3, 1, 1, 0);
    }
  }
  final fctr = 6.0 * lb2of3 * lb2of5;
  final crctn = log(sqrt(30.0)) / log(2.0);
  final lb2est = pow(fctr * n.toDouble(), 1.0/3.0) - crctn;
  final lb2rng = 2.0/lb2est;
  final lb2hi = lb2est + 1.0/lb2est;
  List<Trival> ebnd = [];
  var cnt = 0;
  for (var k = 0; k < (lb2hi / lb2of5).ceil(); ++k) {
    final lb2p = lb2hi - k * lb2of5;
    for (var j = 0; j < (lb2p / lb2of3).ceil(); ++j) {
      final lb2q = lb2p - j * lb2of3;
      final i = lb2q.floor(); final lb2frac = lb2q - i;
      cnt += i + 1;
      if (lb2frac <= lb2rng) {
        final lb2v = i * lb2of2 + j * lb2of3 + k * lb2of5;
        ebnd.add(Trival(lb2v, i, j, k));
      }
    }
  }
  ebnd.sort((a, b) => b.log2.compareTo(a.log2)); // descending order
  final ndx = cnt - n;
  if (ndx < 0) throw Exception("nthHamming:  not enough triples generated!!!");
  if (ndx >= ebnd.length) throw Exception("nthHamming:  error band is too narrow!!!");
  return ebnd[ndx];
}

void main() {
  final numhams = 1000000;
  var nthhamseqstr = "The first 20 Hamming numbers are:  ( ";
  for (var i = 1; i <= 20; ++i) {
    nthhamseqstr += trival2BigInt(nthHamming(i)).toString() + " ";
  }
  print(nthhamseqstr + ")");
  final strt = DateTime.now().millisecondsSinceEpoch;
  final answr = nthHamming(numhams);
  final elpsd = DateTime.now().millisecondsSinceEpoch - strt0;
  print("The ${numhams}th Hamming number is:  $answr");
  print("in full as:  ${trival2BigInt(answr)}");
  print("This test took $elpsd milliseconds.");
}
