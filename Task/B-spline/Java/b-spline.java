import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.IntStream;

public final  class BSpline {

	public static void main(String[] args) throws IOException {
		List<Point> controlPoints = List.of(
			new Point(171.0, 171.0), new Point(185.0, 111.0), new Point(202.0, 109.0),
			new Point(202.0, 189.0), new Point(328.0, 160.0), new Point(208.0, 254.0),
			new Point(241.0, 330.0), new Point(164.0, 252.0), new Point( 69.0, 278.0),
			new Point(139.0, 208.0), new Point( 72.0, 148.0), new Point(168.0, 172.0) );
		
		List<Double> steps = IntStream.range(0, 1_001).mapToObj( i -> (double) i * 0.001 ).toList();
	
		int degree = 2; // The degree of the spline curve
	
		List<Double> knots = IntStream.range(0, controlPoints.size() + degree + 1)
			                          .mapToObj(Double::valueOf).toList();

		List<Point> bSpline2 = bSpline(steps, degree, controlPoints, knots);
		
		degree = 3;
		
		knots = IntStream.range(0, controlPoints.size() + degree + 1)
			             .mapToObj(Double::valueOf).toList();

		List<Point> bSpline3 = bSpline(steps, degree, controlPoints, knots);
		
		final int svgSize = 350;
		StringBuilder text = new StringBuilder();
	    text.append("<svg xmlns='http://www.w3.org/2000/svg'");
        text.append(" width='" + svgSize + "' height='" + svgSize + "'>\n");
        text.append("<rect width='100%' height='100%' fill='black'/>\n");
        for ( int i = 0; i < controlPoints.size() - 1; i++ ) {
        	text.append( // Join controlPoints with lines in red
        		"<line x1='" + controlPoints.get(i).x + "' y1='" + ( svgSize - controlPoints.get(i).y )
        		+ "' x2='" + controlPoints.get(i + 1).x + "' y2='" + ( svgSize - controlPoints.get(i + 1).y )
        		+ "' stroke='red' stroke-width='1'/>");
        }
        for ( int i = 0; i < bSpline2.size() - 1; i++ ) {
        	text.append( // Draw bSpline degree 2 curve in white
        		"<line x1='" + bSpline2.get(i).x + "' y1='" + ( svgSize - bSpline2.get(i).y )
        		+ "' x2='" + bSpline2.get(i + 1).x + "' y2='" + ( svgSize - bSpline2.get(i + 1).y )
        		+ "' stroke='white' stroke-width='3'/>");
        }
        for ( int i = 0; i < bSpline3.size() - 1; i++ ) {
        	text.append( // Draw bSpline degree 3 curve in cyan
        		"<line x1='" + bSpline3.get(i).x + "' y1='" + ( svgSize - bSpline3.get(i).y )
        		+ "' x2='" + bSpline3.get(i + 1).x + "' y2='" + ( svgSize - bSpline3.get(i + 1).y )
        		+ "' stroke='cyan' stroke-width='3'/>");
        }
        text.append("'/>\n</svg>\n");
		
    	Files.write(Paths.get("./bSplineJava.svg"), text.toString().getBytes());
	}
	
	/**
	 * Return a list of points belonging to the bSpline curve formed from the given control points.
 	 * Implements de Boor's algorithm; for information visit
	 * https://en.wikipedia.org/wiki/De_Boor%27s_algorithm
	 */
	public static List<Point> bSpline(
			List<Double> steps, int degree, List<Point> controlPoints, List<Double> knots) {
		
		if ( degree < 1 || degree >= controlPoints.size() ) {
			throw new AssertionError("Degree must be > 1 and < controlPoints.size(): " + degree);
		}	
	    if ( knots.size() != controlPoints.size() + degree + 1 ) {
	    	throw new AssertionError("Invalid knot vector length: " + knots.size());
	    }	
	
	    List<Point> bSplinePoints = new ArrayList<Point>(steps.size());
	
	    final double low  = knots.get(degree);
	    final double high = knots.get(controlPoints.size());	
	
	    steps.forEach( step -> {

		    // Transform the step values so that they match the range of values of the spline sections		
		    step = step * ( high - low ) + low;	
		    if ( step < low || step > high ) {
		    	throw new AssertionError("Invalid step value: " + step);
		    }
		
		    // Locate the spline segment corresponding to the current step value
		    int splineSegment = degree;
		    while ( splineSegment < controlPoints.size() &&		    		
		    	( step < knots.get(splineSegment) || step > knots.get(splineSegment + 1) ) ) {		    	
		    	splineSegment += 1;
		    }
		
		    // Copy 'controlPoints' on each iteration because they are mutated by the algorithm
		    List<Point> copyPoints = new ArrayList<Point>(controlPoints);
		
		    // de Boor's algorithm
		    for ( int level = 1; level <= degree + 1; level++ ) {
		        for ( int i = splineSegment; i > splineSegment - degree - 1 + level; i-- ) {
		            final double alpha = ( step - knots.get(i) ) /
		            	                 ( knots.get(i + degree + 1 - level) - knots.get(i) );		
		            final double x = ( 1.0 - alpha ) * copyPoints.get(i - 1).x + alpha * copyPoints.get(i).x;
		            final double y = ( 1.0 - alpha ) * copyPoints.get(i - 1).y + alpha * copyPoints.get(i).y;
		            copyPoints.set(i, new Point(x, y));
		        }
		    }		

		    bSplinePoints.addLast(copyPoints.get(splineSegment));
	    } );
	
	    return bSplinePoints;	
	}

	private static record Point(double x, double y) {}

}
