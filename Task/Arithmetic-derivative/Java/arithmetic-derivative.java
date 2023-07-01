import java.math.BigInteger;

public final class ArithmeticDerivative {

	public static void main(String[] aArgs) {
        System.out.println("Arithmetic derivatives for -99 to 100 inclusive:");
		for ( int n = -99, column = 0; n <= 100; n++ ) {
			System.out.print(String.format("%4d%s",
				derivative(BigInteger.valueOf(n)), ( ++column % 10 == 0 ) ? "\n" : " "));
		}
		System.out.println();
		
		final BigInteger seven = BigInteger.valueOf(7);
		for ( int power = 1; power <= 20; power++ ) {
			System.out.println(String.format("%s%2d%s%d",
				"D(10^", power, ") / 7 = ", derivative(BigInteger.TEN.pow(power)).divide(seven)));
		}
	}
	
	private static BigInteger derivative(BigInteger aNumber) {
		if ( aNumber.signum() == -1 ) {
			return derivative(aNumber.negate()).negate();
		}
		if ( aNumber == BigInteger.ZERO || aNumber == BigInteger.ONE ) {
			return BigInteger.ZERO;
		}
		BigInteger divisor = BigInteger.TWO;
		while ( divisor.multiply(divisor).compareTo(aNumber) <= 0 ) {
		    if ( aNumber.mod(divisor).signum() == 0 ) {
		        final BigInteger quotient = aNumber.divide(divisor);
		        return quotient.multiply(derivative(divisor)).add(divisor.multiply(derivative(quotient)));
		    }
		    divisor = divisor.add(BigInteger.ONE);
		}
		return BigInteger.ONE;
	}

}
