import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class WalshMatrix {

	public static void main(String[] args) {		
		for ( String type : List.of( "Natural", "Sequency" ) ) {	
			for ( int order : List.of( 2, 4, 5 ) ) {
			    int size = 1 << order;
			    System.out.println("Walsh matrix of order " + order + ", " + type + " order:");
			    List<List<Integer>> walsh = walshMatrix(size);
			    if ( type.equals("Sequency") ) {
			    	Collections.sort(walsh, rowComparator);
			    }
			    display(walsh);
			}
		}
	}
	
	private static List<List<Integer>> walshMatrix(int size) {
		List<List<Integer>> walsh = IntStream.range(0, size).boxed()
            .map( i -> new ArrayList<Integer>(Collections.nCopies(size, 0)) ).collect(Collectors.toList());		
		walsh.get(0).set(0, 1);
		
		int k = 1;
		while ( k < size ) {
	        for ( int i = 0; i < k; i++ ) {
	            for ( int j = 0; j < k; j++ ) {
	            	walsh.get(i + k).set(j, walsh.get(i).get(j));
	            	walsh.get(i).set(j + k, walsh.get(i).get(j));
	            	walsh.get(i + k).set(j + k, -walsh.get(i).get(j));
	            }
	        }
	        k += k;
		}
		return walsh;		
	}
	
	private static int signChangeCount(List<Integer> row) {
	    int signChanges = 0;
	    for ( int i = 1; i < row.size(); i++ ) {
	        if ( row.get(i - 1) == -row.get(i) ) {
	        	signChanges += 1;
	        }
	    }
	    return signChanges;
	}
	
	private static Comparator<List<Integer>> rowComparator =
		(one, two) -> Integer.compare(signChangeCount(one), signChangeCount(two));
	
	private static void display(List<List<Integer>> matrix) {
		for ( List<Integer> row : matrix ) {
			for ( int element : row ) {
				System.out.print(String.format("%3d", element));
			}
			System.out.println();
		}
		System.out.println();
	}	

}
