import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class ConstructFromRationalNumber {
    private static class R2cf implements Iterator<Integer> {
        private int num;
        private int den;

        R2cf(int num, int den) {
            this.num = num;
            this.den = den;
        }

        @Override
        public boolean hasNext() {
            return den != 0;
        }

        @Override
        public Integer next() {
            int div = num / den;
            int rem = num % den;
            num = den;
            den = rem;
            return div;
        }
    }

    private static void iterate(R2cf generator) {
        generator.forEachRemaining(n -> System.out.printf("%d ", n));
        System.out.println();
    }

    public static void main(String[] args) {
        List<Map.Entry<Integer, Integer>> fracs = List.of(
                Map.entry(1, 2),
                Map.entry(3, 1),
                Map.entry(23, 8),
                Map.entry(13, 11),
                Map.entry(22, 7),
                Map.entry(-151, 77)
        );
        for (Map.Entry<Integer, Integer> frac : fracs) {
            System.out.printf("%4d / %-2d = ", frac.getKey(), frac.getValue());
            iterate(new R2cf(frac.getKey(), frac.getValue()));
        }

        System.out.println("\nSqrt(2) ->");
        List<Map.Entry<Integer, Integer>> root2 = List.of(
                Map.entry(    14_142,     10_000),
                Map.entry(   141_421,    100_000),
                Map.entry( 1_414_214,  1_000_000),
                Map.entry(14_142_136, 10_000_000)
        );
        for (Map.Entry<Integer, Integer> frac : root2) {
            System.out.printf("%8d / %-8d = ", frac.getKey(), frac.getValue());
            iterate(new R2cf(frac.getKey(), frac.getValue()));
        }

        System.out.println("\nPi ->");
        List<Map.Entry<Integer, Integer>> pi = List.of(
                Map.entry(         31,        10),
                Map.entry(        314,       100),
                Map.entry(      3_142,      1_000),
                Map.entry(     31_428,     10_000),
                Map.entry(    314_285,    100_000),
                Map.entry(  3_142_857,   1_000_000),
                Map.entry( 31_428_571,  10_000_000),
                Map.entry(314_285_714, 100_000_000)
        );
        for (Map.Entry<Integer, Integer> frac : pi) {
            System.out.printf("%9d / %-9d = ", frac.getKey(), frac.getValue());
            iterate(new R2cf(frac.getKey(), frac.getValue()));
        }
    }
}
