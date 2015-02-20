package nth;

import java.util.stream.IntStream;
import java.util.stream.Stream;

public interface Nth {
  public static String suffix(int n){
    if(n % 100 / 10 == 1){
      return "th"; //teens are all "th"
    }
    switch(n % 10){
      case 1: return "st";
      case 2: return "nd";
      case 3: return "rd";
      default: return "th"; //most of the time it should be "th"
    }
  }

  public static void print(int start, int end) {
    IntStream.rangeClosed(start, end)
      .parallel()
      .mapToObj(i -> i + suffix(i) + " ")
      .reduce(String::concat)
      .ifPresent(System.out::println)
    ;
  }

  public static void print(int[] startAndEnd) {
    print(startAndEnd[0], startAndEnd[1]);
  }

  public static int[] startAndEnd(int start, int end) {
    return new int[] {
      start,
      end
    };
  }

  public static void main(String... arguments){
    Stream.of(
      startAndEnd(0, 25),
      startAndEnd(250, 265),
      startAndEnd(1000, 1025)
    )
      .forEach(Nth::print)
    ;
  }
}
