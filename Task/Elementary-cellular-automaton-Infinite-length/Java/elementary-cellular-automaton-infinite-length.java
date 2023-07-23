public final class ElementaryCellularAutomatonInfiniteLength {

	public static void main(String[] aArgs) {
		evolve(35, 90);
	    System.out.println();
	}
	
	private static void evolve(int aLimit, int aRule) {
		System.out.println(" Rule# " + aRule);
	    StringBuilder cells = new StringBuilder(Character.toString(STAR));
	    for ( int i = 0; i < aLimit; i++ ) {
	        addCells(cells);
	        final int width = 40 - ( cells.length() >> 1 );
	        System.out.println(" ".repeat(width) + cells);
	        cells = nextStep(cells, aRule);
	    }
	}
	
	private static void addCells(StringBuilder aCells) {
		final char left = ( aCells.charAt(0) == STAR ) ? DOT : STAR;
	    final char right = ( aCells.charAt(aCells.length() - 1 ) == STAR ) ? DOT : STAR;
	    for ( int i = 0; i < 2; i++ ) {
	        aCells.insert(0, left);
	        aCells.append(right);
	    }
	}
	
	private static StringBuilder nextStep(StringBuilder aCells, int aRule) {
	    StringBuilder nextCells = new StringBuilder();
	    for ( int i = 0; i < aCells.length() - 2; i++ ) {
	        int binary = 0;
	        int shift = 2;
	        for ( int j = i; j < i + 3; j++ ) {
	            binary += ( ( aCells.charAt(j) == STAR ) ? 1 : 0 ) << shift;
	            shift >>= 1;
	        }
	        final char symbol = ( ( aRule & ( 1 << binary ) ) == 0 ) ? DOT : STAR;
	        nextCells.append(symbol);
	    }
	    return nextCells;
	}
	
	private static final char DOT = '.';
	private static final char STAR = '*';

}
