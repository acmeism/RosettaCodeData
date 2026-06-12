import java.util.ArrayList;
import java.util.List;

public final class MaximumDifferenceBetweenAdjacentElementsOfList {

	public static void main(String[] args) {
		List<Double> test = List.of(
			1.0, 8.0, 2.0, -3.0, 0.0, 1.0, 1.0, -2.3, 0.0, 5.5, 8.0, 6.0, 2.0, 9.0, 11.0, 10.0, 3.0 );
		
		List<Triple> maxDifferences = maxDifferences(test);
		final double maxDiff = maxDifferences.getFirst().difference;
		System.out.println("The maximum difference between adjacent pairs of the list is: " + maxDiff);
		System.out.println("The pairs with this difference are: " + maxDifferences);
	}
	
	private static List<Triple> maxDifferences(List<Double> list) {
		if ( list.size() < 2 ) {
			throw new AssertionError("List is too short to find differences");
		}
		
		List<Triple> maxPairs = new ArrayList<Triple>();
		double maxDifference = -1.0;
		for ( int i = 1; i < list.size(); i++ ) {
			double difference = Math.abs(list.get(i - 1) - list.get(i));
			if ( difference > maxDifference ) {
				maxDifference = difference;
				maxPairs = new ArrayList<Triple>();
				maxPairs.addLast( new Triple(maxDifference, list.get(i - 1), list.get(i)) );
			} else if ( difference == maxDifference ) {
				maxPairs.addLast( new Triple(maxDifference, list.get(i - 1), list.get(i)) );
			}			
		}
		return maxPairs;
	}
	
	private static record Triple(double difference, double one, double two) {
		
		@Override
		public String toString() {
			return "(" + one + ", " + two + ")";
		}
		
	}

}
