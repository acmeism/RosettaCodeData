using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using PrimeT = System.UInt32;
  class PrimesPQ : IEnumerable<PrimeT> {
    private IEnumerator<PrimeT> nmrtr() {
      MinHeapPQ<PrimeT> pq = MinHeapPQ<PrimeT>.empty;
      PrimeT bp = 3; PrimeT q = 9;
      IEnumerator<PrimeT> bps = null;
      yield return 2; yield return 3;
      for (var n = (PrimeT)5; ; n += 2) {
        if (n >= q) { // always equal or less...
          if (q <= 9) {
            bps = nmrtr();
            bps.MoveNext(); bps.MoveNext(); } // move to 3...
          bps.MoveNext(); var nbp = bps.Current; q = nbp * nbp;
          var adv = bp + bp; bp = nbp;
          pq = MinHeapPQ<PrimeT>.push(n + adv, adv, pq);
        }
        else {
          var pk = MinHeapPQ<PrimeT>.peekMin(pq);
          var ck = (pk == null) ? q : pk.Item1;
          if (n >= ck) {
            do { var adv = pk.Item2;
                  pq = MinHeapPQ<PrimeT>.replaceMin(ck + adv, adv, pq);
                  pk = MinHeapPQ<PrimeT>.peekMin(pq); ck = pk.Item1;
            } while (n >= ck);
          }
          else yield return n;
        }
      }
    }
    public IEnumerator<PrimeT> GetEnumerator() { return nmrtr(); }
    IEnumerator IEnumerable.GetEnumerator() { return (IEnumerator)GetEnumerator(); }
  }
