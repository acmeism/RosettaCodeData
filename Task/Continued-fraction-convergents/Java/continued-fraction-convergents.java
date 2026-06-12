import java.util.ArrayList;
import java.util.List;

public final class ContinuedFractionConvergents {

	public static void main(String[] args) {
		record Test(String description, double value) {}
		
		List<Test> tests = List.of( new Test("415/93", (double) 415/93),
				                    new Test("649/200", (double) 649/200),
				                    new Test("Square root of 2", Math.sqrt(2)),
				                    new Test("Square root of 5", Math.sqrt(5)),
				                    new Test("Golden ratio", ( Math.sqrt(5) + 1.0 ) / 2.0) );
		
		System.out.println("The continued fraction convergents for the following (maximum 8 terms) are:");
		tests.forEach( test -> {
			System.out.println(String.format("%20s%s%s", test.description, " => ", convergents(test.value, 8)));
		} );
	}
	
	private static List<String> convergents(double x, int size) {	
	    List<Integer> components = new ArrayList<Integer>();
	    double fractionPart = 1.0;
	    for ( int i = 0; i < size && fractionPart >= 0.000_000_001; i++ ) {
	    	int intPart = (int) x;
	    	fractionPart = x - intPart;
	        components.addLast(intPart);
	        x = 1.0 / fractionPart;	
	    }
	
	    List<String> result = new ArrayList<String>(size);
	    Fraction a = new Fraction(0, 1);
	    Fraction b = new Fraction(1, 0);
	    for ( int component : components ) {
		    Fraction aCopy = new Fraction(a.numer, a.denom);
		    a = new Fraction(b.numer, b.denom);
		    b = new Fraction(aCopy.numer + component * b.numer, aCopy.denom + component * b.denom);
		    result.addLast(b.numer + "/" + b.denom);
	    }
	    return result;
	}
	
	private static record Fraction(int numer, int denom) {}

}
