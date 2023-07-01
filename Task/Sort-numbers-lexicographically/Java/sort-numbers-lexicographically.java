import java.util.List;
import java.util.stream.*;

public class LexicographicalNumbers {

    static List<Integer> lexOrder(int n) {
        int first = 1, last = n;
        if (n < 1) {
            first = n;
            last = 1;
        }
        return IntStream.rangeClosed(first, last)
                        .mapToObj(Integer::toString)
                        .sorted()
                        .map(Integer::valueOf)
                        .collect(Collectors.toList());
    }

    public static void main(String[] args) {
        System.out.println("In lexicographical order:\n");
        int[] ints = {0, 5, 13, 21, -22};
        for (int n : ints) {
           System.out.printf("%3d: %s\n", n, lexOrder(n));
        }
    }
}
