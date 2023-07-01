using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using PrimeT = System.UInt32;
  class PrimesPgd : IEnumerable<PrimeT> {
    private const int PGSZ = 1 << 14; // L1 CPU cache size in bytes
    private const int BFBTS = PGSZ * 8; // in bits
    private const int BFRNG = BFBTS * 2;
    public IEnumerator<PrimeT> nmrtr() {
      IEnumerator<PrimeT> bps = null;
      List<uint> bpa = new List<uint>();
      uint[] cbuf = new uint[PGSZ / 4]; // 4 byte words
      yield return 2;
      for (var lowi = (PrimeT)0; ; lowi += BFBTS) {
        for (var bi = 0; ; ++bi) {
          if (bi < 1) {
            if (bi < 0) { bi = 0; yield return 2; }
            PrimeT nxt = 3 + lowi + lowi + BFRNG;
            if (lowi <= 0) { // cull very first page
              for (int i = 0, p = 3, sqr = 9; sqr < nxt; i++, p += 2, sqr = p * p)
                if ((cbuf[i >> 5] & (1 << (i & 31))) == 0)
                  for (int j = (sqr - 3) >> 1; j < BFBTS; j += p)
                    cbuf[j >> 5] |= 1u << j;
            }
            else { // cull for the rest of the pages
              Array.Clear(cbuf, 0, cbuf.Length);
              if (bpa.Count == 0) { // inite secondar base primes stream
                bps = nmrtr(); bps.MoveNext(); bps.MoveNext();
                bpa.Add((uint)bps.Current); bps.MoveNext();
              } // add 3 to base primes array
              // make sure bpa contains enough base primes...
              for (PrimeT p = bpa[bpa.Count - 1], sqr = p * p; sqr < nxt; ) {
                p = bps.Current; bps.MoveNext(); sqr = p * p; bpa.Add((uint)p);
              }
              for (int i = 0, lmt = bpa.Count - 1; i < lmt; i++) {
                var p = (PrimeT)bpa[i]; var s = (p * p - 3) >> 1;
                // adjust start index based on page lower limit...
                if (s >= lowi) s -= lowi;
                else {
                  var r = (lowi - s) % p;
                  s = (r != 0) ? p - r : 0;
                }
                for (var j = (uint)s; j < BFBTS; j += p)
                  cbuf[j >> 5] |= 1u << ((int)j);
              }
            }
          }
          while (bi < BFBTS && (cbuf[bi >> 5] & (1 << (bi & 31))) != 0) ++bi;
          if (bi < BFBTS) yield return 3 + (((PrimeT)bi + lowi) << 1);
          else break; // outer loop for next page segment...
        }
      }
    }
    public IEnumerator<PrimeT> GetEnumerator() { return nmrtr(); }
    IEnumerator IEnumerable.GetEnumerator() { return (IEnumerator)GetEnumerator(); }
  }
