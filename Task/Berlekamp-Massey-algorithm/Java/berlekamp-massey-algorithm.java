import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class BerlekampMasseyTask {

	public static void main(String[] args) {
		List<Integer> source = List.of( 0, 1, 1, 2, 3, 5, 8, 13, 21 );
		BerlekampMassey bm = new BerlekampMassey(source, 100);
		List<Integer> bmCoeffs = bm.computeCoefficients();
		System.out.println("Berekamp-Massey coefficients: " + bmCoeffs + " (lowest to highest degree)");
		System.out.println("The connection polynomial is " + bm.polynomial(bmCoeffs)
			+ " having degree " + ( bmCoeffs.size() - 1 ) + System.lineSeparator());
		
		System.out.println("Terms indexed 35 to 40 from the Fibonacci sequence modulo 100:");
		// Result can be checked on www.oeis.net, A000045
		List.of( 35, 36, 37, 38, 39, 40 ).forEach( n -> System.out.print(bm.computeTerm(bmCoeffs, n) + " ") );		
	}	
	
}

final class BerlekampMassey {
	
	public BerlekampMassey(List<Integer> aSource, int aModulus) {
		source = new ArrayList<Integer>(aSource);
		modulus = aModulus;
	}
	
	public List<Integer> computeCoefficients() {
	    List<Integer> result = new ArrayList<Integer>();
	    List<Integer> previousResult = new ArrayList<Integer>();
	    int failIndex = -1;
	    for ( int i = 0; i < source.size(); i++ ) {
	    	int delta = source.get(i);
	        for ( int j = 1; j <= result.size(); j++ ) {
	            delta -= result.get(j - 1) * source.get(i - j);
	        }
	        if ( delta == 0 ) {
	            continue;
	        }
	        if ( failIndex == -1 ) {
	        	result = new ArrayList<Integer>(Collections.nCopies(i + 1, 0));
	            failIndex = i;
	        } else {
	        	List<Integer> previousResultCopy = new ArrayList<Integer>();
	        	previousResultCopy.addLast(1);
	        	for ( int term : previousResult ) {
	        		previousResultCopy.addLast(-term);
	        	}	
	            int termFailIndexPusOne = 0;
	            for ( int j = 1; j <= previousResultCopy.size(); j++ ) {
	                termFailIndexPusOne += previousResultCopy.get(j - 1) * source.get(failIndex + 1 - j);
	            }
	            final int coeff = delta / termFailIndexPusOne;
	            for ( int k = 0; k < previousResultCopy.size(); k++ ) {
	            	previousResultCopy.set(k, previousResultCopy.get(k) * coeff);
	            }	
	            for ( int k = 0; k < i - failIndex - 1; k++ ) {
	            	previousResultCopy.addFirst(0);
	            }
	            List<Integer> resultCopy = new ArrayList<Integer>(result);
	            while ( result.size() < previousResultCopy.size() ) {
	            	result.addLast(0);
	            }	
	            for ( int j = 0; j < previousResultCopy.size(); j++ ) {
	            	result.set(j, result.get(j) + previousResultCopy.get(j));
	            }
	            if ( i - resultCopy.size() > failIndex - previousResult.size() ) {
	                previousResult = new ArrayList<Integer>(resultCopy);
	                failIndex = i;
	            }
	        }
	    }
	    return result;
	}
	
	public int computeTerm(List<Integer> bmCoeffs, int index) {
		if ( bmCoeffs.isEmpty() ) {
		    return 0;
		}	
	    if ( index < source.size() ) {
	        return ( source.get(index) + modulus ) % modulus;
	    }	
	    List<Integer> coeffs = new ArrayList<Integer>();
	    coeffs.addLast(modulus - 1);
	    coeffs.addAll(bmCoeffs);
	    final int bmCoeffsSize = bmCoeffs.size();
		List<Integer> f = new ArrayList<Integer>(Collections.nCopies(bmCoeffsSize, 0));
		List<Integer> g = new ArrayList<Integer>(Collections.nCopies(bmCoeffsSize, 0));
	    f.set(0, 1); 	
        if ( bmCoeffsSize == 1 ) {
            g.set(0, coeffs.get(1));
        } else {
            g.set(1, 1);
        }
	    int power = index - 1;
	    while ( power > 0 ) {
	        if ( ( power & 1 ) == 1 ) {
	            f = polynomialMultiply(f, g, bmCoeffsSize, coeffs);
	        }
	        g = polynomialMultiply(g, g, bmCoeffsSize, coeffs);
	        power >>= 1;
	    }
	    int result = 0;
	    for ( int i = 0; i < bmCoeffsSize; i++ ) {
	        if ( i + 1 < source.size() ) {
	            result = ( result + source.get(i + 1) * f.get(i) ) % modulus;
	        }
	    }
	    return ( result + modulus ) % modulus;
	}
	
	public String polynomial(List<Integer> bmCoeffs) {
		final int degree = bmCoeffs.size() - 1;
        if ( degree == 0 ) {
        	return String.valueOf(bmCoeffs.getFirst());
        }

        StringBuilder text = new StringBuilder();
        for ( int i = degree; i >= 0; i-- ) {
        	final int coeff = bmCoeffs.get(i);
        	if ( coeff == 0 ) {
        		continue;
        	}
        	String sign = ( coeff < 0 && i == degree ) ?
        		"-" : ( coeff < 0 ) ? " - " : ( i < degree ) ? " + " : "";
        	text.append(sign);
        	final int coeffAbs = Math.abs(coeff);
        	if ( coeffAbs > 1 ) {
        		text.append(coeffAbs);
        	}
        	String term = ( i > 1 ) ? "x^" + String.valueOf(i) : ( i == 1 ) ?
        		"x" : ( coeffAbs == 1 ) ? "1" : "";
        	text.append(term);
        }
        return text.toString();
    }
	
	private List<Integer> polynomialMultiply(List<Integer> a, List<Integer> b, int degree, List<Integer> coeffs) {
        List<Integer> result = new ArrayList<Integer>(Collections.nCopies(2 * degree, 0));
        for ( int i = 0; i < degree; i++ ) {
            if ( a.get(i) == 0 ) {
            	continue;
            }
            for ( int j = 0; j < degree; j++ ) {
                result.set(i + j, ( result.get(i + j) + a.get(i) * b.get(j) ) % modulus);
            }
        }
        for ( int i = 2 * degree - 1; i > degree - 1; i-- ) {
            if ( result.get(i) == 0 ) {
            	continue;
            }
            final int term = result.get(i);
            result.set(i, 0);
            for ( int j = 0; j <= degree; j++ ) {
                final int index = i - j;
                if ( index >= 0 ) {
                    result.set(index, ( result.get(index) + term * coeffs.get(j) ) % modulus);
                }
            }
        }
        return result.subList(0, degree);
	}
	
	private final List<Integer> source;	
	private final int modulus;
	
}
