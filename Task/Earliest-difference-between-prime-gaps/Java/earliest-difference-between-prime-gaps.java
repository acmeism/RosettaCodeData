import java.util.HashMap;
import java.util.Map;

public class PrimeGaps {
    private Map<Integer, Integer> gapStarts = new HashMap<>();
    private int lastPrime;
    private PrimeGenerator primeGenerator = new PrimeGenerator(1000, 500000);

    public static void main(String[] args) {
        final int limit = 100000000;
        PrimeGaps pg = new PrimeGaps();
        for (int pm = 10, gap1 = 2;;) {
            int start1 = pg.findGapStart(gap1);
            int gap2 = gap1 + 2;
            int start2 = pg.findGapStart(gap2);
            int diff = start2 > start1 ? start2 - start1 : start1 - start2;
            if (diff > pm) {
                System.out.printf(
                    "Earliest difference > %,d between adjacent prime gap starting primes:\n"
                    + "Gap %,d starts at %,d, gap %,d starts at %,d, difference is %,d.\n\n",
                    pm, gap1, start1, gap2, start2, diff);
                if (pm == limit)
                    break;
                pm *= 10;
            } else {
                gap1 = gap2;
            }
        }
    }

    private int findGapStart(int gap) {
        Integer start = gapStarts.get(gap);
        if (start != null)
            return start;
        for (;;) {
            int prev = lastPrime;
            lastPrime = primeGenerator.nextPrime();
            int diff = lastPrime - prev;
            gapStarts.putIfAbsent(diff, prev);
            if (diff == gap)
                return prev;
        }
    }
}
