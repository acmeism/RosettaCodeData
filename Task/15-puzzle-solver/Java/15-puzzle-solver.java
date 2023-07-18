import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Set;
import java.util.stream.Collectors;

public final class Puzzle15Solver {

    public static void main(String[] aArgs) {
        List<Integer> start = List.of( 15, 14, 1, 6, 9, 11, 4, 12, 0, 10, 7, 3, 13, 8, 5, 2 );
        final int zeroIndex = 8;
        Puzzle initial = new Puzzle(start, new ArrayList<String>(), zeroIndex, 0);
        openSet.add(initial);
        System.out.println("Solving the 15 puzzle:");
        initial.display();

        while ( solution == null ) {
            search();
        }

        System.out.println(solution.moves.stream().collect(Collectors.joining("")));
        System.out.println("Number of steps: " + solution.moves.size());
        System.out.println("Number of puzzle states checked: " + closedSet.size());
    }

    private static void search() {
		Puzzle current = openSet.poll();
	    closedSet.add(current);
	    final int zeroIndex = current.zeroIndex;
	    final int row = zeroIndex / 4;
        final int column = zeroIndex % 4;
	
		if ( column > 0 ) {
			Puzzle nextPuzzle = current.clone();
			nextPuzzle.makeMove(Move.LEFT);
	    }
	    if ( column < 3 ) {
	    	Puzzle nextPuzzle = current.clone();
	    	nextPuzzle.makeMove(Move.RIGHT);
	    }
	    if ( row > 0 ) {
	    	Puzzle nextPuzzle = current.clone();
	    	nextPuzzle.makeMove(Move.UP);
	    }
	    if ( row < 3 ) {
	    	Puzzle nextPuzzle = current.clone();
	    	nextPuzzle.makeMove(Move.DOWN);
	    }
	}

    private enum Move {		
		LEFT("L", -1), RIGHT("R", +1), UP("U", -4), DOWN("D", +4);		
		
		private Move(String aSymbol, int aStep) {
			symbol = aSymbol;
			step = aStep;
		}
		
		private String symbol;
		private Integer step;		
	}

    private static class Puzzle {

        public Puzzle(List<Integer> aTiles, List<String> aMoves, int aZeroIndex, int aSearchDepth) {
        	tiles = aTiles;
            moves = aMoves;
            zeroIndex = aZeroIndex;
            searchDepth = aSearchDepth;
        }

        public void makeMove(Move aMove) {    		
    		Integer temp = tiles.get(zeroIndex + aMove.step);
    		tiles.set(zeroIndex + aMove.step, 0);
    		tiles.set(zeroIndex, temp);
    		
    		zeroIndex += aMove.step;
    		moves.add(aMove.symbol);
    		
    		if ( ! closedSet.contains(this) ) {
                openSet.add(this);
                if ( tiles.equals(Puzzle.GOAL) ) {
                    solution = this;
                }
            }
    	}

        public long heuristic() {
        	int distance = 0;
        	for ( int i = 0; i < tiles.size(); i++ ) {
        		final int tile = tiles.get(i);
            	if ( tile > 0 ) {
            		distance += Math.abs( ( i / 4 ) - ( tile - 1 ) / 4 ) + Math.abs( ( i % 4 ) - ( tile - 1 ) % 4 );
            	}
            }
            return distance + searchDepth;
        }

        public Puzzle clone() {
            return new Puzzle(new ArrayList<Integer>(tiles), new ArrayList<String>(moves), zeroIndex, searchDepth + 1);
        }

        public void display() {
        	 for ( int i = 0; i < tiles.size(); i++ ) {
                 System.out.print(String.format("%s%2d%s",
                 	( i % 4 == 0 ) ? "[" : "", tiles.get(i), ( i % 4 == 3 ) ? "]\n" : " "));
             }
             System.out.println();
        }

        @Override
        public boolean equals(Object aObject) {
        	return switch(aObject) {
        		case Puzzle puzzle -> tiles.equals(puzzle.tiles);
        		case Object object -> false;
        	};
        }

        @Override
        public int hashCode() {
            int hash = 3;
            hash = 23 * hash + tiles.hashCode();
            hash = 23 * hash + zeroIndex;
            return hash;
        }

        private List<Integer> tiles;
        private List<String> moves;
        private int zeroIndex;
        private int searchDepth;

        private static final List<Integer> GOAL = List.of( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0 );

    }

    private static Queue<Puzzle> openSet =
    	new PriorityQueue<Puzzle>( (one, two) -> Long.compare(one.heuristic(), two.heuristic()) );
    private static Set<Puzzle> closedSet = new HashSet<Puzzle>();
    private static Puzzle solution;

}
