public class Accumulator
    //implements java.util.function.UnaryOperator<Number> // Java 8
{
    private Number sum;

    public Accumulator(Number sum0) {
	sum = sum0;
    }

    public Number apply(Number n) {
	// Acts like sum += n, but chooses long or double.
	// Converts weird types (like BigInteger) to double.
	return (longable(sum) && longable(n)) ?
	    (sum = sum.longValue() + n.longValue()) :
	    (sum = sum.doubleValue() + n.doubleValue());
    }

    private static boolean longable(Number n) {
	return n instanceof Byte || n instanceof Short ||
	    n instanceof Integer || n instanceof Long;
    }

    public static void main(String[] args) {
	Accumulator x = new Accumulator(1);
	x.apply(5);
	new Accumulator(3);
	System.out.println(x.apply(2.3));
    }
}
