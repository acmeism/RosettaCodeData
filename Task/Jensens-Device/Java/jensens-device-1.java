import java.util.function.*;
import java.util.stream.*;

public class Jensen {
    static double sum(int lo, int hi, IntToDoubleFunction f) {
        return IntStream.rangeClosed(lo, hi).mapToDouble(f).sum();
    }

    public static void main(String args[]) {
        System.out.println(sum(1, 100, (i -> 1.0/i)));
    }
}
