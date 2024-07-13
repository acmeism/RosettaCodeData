import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

public final class CatmullClarkSurfaceSubdivision {

	public static void main(String[] args) {
		List<Face> faces = List.of( new Face(List.of( new Point(-1.0,  1.0,  1.0),
									  				  new Point(-1.0, -1.0,  1.0),
									  				  new Point( 1.0, -1.0,  1.0),
									  				  new Point( 1.0,  1.0,  1.0) )),
				
									new Face(List.of( new Point( 1.0,  1.0,  1.0),
													  new Point( 1.0, -1.0,  1.0),
													  new Point( 1.0, -1.0, -1.0),
													  new Point( 1.0,  1.0, -1.0) )),
											
									new Face(List.of( new Point( 1.0,  1.0, -1.0),
											  		  new Point( 1.0, -1.0, -1.0),
											  		  new Point(-1.0, -1.0, -1.0),
											  		  new Point(-1.0,  1.0, -1.0) )),
									
									new Face(List.of( new Point(-1.0,  1.0, -1.0),
									  		  		  new Point(-1.0,  1.0,  1.0),
									  		  		  new Point( 1.0,  1.0,  1.0),
									  		  		  new Point( 1.0,  1.0, -1.0) )),
									
									new Face(List.of( new Point(-1.0,  1.0, -1.0),
												  	  new Point(-1.0, -1.0, -1.0),
												  	  new Point(-1.0, -1.0,  1.0),
												  	  new Point(-1.0,  1.0,  1.0) )),
									
									new Face(List.of( new Point(-1.0, -1.0, -1.0),
									  		  		  new Point(-1.0, -1.0,  1.0),
									  		  		  new Point( 1.0, -1.0,  1.0),
									  		  		  new Point( 1.0, -1.0, -1.0) )) );
		
		displaySurface(faces);
		final int iterations = 1;
		for ( int i = 0; i < iterations; i++ ) {
			faces = catmullClarkSurfaceSubdivision(faces);
		}
		displaySurface(faces);
	}
	
	// The Catmull-Clarke surface subdivision algorithm.
	private static List<Face> catmullClarkSurfaceSubdivision(List<Face> faces) {
		// Determine, for each edge, whether or not it is an edge of a hole, and set its edge point accordingly.
		List<Edge> edges = faces.stream().map( face -> face.edges.stream() ).flatMap(Function.identity()).toList();
		for ( Edge edge : edges ) {
			List<Point> facePointsForEdge =
				faces.stream().filter( face -> face.contains(edge) ).map( face -> face.facePoint ).toList();
			if ( facePointsForEdge.size() == 2 ) {
				edge.holeEdge = false;
				edge.edgePoint = centroid(List.of( edge.midEdge, centroid(facePointsForEdge) ));
			} else {				
				edge.holeEdge = true;
				edge.edgePoint = edge.midEdge;
			}			
		}
		
		Map<Point, Point> nextVertices = nextVertices(edges, faces);
		
		List<Face> nextFaces = new ArrayList<Face>();
		for ( Face face : faces ) { // The face may contain any number of points
			if ( face.vertices.size() >= 3 ) { // A face with 2 or fewer points does not contribute to the surface
				Point facePoint = face.facePoint;
				for ( int i = 0; i < face.vertices.size(); i++ ) {
					nextFaces.addLast( new Face(List.of(
						nextVertices.get(face.vertices.get(i)),
						face.edges.get(i).edgePoint,
						facePoint,
						face.edges.get(Math.floorMod(i - 1, face.vertices.size())).edgePoint )) );
				}				
			}
		}		
		return nextFaces;
	}
	
	// Return a map containing, for each vertex,
	// the new vertex created by the current iteration of the Catmull-Clark surface subdivision algorithm.
	private static Map<Point, Point> nextVertices(List<Edge> edges, List<Face> faces) {
		Map<Point, Point> nextVertices = new HashMap<Point, Point>();
		List<Point> vertices =
			faces.stream().map( face -> face.vertices.stream() ).flatMap(Function.identity()).distinct().toList();		
		
		for ( Point vertex : vertices ) {	
			List<Face> facesForVertex = faces.stream().filter( face -> face.contains(vertex) ).toList();
			List<Edge> edgesForVertex = edges.stream().filter( edge -> edge.contains(vertex) ).distinct().toList();
			
			if ( facesForVertex.size() != edgesForVertex.size() ) {
				List<Point> midEdgeOfHoleEdges = edgesForVertex.stream().filter( edge -> edge.holeEdge )
												 .map( edge -> edge.midEdge ).collect(Collectors.toList());
				midEdgeOfHoleEdges.add(vertex);
				nextVertices.put(vertex, centroid(midEdgeOfHoleEdges));				
			} else {			
		        final int faceCount = facesForVertex.size();
		        final double multipleOne = (double) ( faceCount - 3 ) / faceCount;
		        final double multipleTwo = 1.0 / faceCount;
		        final double multipleThree = 2.0 / faceCount;
		        	
		        Point nextVertexOne = vertex.multiply(multipleOne);
		        List<Point> facePoints = facesForVertex.stream().map( face -> face.facePoint ).toList();  	
		        Point nextVertexTwo = centroid(facePoints).multiply(multipleTwo);
		        List<Point> midEdges = edgesForVertex.stream().map( edge -> edge.midEdge ).toList();
		        Point nextVertexThree = centroid(midEdges).multiply(multipleThree);
		        Point nextVertexFour = nextVertexOne.add(nextVertexTwo);	
		
		        nextVertices.put(vertex, nextVertexFour.add(nextVertexThree));
			}
	    }	
		return nextVertices;
	}
	
	// Return the centroid point of the given list of points.
	private static Point centroid(List<Point> points) {
		return points.stream().reduce(Point.ZERO, (left, right) -> left.add(right) ).divide(points.size());
	}
	
	// Display the current Catmull-Clark surface on the console.
	private static void displaySurface(List<Face> faces) {
		System.out.println("Surface {");
		faces.stream().forEach(System.out::println);
		System.out.println("}" + System.lineSeparator());		
	}
	
	// A point of the current Catmull-Clark surface.
	private static final class Point implements Comparable<Point> {
		
		public Point(double aX, double aY, double aZ) {
			x = aX; y = aY; z = aZ;
		}
		
		@Override
		public int compareTo(Point other) {
			if ( x == other.x ) {
				if ( y == other.y ) {
					return Double.compare(z, other.z);
				}				
				return Double.compare(y, other.y);
			}			
			return Double.compare(x, other.x);
		}
		
		@Override
		public boolean equals(Object other) {
			return switch ( other ) {
				case Point point -> x == point.x && y == point.y && z == point.z;
				default -> false;
			};
		}
		
		@Override
		public int hashCode() {
			return Objects.hash(x, y, z);
		}
		
		public Point add(Point other) {
			return new Point(x + other.x, y + other.y, z + other.z);
		}
		
		public Point multiply(double factor) {
			return new Point(x * factor, y * factor, z * factor);
		}
		
		public Point divide(double factor) {
			return multiply(1.0 / factor);
		}
		
		public String toString() {
			return "(" + format(x) + ", " + format(y) + ", " + format(z) + ")";
		}
		
		public static Point ZERO = new Point(0.0, 0.0, 0.0);	
		
		private String format(double value) {
			return ( value >= 0 ) ? String.format(" %.3f", value) : String.format("%.3f", value);
		}
		
		private final double x, y, z;
		
	}
	
	// An edge of the current Catmull-Clark surface.
	private static final class Edge {
		
		public Edge(Point aBegin, Point aEnd) {
			if ( aBegin.compareTo(aEnd) <= 0 ) {
				begin = aBegin; end = aEnd;
			} else {
				begin = aEnd; end = aBegin;
			}
			
			midEdge = centroid(List.of( begin, end ));
		}	

		@Override
		public boolean equals(Object other) {
			return switch ( other ) {
				case Edge edge -> begin.equals(edge.begin) && end.equals(edge.end);
				default -> false;
			};
		}
		
		@Override
		public int hashCode() {
			return Objects.hash(begin, end);
		}
		
		public boolean contains(Point point) {
			return point.equals(begin) || point.equals(end);
		}
		
		public boolean holeEdge;
		public Point edgePoint;
		
		public final Point begin, end, midEdge;
		
	}
	
	// A face of the current Catmull-Clark surface.
	private static final class Face {
		
		public Face(List<Point> aVertices) {
			vertices = new ArrayList<Point>(aVertices);			
			facePoint = centroid(vertices);
			
			edges = new ArrayList<Edge>();
			for ( int i = 0; i < vertices.size() - 1; i++ ) {
				edges.addLast( new Edge(vertices.get(i), vertices.get(i + 1)) );
			}
			edges.addLast( new Edge(vertices.getLast(), vertices.getFirst()) );;	
		}	
		
		public boolean contains(Point vertex) {
			return vertices.contains(vertex);
		}
		
		public boolean contains(Edge edge) {
			return contains(edge.begin) && contains(edge.end);
		}
		
		public String toString() {
			return "Face: " + vertices.stream().map( point -> point.toString() ).collect(Collectors.joining("; "));
		}		
		
		public final List<Point> vertices;
		public final Point facePoint;
		public final List<Edge> edges;
		
	}	

}
