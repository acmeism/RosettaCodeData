import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public interface StemAndLeaf {
  public static final int[] data = {12, 127, 28, 42, 39, 113, 42, 18, 44, 118,
    44, 37, 113, 124, 37, 48, 127, 36, 29, 31, 125, 139, 131, 115, 105,
    132, 104, 123, 35, 113, 122, 42, 117, 119, 58, 109, 23, 105, 63,
    27, 44, 105, 99, 41, 128, 121, 116, 125, 32, 61, 37, 127, 29, 113,
    121, 58, 114, 126, 53, 114, 96, 25, 109, 7, 31, 141, 46, 13, 27,
    43, 117, 116, 27, 7, 68, 40, 31, 115, 124, 42, 128, 52, 71, 118,
    117, 38, 27, 106, 33, 117, 116, 111, 40, 119, 47, 105, 57, 122,
    109, 124, 115, 43, 120, 43, 27, 27, 18, 28, 48, 125, 107, 114, 34,
    133, 45, 120, 30, 127, 31, 116, 146};

  public static Map<Integer, List<Integer>> createPlot(int... data) {
    Map<Integer, List<Integer>> plot = Arrays.stream(data)
      .parallel()
      .boxed()
      .collect(
        Collectors.groupingBy(
          datum -> datum / 10, // stem, integer division
          Collectors.mapping(
            datum -> datum % 10, // leaf
            Collectors.toList()
          )
        )
      )
    ;
    int highestStem = Arrays.stream(data)
      .parallel()
      .map(datum -> datum / 10)
      .max()
      .orElse(-1) //for filling in stems with no leaves
    ;
    Optional.of(plot)
      .map(Map::keySet)
      .map(Collection::size)
      .filter(size -> size < highestStem + 1 /*highest stem value and 0*/)
      .ifPresent(p ->
        IntStream.rangeClosed(
          0,
          highestStem
        )
          .parallel()
          .forEach(i ->
            plot.computeIfAbsent(i, $ -> new LinkedList<>())
          )
      )
    ;
    return plot;
  }

  public static void printPlot(Map<Integer, List<Integer>> plot) {
    plot.entrySet()
      .stream()
      .parallel()
      .peek(line -> Optional.of(line)
        .map(Map.Entry::getValue)
        .ifPresent(Collections::sort)
      )
      .map(line ->
        String.join(" ",
          String.valueOf(line.getKey()),
          "|",
          String.valueOf(line.getValue())
        )
      )
      .forEachOrdered(System.out::println)
    ;
  }

  public static void main(String... arguments) {
    Optional.of(data)
      .map(StemAndLeaf::createPlot)
      .ifPresent(StemAndLeaf::printPlot)
    ;
  }
}
