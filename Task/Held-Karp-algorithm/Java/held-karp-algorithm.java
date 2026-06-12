import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class HeldKarpAlgorithm {

	public static void main(String[] args) {
		// Test case: 4 cities with symmetric distances
		// @see the heldKarpAlgorithm() method comment for a description of this list.		
	    List<List<Integer>> distances = List.of(
	        List.of( 0,  2,  9, 10 ),
	        List.of( 1,  0,  6,  4 ),
	        List.of( 15, 7,  0,  8 ),
	        List.of( 6,  3, 12,  0 )
	    );

	    Result result = heldKarpAlgorithm(distances);

	    System.out.println("Minimum tour cost: " + result.cost);
	    System.out.println("Tour: " + result.tour);
	}
	
	/*
	 * Solve the Travelling Salesman Problem using the Held–Karp algorithm (O(n^2·2^n)).
	 *
	 * @param distances : A square matrix of pairwise distances,
	 *                    where distances.get(i).get(j) is the cost of travelling from city i to city j.
	 * @return : A Result(minimumCcost, tour), where tour is a list of city indices starting and ending at 0,
	 *           and minimumCost is the cost of travelling along this tour.
	 */
	private static Result heldKarpAlgorithm(List<List<Integer>> distances) {
	    final int subsetCount = 1 << distances.size();
	    final int INFINITY = Integer.MAX_VALUE / 4;

	    // dp.get(mask).get(j) = minimum cost to start at 0, visit exactly the cities in the mask, and end at city j
	    List<List<Integer>> dp = IntStream.range(0, subsetCount).boxed()
	    	.map( i -> new ArrayList<Integer>(Collections.nCopies(distances.size(), INFINITY)) )
	    	.collect(Collectors.toList());
	
	    // parents.get(mask).get(j) = best predecessor of j in the optimal path from mask to j
	    List<List<Integer>> parents = IntStream.range(0, subsetCount).boxed()
	    	.map( i -> new ArrayList<Integer>(Collections.nCopies(distances.size(), -1)) )
	    	.collect(Collectors.toList());
	
	    dp.get(1).set(0, 0); // Set the base case which is mask = 1 << 0, at city 0, with cost = 0

	    // Build up dp table
	    for ( int mask = 1; mask < subsetCount; mask++ ) {
	        if ( ( mask & 1 ) == 0 ) {
	        	continue; // City 0 is always included in the tour
	        }
	
	        for ( int j = 1; j < distances.size(); j++ ) {
	            if ( ( mask & ( 1 << j ) ) == 0 ) {
	            	continue; // City j is not in this subset
	            }
	
	            final int previousMask = mask ^ ( 1 << j );
	            // Attempt to travel to city j from city k in the previousMask
	            for ( int k = 0; k < distances.size(); k++ ) {
	                if ( ( previousMask & ( 1 << k ) ) > 0 ) {
	                    final int cost = dp.get(previousMask).get(k) + distances.get(k).get(j);
	                    if ( cost < dp.get(mask).get(j) ) {
	                        dp.get(mask).set(j, cost);
	                        parents.get(mask).set(j, k);
	                    }
	                }
	            }
	        }
	    }
	
        // Complete the tour by returning to city 0
        final int fullMask = subsetCount - 1;
        int minimumCost = INFINITY;
        int lastCity = 0;
        for ( int j = 1; j < distances.size(); j++ ) {
            final int cost = dp.get(fullMask).get(j) + distances.get(j).get(0);
            if ( cost < minimumCost ) {
                minimumCost = cost;
                lastCity = j;
            }
        }

        // Construct the optimal tour
        List<Integer> tour = new ArrayList<Integer>(distances.size() + 1);
        int tourMask = fullMask;
        int currentCity = lastCity;
        // Backtrack until city 0 is reached
        while ( currentCity != 0 ) {
            tour.addLast(currentCity);
            final int parent = parents.get(tourMask).get(currentCity);
            tourMask ^= ( 1 << currentCity );
            currentCity = parent;
        }

        tour.addLast(0); // Include the start city 0
        Collections.reverse(tour);
        tour.addLast(0); // Return to the start city 0	

        return new Result(minimumCost, tour);
	}
	
	private record Result(int cost, List<Integer> tour) {}

}
