import java.util.List;

public final class CommonListElements {

	public static void main(String[] args) {
		List<List<List<Integer>>> tests = List.of(
		    List.of( List.of( 2, 5, 1, 3, 8, 9, 4, 6 ),
		    		 List.of( 3, 5, 6, 2, 9, 8, 4 ),
		    		 List.of( 1, 3, 7, 6, 9 ) ),
		
		    List.of( List.of( 2, 2, 1, 3, 8, 9, 4, 6 ),
		    		 List.of( 3, 5, 6, 2, 2, 2, 4 ),
		    		 List.of( 2, 3, 7, 6, 2 ) ) );
		
		for ( List<List<Integer>> test : tests ) {			
			List<Integer> result = test.get(0).stream().filter(test.get(1)::contains).toList()
				.stream().filter(test.get(2)::contains).toList();
			System.out.println("intersection of " + test + " is: " + result);
		}
	}

}
