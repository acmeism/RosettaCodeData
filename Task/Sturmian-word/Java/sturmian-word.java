import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class SturmianWord {

	public static void main(String[] args) {
		String sturmian = sturmianWordRational(13, 21);
		System.out.println(sturmian + " from rational number 13 / 21");
		
		System.out.println(sturmianWordQuadratic(1, 5, -1, 2, 8)
			+ " from real number ( √5 - 1 ) / 2, the first 8 letters");
		
		String fibonacci = fibonacciWord(10);
		System.out.println("Sturmian word equals Fibonacci word? : "
			+ sturmian.equals(fibonacci.substring(0, sturmian.length())));
	}
	
	// Return the Sturmian word for the strictly positive rational number m / n
	private static String sturmianWordRational(int m, int n) {
	    if ( m > n ) {
	    	return sturmianWordRational(n, m).chars().mapToObj( i -> String.valueOf((char) i) )
	    		.reduce("", (accumulator, term) -> accumulator += ( term.equals("0") ? "1" : "0" ));
	    }
	
	    StringBuilder sturmian = new StringBuilder();
	    int k = 1;	
	    while ( ( k * m ) % n != 0 ) {	
	        final int previousFloor = ( k - 1 ) * m / n;
	        final int currentFloor = ( k * m ) / n;
	        sturmian.append( previousFloor == currentFloor ? "0" : "10" );
	        k += 1;
	    }	
	    return sturmian.toString();	
	}
	
	// Return the first 'letterCount' letters of Sturmian word for the strictly positive real number
	// ( b * √(a) + m ) / n, where a is not a perfect square
	private static String sturmianWordQuadratic(int b, int a, int m, int n, int letterCount) {
	    List<Integer> p = Stream.of( 0, 1 ).collect(Collectors.toList());
	    List<Integer> q = Stream.of( 1, 0 ).collect(Collectors.toList());	
	    double remainder = ( b * Math.sqrt(a) + m ) / n;
	
	    for ( int i = 1; i <= letterCount; i++ ) {
	        final int integerPart = (int) remainder;
	        final double fractionPart  = remainder - integerPart;
	        final int pn = integerPart * p.getLast() + p.get(p.size() - 2);
	        final int qn = integerPart * q.getLast() + q.get(q.size() - 2);
	        p.addLast(pn);
	        q.addLast(qn);
	        remainder = 1.0 / fractionPart;
	    };	
	    return sturmianWordRational(p.getLast(), q.getLast());
	}
	
	// Return the Fibonacci word for the given integer
	// @see https://en.wikipedia.org/wiki/Fibonacci_word
	private static String fibonacciWord(int number) {
	    String previous = "0";
	    String result = "01";	
	    for ( int i = 2; i < number; i++ ) {
	        String temp = result;
	        result += previous;
	        previous = temp;
	    }	
	    return result;
	}

}
