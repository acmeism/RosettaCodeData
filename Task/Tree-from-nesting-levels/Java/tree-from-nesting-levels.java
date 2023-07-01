import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public final class TreeNestingLevels {

	public static void main(String[] args) {
		List<List<Integer>> lists = List.of(
 			Arrays.asList(),
			Arrays.asList( 1, 2, 4 ),
			Arrays.asList( 3, 1, 3, 1 ),
			Arrays.asList( 1, 2, 3, 1 ),
			Arrays.asList( 3, 2, 1, 3 ),
			Arrays.asList( 3, 3, 3, 1, 1, 3, 3, 3 )
		);
		
		for ( List<Integer> list : lists ) {
		    List<Object> tree = createTree(list);
		    System.out.println(list + " --> " + tree);
		}	
	}
	
	private static List<Object> createTree(List<Integer> list) {
		return makeTree(list, 0, 1);
	}	
	
	private static List<Object> makeTree(List<Integer> list, int index, int depth) {
		List<Object> tree = new ArrayList<Object>();
		int current;
		
		while ( index < list.size() && depth <= ( current = list.get(index) ) ) {
			if ( depth == current ) {
				tree.add(current);
				index += 1;
			} else {
				tree.add(makeTree(list, index, depth + 1));
				final int position = list.subList(index, list.size()).indexOf(depth);
				index += ( position == -1 ) ? list.size() : position;
			}			
		}
		
		return tree;		
	}
	
}
