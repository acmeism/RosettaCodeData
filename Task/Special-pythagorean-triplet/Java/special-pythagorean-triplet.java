import java.util.stream.IntStream;

public final class SpecialPythagoreanTriplet {

	public static void main(String[] args) {
		IntStream.range(1, 333).forEach( a -> {
		    int b = a + 1;
		    int c = 1_000;
		    while ( b < c ) {
		        c = 1_000 - a - b;
		        if ( a * a + b * b == c * c ) {
		            System.out.println("a = %d, b = %d, c = %d".formatted(a, b, c));
		            System.out.println("a + b + c = " + ( a + b + c ));
		            System.out.println("a * b * c = " + ( a * b * c ));
		        }
		        b += 1;
		    }
		} );
	}

}
