import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;
import java.util.function.UnaryOperator;
import java.util.stream.Collectors;
import java.util.stream.LongStream;

@FunctionalInterface
public interface Y<FUNCTION> extends SelfApplicable<FixedPoint<FUNCTION>> {
  public static void main(String... arguments) {
    BigInteger TWO = BigInteger.ONE.add(BigInteger.ONE);

    Function<Number, Long> toLong = Number::longValue;
    Function<Number, BigInteger> toBigInteger = toLong.andThen(BigInteger::valueOf);

    /* Based on https://gist.github.com/aruld/3965968/#comment-604392 */
    Y<VarargsFunction<Number, Number>> combinator = y -> f -> x -> f.apply(y.selfApply().apply(f)).apply(x);
    FixedPoint<VarargsFunction<Number, Number>> fixedPoint = combinator.selfApply();

    VarargsFunction<Number, Number> fibonacci = fixedPoint.apply(
      f -> VarargsFunction.upgrade(
        toBigInteger.andThen(
          n -> (n.compareTo(TWO) <= 0)
            ? 1
            : new BigInteger(f.apply(n.subtract(BigInteger.ONE)).toString())
              .add(new BigInteger(f.apply(n.subtract(TWO)).toString()))
        )
      )
    );

    VarargsFunction<Number, Number> factorial = fixedPoint.apply(
      f -> VarargsFunction.upgrade(
        toBigInteger.andThen(
          n -> (n.compareTo(BigInteger.ONE) <= 0)
            ? 1
            : n.multiply(new BigInteger(f.apply(n.subtract(BigInteger.ONE)).toString()))
        )
      )
    );

    VarargsFunction<Number, Number> ackermann = fixedPoint.apply(
      f -> VarargsFunction.upgrade(
        (BigInteger m, BigInteger n) -> m.equals(BigInteger.ZERO)
          ? n.add(BigInteger.ONE)
          : f.apply(
              m.subtract(BigInteger.ONE),
              n.equals(BigInteger.ZERO)
                ? BigInteger.ONE
                  : f.apply(m, n.subtract(BigInteger.ONE))
            )
      ).transformArguments(toBigInteger)
    );

    Map<String, VarargsFunction<Number, Number>> functions = new HashMap<>();
    functions.put("fibonacci", fibonacci);
    functions.put("factorial", factorial);
    functions.put("ackermann", ackermann);

    Map<VarargsFunction<Number, Number>, Number[]> parameters = new HashMap<>();
    parameters.put(functions.get("fibonacci"), new Number[]{20});
    parameters.put(functions.get("factorial"), new Number[]{10});
    parameters.put(functions.get("ackermann"), new Number[]{3, 2});

    functions.entrySet().stream().parallel().map(
      entry -> entry.getKey()
        + Arrays.toString(parameters.get(entry.getValue()))
        + " = "
        + entry.getValue().apply(parameters.get(entry.getValue()))
    ).forEach(System.out::println);
  }
}
