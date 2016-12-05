import java.util.stream.IntStream;
import static java.util.stream.IntStream.iterate;

public class LinearCongruentialGenerator {
    final static int mask = (1 << 31) - 1;

    public static void main(String[] args) {
        System.out.println("BSD:");
        randBSD(0).limit(10).forEach(System.out::println);

        System.out.println("\nMS:");
        randMS(0).limit(10).forEach(System.out::println);
    }

    static IntStream randBSD(int seed) {
        return iterate(seed, s -> (s * 1_103_515_245 + 12_345) & mask).skip(1);
    }

    static IntStream randMS(int seed) {
        return iterate(seed, s -> (s * 214_013 + 2_531_011) & mask).skip(1)
                .map(i -> i >> 16);
    }
}
