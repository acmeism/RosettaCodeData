public class Accumulator {
    private Long sumA; // non-null if we're working in the integer domain
    private double sumB;
    public Accumulator(Number sum0) {
	if (sum0 instanceof Double) {
	    sumB = sum0.doubleValue();
	} else {
	    sumA = sum0.longValue();
	}
    }
    public Number call(Number n) {
        if (sumA != null) {
	    if (n instanceof Double) {
		sumB = n.doubleValue() + sumA;
		sumA = null;
		return sumB;
	    }
            return sumA += n.longValue();
        }
        return sumB += n.doubleValue();
    }

    public static void main(String[] args) {
        Accumulator x = new Accumulator(1);
        x.call(5);
        Accumulator y = new Accumulator(3);
        System.out.println(y+" has value "+y.call(0));
        System.out.println(x.call(2.3));
    }
}
