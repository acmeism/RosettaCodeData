import static java.lang.System.out;
import java.util.List;
import java.util.function.Function;
import java.util.stream.*;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.range;

public class PascalMatrix {
    static int binomialCoef(int n, int k) {
        int result = 1;
        for (int i = 1; i <= k; i++)
            result = result * (n - i + 1) / i;
        return result;
    }

    static List<IntStream> pascal(int n, Function<Integer, IntStream> f) {
        return range(0, n).mapToObj(i -> f.apply(i)).collect(toList());
    }

    static List<IntStream> pascalUpp(int n) {
        return pascal(n, i -> range(0, n).map(j -> binomialCoef(j, i)));
    }

    static List<IntStream> pascalLow(int n) {
        return pascal(n, i -> range(0, n).map(j -> binomialCoef(i, j)));
    }

    static List<IntStream> pascalSym(int n) {
        return pascal(n, i -> range(0, n).map(j -> binomialCoef(i + j, i)));
    }

    static void print(String label, List<IntStream> result) {
        out.println("\n" + label);
        for (IntStream row : result) {
            row.forEach(i -> out.printf("%2d ", i));
            System.out.println();
        }
    }

    public static void main(String[] a) {
        print("Upper: ", pascalUpp(5));
        print("Lower: ", pascalLow(5));
        print("Symmetric:", pascalSym(5));
    }
}
