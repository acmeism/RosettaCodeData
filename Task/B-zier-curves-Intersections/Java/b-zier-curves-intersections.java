import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

public final class BezierCurveIntersection {

	public static void main(String[] aArgs) {
		QuadCurve vertical = new QuadCurve( new QuadSpline(-1.0, 0.0, 1.0), new QuadSpline(0.0, 10.0, 0.0) );
		// QuadCurve vertical represents the Bezier curve having control points (-1, 0), (0, 10) and (1, 0)
		QuadCurve horizontal = new QuadCurve( new QuadSpline(2.0, -8.0, 2.0), new QuadSpline(1.0, 2.0, 3.0) );
		// QuadCurve horizontal represents the Bezier curve having control points (2, 1), (-8, 2) and (2, 3) 		

		System.out.println("The points of intersection are:");
		List<Point> intersects = findIntersects(vertical, horizontal);
		for ( Point intersect : intersects ) {
			System.out.println(String.format("%s%9.6f%s%9.6f%s", "( ", intersect.aX, ", ", intersect.aY, " )"));
		}
	}
	
	private static List<Point> findIntersects(QuadCurve aP, QuadCurve aQ) {
		List<Point> result = new ArrayList<Point>();
		Stack<QuadCurve> stack = new Stack<QuadCurve>();
		stack.push(aP);
		stack.push(aQ);
		
		while ( ! stack.isEmpty() ) {
			QuadCurve pp = stack.pop();
		    QuadCurve qq = stack.pop();
		    List<Object> objects = testIntersection(pp, qq);
		    final boolean accepted = (boolean) objects.get(0);
		    final boolean excluded = (boolean) objects.get(1);
		    Point intersect = (Point) objects.get(2);
		
		    if ( accepted ) {
		    	if ( ! seemsToBeDuplicate(result, intersect) ) {
		    		result.add(intersect);
		    	}
		    } else if ( ! excluded ) {
		    	QuadCurve p0 = new QuadCurve();
		    	QuadCurve q0 = new QuadCurve();
		    	QuadCurve p1 = new QuadCurve();
		    	QuadCurve q1 = new QuadCurve();
		    	subdivideQuadCurve(pp, 0.5, p0, p1);
		    	subdivideQuadCurve(qq, 0.5, q0, q1);
		    	stack.addAll(List.of( p0, q0, p0, q1, p1, q0, p1, q1 ));
		    }
		}
		return result;
	}
	
	private static boolean seemsToBeDuplicate(List<Point> aIntersects, Point aPoint) {
		for ( Point intersect : aIntersects ) {
			if ( Math.abs(intersect.aX - aPoint.aX) < SPACING && Math.abs(intersect.aY - aPoint.aY) < SPACING ) {
				return true;
			}
		}
		return false;
	}
	
	private static List<Object> testIntersection(QuadCurve aP, QuadCurve aQ) {
	    final double pxMin = Math.min(Math.min(aP.x.c0, aP.x.c1), aP.x.c2);
	    final double pyMin = Math.min(Math.min(aP.y.c0, aP.y.c1), aP.y.c2);
	    final double pxMax = Math.max(Math.max(aP.x.c0, aP.x.c1), aP.x.c2);
	    final double pyMax = Math.max(Math.max(aP.y.c0, aP.y.c1), aP.y.c2);

	    final double qxMin = Math.min(Math.min(aQ.x.c0, aQ.x.c1), aQ.x.c2);
	    final double qyMin = Math.min(Math.min(aQ.y.c0, aQ.y.c1), aQ.y.c2);
	    final double qxMax = Math.max(Math.max(aQ.x.c0, aQ.x.c1), aQ.x.c2);
	    final double qyMax = Math.max(Math.max(aQ.y.c0, aQ.y.c1), aQ.y.c2);
	
	    boolean accepted = false;
	    boolean excluded = true;
	    Point intersect = new Point(0.0, 0.0);
	
	    if ( rectanglesOverlap(pxMin, pyMin, pxMax, pyMax, qxMin, qyMin, qxMax, qyMax) ) {
		    excluded = false;
		    final double xMin = Math.max(pxMin, qxMin);
		    final double xMax = Math.min(pxMax, pxMax);
		    if ( xMax - xMin <= TOLERANCE ) {
		    	final double yMin = Math.max(pyMin, qyMin);
		    	final double yMax = Math.min(pyMax, qyMax);
		    	if ( yMax - yMin <= TOLERANCE ) {
		    		accepted = true;
		    		intersect = new Point(0.5 * ( xMin + xMax), 0.5 * ( yMin +  yMax));
		    	}
		    }
	    }
	    return List.of( accepted, excluded, intersect );
	}
	
	private static boolean rectanglesOverlap(double aXa0, double aYa0, double aXa1, double aYa1,
										     double aXb0, double aYb0, double aXb1, double aYb1) {
		return aXb0 <= aXa1 && aXa0 <= aXb1 && aYb0 <= aYa1 && aYa0 <= aYb1;
	}
	
	private static void subdivideQuadCurve(QuadCurve aQ, double aT, QuadCurve aU, QuadCurve aV) {
		subdivideQuadSpline(aQ.x, aT, aU.x, aV.x);
		subdivideQuadSpline(aQ.y, aT, aU.y, aV.y);
	}
	
	// de Casteljau's algorithm
	private static void subdivideQuadSpline(QuadSpline aQ, double aT, QuadSpline aU, QuadSpline aV) {
		final double s = 1.0 - aT;
		aU.c0 = aQ.c0;
		aV.c2 = aQ.c2;
		aU.c1 = s * aQ.c0 + aT * aQ.c1;
		aV.c1 = s * aQ.c1 + aT * aQ.c2;
		aU.c2 = s * aU.c1 + aT * aV.c1;
		aV.c0 = aU.c2;
	}
	
	private static record Point(double aX, double aY) {}
	
	private static class QuadSpline {
		
		public QuadSpline(double aC0, double aC1, double aC2) {
			c0 = aC0; c1 = aC1; c2 = aC2;
		}
		
		public QuadSpline() {
			this(0.0, 0.0, 0.0);
		}
		
		private double c0, c1, c2;	
		
	}	
	
	private static class QuadCurve {
		
		public QuadCurve(QuadSpline aX, QuadSpline aY) {
			x = aX; y = aY;
		}
		
		public QuadCurve() {
			this( new QuadSpline(), new QuadSpline() );
		}
		
		private QuadSpline x, y;
		
	}
	
	private static final double TOLERANCE = 0.000_000_1;
	private static final double SPACING = 10 * TOLERANCE;

}
