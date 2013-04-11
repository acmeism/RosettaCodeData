import java.math.BigInteger;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

interface Function<INPUT, OUTPUT> {
  public static final List<Void> NIL = Collections.emptyList();
  public OUTPUT call(List<? extends INPUT> input);
}

class Functions {
  public static <OUTPUT> OUTPUT call(
      Function<Void, OUTPUT> f) {
    return f.call(Function.NIL);
  }

  public static <INPUT, OUTPUT> OUTPUT call(
      Function<INPUT, OUTPUT> f,
      INPUT input) {
    return f.call(Collections.singletonList(input));
  }

  public static <INPUT, OUTPUT> OUTPUT call(
      Function<INPUT, OUTPUT> f,
      INPUT... input) {
    return f.call(Arrays.asList(input));
  }

  public static <INPUT, OUTPUT> OUTPUT call(
      Function<INPUT, OUTPUT> f,
      Class<INPUT> type,
      INPUT... input) {
    List<INPUT> i = Collections.checkedList(new ArrayList<INPUT>(), type);
    i.addAll(Arrays.asList(input));
    return f.call(i);
  }

  public static <T> T input(
      List<T> input, int index) {
    return input.size() > index
        ? input.get(index)
        : null;
  }

  public static <INPUT, INPUT_OUTPUT, OUTPUT> Function<INPUT, OUTPUT> compose(
      final Function<INPUT_OUTPUT, OUTPUT> f
      , final Function<INPUT, INPUT_OUTPUT> g) {
    return new Function<INPUT, OUTPUT>() {
      @Override
      public OUTPUT call(List<? extends INPUT> input) {
        return f.call(Collections.singletonList(g.call(input)));
      }
    };
  }

  public static <INPUT, OUTPUT> Function<INPUT, OUTPUT> y(
      final Function<Function<INPUT, OUTPUT>, Function<INPUT, OUTPUT>> f) {
    return new Function<INPUT, OUTPUT>() {
      @Override
      public OUTPUT call(List<? extends INPUT> input) {
        return Functions.call(f, new Function<INPUT, OUTPUT>() {
          @Override
          public OUTPUT call(List<? extends INPUT> input) {
            return y(f).call(input);
          }
        }).call(input);
      }
    };
  }
}

public class Y {
  public static BigInteger TWO = BigInteger.ONE.add(BigInteger.ONE);

  public static void main(String[] args) {
    Function<Number, Number> fibonacci = Functions.y(
      new Function<Function<Number, Number>, Function<Number, Number>>() {
        @Override
        public Function<Number, Number> call(List<? extends Function<Number, Number>> input) {
          final Function<Number, Number> f = Functions.input(input, 0);
          return new Function<Number, Number>() {
            @Override
            public Number call(List<? extends Number> input) {
              BigInteger n = new BigInteger(Functions.input(input, 0).toString());
              if (n.compareTo(TWO) <= 0) return 1;
              return new BigInteger(Functions.call(f, n.subtract(BigInteger.ONE)).toString())
                .add(new BigInteger(Functions.call(f, n.subtract(TWO)).toString()));
            }
          };
        }
      }
    );

    Function<Number, Number> factorial = Functions.y(
      new Function<Function<Number, Number>, Function<Number, Number>>() {
        @Override
        public Function<Number, Number> call(List<? extends Function<Number, Number>> input) {
          final Function<Number, Number> f = Functions.input(input, 0);
          return new Function<Number, Number>() {
            @Override
            public Number call(List<? extends Number> input) {
              BigInteger n = new BigInteger(Functions.input(input, 0).toString());
              if (n.compareTo(BigInteger.ONE) <= 0) return 1;
              return n.multiply(
                new BigInteger(Functions.call(f, n.subtract(BigInteger.ONE)).toString())
              );
            }
          };
        }
      }
    );

    Function<Number, Number> ackermann = Functions.y(
      new Function<Function<Number, Number>, Function<Number, Number>>() {
        @Override
        public Function<Number, Number> call(List<? extends Function<Number, Number>> input) {
          final Function<Number, Number> f = Functions.input(input, 0);
          return new Function<Number, Number>() {
            @Override
            public Number call(List<? extends Number> input) {
              BigInteger m = new BigInteger(Functions.input(input, 0) + "");
              BigInteger n = new BigInteger(Functions.input(input, 1) + "");
              return m.equals(BigInteger.ZERO)
                ? n.add(BigInteger.ONE)
                 : Functions.call(f, m.subtract(BigInteger.ONE),
                   n.equals(BigInteger.ZERO)
                     ? BigInteger.ONE
                       : Functions.call(f, m, n.subtract(BigInteger.ONE)));
            }
          };
        }
      }
    );

    System.out.println("fibonacci(10) = " + Functions.call(fibonacci, 10));
    System.out.println("factorial(10) = " + Functions.call(factorial, 10));
    System.out.println("ackermann(3, 7) = " + Functions.call(ackermann, 3, 7));
  }
}
