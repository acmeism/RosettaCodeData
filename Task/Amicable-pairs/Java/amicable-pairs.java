import java.util.Map;
import static java.util.function.Function.*;
import static java.util.stream.Collectors.*;
import static java.util.stream.LongStream.*;

public class AmicablePairs {

    public static void main(String[] args) {
        final int limit = 20_000;

        Map<Long, Long> map = rangeClosed(1, limit)
                .parallel()
                .boxed()
                .collect(toMap(identity(), AmicablePairs::properDivsSum));

        rangeClosed(1, limit)
                .forEach(n -> {
                    long m = map.get(n);
                    if (m > n && m <= limit && map.get(m) == n)
                        System.out.printf("%s %s %n", n, m);
                });
    }

    public static Long properDivsSum(long n) {
        return rangeClosed(1, (n + 1) / 2).filter(i -> n % i == 0).sum();
    }
}
