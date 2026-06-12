import java.util.HashSet;
import java.util.List;
import java.util.Set;

public final class JaccardIndex {

	public static void main(String[] args) {
		List<List<Integer>> tests = List.of(
			List.of( ),
			List.of( 1, 2, 3, 4, 5 ),
			List.of( 1, 3, 5, 7, 9 ),
			List.of( 2, 4, 6, 8, 10 ),
			List.of( 2, 3, 5, 7 ),
			List.of( 8 )
		);
		
		System.out.println("     Set A              Set B         J(A, B)");
		System.out.println("---------------------------------------------");
		for ( List<Integer> a : tests ) {
			for ( List<Integer> b : tests ) {
				System.out.println(String.format("%-19s%-19s%.5f", a, b, jaccardIndex(a, b)));
			}
		}
	}
	
	private static double jaccardIndex(List<Integer> A, List<Integer> B) {
		Set<Integer> intersection = new HashSet<Integer>(A);
		intersection.retainAll(B);
		Set<Integer> union = new HashSet<Integer>(A);
		union.addAll(B);
				
		final int i = intersection.size();
		final int u = union.size();
		return ( u == 0 ) ? 1.0 : ( i == 0 ) ? 0.0 : (double) i / u;
	}
	
}
