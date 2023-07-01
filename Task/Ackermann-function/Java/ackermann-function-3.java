import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.UnaryOperator;
import java.util.stream.Stream;

public interface TailRecursive {
  public static <INPUT, INTERMEDIARY, OUTPUT> Function<INPUT, OUTPUT> new_(Function<INPUT, INTERMEDIARY> toIntermediary, UnaryOperator<INTERMEDIARY> unaryOperator, Predicate<INTERMEDIARY> predicate, Function<INTERMEDIARY, OUTPUT> toOutput) {
    return input ->
      $.new_(
        Stream.iterate(
          toIntermediary.apply(input),
          unaryOperator
        ),
        predicate,
        toOutput
      )
    ;
  }

  public static <INPUT1, INPUT2, INTERMEDIARY, OUTPUT> BiFunction<INPUT1, INPUT2, OUTPUT> new_(BiFunction<INPUT1, INPUT2, INTERMEDIARY> toIntermediary, UnaryOperator<INTERMEDIARY> unaryOperator, Predicate<INTERMEDIARY> predicate, Function<INTERMEDIARY, OUTPUT> toOutput) {
    return (input1, input2) ->
      $.new_(
        Stream.iterate(
          toIntermediary.apply(input1, input2),
          unaryOperator
        ),
        predicate,
        toOutput
      )
    ;
  }

  public enum $ {
    $$;

    private static <INTERMEDIARY, OUTPUT> OUTPUT new_(Stream<INTERMEDIARY> stream, Predicate<INTERMEDIARY> predicate, Function<INTERMEDIARY, OUTPUT> function) {
      return stream
        .filter(predicate)
        .map(function)
        .findAny()
        .orElseThrow(RuntimeException::new)
      ;
    }
  }
}
