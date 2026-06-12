import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class InventorySequence {

	public static void main(String[] args) {
		List<Integer> inventorySequence = inventorySequence(10_000);
		
		int thousands = 1_000;
		System.out.println("The first 100 numbers of the inventory sequence:");
		for ( int i = 0; i < inventorySequence.size(); i++ ) {
			final int number = inventorySequence.get(i);
		    if ( i < 100 ) {
		    	System.out.print(String.format("%2d%s", number, ( i % 20 == 19 ? "\n" : " " )));
		    } else if ( i == 100 ) {
		    	System.out.println();
		    } else if ( number >= thousands ) {
		    	System.out.println(String.format("%s%5d%s%5d%s%6d",
		    		"The first element ≥ ", thousands, " is ", number, " which occurs at index ", i));
		    	thousands += 1_000;
		    }		
		}
	}
	
	private static List<Integer> inventorySequence(int maxTerm) {
		int term = 0;
		List<Integer> result = new ArrayList<Integer>(List.of(term ));
	    Map<Integer, Integer> inventory = new HashMap<Integer, Integer>(Map.of( 0, 1 ));
	    while ( result.getLast() < maxTerm ) {
	        final int count = inventory.computeIfAbsent(term, n -> 0 );
	        term = ( count == 0 ) ? 0 : term + 1;	
	        inventory.merge(count, 1, Integer::sum);
	        result.addLast(count);
	    }
	    return result;
	}

}
