import java.util.ArrayList;
import java.util.List;

public final class AbelianSandpileModel {

	public static void main(String[] aArgs) {
		Sandpile avalanche = new Sandpile(List.of( 4, 3, 3, 3, 1, 2, 0, 2, 3 ));
		System.out.println("Avalanche reduction to stable state:");
		avalanche.display();
		System.out.println(" ==> ");
		avalanche.stabilise();
		avalanche.display();
		
		Sandpile s1 = new Sandpile(List.of( 1, 2, 0, 2, 1, 1, 0, 1, 3 ));
		Sandpile s2 = new Sandpile(List.of( 2, 1, 3, 1, 0, 1, 0, 1, 0 ));
		Sandpile sum1 = s1.add(s2);
		Sandpile sum2 = s2.add(s1);
		System.out.println(System.lineSeparator() + "Commutativity of addition" + System.lineSeparator());
		System.out.println("Sandpile1 + Sandpile2:");
		sum1.display();
		System.out.println("Sandpile2 + Sandpile1:");
		sum2.display();
		System.out.println("Sandpile1 + Sandpile2 = Sandpile2 + Sandpile1: " + sum1.equals(sum2));
		
		Sandpile s3 = new Sandpile(List.of( 3, 3, 3, 3, 3, 3, 3, 3, 3 ));
		Sandpile s3_id = new Sandpile(List.of( 2, 1, 2, 1, 0, 1, 2, 1, 2 ));
		Sandpile sum3 = s3.add(s3_id);
		Sandpile sum4 = s3_id.add(s3_id);
		System.out.println(System.lineSeparator() + "Identity Sandpile" + System.lineSeparator());
		System.out.println("Sandpile3 + Sandpile3_id:");
		sum3.display();
		System.out.println("Sandpile3_id + Sandpile3_id:");
		sum4.display();		
	}

}

final class Sandpile {
	
    public Sandpile(List<Integer> aList) {
    	if ( aList.size() != CELL_COUNT ) {
    		throw new IllegalArgumentException("Initialiser list must contain " + CELL_COUNT + " elements");
    	}    	
    	cells = new ArrayList<Integer>(aList);    	
    }

    public void stabilise() {
    	while ( ! isStable() ) {
            topple();
    	}
    }

    public boolean isStable() {
    	return cells.stream().noneMatch( i -> i >= CELL_LIMIT );
    }

    public void topple() {
    	for ( int i = 0; i < CELL_COUNT; i++ ) {
    		if ( cells.get(i) >= CELL_LIMIT ) {
	            cells.set(i, cells.get(i) - CELL_LIMIT);
	            final int row = rowIndex(i);
	            final int col = colIndex(i);
	            if ( row > 0 ) {
	            	increment(row - 1, col);
	            }
	            if ( row + 1 < ROW_COUNT ) {
	                increment(row + 1, col);
	            }
	            if ( col > 0 ) {
	                increment(row, col - 1);
	            }
	            if ( col + 1 < COL_COUNT ) {
	                increment(row, col + 1);
	            }
    		}
	    }
    }

    public Sandpile add(Sandpile aOther) {
    	List<Integer> list = new ArrayList<Integer>();
    	for ( int i = 0; i < CELL_COUNT; i++ ) {
            list.add(cells.get(i) + aOther.cells.get(i));
    	}
    	Sandpile result = new Sandpile(list);
        result.stabilise();
        return result;
    }

    public boolean equals(Sandpile aOther) {
    	return cells.equals(aOther.cells);
    }

    public void display() {
    	for ( int i = 0; i < CELL_COUNT; i++ ) {
    		System.out.print(cells.get(i));
    		System.out.print( ( colIndex(i + 1) == 0 ) ? System.lineSeparator() : " ");
    	}
    }

	private void increment(int aRow, int aCol) {
		final int index = cellIndex(aRow, aCol);
		cells.set(index, cells.get(index) + 1);
	}

    private static int cellIndex(int aRow, int aCol) {
        return aRow * COL_COUNT + aCol;
    }

    private static int rowIndex(int aCellIndex) {
        return aCellIndex / COL_COUNT;
    }

    private static int colIndex(int aCellIndex) {
        return aCellIndex % COL_COUNT;
    }
	
    private List<Integer> cells;

	private static final int ROW_COUNT = 3;
	private static final int COL_COUNT = 3;
	private static final int CELL_COUNT = ROW_COUNT * COL_COUNT;
	private static final int CELL_LIMIT = 4;
	
}
