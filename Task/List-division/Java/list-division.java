import module java.base;

public final class ListDivision {

	public static void main() {
		List<Tuple<Integer>> tests = List.of(
			new Tuple<Integer>(List.of( 94, 94, 13, 77, 35, 10, 51, 27, 60 ), 6),
			new Tuple<Integer>(List.of( 19, 46, 43, 17, 94 ), 1),
			new Tuple<Integer>(List.of( 93, 88, 40, 88, 30, 68, 84, 25 ), 3),
			new Tuple<Integer>(List.of( 88, 94, 10, 27, 54, 14 ), 3),
			new Tuple<Integer>(List.of( 31, 19, 63, 57, 57, 74, 50, 14, 38 ), 4),
			new Tuple<Integer>(List.of( 72, 57, 89, 55, 36, 84, 10, 95, 99, 35 ), 7),
			// The following lists are divided as far as possible, without returning empty lists
			new Tuple<Integer>(List.of( 23, 49, 57 ), 10),
			new Tuple<Integer>(List.of( 1 ), 2),
			new Tuple<Integer>(List.of( ), 2)
		);
		
		tests.forEach(ListDivision::divideList);
	}
	
	private static <T> void divideList(Tuple<T> tuple) {
	    List<List<T>> result = new ArrayList<List<T>>();	
	    final int quotient = tuple.list.size() / tuple.partCount;
	    final int remainder = tuple.list.size() % tuple.partCount;
	
	    int start = 0;
	    for ( int part = 0; part < tuple.partCount; part++ ) {
	    	final int size = ( part < remainder ) ? quotient + 1 : quotient;
	    	if ( size > 0 ) {
	    		result.addLast(tuple.list.subList(start, start + size));
	    		start += size;
	    	}
	    }	
	
	    IO.println(result);
	}
	
	private record Tuple<T>(List<T> list, int partCount) {}

}
