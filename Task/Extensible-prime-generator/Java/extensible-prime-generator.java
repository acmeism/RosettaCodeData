import java.util.*;

public class PrimeGenerator {
    private int limit_;
    private int index_ = 0;
    private int increment_;
    private int count_ = 0;
    private List<Integer> primes_ = new ArrayList<>();
    private BitSet sieve_ = new BitSet();
    private int sieveLimit_ = 0;

    public PrimeGenerator(int initialLimit, int increment) {
        limit_ = nextOddNumber(initialLimit);
        increment_ = increment;
        primes_.add(2);
        findPrimes(3);
    }

    public int nextPrime() {
        if (index_ == primes_.size()) {
            if (Integer.MAX_VALUE - increment_ < limit_)
                return 0;
            int start = limit_ + 2;
            limit_ = nextOddNumber(limit_ + increment_);
            primes_.clear();
            findPrimes(start);
        }
        ++count_;
        return primes_.get(index_++);
    }

    public int count() {
        return count_;
    }

    private void findPrimes(int start) {
        index_ = 0;
        int newLimit = sqrt(limit_);
        for (int p = 3; p * p <= newLimit; p += 2) {
            if (sieve_.get(p/2 - 1))
                continue;
            int q = p * Math.max(p, nextOddNumber((sieveLimit_ + p - 1)/p));
            for (; q <= newLimit; q += 2*p)
                sieve_.set(q/2 - 1, true);
        }
        sieveLimit_ = newLimit;
        int count = (limit_ - start)/2 + 1;
        BitSet composite = new BitSet(count);
        for (int p = 3; p <= newLimit; p += 2) {
            if (sieve_.get(p/2 - 1))
                continue;
            int q = p * Math.max(p, nextOddNumber((start + p - 1)/p)) - start;
            q /= 2;
            for (; q >= 0 && q < count; q += p)
                composite.set(q, true);
        }
        for (int p = 0; p < count; ++p) {
            if (!composite.get(p))
                primes_.add(p * 2 + start);
        }
    }

    private static int sqrt(int n) {
        return nextOddNumber((int)Math.sqrt(n));
    }

    private static int nextOddNumber(int n) {
        return 1 + 2 * (n/2);
    }

    public static void main(String[] args) {
        PrimeGenerator pgen = new PrimeGenerator(20, 200000);
        System.out.println("First 20 primes:");
        for (int i = 0; i < 20; ++i) {
            if (i > 0)
                System.out.print(", ");
            System.out.print(pgen.nextPrime());
        }
        System.out.println();
        System.out.println("Primes between 100 and 150:");
        for (int i = 0; ; ) {
            int prime = pgen.nextPrime();
            if (prime > 150)
                break;
            if (prime >= 100) {
                if (i++ != 0)
                    System.out.print(", ");
                System.out.print(prime);
            }
        }
        System.out.println();
        int count = 0;
        for (;;) {
            int prime = pgen.nextPrime();
            if (prime > 8000)
                break;
            if (prime >= 7700)
                ++count;
        }
        System.out.println("Number of primes between 7700 and 8000: " + count);
        int n = 10000;
        for (;;) {
            int prime = pgen.nextPrime();
            if (prime == 0) {
                System.out.println("Can't generate any more primes.");
                break;
            }
            if (pgen.count() == n) {
                System.out.println(n + "th prime: " + prime);
                n *= 10;
            }
        }
    }
}
