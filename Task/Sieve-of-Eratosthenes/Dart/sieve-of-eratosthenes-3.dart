import 'dart:collection';

class _SoEPagedIterator implements Iterator<int> {
  static const int _BFSZ = 1 << 16;
  static const int _BFBTS = _BFSZ * 32;
  static const int _BFRNG = _BFBTS * 2;
  int _prime = null;
  int _bi = -1;
  int _lowi = 0;
  List<int> _bpa = new List<int>();
  Iterator<int> _bps;
  List<int> _buf = new List<int>();
  int get current => this._prime;
  bool moveNext() {
    // the following redundant local variable declaration is necessary to
    // prevent the dart2js compiler from "tree-shaking" and eliminating some
    // essential code from the below, which doesn't happen with the Dart VM compiler.
    int lowi = this._lowi;
    while (true) {
      if (this._bi < 1) {
        if (this._bi < 0) { this._bi++; this._prime = 2; break; }
        int nxt = 3 + (this._lowi << 1) + _BFRNG;
        this._buf.clear();
        for (int i = 0; i < _BFSZ; i++) this._buf.add(0); // faster initialization:
        if (lowi <= 0) { // special culling for first page as no base primes yet:
          for (int i = 0, p = 3, sqr = 9; sqr < nxt; i++, p += 2, sqr = p * p)
            if ((this._buf[i >> 5] & (1 << (i & 31))) == 0)
              for (int j = (sqr - 3) >> 1; j < _BFBTS; j += p)
                this._buf[j >> 5] |= 1 << (j & 31);
        } else { // after the first page:
          if (this._bpa.length == 0) { // if this is the first page after the zero one:
            this._bps = new _SoEPagedIterator(); // initialize separate base primes stream:
            this._bps.moveNext(); // advance to the only even prime of two
            this._bps.moveNext(); // advance past 2 to the next prime of 3
          }
          // get enough base primes for the page range...
          for (var lp = this._bps.current, sqr = lp * lp; sqr < nxt;
               this._bps.moveNext(), lp = this._bps.current, sqr = lp * lp) this._bpa.add(lp);
          for (var i = 0; i < this._bpa.length; i++) {
            int p = this._bpa[i];
            int s = (p * p - 3) >> 1;
            if (s >= this._lowi) // adjust start index based on page lower limit...
              s -= this._lowi;
            else {
              int r = (this._lowi - s) % p;
              s = (r != 0) ? p - r : 0;
            }
            for (var j = s; j < _BFBTS; j += p)
              this._buf[j >> 5] |= 1 << (j & 31);
          }
        }
      }
      while (this._bi < _BFBTS && ((this._buf[this._bi >> 5] & (1 << (this._bi & 31))) != 0))
        this._bi++; // find next marker still with prime status
      if (this._bi < _BFBTS) { // within buffer: output computed prime
        this._prime = 3 + ((this._lowi + this._bi++) << 1); break; }
      else { // beyond buffer range: advance buffer
        this._bi = 0;
        this._lowi += _BFBTS;
        lowi = this._lowi;
      }
    } return true;
  }
}

class SoEPagedOddsInfGen extends IterableBase<int> {
  Iterator<int> get iterator { return new _SoEPagedIterator(); }
}

void main() {
  int n = 1000000000;
  int strt = new DateTime.now().millisecondsSinceEpoch;
  int count = new SoEPagedOddsInfGen().takeWhile((p) => p <= n).length;
  int elpsd = new DateTime.now().millisecondsSinceEpoch - strt;
  print("For a range of " + n.toString() + ", " + count.toString() +
      " primes found in " + elpsd.toString() + " milliseconds.");
}
