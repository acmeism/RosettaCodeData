import java.util.Collection;
import java.util.Map;
import java.util.Optional;
import java.util.function.BooleanSupplier;
import java.util.function.Supplier;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import static java.util.Collections.singletonMap;

public interface YinYang {
  public static boolean circle(
    int x,
    int y,
    int c,
    int r
  ) {
    return
      (r * r) >=
        ((x = x / 2) * x)
         + ((y = y - c) * y)
    ;
  }

  public static String pixel(int x, int y, int r) {
    return Stream.<Map<BooleanSupplier, Supplier<String>>>of(
      singletonMap(
        () -> circle(x, y, -r / 2, r / 6),
        () -> "#"
      ),
      singletonMap(
        () -> circle(x, y, r / 2, r / 6),
        () -> "."
      ),
      singletonMap(
        () -> circle(x, y, -r / 2, r / 2),
        () -> "."
      ),
      singletonMap(
        () -> circle(x, y, r / 2, r / 2),
        () -> "#"
      ),
      singletonMap(
        () -> circle(x, y, 0, r),
        () -> x < 0 ? "." : "#"
      )
    )
      .sequential()
      .map(Map::entrySet)
      .flatMap(Collection::stream)
      .filter(e -> e.getKey().getAsBoolean())
      .map(Map.Entry::getValue)
      .map(Supplier::get)
      .findAny()
      .orElse(" ")
    ;
  }

  public static void yinYang(int r) {
    IntStream.rangeClosed(-r, r)
      .mapToObj(
        y ->
          IntStream.rangeClosed(
            0 - r - r,
            r + r
          )
            .mapToObj(x -> pixel(x, y, r))
            .reduce("", String::concat)
      )
      .forEach(System.out::println)
    ;
  }

  public static void main(String... arguments) {
    Optional.of(arguments)
      .filter(a -> a.length == 1)
      .map(a -> a[0])
      .map(Integer::parseInt)
      .ifPresent(YinYang::yinYang)
    ;
  }
}
