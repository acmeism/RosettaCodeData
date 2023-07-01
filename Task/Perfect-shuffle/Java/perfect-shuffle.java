import java.util.Arrays;
import java.util.stream.IntStream;

public class PerfectShuffle {

    public static void main(String[] args) {
        int[] sizes = {8, 24, 52, 100, 1020, 1024, 10_000};
        for (int size : sizes)
            System.out.printf("%5d : %5d%n", size, perfectShuffle(size));
    }

    static int perfectShuffle(int size) {
        if (size % 2 != 0)
            throw new IllegalArgumentException("size must be even");

        int half = size / 2;
        int[] a = IntStream.range(0, size).toArray();
        int[] original = a.clone();
        int[] aa = new int[size];

        for (int count = 1; true; count++) {
            System.arraycopy(a, 0, aa, 0, size);

            for (int i = 0; i < half; i++) {
                a[2 * i] = aa[i];
                a[2 * i + 1] = aa[i + half];
            }

            if (Arrays.equals(a, original))
                return count;
        }
    }
}
