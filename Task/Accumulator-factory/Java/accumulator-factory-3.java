import java.util.function.DoubleUnaryOperator;

public interface AccumulatorFactory {
  public static DoubleUnaryOperator accumulator(double element) {
    double[] sum = new double[] { element };
    return value -> sum[0] += value;
  }

  public static void main(String... arguments) {
    DoubleUnaryOperator x = accumulator(1d);
    x.applyAsDouble(5d);
    System.out.println(accumulator(3d));		
    System.out.println(x.applyAsDouble(2.3));
  }
}
