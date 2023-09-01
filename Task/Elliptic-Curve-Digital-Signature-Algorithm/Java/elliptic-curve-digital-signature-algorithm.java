import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

public final class EllipticCurveDigitalSignatureAlgorithm {

	public static void main(String[] aArgs) {
		// Test parameters for elliptic curve digital signature algorithm,
		// using the short Weierstrass model: y^2 = x^3 + ax + b (mod N).
		//
		// Parameter: a, b, modulus N, base point G, order of G in the elliptic curve.

		List<Parameter> parameters = List.of(				
		    new Parameter( 355, 671, 1073741789, new Point(13693, 10088), 1073807281 ),
		    new Parameter(   0,   7,   67096021, new Point( 6580,   779),   16769911 ),
		    new Parameter(  -3,   1,     877073, new Point(    0,     1),     878159 ),
		    new Parameter(   0,  14,      22651, new Point(   63,    30),        151 ),
		    new Parameter(   3,   2,          5, new Point(    2,     1),          5 ) );

			// Parameters which cause failure of the algorithm for the given reasons
		    // the base point is of composite order
//		    new Parameter(   0,   7,   67096021, new Point( 2402,  6067),   33539822 ),
		    // the given order is of composite order
//		    new Parameter(   0,   7,   67096021, new Point( 6580,   779),   67079644 ),
		    // the modulus is not prime (deceptive example)
//		    new Parameter(   0,   7,     877069, new Point(    3, 97123),     877069 ),
		    // fails if the modulus divides the discriminant
//		    new Parameter(  39, 387,      22651, new Point(   95,    27),      22651 ) );		
		
		final long f = 0x789abcde; // The message's digital signature hash which is to be verified
		final int d = 0;           // Set d > 0 to simulate corrupted data

		for ( Parameter parameter : parameters ) {
			EllipticCurve ellipticCurve = new EllipticCurve(parameter);			
		    ecdsa(ellipticCurve, f, d);		
		}
	}
	
	// Build the digital signature for a message using the hash aF with error bit aD
	private static void ecdsa(EllipticCurve aCurve, long aF, int aD) {
		Point point = aCurve.multiply(aCurve.g, aCurve.r);
		
		if ( aCurve.discriminant() == 0 || aCurve.g.isZero() || ! point.isZero() || ! aCurve.contains(aCurve.g) ) {		
		    throw new AssertionError("Invalid parameter in method ecdsa");
		}

		System.out.println(System.lineSeparator() + "key generation");
		final long s = 1 + (long) ( random() * (double) ( aCurve.r - 1 ) );
		point = aCurve.multiply(aCurve.g, s);
		System.out.println("private key s = " + s);
		aCurve.printPointWithPrefix(point, "public key W = sG");

		// Find the next highest power of two minus one.
		long t = aCurve.r;
		long i = 1;
		while ( i < 64 ) {
		    t |= t >> i;
		    i <<= 1;
		}
		long f = aF;
		while ( f > t ) {
			f >>= 1;
		}
		System.out.println(System.lineSeparator() + "aligned hash " + String.format("%08x", f));

		Pair signature = signature(aCurve, s, f);
		System.out.println("signature c, d = " + signature.a + ", " + signature.b);

		long d = aD;
		if ( d > 0 ) {
		    while ( d > t ) {
		    	d >>= 1;
		    }
		    f ^= d;
		    System.out.println(System.lineSeparator() + "corrupted hash " + String.format("%08x", f));
		}

		System.out.println(verify(aCurve, point, f, signature) ? "Valid" : "Invalid");
		System.out.println("-----------------");
	}
	
	private static boolean verify(EllipticCurve aCurve, Point aPoint, long aF, Pair aSignature) {
		if ( aSignature.a < 1 || aSignature.a >= aCurve.r || aSignature.b < 1 || aSignature.b >= aCurve.r ) {
		    return false;
		}

		System.out.println(System.lineSeparator() + "signature verification");
		final long h = extendedGCD(aSignature.b, aCurve.r);
		final long h1 = Math.floorMod(aF * h, aCurve.r);
		final long h2 = Math.floorMod(aSignature.a * h, aCurve.r);
		System.out.println("h1, h2 = " + h1 + ", " + h2);
		Point v = aCurve.multiply(aCurve.g, h1);
		Point v2 = aCurve.multiply(aPoint, h2);
		aCurve.printPointWithPrefix(v, "h1G");
		aCurve.printPointWithPrefix(v2, "h2W");
		v = aCurve.add(v, v2);
		aCurve.printPointWithPrefix(v, "+ =");
		
		if ( v.isZero() ) {
			return false;
		}
		long c1 = Math.floorMod(v.x, aCurve.r);
		System.out.println("c' = " + c1);
		return c1 == aSignature.a;
	}
	
	private static Pair signature(EllipticCurve aCurve, long aS, long aF) {
		long c = 0;
		long d = 0;
		long u;
		Point v;
		System.out.println("Signature computation");

		while ( true ) {
		    while ( true ) {
		        u = 1 + (long) ( random() * (double) ( aCurve.r - 1 ) );
		        v = aCurve.multiply(aCurve.g, u);
		        c = Math.floorMod(v.x, aCurve.r);
		        if ( c != 0 ) {
		        	break;
		        }
		    }
		
		    d = Math.floorMod(extendedGCD(u, aCurve.r) * Math.floorMod(aF + aS * c, aCurve.r), aCurve.r);
		    if ( d != 0 ) {
		    	break;
		    }
		}

		System.out.println("one-time u = " + u);
		aCurve.printPointWithPrefix(v, "V = uG");
		return new Pair(c, d);
	}		
	
	// Return 1 / aV modulus aU
	private static long extendedGCD(long aV, long aU) {
		if ( aV < 0 ) {
			aV += aU;
		}

		long result = 0;
		long s = 1;
		while ( aV != 0 ) {
		    final long quotient = Math.floorDiv(aU, aV);
		    aU = Math.floorMod(aU, aV);
		    long temp = aU; aU = aV; aV = temp;
		    result -= quotient * s;
		    temp = result; result = s; s = temp;
		}

		if ( aU != 1 ) {
		    throw new AssertionError("Cannot inverse modulo N, gcd = " + aU);
		}
		return result;
	}
	
	private static double random() {
		return RANDOM.nextDouble();
	}

	private static class EllipticCurve {
		
		public EllipticCurve(Parameter aParameter) {
			n = aParameter.n;
			if ( n < 5 || n > MAX_MODULUS ) {
			    throw new AssertionError("Invalid value for modulus: " + n);
			}
			
			a = Math.floorMod(aParameter.a, n);
			b = Math.floorMod(aParameter.b, n);
			g = aParameter.g;
			r = aParameter.r;

			if ( r < 5 || r > MAX_ORDER_G ) {
			    throw new AssertionError("Invalid value for the order of g: " + r);
			}

			System.out.println();
			System.out.println("Elliptic curve: y^2 = x^3 + " + a + "x + " + b + " (mod " + n + ")");
			printPointWithPrefix(g, "base point G");
			System.out.println("order(G, E) = " + r);
		}	
		
		private Point add(Point aP, Point aQ) {
			if ( aP.isZero() ) {
				return aQ;
			}
			if ( aQ.isZero() ) {
				return aP;
			}

			long la;
			if ( aP.x != aQ.x ) {
			    la = Math.floorMod(( aP.y - aQ.y ) * extendedGCD(aP.x - aQ.x, n), n);			
			} else if ( aP.y == aQ.y && aP.y != 0 ) {
				la = Math.floorMod(Math.floorMod(Math.floorMod(
					aP.x * aP.x, n) * 3 + a, n) * extendedGCD(2 * aP.y, n), n);
			} else {
			    return Point.ZERO;
			}

			final long xCoordinate = Math.floorMod(la * la - aP.x - aQ.x, n);
			final long yCoordinate = Math.floorMod(la * ( aP.x - xCoordinate ) - aP.y, n);
			return new Point(xCoordinate, yCoordinate);
		}
		
		public Point multiply(Point aPoint, long aK) {
			Point result = Point.ZERO;

			while ( aK != 0 ) {
			    if ( ( aK & 1 ) == 1 ) {
			        result = add(result, aPoint);
			    }
			    aPoint = add(aPoint, aPoint);
			    aK >>= 1;
			}
			return result;
		}
		
		public boolean contains(Point aPoint) {
			if ( aPoint.isZero() ) {
				return true;
			}
			
			final long r = Math.floorMod(Math.floorMod(a + aPoint.x * aPoint.x, n) * aPoint.x + b, n);
			final long s = Math.floorMod(aPoint.y * aPoint.y, n);
			return r == s;
		}	
		
		public long discriminant() {			
			final long constant = 4 * Math.floorMod(a * a, n) * Math.floorMod(a, n);
			return Math.floorMod(-16 * ( Math.floorMod(b * b, n) * 27 + constant ), n);
		}	
		
		public void printPointWithPrefix(Point aPoint, String aPrefix) {		
			 long y = aPoint.y;
			 if ( aPoint.isZero() ) {
				 System.out.println(aPrefix + " (0)");
			 } else {
			    if ( y > n - y ) {
			    	y -= n;
			    }
			    System.out.println(aPrefix + " (" + aPoint.x + ", " + y + ")");
			 }
		}		
		
		private final long a, b, n, r;
		private final Point g;
		
	}
	
	private static class Point {
		
		public Point(long aX, long aY) {
			x = aX;
			y = aY;
		}	
		
		public boolean isZero() {
			return x == INFINITY && y == 0;
		}
					
		private long x, y;
		
		private static final long INFINITY = Long.MAX_VALUE;
		private static final Point ZERO = new Point(INFINITY, 0);
			
	}

	private static record Pair(long a, long b) {}

	private static record Parameter(long a, long b, long n, Point g, long r) {}
	
	private static final int MAX_MODULUS = 1073741789;
	private static final int MAX_ORDER_G = MAX_MODULUS + 65536;
	
	private static final ThreadLocalRandom RANDOM = ThreadLocalRandom.current();

}
