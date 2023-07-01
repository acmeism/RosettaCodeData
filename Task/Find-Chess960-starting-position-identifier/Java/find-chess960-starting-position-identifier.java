import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Predicate;

public final class Chess960SPID {

	public static void main(String[] aArgs) {
		String[] positions = { "QNRBBNKR", "RNBQKBNR", "RQNBBKRN", "RNQBBKRN" };
		
		createKnightsTable();
		
		for ( String position : positions ) {		
			validate("RQNBBKRN");
			System.out.println("Position " + position + " has Chess960 SP-ID = " + calculateSPID(position));
		}
	}
	
	private static void validate(String aPosition) {
		if ( aPosition.length() != 8 ) {
			throw new AssertionError("Chess position has invalid length: " + aPosition.length() + ".");
		}
		
		Map<Character, Integer> pieces = new HashMap<Character, Integer>();
		for ( char ch : aPosition.toCharArray() ) {
			pieces.merge(ch, 1, (oldV, newV) -> oldV + 1);
		}
		Set<Map.Entry<Character, Integer>> correctPieces =
			Set.of(Map.entry('R', 2), Map.entry('N', 2), Map.entry('B', 2), Map.entry('Q', 1), Map.entry('K', 1));
		if ( ! pieces.entrySet().equals(correctPieces) ) {
			throw new AssertionError("Chess position contains incorrect pieces.");
		}
		
		List<Integer> bishops = List.of(aPosition.indexOf('B'), aPosition.lastIndexOf('B'));
		if ( ( bishops.get(1) - bishops.get(0) ) % 2 == 0 ) {
			throw new AssertionError("Bishops must be on different coloured squares.");
		}
		
		List<Integer> rookKing = List.of(aPosition.indexOf('R'), aPosition.indexOf('K'), aPosition.lastIndexOf('R'));
		if ( ! ( rookKing.get(0) < rookKing.get(1) && rookKing.get(1) < rookKing.get(2) ) ) {
			throw new AssertionError("The king must be between the two rooks.");
		}
	}
	
	private static int calculateSPID(String aPosition) {
		String noBishopsOrQueen = retainIf(aPosition, s -> s != 'B' && s != 'Q');
		final int N = knightsTable.get(List.of(noBishopsOrQueen.indexOf('N'), noBishopsOrQueen.lastIndexOf('N')));
		
		String noBishops = retainIf(aPosition, s -> s != 'B');
		final int Q = noBishops.indexOf('Q');

		final int indexOne = aPosition.indexOf('B');
		final int indexTwo = aPosition.lastIndexOf('B');
		final int D = ( indexOne % 2 == 0 ) ? indexOne / 2 : indexTwo / 2;
		final int L = ( indexOne % 2 == 0 ) ? indexTwo / 2 : indexOne / 2;
		
		return 96 * N + 16 * Q + 4 * D + L;
	}
	
	private static String retainIf(String aText, Predicate<Character> aPredicate) {
		return aText.chars()
				    .mapToObj( i -> (char) i )
				    .filter(aPredicate)
				    .map(String::valueOf)
				    .reduce("", String::concat);
	}
	
	private static void createKnightsTable() {
		knightsTable = new HashMap<List<Integer>, Integer>();
		knightsTable.put(List.of(0, 1), 0);
		knightsTable.put(List.of(0, 2), 1);
		knightsTable.put(List.of(0, 3), 2);
		knightsTable.put(List.of(0, 4), 3);
		knightsTable.put(List.of(1, 2), 4);
		knightsTable.put(List.of(1, 3), 5);
		knightsTable.put(List.of(1, 4), 6);
		knightsTable.put(List.of(2, 3), 7);
		knightsTable.put(List.of(2, 4), 8);
		knightsTable.put(List.of(3, 4), 9);
	}	
	
	private static Map<List<Integer>, Integer> knightsTable;

}
