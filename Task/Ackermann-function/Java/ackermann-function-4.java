import java.math.BigInteger;
import java.util.Stack;
import java.util.function.BinaryOperator;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public interface Ackermann {
  public static Ackermann new_(BigInteger number1, BigInteger number2, Stack<BigInteger> stack, boolean flag) {
    return $.new_(number1, number2, stack, flag);
  }
  public static void main(String... arguments) {
    $.main(arguments);
  }
  public BigInteger number1();
  public BigInteger number2();

  public Stack<BigInteger> stack();

  public boolean flag();

  public enum $ {
    $$;

    private static final BigInteger ZERO = BigInteger.ZERO;
    private static final BigInteger ONE = BigInteger.ONE;
    private static final BigInteger TWO = BigInteger.valueOf(2);
    private static final BigInteger THREE = BigInteger.valueOf(3);
    private static final BigInteger FOUR = BigInteger.valueOf(4);

    private static Ackermann new_(BigInteger number1, BigInteger number2, Stack<BigInteger> stack, boolean flag) {
      return (FunctionalAckermann) field -> {
        switch (field) {
          case number1: return number1;
          case number2: return number2;
          case stack: return stack;
          case flag: return flag;
          default: throw new UnsupportedOperationException(
            field instanceof Field
              ? "Field checker has not been updated properly."
              : "Field is not of the correct type."
          );
        }
      };
    }

    private static final BinaryOperator<BigInteger> ACKERMANN =
      TailRecursive.new_(
        (BigInteger number1, BigInteger number2) ->
          new_(
            number1,
            number2,
            Stream.of(number1).collect(
              Collectors.toCollection(Stack::new)
            ),
            false
          )
        ,
        ackermann -> {
          BigInteger number1 = ackermann.number1();
          BigInteger number2 = ackermann.number2();
          Stack<BigInteger> stack = ackermann.stack();
          if (!stack.empty() && !ackermann.flag()) {
            number1 = stack.pop();
          }
          switch (number1.intValue()) {
            case 0:
              return new_(
                number1,
                number2.add(ONE),
                stack,
                false
              );
            case 1:
              return new_(
                number1,
                number2.add(TWO),
                stack,
                false
              );
            case 2:
              return new_(
                number1,
                number2.multiply(TWO).add(THREE),
                stack,
                false
              );
            default:
              if (ZERO.equals(number2)) {
                return new_(
                  number1.subtract(ONE),
                  ONE,
                  stack,
                  true
                );
              } else {
                stack.push(number1.subtract(ONE));
                return new_(
                  number1,
                  number2.subtract(ONE),
                  stack,
                  true
                );
              }
          }
        },
        ackermann -> ackermann.stack().empty(),
        Ackermann::number2
      )::apply
    ;

    private static void main(String... arguments) {
      System.out.println(ACKERMANN.apply(FOUR, TWO));
    }

    private enum Field {
      number1,
      number2,
      stack,
      flag
    }

    @FunctionalInterface
    private interface FunctionalAckermann extends FunctionalField<Field>, Ackermann {
      @Override
      public default BigInteger number1() {
        return field(Field.number1);
      }

      @Override
      public default BigInteger number2() {
        return field(Field.number2);
      }

      @Override
      public default Stack<BigInteger> stack() {
        return field(Field.stack);
      }

      @Override
      public default boolean flag() {
        return field(Field.flag);
      }
    }
  }
}
