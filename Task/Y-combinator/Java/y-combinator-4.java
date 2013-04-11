import java.math.BigInteger;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.function.BiFunction;
import java.util.stream.Collectors;

@FunctionalInterface
interface VarargFunction<INPUT, OUTPUT> {
  public OUTPUT apply(List<? extends INPUT> input);

  public default OUTPUT apply() {
    return apply(Collections.emptyList());
  }

  public default OUTPUT apply(INPUT input) {
    return apply(Collections.singletonList(input));
  }

  public default OUTPUT apply(INPUT input, INPUT input2) {
    return apply(Arrays.asList(input, input2));
  }

  public default OUTPUT apply(INPUT input, INPUT input2, INPUT input3) {
    return apply(Arrays.asList(input, input2, input3));
  }

  public default OUTPUT apply(Class<INPUT> type, Object... input) {
    List<INPUT> i = Collections.checkedList(new ArrayList<>(), type);
    for (Object object : input) {
      i.add(type.cast(object));
    }
    return apply(i);
  }

  public default <POST_OUTPUT> VarargFunction<INPUT, POST_OUTPUT> compose(
      VarargFunction<OUTPUT, POST_OUTPUT> after) {
    return input -> after.apply(apply(input));
  }

  public default Function<INPUT, OUTPUT> toFunction() {
    return input -> apply(input);
  }

  public default BiFunction<INPUT, INPUT, OUTPUT> toBiFunction() {
    return (input, input2) -> apply(input, input2);
  }

  public default <PRE_INPUT> VarargFunction<PRE_INPUT, OUTPUT> transformArguments(Function<PRE_INPUT, INPUT> transformer) {
    return input -> apply(input.parallelStream().map(transformer).collect(Collectors.toList()));
  }
}

@FunctionalInterface
interface SelfApplicable<OUTPUT> {
  OUTPUT apply(SelfApplicable<OUTPUT> input);
}

class Utils {
  public static <T> T input( List<T> input, int index) {
    return input.size() > index ? input.get(index) : null;
  }

  /* Based on https://gist.github.com/aruld/3965968/#comment-604392 */

  public static <INPUT, OUTPUT> SelfApplicable<Function<Function<Function<INPUT, OUTPUT>, Function<INPUT, OUTPUT>>, Function<INPUT, OUTPUT>>> y(Class<INPUT> input, Class<OUTPUT> output) {
    return y -> f -> x -> f.apply(y.apply(y).apply(f)).apply(x);
  }

  public static <INPUT, OUTPUT> Function<Function<Function<INPUT, OUTPUT>, Function<INPUT, OUTPUT>>, Function<INPUT, OUTPUT>> fix(Class<INPUT> input, Class<OUTPUT> output) {
    return y(input, output).apply(y(input, output));
  }

  public static <INPUT, OUTPUT> SelfApplicable<Function<Function<VarargFunction<INPUT, OUTPUT>, VarargFunction<INPUT, OUTPUT>>, VarargFunction<INPUT, OUTPUT>>> yVararg(Class<INPUT> input, Class<OUTPUT> output) {
    return y -> f -> x -> f.apply(y.apply(y).apply(f)).apply(x);
  }

  public static <INPUT, OUTPUT> Function<Function<VarargFunction<INPUT, OUTPUT>, VarargFunction<INPUT, OUTPUT>>, VarargFunction<INPUT, OUTPUT>> fixVararg(Class<INPUT> input, Class<OUTPUT> output) {
    return yVararg(input, output).apply(yVararg(input, output));
  }

  public static <INPUT, OUTPUT> VarargFunction<INPUT, OUTPUT> toVarargFunction(Function<INPUT, OUTPUT> function) {
    return input -> function.apply(Utils.input(input, 0));
  }

  public static <INPUT, OUTPUT> VarargFunction<INPUT, OUTPUT> toVarargFunction(BiFunction<INPUT, INPUT, OUTPUT> function) {
    return input -> function.apply(Utils.input(input, 0), Utils.input(input, 1));
  }
}

public class Y {
  public static final BigInteger TWO = BigInteger.ONE.add(BigInteger.ONE);

  public static final Function<Number, BigInteger> toBigInteger = ((Function<Number, Long>) Number::longValue).compose(BigInteger::valueOf);

  public static void main(String[] args) {
    VarargFunction<Number, Number> fibonacci = Utils.fixVararg(Number.class, Number.class).apply(
      f -> Utils.toVarargFunction(
        toBigInteger.compose(
          n -> (n.compareTo(TWO) <= 0) ? 1
            : new BigInteger(f.apply(n.subtract(BigInteger.ONE)).toString())
              .add(new BigInteger(f.apply(n.subtract(TWO)).toString()))
        )
      )
    );

    VarargFunction<Number, Number> factorial = Utils.fixVararg(Number.class, Number.class).apply(
      f -> Utils.toVarargFunction(
        toBigInteger.compose(
          n -> (n.compareTo(BigInteger.ONE) <= 0) ? 1
          : n.multiply(new BigInteger(f.apply(n.subtract(BigInteger.ONE)).toString()))
        )
      )
    );

    VarargFunction<Number, Number> ackermann = Utils.fixVararg(Number.class, Number.class).apply(
      f -> Utils.toVarargFunction(
        (BigInteger m, BigInteger n) -> m.equals(BigInteger.ZERO) ? n.add(BigInteger.ONE)
          : f.apply(m.subtract(BigInteger.ONE),
            n.equals(BigInteger.ZERO)
              ? BigInteger.ONE
                : f.apply(m, n.subtract(BigInteger.ONE)))
      ).transformArguments(toBigInteger)
    );

    Map<String, VarargFunction<Number, Number>> functions = new HashMap<>();
    functions.put("fibonacci", fibonacci);
    functions.put("factorial", factorial);
    functions.put("ackermann", ackermann);

    Map<VarargFunction<Number, Number>, List<Number>> arguments = new HashMap<>();
    arguments.put(functions.get("fibonacci"), Arrays.asList(20));
    arguments.put(functions.get("factorial"), Arrays.asList(10));
    arguments.put(functions.get("ackermann"), Arrays.asList(3, 2));

    functions.entrySet().parallelStream().map(
      entry ->
        entry.getKey() + arguments.get(entry.getValue()) + " = "
          + entry.getValue().apply(arguments.get(entry.getValue()))
    ).forEach(System.out::println);
  }
}
