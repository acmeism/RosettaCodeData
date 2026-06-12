import java.util.ArrayList;
import java.util.List;

public final class ContinuedFractionArithmeticG2 {

	public static void main(String[] aArgs) {	
	    test("[3; 7] + [0; 2]", new NG( new NG8(0, 1, 1, 0, 0, 0, 0, 1), new R2cf(1, 2), new R2cf(22, 7) ),
	    		                new NG( new NG4(2, 1, 0, 2), new R2cf(22, 7) ));
	
	    test("[1; 5, 2] * [3; 7]", new NG( new NG8(1, 0, 0, 0, 0, 0, 0, 1), new R2cf(13, 11), new R2cf(22, 7) ),
	    		                   new R2cf(286, 77) );
	
	    test("[1; 5, 2] - [3; 7]", new NG( new NG8(0, 1, -1, 0, 0, 0, 0, 1), new R2cf(13, 11), new R2cf(22, 7) ),
	    					       new R2cf(-151, 77) );
	
	    test("Divide [] by [3; 7]",
	    	new NG( new NG8(0, 1, 0, 0, 0, 0, 1, 0), new R2cf(22 * 22, 7 * 7), new R2cf(22,7)) );
	
	    test("([0; 3, 2] + [1; 5, 2]) * ([0; 3, 2] - [1; 5, 2])",
	    	new NG( new NG8(1, 0, 0, 0, 0, 0, 0, 1),
	    			new NG( new NG8(0, 1, 1, 0, 0, 0, 0, 1),
	    					new R2cf(2, 7), new R2cf(13, 11)),
	    						new NG( new NG8(0, 1, -1, 0, 0, 0, 0, 1), new R2cf(2, 7), new R2cf(13, 11) ) ),
	    	new R2cf(-7797, 5929) );
	}
	
	private static void test(String aDescription, ContinuedFraction... aFractions) {
	    System.out.println("Testing: " + aDescription);
	    for ( ContinuedFraction fraction : aFractions ) {
	        while ( fraction.hasMoreTerms() ) {
	        	System.out.print(fraction.nextTerm() + " ");
	        }
	        System.out.println();
	    }
	    System.out.println();
	}
	
	private static abstract class MatrixNG {
		
	    protected abstract void consumeTerm();
	    protected abstract void consumeTerm(int aN);
	    protected abstract boolean needsTerm();
	
	    protected int configuration = 0;
	    protected int currentTerm = 0;
	    protected boolean hasTerm = false;
	
	}
	
	private static class NG4 extends MatrixNG {
		
		public NG4(int aA1, int aA, int aB1, int aB) {
			a1 = aA1; a = aA; b1 = aB1; b = aB;
		}
		
		public void consumeTerm() {
			a = a1;
		    b = b1;
		}

		public void consumeTerm(int aN) {
		    int temp = a; a = a1; a1 = temp + a1 * aN;
		        temp = b; b = b1; b1 = temp + b1 * aN;
		}	
		
		public boolean needsTerm() {
	        if ( b1 == 0 && b == 0 ) {
	        	return false;
	        }
	        if ( b1 == 0 || b == 0 ) {
	        	return true;
	        }
	
	        currentTerm = a / b;
	        if ( currentTerm ==  a1 / b1 ) {
	            int temp = a;  a  = b;  b  = temp - b  * currentTerm;
	                temp = a1; a1 = b1; b1 = temp - b1 * currentTerm;

	            hasTerm = true;
	            return false;
	        }
	        return true;
	    }
		
		private int a1, a, b1, b;
		
	}
	
	private static class NG8 extends MatrixNG {
		
		public NG8(int aA12, int aA1, int aA2, int aA, int aB12, int aB1, int aB2, int aB) {
			a12 = aA12; a1 = aA1; a2 = aA2; a = aA; b12 = aB12; b1 = aB1; b2 = aB2; b = aB;			
		}
	
	    public void consumeTerm() {
	        if ( configuration == 0 ) {
	            a = a1; a2 = a12;
	            b = b1; b2 = b12;
	        } else {
	            a = a2; a1 = a12;
	            b = b2; b1 = b12;
	        }
	    }

	    public void consumeTerm(int aN) {
	        if ( configuration == 0 ) {
	            int temp = a;  a  = a1;  a1  = temp + a1  * aN;
	                temp = a2; a2 = a12; a12 = temp + a12 * aN;
	                temp = b;  b  = b1;  b1  = temp + b1  * aN;
	                temp = b2; b2 = b12; b12 = temp + b12 * aN;
	        } else {
	            int temp = a;  a  = a2;  a2  = temp + a2  * aN;
	                temp = a1; a1 = a12; a12 = temp + a12 * aN;
	                temp = b;  b  = b2;  b2  = temp + b2  * aN;
	                temp = b1; b1 = b12; b12 = temp + b12 * aN;
	        }
	    }
	
	    public boolean needsTerm() {
	        if ( b1 == 0 && b == 0 && b2 == 0 && b12 == 0 ) {
	        	return false;
	        }
	
	        if ( b == 0 ) {
	            configuration = ( b2 == 0 ) ? 0 : 1;
	            return true;
	        }
	        ab = (double) a / b;
	
	        if ( b2 == 0 ) {
	            configuration = 1;
	            return true;
	        }
	        a2b2 = (double) a2 / b2;
	
	        if ( b1 == 0 ) {
	            configuration = 0;
	            return true;
	        }
	        a1b1 = (double) a1 / b1;
	
	        if ( b12 == 0 ) {
	            configuration = setConfiguration();
	            return true;
	        }
	        a12b12 = (double) a12 / b12;	

	        currentTerm = (int) ab;
	        if ( currentTerm == (int) a1b1 && currentTerm == (int) a2b2 && currentTerm == (int) a12b12 ) {
	            int temp = a;     a = b;     b = temp -   b * currentTerm;
	                temp = a1;   a1 = b1;   b1 = temp -  b1 * currentTerm;
	                temp = a2;   a2 = b2;   b2 = temp -  b2 * currentTerm;
	            	temp = a12; a12 = b12; b12 = temp - b12 * currentTerm;
	            	
	            hasTerm = true;
	            return false;
	        }
	        configuration = setConfiguration();
	        return true;
	    }
	
	    private int setConfiguration() {
	    	return ( Math.abs(a1b1 - ab) > Math.abs(a2b2 - ab) ) ? 0 : 1;
	    }

	    private int a12, a1, a2, a, b12, b1, b2, b;
	    private double ab, a1b1, a2b2, a12b12;
	    	
	}

	private static interface ContinuedFraction {
		
	    public boolean hasMoreTerms();
	    public int nextTerm();
	
	}	
	
	private static class R2cf implements ContinuedFraction {
		
		public R2cf(int aN1, int aN2) {
			n1 = aN1; n2 = aN2;	
		}

		public boolean hasMoreTerms() {
	    	return Math.abs(n2) > 0;
	    }
		
	    public int nextTerm() {
	        final int term = n1 / n2;
	        final int temp = n2;
	        n2 = n1 - term * n2;
	        n1 = temp;
	        return term;
	    }	
	
	    private int n1, n2; 		
	
	}
	
	private static class NG implements ContinuedFraction {
		
		public NG(NG4 aNG, ContinuedFraction aCF) {
			matrixNG = aNG;
			cf.add(aCF);
		}
		
		public NG(NG8 aNG, ContinuedFraction aCF1, ContinuedFraction aCF2) {
			matrixNG = aNG;
			cf.add(aCF1); cf.add(aCF2);
		}

	    public boolean hasMoreTerms() {
	        while ( matrixNG.needsTerm() ) {
	            if ( cf.get(matrixNG.configuration).hasMoreTerms() ) {
	                matrixNG.consumeTerm(cf.get(matrixNG.configuration).nextTerm());
	            } else {
	                matrixNG.consumeTerm();
	            }
	        }
	        return matrixNG.hasTerm;
	    }
	
	    public int nextTerm() {
	        matrixNG.hasTerm = false;
	        return matrixNG.currentTerm;
	    }
	
	    private MatrixNG matrixNG;
	    private List<ContinuedFraction> cf = new ArrayList<ContinuedFraction>();
	
	}

}
