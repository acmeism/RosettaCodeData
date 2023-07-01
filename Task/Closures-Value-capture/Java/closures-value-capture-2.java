import java.util.List;
import java.util.function.IntSupplier;
import java.util.stream.IntStream;

import static java.util.stream.Collectors.toList;

public interface ValueCapture {
  public static void main(String... arguments) {
    List<IntSupplier> closures = IntStream.rangeClosed(0, 10)
      .<IntSupplier>mapToObj(i -> () -> i * i)
      .collect(toList())
    ;

    IntSupplier closure = closures.get(3);
    System.out.println(closure.getAsInt()); // prints "9"
  }
}
