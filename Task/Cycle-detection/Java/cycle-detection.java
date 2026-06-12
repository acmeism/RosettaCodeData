import java.util.function.*;
import static java.util.stream.IntStream.*;

public class CycleDetection {

    public static void main(String[] args) {
        brent(i -> (i * i + 1) % 255, 3);
    }

    static void brent(IntUnaryOperator f, int x0) {
        int cycleLength;
        int hare = x0;
        FOUND:
        for (int power = 1; ; power *= 2) {
            int tortoise = hare;
            for (int i = 1; i <= power; i++) {
                hare = f.applyAsInt(hare);
                 if (tortoise == hare) {
                    cycleLength = i;
                    break FOUND;
                }
            }
        }

        hare = x0;
        for (int i = 0; i < cycleLength; i++)
            hare = f.applyAsInt(hare);

        int cycleStart = 0;
        for (int tortoise = x0; tortoise != hare; cycleStart++) {
            tortoise = f.applyAsInt(tortoise);
            hare = f.applyAsInt(hare);
        }

        printResult(x0, f, cycleLength, cycleStart);
    }

    static void printResult(int x0, IntUnaryOperator f, int len, int start) {
        System.out.printf("Cycle length: %d%nCycle: ", len);
        iterate(x0, f).skip(start).limit(len)
                .forEach(n -> System.out.printf("%s ", n));
    }
}
