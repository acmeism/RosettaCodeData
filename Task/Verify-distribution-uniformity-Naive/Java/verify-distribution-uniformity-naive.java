import static java.lang.Math.abs;
import java.util.*;
import java.util.function.IntSupplier;

public class Test {

    static void distCheck(IntSupplier f, int nRepeats, double delta) {
        Map<Integer, Integer> counts = new HashMap<>();

        for (int i = 0; i < nRepeats; i++)
            counts.compute(f.getAsInt(), (k, v) -> v == null ? 1 : v + 1);

        double target = nRepeats / (double) counts.size();
        int deltaCount = (int) (delta / 100.0 * target);

        counts.forEach((k, v) -> {
            if (abs(target - v) >= deltaCount)
                System.out.printf("distribution potentially skewed "
                        + "for '%s': '%d'%n", k, v);
        });

        counts.keySet().stream().sorted().forEach(k
                -> System.out.printf("%d %d%n", k, counts.get(k)));
    }

    public static void main(String[] a) {
        distCheck(() -> (int) (Math.random() * 5) + 1, 1_000_000, 1);
    }
}
