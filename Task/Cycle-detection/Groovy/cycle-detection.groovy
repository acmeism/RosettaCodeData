import java.util.function.IntUnaryOperator

class CycleDetection {
    static void main(String[] args) {
        brent({ i -> (i * i + 1) % 255 }, 3)
    }

    static void brent(IntUnaryOperator f, int x0) {
        int cycleLength = -1
        int hare = x0
        FOUND:
        for (int power = 1; ; power *= 2) {
            int tortoise = hare
            for (int i = 1; i <= power; i++) {
                hare = f.applyAsInt(hare)
                if (tortoise == hare) {
                    cycleLength = i
                    break FOUND
                }
            }
        }

        hare = x0
        for (int i = 0; i < cycleLength; i++) {
            hare = f.applyAsInt(hare)
        }

        int cycleStart = 0
        for (int tortoise = x0; tortoise != hare; cycleStart++) {
            tortoise = f.applyAsInt(tortoise)
            hare = f.applyAsInt(hare)
        }

        printResult(x0, f, cycleLength, cycleStart)
    }

    static void printResult(int x0, IntUnaryOperator f, int len, int start) {
        printf("Cycle length: %d%nCycle: ", len)

        int n = x0
        for (int i = 0; i < start + len; i++) {
            n = f.applyAsInt(n)
            if (i >= start) {
                printf("%s ", n)
            }
        }
        println()
    }
}
