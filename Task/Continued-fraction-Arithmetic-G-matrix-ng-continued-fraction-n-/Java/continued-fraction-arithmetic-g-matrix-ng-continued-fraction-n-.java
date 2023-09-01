import java.util.List;

public final class ContinuedFractionArithmeticG1 {

	public static void main(String[] aArgs) {
		List<CFData> cfData = List.of(
	        new CFData("[1; 5, 2] + 1 / 2    ", new int[] { 2, 1, 0, 2 }, (CFIterator) new R2cfIterator(13, 11) ),
	        new CFData("[3; 7] + 1 / 2       ", new int[] { 2, 1, 0, 2 }, (CFIterator) new R2cfIterator(22, 7) ),
	        new CFData("[3; 7] divided by 4  ", new int[] { 1, 0, 0, 4 }, (CFIterator) new R2cfIterator(22, 7) ),
	        new CFData("sqrt(2)              ", new int[] { 0, 1, 1, 0 }, (CFIterator) new ReciprocalRoot2() ),
	        new CFData("1 / sqrt(2)          ", new int[] { 0, 1, 1, 0 }, (CFIterator) new Root2() ),
	        new CFData("(1 + sqrt(2)) / 2    ", new int[] { 1, 1, 0, 2 }, (CFIterator) new Root2() ),
	        new CFData("(1 + 1 / sqrt(2)) / 2", new int[] { 1, 1, 0, 2 }, (CFIterator) new ReciprocalRoot2() ) );
		
		for ( CFData data : cfData ) {
            System.out.print(data.text + " -> ");
			NG ng = new NG(data.arguments);
			CFIterator iterator = data.iterator;			
			int nextTerm = 0;
			
			for ( int i = 1; i <= 20 && iterator.hasNext(); i++ ) {			
				nextTerm = iterator.next();					
		        if ( ! ng.needsTerm() ) {
		        	System.out.print(ng.egress() + " ");
		        }
		        ng.ingress(nextTerm);
	        }
			
			while ( ! ng.done() ) {
	            System.out.print(ng.egressDone() + " ");
	        }
	        System.out.println();
		}

	}
	
	private static class NG {
		
		public NG(int[] aArgs) {
			a1 = aArgs[0]; a = aArgs[1]; b1 = aArgs[2]; b = aArgs[3];
		}

	    public void ingress(int aN) {
	        int temp = a; a = a1; a1 = temp + a1 * aN;
	            temp = b; b = b1; b1 = temp + b1 * aN;
	    }

	    public int egress() {
	        final int n = a / b;
	        int temp = a;  a  = b;  b  = temp - b * n;
	            temp = a1; a1 = b1; b1 = temp - b1 * n;
	        return n;
	    }

	    public boolean needsTerm() {
	    	return ( b == 0 || b1 == 0 ) || ( a * b1 != a1 * b );
	    }
	
	    public int egressDone() {	
            if ( needsTerm() ) {
                a = a1;
                b = b1;
            }
            return egress();
	    }
	
	    public boolean done() {
	    	return ( b == 0 || b1 == 0 );
	    }
	    		
	    private int a1, a, b1, b;
	}

	private static abstract class CFIterator {
		
		public abstract boolean hasNext();
		public abstract int next();
		
	}	
	
	private static class R2cfIterator extends CFIterator {
		
		public R2cfIterator(int aNumerator, int aDenominator) {
			numerator = aNumerator; denominator = aDenominator;
		}
		
		public boolean hasNext() {
			return denominator != 0;
		}
		
		public int next() {
			int div = numerator / denominator;
            int rem = numerator % denominator;
            numerator = denominator;
            denominator = rem;
            return div;
		}
		
		private int numerator, denominator;
		
	}

	private static class Root2 extends CFIterator {
		
		public Root2() {
			firstReturn = true;
		}
		
		public boolean hasNext() {
			return true;
		}
		
		public int next() {
			if ( firstReturn ) {
				firstReturn = false;
				return 1;
			}
			return 2;
		}
		
		private boolean firstReturn;
		
	}
	
	private static class ReciprocalRoot2 extends CFIterator {
		
		public ReciprocalRoot2() {
			firstReturn = true;
			secondReturn = true;
		}
		
		public boolean hasNext() {
			return true;
		}
		
		public int next() {
			if ( firstReturn ) {
				firstReturn = false;
				return 0;
			}
			if ( secondReturn ) {
				secondReturn = false;
				return 1;
			}
			return 2;
		}
		
		private boolean firstReturn, secondReturn;
		
	}
	
	private static record CFData(String text, int[] arguments, CFIterator iterator) {}
	
}
