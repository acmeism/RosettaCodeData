import java.util.List;
import java.util.TreeSet;
import java.util.stream.Collectors;

public final class FindFirstMissingPositive {

	public static void main(String[] args) {
		List<List<Integer>> tests = List.of( List.of( 1, 2, 0 ), List.of( 3, 4, -1, 1 ),
			List.of( 7, 8, 9, 11, 12 ), List.of ( 1, 2, 3, 4, 5 ), List.of( -6, -5, -2, -1 ),
			List.of( 5, -5 ), List.of( -2 ), List.of( 1 ), List.of( ) );
		
		tests.forEach( test -> findFirstMissing(test) );
	}
	
	private static void findFirstMissing(List<Integer> test) {
		TreeSet<Integer> set = test.stream().filter( i -> i > 0 )
				                   .collect(Collectors.toCollection(TreeSet::new));			
		int result = 1;
		while ( ! set.isEmpty() && result >= set.pollFirst() ) {
			result += 1;			
		}
		System.out.println(test + " => " + result);
	}

}
