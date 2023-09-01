import java.util.ArrayList;
import java.util.List;

public final class MinkowskiQuestionMarkFunction {

	public static void main(String[] aArgs) {
		System.out.println(String.format("%20.16f%20.16f", minkowski(0.5 * ( 1 + Math.sqrt(5) )), 5.0 / 3.0));
		System.out.println(String.format("%20.16f%20.16f", minkowskiInverse(-5.0 / 9.0), ( Math.sqrt(13) - 7 ) / 6 ));
		System.out.println(String.format("%20.16f%20.16f", minkowski(minkowskiInverse(0.718281828)), 0.718281828));
		System.out.println(String.format("%20.16f%20.16f",
			minkowskiInverse(minkowski(0.1213141516271819)), 0.1213141516171819));
	}
	
	private static double minkowski(double aX) {
	    if ( aX < 0 || aX > 1 ) {
	        return Math.floor(aX) + minkowski(aX - Math.floor(aX));
	    }
	
	    long p = (long) aX;
	    long q = 1;
	    long r = p + 1;
	    long s = 1;
	    double d = 1.0;
	    double y = (double) p;
	
	    while ( true ) {
	        d /= 2;
	        if ( d == 0.0 ) {
	            break;
	        }
	
	        long m = p + r;
	        if ( m < 0 || p < 0 ) {
	            break;
	        }
	
	        long n = q + s;
	        if ( n < 0 ) {
	            break;
	        }
	
	        if ( aX < (double) m / n ) {
	            r = m;
	            s = n;
	        } else {
	            y += d;
	            p = m;
	            q = n;
	        }
	    }	
	    return y + d;
	}
	
	private static double minkowskiInverse(double aX) {
	    if ( aX < 0 || aX > 1 ) {
	        return Math.floor(aX) + minkowskiInverse(aX - Math.floor(aX));
	    }
	
	    if ( aX == 0 || aX == 1 ) {
	        return aX;
	    }
	
	    List<Integer> continuedFraction = new ArrayList<Integer>();
	    continuedFraction.add(0);
	    int current = 0;
	    int count = 1;
	    int i = 0;
	
	    while ( true ) {
	        aX *= 2;
	        if ( current == 0 ) {
	            if ( aX < 1 ) {
	                count += 1;
	            } else {
	            	 continuedFraction.add(0);
	                 continuedFraction.set(i, count);

	                 i += 1;
	                 count = 1;
	                 current = 1;
	                 aX -= 1;
	            }
	        } else {
	        	 if ( aX > 1 ) {
	                 count += 1;
	                 aX -= 1;
	        	 } else {
	                 continuedFraction.add(0);
	                 continuedFraction.set(i, count);

	                 i += 1;
	                 count = 1;
	                 current = 0;
	        	 }
	        }

	        if ( aX == Math.floor(aX) ) {
	             continuedFraction.set(i, count);
	             break;
	        }

	        if ( i == MAX_ITERATIONS ) {
	             break;
	        }
	    }

	    double reciprocal = 1.0 / continuedFraction.get(i);
	    for ( int j = i - 1; j >= 0; j-- ) {
	         reciprocal = continuedFraction.get(j) + 1.0 / reciprocal;
	    }

	    return 1.0 / reciprocal;	
	}
	
	private static final int MAX_ITERATIONS = 150;

}
