import java.util.LinkedList;
import java.util.List;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class StrangeNumbers {
    private static List<Integer> digits(int n) {
        var result = new LinkedList<Integer>();
        while (n > 0) {
            var rem = n % 10;
            result.addFirst(rem);
            n /= 10;
        }
        return result;
    }

    private static boolean isStrange(int n) {
        BiPredicate<Integer, Integer> test = (a, b) -> {
            var abs = Math.abs(a - b);
            return abs == 2 || abs == 3 || abs == 5 || abs == 7;
        };

        var xs = digits(n);
        for (int i = 1; i < xs.size(); i++) {
            if (test.negate().test(xs.get(i - 1), xs.get(i))) {
                return false;
            }
        }
        return true;
    }

    public static void main(String[] args) {
        var xs = IntStream.rangeClosed(100, 500)
            .filter(StrangeNumbers::isStrange)
            .boxed()
            .collect(Collectors.toList());

        System.out.println("Strange numbers in range [100..500]");
        System.out.printf("(Total: %d)\n\n", xs.size());

        for (int i = 0; i < xs.size(); i++) {
            Integer x = xs.get(i);
            System.out.print(x);

            if ((i + 1) % 10 == 0) {
                System.out.println();
            } else {
                System.out.print(' ');
            }
        }
    }
}
