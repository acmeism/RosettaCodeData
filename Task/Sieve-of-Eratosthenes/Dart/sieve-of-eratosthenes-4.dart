import 'dart:typed_data';
import 'dart:math';
import 'dart:collection';

// a lazy list
typedef _LazyList _Thunk();
class _LazyList<T> {
  final T head;
  _Thunk thunk;
  _LazyList<T> _rest;
  _LazyList(T this.head, _Thunk this.thunk);
  _LazyList<T> get rest {
    if (this.thunk != null) {
      this._rest = this.thunk();
      this.thunk = null;
    }
    return this._rest;
  }
}

class _LazyListIterable<T> extends IterableBase<T> {
  _LazyList<T> _first;
  _LazyListIterable(_LazyList<T> this._first);
  @override Iterator<T> get iterator {
    Iterable<T> inner() sync* {
      _LazyList<T> current = this._first;
      while (true) {
        yield(current.head);
        current = current.rest;
      }
    }
    return inner().iterator;
  }
}

// zero bit population count Look Up Table for 16-bit range...
final Uint8List CLUT =
  Uint8List.fromList(
    Iterable.generate(65536)
    .map((i) {
      final int v0 = ~i & 0xFFFF;
      final int v1 = v0 - ((v0 & 0xAAAA) >> 1);
      final int v2 = (v1 & 0x3333) + ((v1 & 0xCCCC) >> 2);
      return (((((v2 & 0x0F0F) + ((v2 & 0xF0F0) >> 4)) * 0x0101)) >> 8) & 31;
    })
    .toList());

int _countComposites(Uint8List cmpsts) {
  Uint16List buf = Uint16List.view(cmpsts.buffer);
  int lmt = buf.length;
  int count = 0;
  for (var i = 0; i < lmt; ++i) {
    count += CLUT[buf[i]];
  }
  return count;
}

// converts an entire sieved array of bytes into an array of UInt32 primes,
// to be used as a source of base primes...
Uint32List _composites2BasePrimeArray(int low, Uint8List cmpsts) {
  final int lmti = cmpsts.length << 3;
  final int len = _countComposites(cmpsts);
  final Uint32List rslt = Uint32List(len);
  int j = 0;
  for (int i = 0; i < lmti; ++i) {
    if (cmpsts[i >> 3] & 1 << (i & 7) == 0) {
        rslt[j++] = low + i + i;
    }
  }
  return rslt;
}

// do sieving work based on low starting value for the given buffer and
// the given lazy list of base prime arrays...
void _sieveComposites(int low, Uint8List buffer, Iterable<Uint32List> bpas) {
  final int lowi = (low - 3) >> 1;
  final int len = buffer.length;
  final int lmti = len << 3;
  final int nxti = lowi + lmti;
  for (var bpa in bpas) {
    for (var bp in bpa) {
      final int bpi = (bp - 3) >> 1;
      int strti = ((bpi * (bpi + 3)) << 1) + 3;
      if (strti >= nxti) return;
      if (strti >= lowi) strti = strti - lowi;
      else {
        strti = (lowi - strti) % bp;
        if (strti != 0) strti = bp - strti;
      }
      if (bp <= len >> 3 && strti <= lmti - bp << 6) {
        final int slmti = min(lmti, strti + bp << 3);
        for (var s = strti; s < slmti; s += bp) {
          final int msk = 1 << (s & 7);
          for (var c = s >> 3; c < len; c += bp) {
              buffer[c] |= msk;
          }
        }
      }
      else {
        for (var c = strti; c < lmti; c += bp) {
            buffer[c >> 3] |= 1 << (c & 7);
        }
      }
    }
  }
}

// starts the secondary base primes feed with minimum size in bits set to 4K...
// thus, for the first buffer primes up to 8293,
// the seeded primes easily cover it as 97 squared is 9409...
Iterable<Uint32List> _makeBasePrimeArrays() {
  var cmpsts = Uint8List(512);
  _LazyList<Uint32List> _nextelem(int low, Iterable<Uint32List> bpas) {
    // calculate size so that the bit span is at least as big as the
    // maximum culling prime required, rounded up to minsizebits blocks...
    final int rqdsz = 2 + sqrt((1 + low).toDouble()).toInt();
    final sz = (((rqdsz >> 12) + 1) << 9); // size in bytes
    if (sz > cmpsts.length) cmpsts = Uint8List(sz);
    cmpsts.fillRange(0, cmpsts.length, 0);
    _sieveComposites(low, cmpsts, bpas);
    final arr = _composites2BasePrimeArray(low, cmpsts);
    final nxt = low + (cmpsts.length << 4);
    return _LazyList(arr, () => _nextelem(nxt, bpas));
  }
  // pre-seeding breaks recursive race,
  // as only known base primes used for first page...
  final preseedarr = Uint32List.fromList( [ // pre-seed to 100, can sieve to 10,000...
    3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41
    , 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97 ] );
  return _LazyListIterable(
           _LazyList(preseedarr,
           () => _nextelem(101, _makeBasePrimeArrays()))
         );
}

// an iterable sequence over successive sieved buffer composite arrays,
// returning a tuple of the value represented by the lowest possible prime
// in the sieved composites array and the array itself;
// the array has a 16 Kilobytes minimum size (CPU L1 cache), but
// will grow so that the bit span is larger than the
// maximum culling base prime required, possibly making it larger than
// the L1 cache for large ranges, but still reasonably efficient using
// the L2 cache: very efficient up to about 16e9 range;
// reasonably efficient to about 2.56e14 for two Megabyte L2 cache = > 1 day...
Iterable<List> _makeSievePages() sync*  {
  final bpas = _makeBasePrimeArrays(); // secondary source of base prime arrays
  int low = 3;
  Uint8List cmpsts = Uint8List(16384);
  _sieveComposites(3, cmpsts, bpas);
  while (true) {
    yield([low, cmpsts]);
    final rqdsz = 2 + sqrt((1 + low).toDouble()).toInt(); // problem with sqrt not exact past about 10^12!!!!!!!!!
    final sz = ((rqdsz >> 17) + 1) << 14; // size iin bytes
    if (sz > cmpsts.length) cmpsts = Uint8List(sz);
    cmpsts.fillRange(0, cmpsts.length, 0);
    low += cmpsts.length << 4;
    _sieveComposites(low, cmpsts, bpas);
  }
}

int countPrimesTo(int range) {
  if (range < 3) { if (range < 2) return 0; else return 1; }
  var count = 1;
  for (var sp in _makeSievePages()) {
    int low = sp[0]; Uint8List cmpsts = sp[1];
    if ((low + (cmpsts.length << 4)) > range) {
      int lsti = (range - low) >> 1;
      var lstw = (lsti >> 4); var lstb = lstw << 1;
      var msk = (-2 << (lsti & 15)) & 0xFFFF;
      var buf = Uint16List.view(cmpsts.buffer, 0, lstw);
      for (var i = 0; i < lstw; ++i)
        count += CLUT[buf[i]];
      count += CLUT[(cmpsts[lstb + 1] << 8) | cmpsts[lstb] | msk];
      break;
    } else {
      count += _countComposites(cmpsts);
    }
  }
  return count;
}

// sequence over primes from above page iterator;
// unless doing something special with individual primes, usually unnecessary;
// better to do manipulations based on the composites bit arrays...
// takes at least as long to enumerate the primes as sieve them...
Iterable<int> primesPaged() sync* {
  yield(2);
  for (var sp in _makeSievePages()) {
    int low = sp[0]; Uint8List cmpsts = sp[1];
    var szbts = cmpsts.length << 3;
    for (var i = 0; i < szbts; ++i) {
        if (cmpsts[i >> 3].toInt() & (1 << (i & 7)) != 0) continue;
        yield(low + i + i);
    }
  }
}

void main() {
  final int range = 1000000000;
  String s = "( ";
  primesPaged().take(25).forEach((p)=>s += "$p "); print(s + ")");
  print("There are ${countPrimesTo(1000000)} primes to 1000000.");
  final start = DateTime.now().millisecondsSinceEpoch;
  final answer = countPrimesTo(range); // fast way
//  final answer = primesPaged().takeWhile((p)=>p<=range).length; // slow way using enumeration
  final elapsed = DateTime.now().millisecondsSinceEpoch - start;
  print("There were $answer primes found up to $range.");
  print("This test bench took $elapsed milliseconds.");
}
