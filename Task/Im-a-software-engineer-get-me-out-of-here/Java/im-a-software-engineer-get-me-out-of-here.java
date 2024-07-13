import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class ImASoftwareEngineerGetMeOutOfHere {

	public static void main(String[] args) {
		searchFromCell(11, 11);
		showShortestRoutesToSafety();
		System.out.println();
		
		searchFromCell(21, 11);
		System.out.println("The shortest route from (21, 11) to (1, 11):");
		System.out.println(createRouteToCell(1, 11));
		System.out.println();
		
		searchFromCell(1, 11);
		System.out.println("The shortest route from (1, 11) to (21, 11):");
		System.out.println(createRouteToCell(21, 11));
		System.out.println();
		
		searchFromCell(11, 11);
		showUnreachableCells();
		System.out.println();
		
		showCellsWithLongestRouteFromHQ();	
	}
	
	private static void searchFromCell(int row, int col) {	
	    routes = IntStream.range(0, HEIGHT).boxed()
	    	.map( i -> new ArrayList<CellWithCost>(Collections.nCopies(WIDTH, CellWithCost.ZERO)) )
	    	.collect(Collectors.toList());	
	    routes.get(row).set(col, new CellWithCost(row, col, 0));
	
	    List<CellWithCost> route = new ArrayList<CellWithCost>();
	    int cost = 0;
	
	    while ( true ) {
	        final int startDigit = Character.digit(GMOOH[row].charAt(col), 10);
	        for ( Cell direction : directions ) {	
	            final int nextRow = row + startDigit * direction.row;
	            final int nextCol = col + startDigit * direction.col;
	            if ( nextCol >= 0 && nextCol < WIDTH && nextRow >= 0 && nextRow < HEIGHT
	            	&& Character.digit(GMOOH[nextRow].charAt(nextCol), 10) >= 0 ) {
	                CellWithCost currentCell = routes.get(nextRow).get(nextCol);
	                if ( currentCell.equals(CellWithCost.ZERO) || currentCell.cost > cost + 1 ) {
	                    routes.get(nextRow).set(nextCol, new CellWithCost(row, col, cost + 1));
	                    if ( Character.digit(GMOOH[nextRow].charAt(nextCol), 10) > 0 ) {
	                        route.addLast( new CellWithCost(nextRow, nextCol, cost + 1) );
	                    }
	                }
	            }
	        }
	
	        if ( route.isEmpty() ) { // All routes have been searched
	        	break;
	        }
	
	        CellWithCost nextCell = route.removeFirst();
	        row = nextCell.fromRow;
	        col = nextCell.fromCol;
	        cost = nextCell.cost;
	    }
	}
	
	private static void showShortestRoutesToSafety() {
	    int minimumCost = Integer.MAX_VALUE;
	    List<Cell> cells = new ArrayList<Cell>();
	    for ( int col = 0; col < WIDTH; col++ ) {
	        for ( int row = 0; row < HEIGHT; row++ ) {
	            if ( Character.digit(GMOOH[row].charAt(col), 10) == 0 ) {
	                CellWithCost currentCell = routes.get(row).get(col);
	                if ( ! currentCell.equals(CellWithCost.ZERO) ) {
	                    final int cost = currentCell.cost;
	                    if ( cost <= minimumCost ) {
	                        if ( cost < minimumCost ) {
	                            cells.clear();
	                            minimumCost = cost;
	                        }
	                        cells.addLast( new Cell(row, col) );
	                    }
	                }
	            }
	        }
	    }
	
	    String areIs  = ( cells.size() > 1 ) ? "are " : "is ";
	    String plural = ( cells.size() > 1 ) ? "s" : "";
	    System.out.println("There " + areIs + cells.size() + " shortest route" + plural
	    				   + " of " + minimumCost + " days to safety:");
	    for ( Cell cell : cells ) {
	    	System.out.println(createRouteToCell(cell.row, cell.col));
	    }
	}
	
	private static List<Cell> createRouteToCell(int row, int col) {
	    List<Cell> route = new ArrayList<Cell>();
	    route.addLast( new Cell(row, col) );
	
	    while ( true ) {
	    	CellWithCost currentCell = routes.get(row).get(col);
	        if ( currentCell.cost == 0 ) {
	        	break;
	        }
	
	        row = currentCell.fromRow;
	        col = currentCell.fromCol;
	        route.addFirst( new Cell(row, col) );
	    }	
	    return route;
	}
	
	private static void showUnreachableCells() {
		List<Cell> unreachableCells = new ArrayList<Cell>();
		for ( int col = 0; col < WIDTH; col++ ) {
	        for ( int row = 0; row < HEIGHT; row++ ) {
	        	if ( Character.digit(GMOOH[row].charAt(col), 10) >= 0
	        		&& routes.get(row).get(col).equals(CellWithCost.ZERO) ) {
			        unreachableCells.addLast( new Cell(row, col) );
	        	}
	        }
		}
		
		System.out.println("The following cells are unreachable:");
		System.out.println(unreachableCells);
	}
	
	private static void showCellsWithLongestRouteFromHQ() {
		int maximumCost = Integer.MIN_VALUE;
		List<Cell> cells = new ArrayList<Cell>();
		for ( int col = 0; col < WIDTH; col++ ) {
	        for ( int row = 0; row < HEIGHT; row++ ) {
	        	if ( Character.digit(GMOOH[row].charAt(col), 10) >= 0 ) {
	        		CellWithCost currentCell = routes.get(row).get(col);
	        		if ( ! currentCell.equals(CellWithCost.ZERO) ) {
	        			final int cost = currentCell.cost;
	        			if ( cost >= maximumCost) {
	        				if ( cost > maximumCost ) {
	        					cells.clear();
	        					maximumCost = cost;
	        				}
	        				cells.addLast( new Cell(row, col) );
	        			}
	        		}
	        	}
	        }
		}
		
		System.out.println("There are " + cells.size() + " cells that require " + maximumCost
						   + " days to receive reinforcements from HQ:");
		for ( Cell cell : cells ) {
			System.out.println(createRouteToCell(cell.row, cell.col));
		}
	}
	
	private static List<List<CellWithCost>> routes;
	
	private static final List<Cell> directions = List.of( new Cell(1, -1),  new Cell(1, 0),  new Cell(1, 1),
            										 	  new Cell(0, -1),                   new Cell(0, 1),
            										 	  new Cell(-1, -1), new Cell(-1, 0), new Cell(-1, 1) );
	
	private static record CellWithCost(int fromRow, int fromCol, int cost) {
		
		public boolean equals(CellWithCost other) {
			return cost == other.cost && fromRow == other.fromRow && fromCol == other.fromCol;
		}		
		
		public static CellWithCost ZERO = new CellWithCost(0, 0, 0);
		
	}	
	
	private static record Cell(int row, int col) {
		
		public String toString() {
			return "(" + row + ", " + col + ")";
		}
		
	}
	
	private static final String[] GMOOH = """
		.........00000.........
		......00003130000......
		....000321322221000....
		...00231222432132200...
		..0041433223233211100..
		..0232231612142618530..
		.003152122326114121200.
		.031252235216111132210.
		.022211246332311115210.
		00113232262121317213200
		03152118212313211411110
		03231234121132221411410
		03513213411311414112320
		00427534125412213211400
		.013322444412122123210.
		.015132331312411123120.
		.003333612214233913300.
		..0219126511415312570..
		..0021321524341325100..
		...00211415413523200...
		....000122111322000....
		......00001120000......
		.........00000.........
		""".split("\n");

	private static final int WIDTH  = GMOOH[0].length();
	private static final int HEIGHT = GMOOH.length;

}
