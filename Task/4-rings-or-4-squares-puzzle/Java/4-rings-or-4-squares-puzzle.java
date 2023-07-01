import java.util.Arrays;

public class FourSquares {
    public static void main(String[] args) {
        fourSquare(1, 7, true, true);
        fourSquare(3, 9, true, true);
        fourSquare(0, 9, false, false);
    }

    private static void fourSquare(int low, int high, boolean unique, boolean print) {
        int count = 0;

        if (print) {
            System.out.println("a b c d e f g");
        }
        for (int a = low; a <= high; ++a) {
            for (int b = low; b <= high; ++b) {
                if (notValid(unique, a, b)) continue;

                int fp = a + b;
                for (int c = low; c <= high; ++c) {
                    if (notValid(unique, c, a, b)) continue;
                    for (int d = low; d <= high; ++d) {
                        if (notValid(unique, d, a, b, c)) continue;
                        if (fp != b + c + d) continue;

                        for (int e = low; e <= high; ++e) {
                            if (notValid(unique, e, a, b, c, d)) continue;
                            for (int f = low; f <= high; ++f) {
                                if (notValid(unique, f, a, b, c, d, e)) continue;
                                if (fp != d + e + f) continue;

                                for (int g = low; g <= high; ++g) {
                                    if (notValid(unique, g, a, b, c, d, e, f)) continue;
                                    if (fp != f + g) continue;

                                    ++count;
                                    if (print) {
                                        System.out.printf("%d %d %d %d %d %d %d%n", a, b, c, d, e, f, g);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if (unique) {
            System.out.printf("There are %d unique solutions in [%d, %d]%n", count, low, high);
        } else {
            System.out.printf("There are %d non-unique solutions in [%d, %d]%n", count, low, high);
        }
    }

    private static boolean notValid(boolean unique, int needle, int... haystack) {
        return unique && Arrays.stream(haystack).anyMatch(p -> p == needle);
    }
}
