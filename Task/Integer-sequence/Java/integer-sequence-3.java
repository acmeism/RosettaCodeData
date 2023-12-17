import java.util.stream.LongStream;

public class Count {
    public static void main(String[] args) {
        LongStream.iterate(1, l -> l + 1)
                  .forEach(System.out::println);
    }
}
