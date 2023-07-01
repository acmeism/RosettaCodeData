import java.util.ArrayList;
import java.util.stream.IntStream;
import java.util.stream.LongStream;

public class EstheticNumbers {
    interface RecTriConsumer<A, B, C> {
        void accept(RecTriConsumer<A, B, C> f, A a, B b, C c);
    }

    private static boolean isEsthetic(long n, long b) {
        if (n == 0) {
            return false;
        }
        var i = n % b;
        var n2 = n / b;
        while (n2 > 0) {
            var j = n2 % b;
            if (Math.abs(i - j) != 1) {
                return false;
            }
            n2 /= b;
            i = j;
        }
        return true;
    }

    private static void listEsths(long n, long n2, long m, long m2, int perLine, boolean all) {
        var esths = new ArrayList<Long>();
        var dfs = new RecTriConsumer<Long, Long, Long>() {
            public void accept(Long n, Long m, Long i) {
                accept(this, n, m, i);
            }

            @Override
            public void accept(RecTriConsumer<Long, Long, Long> f, Long n, Long m, Long i) {
                if (n <= i && i <= m) {
                    esths.add(i);
                }
                if (i == 0 || i > m) {
                    return;
                }
                var d = i % 10;
                var i1 = i * 10 + d - 1;
                var i2 = i1 + 2;
                if (d == 0) {
                    f.accept(f, n, m, i2);
                } else if (d == 9) {
                    f.accept(f, n, m, i1);
                } else {
                    f.accept(f, n, m, i1);
                    f.accept(f, n, m, i2);
                }
            }
        };

        LongStream.range(0, 10).forEach(i -> dfs.accept(n2, m2, i));

        var le = esths.size();
        System.out.printf("Base 10: %d esthetic numbers between %d and %d:%n", le, n, m);
        if (all) {
            for (int i = 0; i < esths.size(); i++) {
                System.out.printf("%d ", esths.get(i));
                if ((i + 1) % perLine == 0) {
                    System.out.println();
                }
            }
        } else {
            for (int i = 0; i < perLine; i++) {
                System.out.printf("%d ", esths.get(i));
            }
            System.out.println();
            System.out.println("............");
            for (int i = le - perLine; i < le; i++) {
                System.out.printf("%d ", esths.get(i));
            }
        }
        System.out.println();
        System.out.println();
    }

    public static void main(String[] args) {
        IntStream.rangeClosed(2, 16).forEach(b -> {
            System.out.printf("Base %d: %dth to %dth esthetic numbers:%n", b, 4 * b, 6 * b);
            var n = 1L;
            var c = 0L;
            while (c < 6 * b) {
                if (isEsthetic(n, b)) {
                    c++;
                    if (c >= 4 * b) {
                        System.out.printf("%s ", Long.toString(n, b));
                    }
                }
                n++;
            }
            System.out.println();
        });
        System.out.println();

        // the following all use the obvious range limitations for the numbers in question
        listEsths(1000, 1010, 9999, 9898, 16, true);
        listEsths((long) 1e8, 101_010_101, 13 * (long) 1e7, 123_456_789, 9, true);
        listEsths((long) 1e11, 101_010_101_010L, 13 * (long) 1e10, 123_456_789_898L, 7, false);
        listEsths((long) 1e14, 101_010_101_010_101L, 13 * (long) 1e13, 123_456_789_898_989L, 5, false);
        listEsths((long) 1e17, 101_010_101_010_101_010L, 13 * (long) 1e16, 123_456_789_898_989_898L, 4, false);
    }
}
