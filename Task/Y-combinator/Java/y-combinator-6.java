import java.util.Arrays;
import java.util.Optional;
import java.util.function.Function;
import java.util.function.BiFunction;

@FunctionalInterface
public interface VarargsFunction<INPUTS, OUTPUT> extends Function<INPUTS[], OUTPUT> {
  @SuppressWarnings("unchecked")
  public OUTPUT apply(INPUTS... inputs);

  public static <INPUTS, OUTPUT> VarargsFunction<INPUTS, OUTPUT> from(Function<INPUTS[], OUTPUT> function) {
    return function::apply;
  }

  public static <INPUTS, OUTPUT> VarargsFunction<INPUTS, OUTPUT> upgrade(Function<INPUTS, OUTPUT> function) {
    return inputs -> function.apply(inputs[0]);
  }

  public static <INPUTS, OUTPUT> VarargsFunction<INPUTS, OUTPUT> upgrade(BiFunction<INPUTS, INPUTS, OUTPUT> function) {
    return inputs -> function.apply(inputs[0], inputs[1]);
  }

  @SuppressWarnings("unchecked")
  public default <POST_OUTPUT> VarargsFunction<INPUTS, POST_OUTPUT> andThen(
      VarargsFunction<OUTPUT, POST_OUTPUT> after) {
    return inputs -> after.apply(apply(inputs));
  }

  @SuppressWarnings("unchecked")
  public default Function<INPUTS, OUTPUT> toFunction() {
    return input -> apply(input);
  }

  @SuppressWarnings("unchecked")
  public default BiFunction<INPUTS, INPUTS, OUTPUT> toBiFunction() {
    return (input, input2) -> apply(input, input2);
  }

  @SuppressWarnings("unchecked")
  public default <PRE_INPUTS> VarargsFunction<PRE_INPUTS, OUTPUT> transformArguments(Function<PRE_INPUTS, INPUTS> transformer) {
    return inputs -> apply((INPUTS[]) Arrays.stream(inputs).parallel().map(transformer).toArray());
  }
}
