import java.util.ArrayList;
import java.util.BitSet;
import java.util.List;

public final class MeisselMertensConstant {
	
	public static void main(String[] aArgs) {
		List<Double> primeReciprocals = listPrimeReciprocals(1_000_000_000);
		final double euler = 0.577_215_664_901_532_861;
		double sum = 0.0;
	    for ( double reciprocal : primeReciprocals ) {
	    	sum += reciprocal + Math.log(1.0 - reciprocal);
	    }	
	
	    final double meisselMertens = euler + sum;	
	    System.out.println(String.format("%s%.9f", "The Meissel-Mertens constant = ", meisselMertens));
	}	
	
	private static List<Double> listPrimeReciprocals(int aLimit) {
		BitSet sieve = new BitSet(aLimit + 1);
		sieve.set(2, aLimit + 1);
		
		for ( int i = 2; i <= Math.sqrt(aLimit); i = sieve.nextSetBit(i + 1) ) {
			for ( int j = i * i; j <= aLimit; j += i ) {
				sieve.clear(j);
			}
		}
		
		List<Double> result = new ArrayList<Double>(sieve.cardinality());
		for ( int i = 2; i >= 0; i = sieve.nextSetBit(i + 1) ) {
			result.add(1.0 / i);
		}
		
		return result;
	}

}
