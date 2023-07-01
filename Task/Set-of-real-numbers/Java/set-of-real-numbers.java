import java.util.Objects;
import java.util.function.Predicate;

public class RealNumberSet {
    public enum RangeType {
        CLOSED,
        BOTH_OPEN,
        LEFT_OPEN,
        RIGHT_OPEN,
    }

    public static class RealSet {
        private Double low;
        private Double high;
        private Predicate<Double> predicate;
        private double interval = 0.00001;

        public RealSet(Double low, Double high, Predicate<Double> predicate) {
            this.low = low;
            this.high = high;
            this.predicate = predicate;
        }

        public RealSet(Double start, Double end, RangeType rangeType) {
            this(start, end, d -> {
                switch (rangeType) {
                    case CLOSED:
                        return start <= d && d <= end;
                    case BOTH_OPEN:
                        return start < d && d < end;
                    case LEFT_OPEN:
                        return start < d && d <= end;
                    case RIGHT_OPEN:
                        return start <= d && d < end;
                    default:
                        throw new IllegalStateException("Unhandled range type encountered.");
                }
            });
        }

        public boolean contains(Double d) {
            return predicate.test(d);
        }

        public RealSet union(RealSet other) {
            double low2 = Math.min(low, other.low);
            double high2 = Math.max(high, other.high);
            return new RealSet(low2, high2, d -> predicate.or(other.predicate).test(d));
        }

        public RealSet intersect(RealSet other) {
            double low2 = Math.min(low, other.low);
            double high2 = Math.max(high, other.high);
            return new RealSet(low2, high2, d -> predicate.and(other.predicate).test(d));
        }

        public RealSet subtract(RealSet other) {
            return new RealSet(low, high, d -> predicate.and(other.predicate.negate()).test(d));
        }

        public double length() {
            if (low.isInfinite() || high.isInfinite()) return -1.0; // error value
            if (high <= low) return 0.0;
            Double p = low;
            int count = 0;
            do {
                if (predicate.test(p)) count++;
                p += interval;
            } while (p < high);
            return count * interval;
        }

        public boolean isEmpty() {
            if (Objects.equals(high, low)) {
                return predicate.negate().test(low);
            }
            return length() == 0.0;
        }
    }

    public static void main(String[] args) {
        RealSet a = new RealSet(0.0, 1.0, RangeType.LEFT_OPEN);
        RealSet b = new RealSet(0.0, 2.0, RangeType.RIGHT_OPEN);
        RealSet c = new RealSet(1.0, 2.0, RangeType.LEFT_OPEN);
        RealSet d = new RealSet(0.0, 3.0, RangeType.RIGHT_OPEN);
        RealSet e = new RealSet(0.0, 1.0, RangeType.BOTH_OPEN);
        RealSet f = new RealSet(0.0, 1.0, RangeType.CLOSED);
        RealSet g = new RealSet(0.0, 0.0, RangeType.CLOSED);

        for (int i = 0; i <= 2; i++) {
            Double dd = (double) i;
            System.out.printf("(0, 1] ∪ [0, 2) contains %d is %s\n", i, a.union(b).contains(dd));
            System.out.printf("[0, 2) ∩ (1, 2] contains %d is %s\n", i, b.intersect(c).contains(dd));
            System.out.printf("[0, 3) − (0, 1) contains %d is %s\n", i, d.subtract(e).contains(dd));
            System.out.printf("[0, 3) − [0, 1] contains %d is %s\n", i, d.subtract(f).contains(dd));
            System.out.println();
        }

        System.out.printf("[0, 0] is empty is %s\n", g.isEmpty());
        System.out.println();

        RealSet aa = new RealSet(
            0.0, 10.0,
            x -> (0.0 < x && x < 10.0) && Math.abs(Math.sin(Math.PI * x * x)) > 0.5
        );
        RealSet bb = new RealSet(
            0.0, 10.0,
            x -> (0.0 < x && x < 10.0) && Math.abs(Math.sin(Math.PI * x)) > 0.5
        );
        RealSet cc = aa.subtract(bb);
        System.out.printf("Approx length of A - B is %f\n", cc.length());
    }
}
