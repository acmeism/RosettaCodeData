import java.util.Comparator;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public interface IntConcat {
  public static Comparator<Integer> SORTER = (o1, o2) -> {
    String o1s = o1.toString();
    String o2s = o2.toString();

    if (o1s.length() == o2s.length()) {
      return o2s.compareTo(o1s);
    }

    int mlen = Math.max(o1s.length(), o2s.length());
    while (o1s.length() < mlen * 2) {
      o1s += o1s;
    }
    while (o2s.length() < mlen * 2) {
      o2s += o2s;
    }

    return o2s.compareTo(o1s);
  };

  public static void main(String[] args) {
    Stream<Integer> ints1 = Stream.of(
      1, 34, 3, 98, 9, 76, 45, 4
    );

    System.out.println(ints1
      .parallel()
      .sorted(SORTER)
      .map(String::valueOf)
      .collect(Collectors.joining())
    );

    Stream<Integer> ints2 = Stream.of(
      54, 546, 548, 60
    );

    System.out.println(ints2
      .parallel()
      .sorted(SORTER)
      .map(String::valueOf)
      .collect(Collectors.joining())
    );
  }
}
