import java.util.stream.Stream;

public class ReduceTask {

    public static void main(String[] args) {
        System.out.println(Stream.of(1, 2, 3, 4, 5).mapToInt(i -> i).sum());
        System.out.println(Stream.of(1, 2, 3, 4, 5).reduce(1, (a, b) -> a * b));
    }
}
