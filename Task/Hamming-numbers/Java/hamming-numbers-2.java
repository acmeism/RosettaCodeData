import java.math.BigInteger;
import java.util.*;

// ilkka.kokkarinen@gmail.com

public class HammingTriple implements Comparable<HammingTriple> {

    // Precompute a couple of constants that we need all the time
    private static final BigInteger two = BigInteger.valueOf(2);
    private static final BigInteger three = BigInteger.valueOf(3);
    private static final BigInteger five = BigInteger.valueOf(5);
    private static final double logOf2 = Math.log(2);
    private static final double logOf3 = Math.log(3);
    private static final double logOf5 = Math.log(5);

    // The powers of this triple
    private int a, b, c;

    public HammingTriple(int a, int b, int c) {
        this.a = a; this.b = b; this.c = c;
    }

    public String toString() {
        return "[" + a + ", " + b + ", " + c + "]";
    }

    public BigInteger getValue() {
        return two.pow(a).multiply(three.pow(b)).multiply(five.pow(c));
    }

    public boolean equals(Object other) {
        if(other instanceof HammingTriple) {
            HammingTriple h = (HammingTriple) other;
            return this.a == h.a && this.b == h.b && this.c == h.c;
        }
        else { return false; }
    }

    // Return 0 if this == other, +1 if this > other, and -1 if this < other
    public int compareTo(HammingTriple other) {
        // equality
        if(this.a == other.a && this.b == other.b && this.c == other.c) {
            return 0;
        }
        // this dominates
        if(this.a >= other.a && this.b >= other.b && this.c >= other.c) {
            return +1;
        }
        // other dominates
        if(this.a <= other.a && this.b <= other.b && this.c <= other.c) {
            return -1;
        }

        // take the logarithms for comparison
        double log1 = this.a * logOf2 + this.b * logOf3 + this.c * logOf5;
        double log2 = other.a * logOf2 + other.b * logOf3 + other.c * logOf5;

        // are these different enough to be reliable?
        if(Math.abs(log1 - log2) > 0.0000001) {
            return (log1 < log2) ? -1: +1;
        }

        // oh well, looks like we have to do this the hard way
        return this.getValue().compareTo(other.getValue());
        // (getting this far should be pretty rare, though)
    }

    public static BigInteger computeHamming(int n, boolean verbose) {
        if(verbose) {
            System.out.println("Hamming number #" + n);
        }
        long startTime = System.currentTimeMillis();

        // The elements of the search frontier
        PriorityQueue<HammingTriple> frontierQ = new PriorityQueue<HammingTriple>();
        int maxFrontierSize = 1;

        // Initialize the frontier
        frontierQ.offer(new HammingTriple(0, 0, 0)); // 1

        while(true) {
            if(frontierQ.size() > maxFrontierSize) {
                maxFrontierSize = frontierQ.size();
            }
            // Pop out the next Hamming number from the frontier
            HammingTriple curr = frontierQ.poll();

            if(--n == 0) {
                if(verbose) {
                    System.out.println("Time: " + (System.currentTimeMillis() - startTime) + " ms");
                    System.out.println("Frontier max size: " + maxFrontierSize);
                    System.out.println("As powers: " + curr.toString());
                    System.out.println("As value: " + curr.getValue());
                }
                return curr.getValue();
            }

            // Current times five, if at origin in (a,b) plane
            if(curr.a == 0 && curr.b == 0) {
                frontierQ.offer(new HammingTriple(curr.a, curr.b, curr.c + 1));
            }
            // Current times three, if at line a == 0
            if(curr.a == 0) {
                frontierQ.offer(new HammingTriple(curr.a, curr.b + 1, curr.c));
            }
            // Current times two, unconditionally
            curr.a++;
            frontierQ.offer(curr); // reuse the current HammingTriple object
        }
    }
}
