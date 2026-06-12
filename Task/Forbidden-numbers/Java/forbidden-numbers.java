import java.util.List;
import java.util.stream.IntStream;

public final class ForbiddenNumbers {

	public static void main(String[] args) {
		List<Integer> forbiddens =
            IntStream.rangeClosed(1, 500_000).filter( i -> isForbidden(i) ).boxed().toList();
		
		System.out.println("The first 50 forbidden numbers are:");
		for ( int n = 0; n < 50; n++ ) {
			System.out.print(String.format("%3d%s", forbiddens.get(n), ( n % 10 == 9 ? "\n" : " " )));
		}
		System.out.println();

		for ( int limit : List.of( 500, 5_000, 50_000, 500_000 ) ) {
		     final long count = forbiddens.stream().filter( i -> i <= limit ).count();
		     System.out.println("There are " + count + " forbidden number count <= " + limit);
		}
	}
	
	private static boolean isForbidden(int number) {
		int copyNumber = number;
	    int powerOf4 = 0;
	    while ( copyNumber > 1 && copyNumber % 4 == 0 ) {
	        copyNumber /= 4;
	        powerOf4 += 1;
	    }
	    return ( number / Math.pow(4, powerOf4) ) % 8 == 7;
	}

}
