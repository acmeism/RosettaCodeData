import java.util.function.Consumer;

public class RateCounter {

    public static void main(String[] args) {
        for (double d : benchmark(10, x -> System.out.print(""), 10))
            System.out.println(d);
    }

    static double[] benchmark(int n, Consumer<Integer> f, int arg) {
        double[] timings = new double[n];
        for (int i = 0; i < n; i++) {
            long time = System.nanoTime();
            f.accept(arg);
            timings[i] = System.nanoTime() - time;
        }
        return timings;
    }
}
