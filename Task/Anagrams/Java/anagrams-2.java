import java.net.*;
import java.io.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.function.*;

public interface Anagram {
  public static <AUTOCLOSEABLE extends AutoCloseable, OUTPUT> Supplier<OUTPUT> tryWithResources(Callable<AUTOCLOSEABLE> callable, Function<AUTOCLOSEABLE, Supplier<OUTPUT>> function, Supplier<OUTPUT> defaultSupplier) {
    return () -> {
      try (AUTOCLOSEABLE autoCloseable = callable.call()) {
        return function.apply(autoCloseable).get();
      } catch (Throwable throwable) {
        return defaultSupplier.get();
      }
    };
  }

  public static <INPUT, OUTPUT> Function<INPUT, OUTPUT> function(Supplier<OUTPUT> supplier) {
    return i -> supplier.get();
  }

  public static void main(String... args) {
    Map<String, Collection<String>> anagrams = new ConcurrentSkipListMap<>();
    int count = tryWithResources(
      () -> new BufferedReader(
        new InputStreamReader(
          new URL(
            "http://www.puzzlers.org/pub/wordlists/unixdict.txt"
          ).openStream()
        )
      ),
      reader -> () -> reader.lines()
        .parallel()
        .mapToInt(word -> {
          char[] chars = word.toCharArray();
          Arrays.parallelSort(chars);
          String key = Arrays.toString(chars);
          Collection<String> collection = anagrams.computeIfAbsent(
            key, function(ArrayList::new)
          );
          collection.add(word);
          return collection.size();
        })
        .max()
        .orElse(0),
      () -> 0
    ).get();
    anagrams.values().stream()
      .filter(ana -> ana.size() >= count)
      .forEach(System.out::println)
    ;
  }
}
