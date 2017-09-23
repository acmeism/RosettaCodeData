import java.util.function.DoubleUnaryOperator;

public interface AccumulatorFactory {
  public static DoubleUnaryOperator accumulator(double element) {
    double[] sum = { element };
    return value -> sum[0] += value;
  }

  public static void main(String... arguments) {
    DoubleUnaryOperator x = accumulator(1.0);
    x.applyAsDouble(5.0);
    System.out.println(accumulator(3.0));
    System.out.println(x.applyAsDouble(2.3));
  }
}
