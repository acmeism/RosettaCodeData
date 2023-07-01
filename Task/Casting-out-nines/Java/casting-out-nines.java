import java.util.*;
import java.util.stream.IntStream;

public class CastingOutNines {

    public static void main(String[] args) {
        System.out.println(castOut(16, 1, 255));
        System.out.println(castOut(10, 1, 99));
        System.out.println(castOut(17, 1, 288));
    }

    static List<Integer> castOut(int base, int start, int end) {
        int[] ran = IntStream
                .range(0, base - 1)
                .filter(x -> x % (base - 1) == (x * x) % (base - 1))
                .toArray();

        int x = start / (base - 1);

        List<Integer> result = new ArrayList<>();
        while (true) {
            for (int n : ran) {
                int k = (base - 1) * x + n;
                if (k < start)
                    continue;
                if (k > end)
                    return result;
                result.add(k);
            }
            x++;
        }
    }
}
