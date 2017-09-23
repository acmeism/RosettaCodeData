public class AccumulatorFactory {

    public interface Accumulator {
        double add(double x);
    }

    private static Accumulator accumulator(final double initial) {
        return new Accumulator() {
            private double sum = initial;

            @Override
            public double add(double x) {
                return sum += x;
            }
        };
    }

    public static void main(String[] args) {
        Accumulator x = accumulator(1.0);
        x.add(5.0);
        System.out.println(accumulator(3.0));
        System.out.println(x.add(2.3));
    }
}
