import java.util.function.Consumer;
import java.util.stream.IntStream;

public class Repeat {

    public static void main(String[] args) {
        repeat(3, (x) -> System.out.println("Example " + x));
    }

    static void repeat (int n, Consumer<Integer> fun) {
        IntStream.range(0, n).forEach(i -> fun.accept(i + 1));
    }
}
