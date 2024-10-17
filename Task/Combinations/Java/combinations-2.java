import java.util.ArrayList;
import java.util.List;

public final class Combinations {

	public static void main(String[] args) {		
		System.out.println(createCombinations(List.of( 0, 1, 2, 3, 4 ), 3));
		System.out.println(createCombinations(List.of( "Crosby", "Nash", "Stills", "Young" ), 3));
	}
	
	private static <T> List<List<T>> createCombinations(List<T> elements, int k) {
		List<List<T>> combinations = new ArrayList<List<T>>();
		createCombinations(elements, k, new ArrayList<T>(), combinations, 0);
		return combinations;
	}
	
	private static <T> void createCombinations(
			List<T> elements, int k, List<T> accumulator, List<List<T>> combinations, int index) {
		if ( accumulator.size() == k ) {
		    combinations.addFirst( new ArrayList<T>(accumulator) );
		} else if ( k - accumulator.size() <= elements.size() - index ) {
		    createCombinations(elements, k, accumulator, combinations, index + 1);
		    accumulator.add(elements.get(index));
		    createCombinations(elements, k, accumulator, combinations, index + 1);
		    accumulator.removeLast();
		}
	}

}
