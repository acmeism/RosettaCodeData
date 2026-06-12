import java.util.Arrays;
import java.util.List;

public final class BernsteinBasisPolynomials {

	public static void main(String[] args) {
		/**
		 * For the following polynomials,
         * use Subprogram (1) to find coefficients in the degree-2 Bernstein basis:
		 *
		 *  p(x) = 1
		 *  q(x) = 1 + 2x + 3x²
		 */
		QuadraticCoefficients pMonomial2 = new QuadraticCoefficients(1.0, 0.0, 0.0);
		QuadraticCoefficients qMonomial2 = new QuadraticCoefficients(1.0, 2.0, 3.0);
		QuadraticCoefficients pBernstein2 = monomialToBernsteinDegree2(pMonomial2);
		QuadraticCoefficients qBernstein2 = monomialToBernsteinDegree2(qMonomial2);
		System.out.println("Subprogram (1) examples:");
		System.out.println("    monomial " + pMonomial2 + " --> bernstein " + pBernstein2);
		System.out.println("    monomial " + qMonomial2 + " --> bernstein " + qBernstein2);
		
		/**
		 * Use Subprogram (2) to evaluate p(x) and q(x) at x = 0.25, 7.50. Display the results.
		 * Optionally also display results from evaluating in the original monomial basis.
		 */
		System.out.println("Subprogram (2) examples:");
		for ( double x : List.of( 0.25, 7.50 ) ) {
		    System.out.println("    p(" + x + ") = " + evaluateBernsteinDegree2(pBernstein2, x) +
		          " ( mono: " + evaluateMonomialDegree2(pMonomial2, x) + " )");
		}
		for ( double x : List.of( 0.25, 7.50 ) ) {
		    System.out.println("    q(" + x + ") = " + evaluateBernsteinDegree2(qBernstein2, x) +
		          " ( mono: " + evaluateMonomialDegree2(qMonomial2, x) + " )");
		}
		
		/**
		 * For the following polynomials,
         * use Subprogram (3) to find coefficients in the degree-3 Bernstein basis:
		 *
		 *  p(x) = 1
		 *  q(x) = 1 + 2x + 3x²
		 *  r(x) = 1 + 2x + 3x² + 4x³
		 *
		 * Display the results.
		 */
		CubicCoefficients pMonomial3 = new CubicCoefficients(1.0, 0.0, 0.0, 0.0);
		CubicCoefficients qMonomial3 = new CubicCoefficients(1.0, 2.0, 3.0, 0.0);
		CubicCoefficients rMonomial3 = new CubicCoefficients(1.0, 2.0, 3.0, 4.0);
		CubicCoefficients pBernstein3 = monomialToBernsteinDegree3(pMonomial3);
		CubicCoefficients qBernstein3 = monomialToBernsteinDegree3(qMonomial3);
		CubicCoefficients rBernstein3 = monomialToBernsteinDegree3(rMonomial3);
		System.out.println("Subprogram (3) examples:");
		System.out.println("    monomial " + pMonomial3 + " --> bernstein " + pBernstein3);
		System.out.println("    monomial " + qMonomial3 + " --> bernstein " + qBernstein3);
		System.out.println("    monomial " + rMonomial3 + " --> bernstein " + rBernstein3);
		
		/**
		 * Use Subprogram (4) to evaluate p(x), q(x), and r(x) at x = 0.25, 7.50.  Display the results.
		 * Optionally also display results from evaluating in the original monomial basis.
		 */
		System.out.println("Subprogram (4) examples:");
		for ( double x : List.of( 0.25, 7.50 ) ) {
		    System.out.println("    p(" + x + ") = " + evaluateBernsteinDegree3(pBernstein3, x) +
		          " ( mono: " + evaluateMonomialDegree3(pMonomial3, x) + " )");
		}
		for ( double x : List.of( 0.25, 7.50 ) ) {
		    System.out.println("    q(" + x + ") = " + evaluateBernsteinDegree3(qBernstein3, x) +
		          " ( mono: " + evaluateMonomialDegree3(qMonomial3, x) + " )");
		}
		for ( double x : List.of( 0.25, 7.50 ) ) {
		    System.out.println("    r(" + x + ") = " + evaluateBernsteinDegree3(rBernstein3, x) +
		          " ( mono: " + evaluateMonomialDegree3(rMonomial3, x) + " )");
		}
		
		/**
		 * For the following polynomials, using the result of Subprogram (1) applied to the polynomial,
		 * use Subprogram (5) to get coefficients for the degree-3 Bernstein basis:
		 *
		 *  p(x) = 1
		 *  q(x) = 1 + 2x + 3x²
		 *
		 * Display the results.
		 */
		System.out.println("Subprogram (5) examples:");
		CubicCoefficients pBernstein3a = bernsteinDegree2ToDegree3(pBernstein2);
		CubicCoefficients qBernstein3a = bernsteinDegree2ToDegree3(qBernstein2);
		System.out.println("    bernstein " + pBernstein2 + " --> bernstein " + pBernstein3a);
		System.out.println("    bernstein " + qBernstein2 + " --> bernstein " + qBernstein3a);
	}
	
	private static record QuadraticCoefficients(double q0, double q1, double q2) {
		
		@Override
		public String toString() {
			return Arrays.asList(q0, q1, q2).toString();
		}	
		
	}
	
	private static record CubicCoefficients(double c0, double c1, double c2, double c3) {
		
		@Override
		public String toString() {
			return Arrays.asList(c0, c1, c2, c3).toString();
		}			
		
	}
	
	// Subprogram (1)
	private static QuadraticCoefficients monomialToBernsteinDegree2(QuadraticCoefficients monomial) {
		return new QuadraticCoefficients( monomial.q0,
									      monomial.q0 + ( monomial.q1 / 2.0 ),
									      monomial.q0 + monomial.q1 + monomial.q2 );
	}
	
	// Subprogram (2)
	private static double evaluateBernsteinDegree2(QuadraticCoefficients bernstein, double t) {
	    // de Casteljau’s algorithm
	    final double s = 1 - t;
	    final double b01 = ( s * bernstein.q0 ) + ( t * bernstein.q1 );
	    final double b12 = ( s * bernstein.q1 ) + ( t * bernstein.q2 );
	    return ( s * b01 ) + ( t * b12 );
	}
	
	// Subprogram (3)
	private static CubicCoefficients monomialToBernsteinDegree3(CubicCoefficients monomial) {
	    return  new CubicCoefficients( monomial.c0,
	    							   monomial.c0 + ( monomial.c1 / 3.0 ),
	    							   monomial.c0 + ( 2.0 * monomial.c1 / 3.0 ) + ( monomial.c2 / 3.0 ),
	    							   monomial.c0 + monomial.c1 + monomial.c2 + monomial.c3 );
	}
	
	// Subprogram (4)
	private static double evaluateBernsteinDegree3(CubicCoefficients bernstein, double t) {
	    // de Casteljau’s algorithm
	    final double s = 1 - t;
	    final double b01 = ( s * bernstein.c0 ) + ( t * bernstein.c1 );
	    final double b12 = ( s * bernstein.c1 ) + ( t * bernstein.c2 );
	    final double b23 = ( s * bernstein.c2 ) + ( t * bernstein.c3 );
	    final double b012 = ( s * b01 ) + ( t * b12 );
	    final double b123 = ( s * b12 ) + ( t * b23 );
	    return ( s * b012 ) + ( t * b123 );
	}
	
	// Subprogram (5)
	private static CubicCoefficients bernsteinDegree2ToDegree3(QuadraticCoefficients bernstein) {
	    return new CubicCoefficients( bernstein.q0,
	    		 					 ( bernstein.q0 / 3.0 ) + ( 2.0 * bernstein.q1 / 3.0 ),
	    		 					 ( 2.0 * bernstein.q1 / 3.0 ) + ( bernstein.q2 / 3.0 ),
	    		 					 bernstein.q2 );
	}
	
	private static double evaluateMonomialDegree2(QuadraticCoefficients monomial, double t) {
	    // Horner’s rule
	    return monomial.q0 + ( t * ( monomial.q1 + ( t * monomial.q2 ) ) );
	}
	
	private static double evaluateMonomialDegree3(CubicCoefficients monomial, double t) {
	    // Horner’s rule
	    return monomial.c0 + ( t * ( monomial.c1 + ( t * ( monomial.c2 + ( t * monomial.c3 ) ) ) ) );
	}

}
