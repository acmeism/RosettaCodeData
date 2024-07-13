import java.awt.Point;
import java.util.ArrayDeque;
import java.util.List;
import java.util.Queue;

public final class TopicVariable {

	public static void main(String[] args) {
		List<Integer> numbers = List.of( 1, 2, 3, 4, 5, 6, 7, 8, 9 );
		// Example 1:		
		// We only want to count the number of elements in a list,
		// so a topic variable can be used for the identify of each element of the list.
		// An artificial example since we could just use 'total = numbers.size()'.
	    int total = 0;
	    for ( Integer _ : numbers ) { // Topic variable
	        total += 1;
	    }
	    System.out.println("The list contains " + total + " numbers");
		
	    // Example 2:
	    // A topic variable is suitable for the unused identifier of the NumberFormatException.
		String text = "123456:@~";
		int i = 0;
		try {
		    i = Integer.parseInt(text);
		} catch(NumberFormatException _) { // Topic variable
		    System.out.println("Variable i is incorrectly defined with value: " + i);
		}
		
		// Example 3:
		// We only require the first two out of every three items in a queue.
		// A topic variable can be used for the third unused item.
		Queue<Integer> queue = new ArrayDeque<Integer>(numbers);
		while ( queue.size() >= 3 ) {
			int x = queue.poll();
		    int y = queue.poll();
		    int _ = queue.poll(); // Topic variable
		    System.out.println( new Point(x, y) );
		}
	}

}
