import java.util.ArrayList;
import java.util.List;

public final class CheckIfTwoPolygonsOverlap {

	public static void main(String[] args) {
		Polygon polygon1 = new Polygon(List.of( new Point(0.0, 0.0), new Point(0.0, 2.0), new Point(1.0, 4.0),
				                                new Point(2.0, 2.0), new Point(2.0, 0.0) ));
				
		Polygon polygon2 = new Polygon(List.of( new Point(4.0, 0.0), new Point(4.0, 2.0), new Point(5.0, 4.0),
				                                new Point(6.0, 2.0), new Point(6.0, 0.0) ));
		
		Polygon polygon3 = new Polygon(List.of( new Point(1.0, 0.0), new Point(1.0, 2.0), new Point(5.0, 4.0),
				                                new Point(9.0, 2.0), new Point(9.0, 0.0) ));
		
		System.out.println("polygon1 = " + polygon1);
		System.out.println("polygon2 = " + polygon2);
		System.out.println("polygon3 = " + polygon3);
		System.out.println();
		System.out.println("polygon1 and polygon2 overlap? " + polygon1.overlaps(polygon2));
		System.out.println("polygon1 and polygon3 overlap? " + polygon1.overlaps(polygon3));
		System.out.println("polygon2 and polygon3 overlap? " + polygon2.overlaps(polygon3));
	}
	
	private static class Polygon {
		
		public Polygon(List<Point> points) {
			vertices = points.stream().map( point -> new Vector(point.x, point.y) ).toList();
			computeAxes();
		}
		
		public boolean overlaps(Polygon other) {
			List<Vector> allAxes = new ArrayList<Vector>(axes);
			allAxes.addAll(other.axes);
	
			for ( Vector axis : allAxes ) {
		        Projection projection1 = projectionOnAxis(axis);
		        Projection projection2 = other.projectionOnAxis(axis);
		        if ( ! projection1.overlaps(projection2) ) {
		        	return false;
		        }
			}
			
			return true;
	    }
		
		public Projection projectionOnAxis(Vector axis) {
			double min = Double.POSITIVE_INFINITY;
			double max = Double.NEGATIVE_INFINITY;
		
			for ( Vector vertex : vertices ) {
			    double p = axis.scalarProduct(vertex);
			    if ( p < min ) {
			        min = p;
			    }
			    if ( p > max ) {
			      max = p;
			    }
			}
			
			return new Projection(min, max);
	    }
		
		public String toString() {
			StringBuilder result = new StringBuilder("[ ");
			for ( Vector vertex : vertices ) {
				result.append(vertex);
			}
			
			result.append("]");
			return result.toString();			
		}
		
		private void computeAxes() {
	        axes = new ArrayList<Vector>();
            for ( int i = 0; i < vertices.size(); i++ ) {
                Vector vertex1 = vertices.get(i);
                Vector vertex2 = vertices.get(( i + 1 ) % vertices.size());
                Vector edge = vertex1.edgeWith(vertex2);
                axes.addLast(edge.perpendicular());
            }
        }
		
		private List<Vector> vertices;
	    private List<Vector> axes;
		
	}
	
	final record Vector(double x, double y) {			
		
	    public double scalarProduct(Vector other) {
	    	return x * other.x + y * other.y;
	    }
	
	    public Vector edgeWith(Vector other) {
	    	return new Vector(x - other.x, y - other.y);
	    }
	
	    public Vector perpendicular() {
	    	return new Vector(-y, x);
	    }
	
	    public String toString() {
			return "(" + x + ", " + y + ") ";
		}
	    		
	}

	final record Projection(double min, double max) {
		
		public boolean overlaps(Projection other) {
			return ! ( max < other.min || other.max < min );
		}

	}

	final record Point(double x, double y) { }

}
