import static java.math.BigInteger.ONE;

import java.util.stream.Stream;

public class Count {
    public static void main(String[] args) {
        Stream.iterate(ONE, i -> i.add(ONE))
              .forEach(System.out::println);
    }
}
