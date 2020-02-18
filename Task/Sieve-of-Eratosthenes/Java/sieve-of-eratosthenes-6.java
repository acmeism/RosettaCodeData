import java.util.Iterator;
import java.util.HashMap;

// generates all prime numbers up to about 10 ^ 19 if one can wait 1000's of years or so...
public class SoEInfHashMap implements Iterator<Long> {

  long candidate = 2;
  Iterator<Long> baseprimes = null;
  long basep = 3;
  long basepsqr = 9;
  // HashMap of the sequences of non-primes
  // the hash map allows us to get the "next" non-prime reasonably quickly
  // but further allows re-insertions to take amortized constant time
  final HashMap<Long,Long> nonprimes = new HashMap<>();

  @Override public boolean hasNext() { return true; }
  @Override public Long next() {
    // do the initial primes separately to initialize the base primes sequence
    if (this.candidate <= 5L) if (this.candidate++ == 2L) return 2L; else {
      this.candidate++; if (this.candidate == 5L) return 3L; else {
        this.baseprimes = new SoEInfHashMap();
        this.baseprimes.next(); this.baseprimes.next(); // throw away 2 and 3
        return 5L;
    } }
    // skip non-prime numbers including squares of next base prime
    for ( ; this.candidate >= this.basepsqr || //equals nextbase squared => not prime
              nonprimes.containsKey(this.candidate); candidate += 2) {
      // insert a square root prime sequence into hash map if to limit
      if (candidate >= basepsqr) { // if square of base prime, always equal
        long adv = this.basep << 1;
        nonprimes.put(this.basep * this.basep + adv, adv);
        this.basep = this.baseprimes.next();
        this.basepsqr = this.basep * this.basep;
      }
      // else for each sequence that generates this number,
      // have it go to the next number (simply add the advance)
      // and re-position it in the hash map at an emply slot
      else {
        long adv = nonprimes.remove(this.candidate);
        long nxt = this.candidate + adv;
        while (this.nonprimes.containsKey(nxt)) nxt += adv; //unique keys
        this.nonprimes.put(nxt, adv);
      }
    }
    // prime
    long tmp = candidate; this.candidate += 2; return tmp;
  }

  public static void main(String[] args) {
    int n = 100000000;
    long strt = System.currentTimeMillis();
    SoEInfHashMap sieve = new SoEInfHashMap();
    int count = 0;
    while (sieve.next() <= n) count++;
    long elpsd = System.currentTimeMillis() - strt;
    System.out.println("Found " + count + " primes up to " + n + " in " + elpsd + " milliseconds.");
  }

}
