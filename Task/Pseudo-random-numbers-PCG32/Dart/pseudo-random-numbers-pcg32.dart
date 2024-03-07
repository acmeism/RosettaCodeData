import 'dart:math';

class PCG32 {
  BigInt fState = BigInt.zero;
  BigInt fInc = BigInt.zero;
  final BigInt mask64 = (BigInt.one << 64) - BigInt.one;
  final BigInt mask32 = (BigInt.one << 32) - BigInt.one;
  final BigInt k = BigInt.parse('6364136223846793005');

  PCG32(BigInt seedState, BigInt seedSequence) {
    seed(seedState, seedSequence);
  }

  PCG32.noSeed() {
    fState = BigInt.zero;
    fInc = BigInt.zero;
  }

  void seed(BigInt seedState, BigInt seedSequence) {
    fState = BigInt.zero;
    fInc = ((seedSequence << 1) | BigInt.one) & mask64;
    nextInt();
    fState += seedState;
    nextInt();
  }

  BigInt nextInt() {
    BigInt old = fState;
    fState = ((old * k) + fInc) & mask64;
    BigInt xorshifted = ( ((old >> 18) ^ old) >> 27) & mask32;
    BigInt rot = (old >> 59) & mask32;
    BigInt shifted = (xorshifted >> rot.toInt()) | (xorshifted << ((-rot) & BigInt.from(31)).toInt());
    return shifted & mask32;
  }

  double nextFloat() {
    return nextInt().toDouble() / (BigInt.one << 32).toDouble();
  }

  List<BigInt> nextIntRange(int size) {
    List<BigInt> result = [];
    for (int i = 0; i < size; i++) {
      result.add(nextInt());
    }
    return result;
  }
}

void main() {
  var pcg32 = PCG32(BigInt.from(42), BigInt.from(54));

  for (int i = 0; i < 5; i++) {
    print(pcg32.nextInt().toString());
  }

  pcg32.seed(BigInt.from(987654321), BigInt.one);

  var count = <int, int>{};

  for (int i = 0; i < 100000; i++) {
    int key = (pcg32.nextFloat() * 5).truncate();
    count[key] = (count[key] ?? 0) + 1;
  }

  print('\nThe counts for 100,000 repetitions are:');
  count.forEach((key, value) {
    print('$key : $value');
  });
}
