using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using PrimeT = System.UInt32;
  class PrimesDict : IEnumerable<PrimeT> {
    private IEnumerator<PrimeT> nmrtr() {
      Dictionary<PrimeT, PrimeT> dct = new Dictionary<PrimeT, PrimeT>();
      PrimeT bp = 3; PrimeT q = 9;
      IEnumerator<PrimeT> bps = null;
      yield return 2; yield return 3;
      for (var n = (PrimeT)5; ; n += 2) {
        if (n >= q) { // always equal or less...
          if (q <= 9) {
            bps = nmrtr();
            bps.MoveNext(); bps.MoveNext();
          } // move to 3...
          bps.MoveNext(); var nbp = bps.Current; q = nbp * nbp;
          var adv = bp + bp; bp = nbp;
          dct.Add(n + adv, adv);
        }
        else {
          if (dct.ContainsKey(n)) {
            PrimeT nadv; dct.TryGetValue(n, out nadv); dct.Remove(n); var nc = n + nadv;
            while (dct.ContainsKey(nc)) nc += nadv;
            dct.Add(nc, nadv);
          }
          else yield return n;
        }
      }
    }
    public IEnumerator<PrimeT> GetEnumerator() { return nmrtr(); }
    IEnumerator IEnumerable.GetEnumerator() { return (IEnumerator)GetEnumerator(); }
  }
