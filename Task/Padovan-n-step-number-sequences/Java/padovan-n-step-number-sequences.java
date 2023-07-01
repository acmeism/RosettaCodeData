import java.util.ArrayList;
import java.util.List;

public final class PadovanNStep {

	public static void main(String[] aArgs) {
		final int limit = 8;
	    final int termCount = 15;
	
	    System.out.println("First " + termCount + " terms of the Padovan n-step number sequences:");	
	    padovan(limit, termCount);	
	}
	
	private static void padovan(int aLimit, int aTermCount) {
		List<Integer> previous = List.of( 1, 1, 1 );
		
		for ( int N = 2; N <= aLimit; N++ ) {
			List<Integer> next = new ArrayList<Integer>(previous.subList(0, N + 1));
			
			while ( next.size() < aTermCount ) {
				int sum = 0;
				for ( int stepBack = 2; stepBack <= N + 1; stepBack++ ) {
					sum += next.get(next.size() - stepBack);
				}
				next.add(sum);
			}
			
			System.out.print(N + ": ");
			next.forEach( term -> System.out.print(String.format("%4d", term)));
			System.out.println();
			
			previous = next;
		}	
	}

}
