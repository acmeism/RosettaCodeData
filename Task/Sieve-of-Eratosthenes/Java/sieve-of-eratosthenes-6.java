import java.util.Iterator;
import java.util.ArrayList;

// generates all prime numbers up to about 10 ^ 19 if one can wait 100's of years or so...
// practical range is about 10^14 in a week or so...
public class SoEPagedOdds implements Iterator<Long> {
  private final int BFSZ = 1 << 16;
  private final int BFBTS = BFSZ * 32;
  private final int BFRNG = BFBTS * 2;
  private long bi = -1;
  private long lowi = 0;
  private final ArrayList<Integer> bpa = new ArrayList<>();
  private Iterator<Long> bps;
  private final int[] buf = new int[BFSZ];

  @Override public boolean hasNext() { return true; }
  @Override public Long next() {
    if (this.bi < 1) {
      if (this.bi < 0) {
        this.bi = 0;
        return 2L;
      }
      //this.bi muxt be 0
      long nxt = 3 + (this.lowi << 1) + BFRNG;
      if (this.lowi <= 0) { // special culling for first page as no base primes yet:
          for (int i = 0, p = 3, sqr = 9; sqr < nxt; i++, p += 2, sqr = p * p)
              if ((this.buf[i >>> 5] & (1 << (i & 31))) == 0)
                  for (int j = (sqr - 3) >> 1; j < BFBTS; j += p)
                      this.buf[j >>> 5] |= 1 << (j & 31);
      }
      else { // after the first page:
        for (int i = 0; i < this.buf.length; i++)
          this.buf[i] = 0; // clear the sieve buffer
        if (this.bpa.isEmpty()) { // if this is the first page after the zero one:
            this.bps = new SoEPagedOdds(); // initialize separate base primes stream:
            this.bps.next(); // advance past the only even prime of two
            this.bpa.add(this.bps.next().intValue()); // get the next prime (3 in this case)
        }
        // get enough base primes for the page range...
        for (long p = this.bpa.get(this.bpa.size() - 1), sqr = p * p; sqr < nxt;
                p = this.bps.next(), this.bpa.add((int)p), sqr = p * p) ;
        for (int i = 0; i < this.bpa.size() - 1; i++) {
          long p = this.bpa.get(i);
          long s = (p * p - 3) >>> 1;
          if (s >= this.lowi) // adjust start index based on page lower limit...
            s -= this.lowi;
          else {
            long r = (this.lowi - s) % p;
            s = (r != 0) ? p - r : 0;
          }
          for (int j = (int)s; j < BFBTS; j += p)
            this.buf[j >>> 5] |= 1 << (j & 31);
        }
      }
    }
    while ((this.bi < BFBTS) &&
           ((this.buf[(int)this.bi >>> 5] & (1 << ((int)this.bi & 31))) != 0))
        this.bi++; // find next marker still with prime status
    if (this.bi < BFBTS) // within buffer: output computed prime
        return 3 + ((this.lowi + this.bi++) << 1);
    else { // beyond buffer range: advance buffer
        this.bi = 0;
        this.lowi += BFBTS;
        return this.next(); // and recursively loop
    }
  }

  public static void main(String[] args) {
    long n = 1000000000;
    long strt = System.currentTimeMillis();
    Iterator<Long> gen = new SoEPagedOdds();
    int count = 0;
    while (gen.next() <= n) count++;
    long elpsd = System.currentTimeMillis() - strt;
    System.out.println("Found " + count + " primes up to " + n + " in " + elpsd + " milliseconds.");
  }

}
