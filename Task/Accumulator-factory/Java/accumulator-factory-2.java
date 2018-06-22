import java.util.function.UnaryOperator;

public class AccumulatorFactory {

    public static UnaryOperator<Number> accumulator(Number sum0) {
	// Allows sum[0] = ... inside lambda.
	Number[] sum = { sum0 };

	// Acts like n -> sum[0] += n, but chooses long or double.
	// Converts weird types (like BigInteger) to double.
	return n -> (longable(sum[0]) && longable(n)) ?
	    (sum[0] = sum[0].longValue() + n.longValue()) :
	    (sum[0] = sum[0].doubleValue() + n.doubleValue());
    }

    private static boolean longable(Number n) {
	return n instanceof Byte || n instanceof Short ||
	    n instanceof Integer || n instanceof Long;
    }

    public static void main(String[] args) {
	UnaryOperator<Number> x = accumulator(1);
	x.apply(5);
	accumulator(3);
	System.out.println(x.apply(2.3));
    }
}
