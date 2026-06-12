import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class CentroidOfASetOfNDimensionalPoints {

	public static void main(String[] args) {
		List<List<List<Double>>> listPoints = List.of(
		    List.of( List.of( 1.0 ), List.of( 2.0 ), List.of( 3.0 ) ),
		    List.of( List.of( 8.0, 2.0 ), List.of( 0.0, 0.0 ) ),
		    List.of( List.of( 5.0, 5.0, 0.0 ), List.of( 10.0, 10.0, 0.0 ) ),
		    List.of( List.of( 1.0, 3.1, 6.5 ), List.of( -2.0, -5.0, 3.4 ),
		    		 List.of( -7.0, -4.0, 9.0 ), List.of( 2.0, 0.0, 3.0 ) ),
		    List.of( List.of( 0.0, 0.0, 0.0, 0.0, 1.0 ), List.of( 0.0, 0.0, 0.0, 1.0, 0.0 ),
		    		 List.of( 0.0, 0.0, 1.0, 0.0, 0.0 ), List.of( 0.0, 1.0, 0.0, 0.0, 0.0 ) )
		);
		
		listPoints.forEach( points -> {
		    System.out.println(points + " => Centroid: " + centroid(points));
		} );
	}
	
	private static List<Double> centroid(List<List<Double>> points) {
		if ( points.isEmpty() ) {
			throw new AssertionError("List must contain at least one point.");
		}
		
	    final int dimension = points.getFirst().size();
	    if ( ! points.stream().skip(1).allMatch( list -> list.size() == dimension ) ) {
	        throw new AssertionError("Points must all have the same dimension.");
	    }
	
		List<Double> result = Stream.generate( () -> 0.0 ).limit(dimension).collect(Collectors.toList());
	    for ( int j = 0; j < dimension; j++ ) {
	        for ( int i = 0; i < points.size(); i++ ) {
	        	result.set(j, result.get(j) + points.get(i).get(j));
	        }
	        result.set(j, result.get(j) / points.size());
	    }
	    return result;
	}

}
