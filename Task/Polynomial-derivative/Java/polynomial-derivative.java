import java.util.List;
import java.util.stream.IntStream;

public final class PolynomialDerivative {

	public static void main(String[] args) {
		System.out.println("The derivatives of the following polynomials are:" + System.lineSeparator());		
		List<List<Integer>> polynomials = List.of( List.of( 5 ), List.of( 4, -3 ), List.of( -1, 6, 5 ),
												   List.of( -4, 3, -2, 1 ), List.of( 1, 1, 0, -1, -1 ) );
	    polynomials.forEach( polynomial -> System.out.println(polynomial + " => " + differentiate(polynomial)) );
	}
	
	private static List<Integer> differentiate(List<Integer> polynomial) {		
		if ( polynomial.size() ==  1 ) {
			return List.of( 0 );
		}
		
	    return IntStream.range(1, polynomial.size()).map( i -> polynomial.get(i) * i ).boxed().toList();
	}

}
