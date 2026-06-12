import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class SmallestEnclosingCircle {

	public static void main(String[] args) {
		List<List<Point>> tests = List.of(
			List.of( new Point(0.0, 0.0), new Point(0.0, 1.0), new Point(1.0, 0.0) ),
			List.of( new Point(5.0, -2.0), new Point(-3.0, -2.0), new Point(-2.0, 5.0),
					 new Point(1.0, 6.0), new Point(0.0, 2.0) ),
			List.of( new Point(0.0, 0.0), new Point(-2.0, -1.0), new Point(3.0, -4.0), new Point(2.0, 8.0),
					 new Point(3.0, 11.0), new Point(-8.0, -2.0), new Point(-14.0, -6.0),
					 new Point(7.0, 3.0), new Point(10.0, 4.0), new Point(-1.0, 4.0) )
		);
		
		tests.forEach( test -> {
			Circle circle = welzlAlgorithm(test);
			System.out.println("Centre: (" + circle.centre.x + ", " + circle.centre.y + "), Radius: " + circle.radius);
		} );
	}
	
	// Return the smallest enclosing circle using Welzl's algorithm
	private static Circle welzlAlgorithm(List<Point> points) {
		List<Point> pointsCopy = new ArrayList<Point>(points);
		Collections.shuffle(pointsCopy);
	    return welzlAlgorithmRecursive(pointsCopy, new ArrayList<Point>());
	}
	
	private static Circle welzlAlgorithmRecursive(List<Point> aPoints, List<Point> aBoundary) {
		List<Point> points = new ArrayList<Point>(aPoints);
		List<Point> boundary = new ArrayList<Point>(aBoundary);
		
		// Base case occurs when all the points have been processed
		// or the smallest enclosing circle boundary is specified by three points
		if ( points.isEmpty() || boundary.size() == 3 ) {
			return circleFromListPoints(boundary);
		}
		
		// Choose a random point from the given 'points', since 'points' has already been shuffled
		Point point = points.removeLast();
	
		// Recurse with the chosen point removed
		Circle candidate = welzlAlgorithmRecursive(points, boundary);
		
		if ( encloses(point, candidate) ) {
			return candidate;
		}
		
		// Otherwise, 'point' must be on the boundary of the smallest enclosing circle
		boundary.addLast(point);
		
		// Recurse with the chosen point removed from 'points' and added to the 'boundary'
		return welzlAlgorithmRecursive(points, boundary);
	}
	
	private static Circle circleFromListPoints(List<Point> points) {
		return switch ( points.size() ) {
			case 0 -> new Circle( new Point(0.0, 0.0), 0.0);
			case 1 -> new Circle(points.getFirst(), 0.0);
			case 2 -> circleFromTwoPoints(points.get(0), points.get(1));
			case 3 -> circleFromThreePoints(points.get(0), points.get(1), points.get(2));
			default -> throw new AssertionError("There should be three or fewer points: " + points.size());
		};
	}	
		
	private static Circle circleFromThreePoints(Point a, Point b, Point c) {
		Point ba = new Point(b.x - a.x, b.y - a.y);
	    Point ca = new Point(c.x - a.x, c.y - a.y);
	    final double bb = ba.x * ba.x + ba.y * ba.y;
	    final double cc = ca.x * ca.x + ca.y * ca.y;
	    final double dd = ( ba.x * ca.y - ba.y * ca.x) * 2.0;
	    final double centreX = ( ca.y * bb - ba.y * cc ) / dd + a.x;
	    final double centreY = ( ba.x * cc - ca.x * bb ) / dd + a.y;
	    Point centre = new Point(centreX, centreY);
	    return new Circle(centre, distance(a, centre));
	}
	
	private static Circle circleFromTwoPoints(Point a, Point b) {
		return new Circle( new Point(( a.x + b.x ) / 2.0, ( a.y + b.y ) / 2.0), distance(a, b) / 2.0);
	}
		
	private static boolean encloses(Point point, Circle circle) {
		return distance(point, circle.centre) <= circle.radius;
	}

	private static double distance(Point a, Point b) {
		return Math.hypot(a.x - b.x, a.y - b.y);
	}		

	private static record Point(double x, double y) {}
	private static record Circle(Point centre, double radius) {}
	
}
