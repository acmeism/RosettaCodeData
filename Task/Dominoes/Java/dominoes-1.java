import java.awt.Point;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class Dominos {

	public static void main(String[] args) {
		List.of( tableauOne, tableauTwo ).forEach( tableau -> {
			List<Pattern> patterns = findPatterns(tableau);
			System.out.println("Layouts found: " + patterns.size() + System.lineSeparator());
			printLayout(patterns.getFirst());
		} );
	}
	
	private static List<Pattern> findPatterns(int[][] tableau) {		
	    final int nRows = tableau.length;
	    final int nCols = tableau[0].length;
	    final int dominoCount = ( nRows * nCols ) / 2;
	    int[][] emptyTableau = IntStream.range(0, nRows)
	    	.mapToObj( i -> IntStream.range(0, nCols).map( j -> EMPTY ).toArray() ).toArray(int[][]::new);
	    List<Pattern> patterns = new ArrayList<Pattern>();
	    patterns.addLast( new Pattern(emptyTableau, new ArrayList<Domino>(), new ArrayList<Point>()) );
	
	    while ( true ) {
	        List<Pattern> nextPatterns = new ArrayList<Pattern>();
	        for ( Pattern pattern : patterns ) {
	        	int[][] nextTableau = pattern.tableau;
	        	List<Domino> dominoes = pattern.dominoes;
	        	List<Point> points = pattern.points;	        	
	        	final int index = IntStream.range(0, nRows * nCols)
	        		.filter( i -> nextTableau[i / nCols][i % nCols] == EMPTY ).findFirst().orElse(EMPTY);	
	        	if ( index == EMPTY ) {
	                continue;
	            }
	
	            int row = index / nCols;
	            int col = index % nCols;
	            if ( row + 1 < nRows && nextTableau[row + 1][col] == EMPTY ) {	
        	        Domino domino = new Domino(tableau[row][col], tableau[row + 1][col]);
        	        if ( ! dominoes.contains(domino) ) {        	        	
        	        	int[][] finalTableau = new int[nextTableau.length][];
        	        	for ( int i = 0; i < nextTableau.length; i++ ) {
        	        	      finalTableau[i] = new int[nextTableau[i].length];
        	        	      System.arraycopy(nextTableau[i], 0, finalTableau[i], 0, nextTableau[i].length);        	        		
        	        	}        	        	
        	        	finalTableau[row][col] = tableau[row][col];
        	        	finalTableau[row + 1][col] = tableau[row + 1][col];         	        	
        	        	List<Domino> nextDominoes = new ArrayList<Domino>(dominoes);
        	        	nextDominoes.addLast(domino);
        	        	List<Point> nextPoints = new ArrayList<Point>(points);
        	        	nextPoints.addAll(List.of( new Point(row, col), new Point(row + 1, col) ));
        	        	nextPatterns.addLast( new Pattern(finalTableau, nextDominoes, nextPoints) );
        	        }
	            }	
	
	            if ( col + 1 < nCols && nextTableau[row][col + 1] == EMPTY ) {
	                Domino domino = new Domino(tableau[row][col], tableau[row][col + 1]);
	                if ( ! dominoes.contains(domino) ) {
	                	nextTableau[row][col] = tableau[row][col];
	                	nextTableau[row][col + 1] = tableau[row][col + 1];	                	                	
            	        dominoes.add(domino);
            	        points.addAll(List.of( new Point(row, col), new Point(row, col + 1) ));
            	        nextPatterns.addLast( new Pattern(nextTableau, dominoes, points) );
	                }
	            }
	        }
	
	        if ( nextPatterns.isEmpty() ) {  	
	        	break;
	        }
	        patterns = nextPatterns;
	        if ( patterns.getFirst().dominoes.size() == dominoCount ) {
	        	break;
	        }	
	    }
	
	    return patterns;
	}	

	private static void printLayout(Pattern pattern) {	
		List<List<String>> output = IntStream.range(0, 2 * pattern.tableau.length)
		.mapToObj( i -> new ArrayList<String>(Collections.nCopies(2 * pattern.tableau[0].length - 1, " ")) )
		.collect(Collectors.toList());
		
	    for ( int i = 0; i < pattern.points.size() - 1; i += 2 ) {
	    	final int x1 = pattern.points.get(i).x;
	    	final int y1 = pattern.points.get(i).y;
	    	final int x2 = pattern.points.get(i + 1).x;
	    	final int y2 = pattern.points.get(i + 1).y;
	    	final int n1 = pattern.tableau[x1][y1];
	    	final int n2 = pattern.tableau[x2][y2];
	        output.get(2 * x1).set(2 * y1, String.valueOf(n1));
	        output.get(2 * x2).set(2 * y2, String.valueOf(n2));
	        if ( x1 == x2 ) {
	        	output.get(2 * x1).set(2 * y1 + 1, "+");
	        } else if ( y1 == y2 ) {
	        	output.get(2 * x1 + 1).set(2 * y1, "+");
	        }
	    }
	
	    output.forEach( i -> System.out.println(i.stream().collect(Collectors.joining())) );
	}
	
	private static class Domino {
	
		public Domino(int aOne, int aTwo) {
			one = Math.min(aOne, aTwo);
			two = Math.max(aOne, aTwo);
		}
		
		@Override
		public int hashCode() {
			return 2 * one + 3 * two;
		}
		
		@Override
		public boolean equals(Object other) {
			return switch ( other ) {
				case Domino domino -> one == domino.one && two == domino.two;
				case Object object -> false;
			};
		}
		
		private int one, two;		
	
	}
	
	private static final int EMPTY = -1;
	
	private static record Pattern(int[][] tableau, List<Domino> dominoes, List<Point> points) {}
	
	private static final int[][] tableauOne = { { 0, 5, 1, 3, 2, 2, 3, 1 },
												{ 0, 5, 5, 0, 5, 2, 4, 6 },
												{ 4, 3, 0, 3, 6, 6, 2, 0 },
	                                            { 0, 6, 2, 3, 5, 1, 2, 6 },
	                                            { 1, 1, 3, 0, 0, 2, 4, 5 },
	                                            { 2, 1, 4, 3, 3, 4, 6, 6 },
	                                            { 6, 4, 5, 1, 5, 4, 1, 4 } };
	
	private static final int[][] tableauTwo = { { 6, 4, 2, 2, 0, 6, 5, 0 },
	                                            { 1, 6, 2, 3, 4, 1, 4, 3 },
	                                            { 2, 1, 0, 2, 3, 5, 5, 1 },
	                                            { 1, 3, 5, 0, 5, 6, 1, 0 },
	                                            { 4, 2, 6, 0, 4, 0, 1, 1 },
	                                            { 4, 4, 2, 0, 5, 3, 6, 3 },
	                                            { 6, 6, 5, 2, 5, 3, 3, 4 } };	

}
