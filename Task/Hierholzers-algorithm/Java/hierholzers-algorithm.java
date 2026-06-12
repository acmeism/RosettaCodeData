import java.util.ArrayList;
import java.util.List;
import java.util.Stack;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class HierholzesAlgorithm {

	public static void main(String[] args) {
		List<List<Integer>> adjacencyList1 = new ArrayList<List<Integer>>();		
		adjacencyList1.addLast( Stream.of( 1 ).collect(Collectors.toList()) );
		adjacencyList1.addLast( Stream.of( 2 ).collect(Collectors.toList()) );
		adjacencyList1.addLast( Stream.of( 0 ).collect(Collectors.toList()) );
		
		printCircuit(adjacencyList1);
				
		List<List<Integer>> adjacencyList2 = new ArrayList<List<Integer>>();	
		adjacencyList2.addLast( Stream.of( 1, 6 ).collect(Collectors.toList()) );
		adjacencyList2.addLast( Stream.of( 2 )   .collect(Collectors.toList()) );
		adjacencyList2.addLast( Stream.of( 0, 3 ).collect(Collectors.toList()) );		
		adjacencyList2.addLast( Stream.of( 4 )   .collect(Collectors.toList()) );
		adjacencyList2.addLast( Stream.of( 2, 5 ).collect(Collectors.toList()) );
		adjacencyList2.addLast( Stream.of( 0 )   .collect(Collectors.toList()) );
		adjacencyList2.addLast( Stream.of( 4 )   .collect(Collectors.toList()) );

		printCircuit(adjacencyList2);	
	}
	
	 public static void printCircuit(List<List<Integer>> adjacencyList) {
		 if ( adjacencyList.isEmpty() ) {
			 return;
	     }
		
		 Stack<Integer> path = new Stack<Integer>();
	     List<Integer> circuit = new ArrayList<Integer>();
	
	     int currentVertex = 0; // Start at vertex 0
	     path.push(currentVertex);	
	     while ( ! path.isEmpty() ) {
	         if ( ! adjacencyList.get(currentVertex).isEmpty() ) {
	             path.push(currentVertex);
	             final int nextVertex = adjacencyList.get(currentVertex).getLast();
	             adjacencyList.get(currentVertex).removeLast();
	             currentVertex = nextVertex;
	         } else { // Back-tracking
	             circuit.add(currentVertex);
	             currentVertex = path.pop();
	         }
	     }
	
        for ( int i = circuit.size() - 1; i >= 0; i-- ) { // Print the circuit
            System.out.print(circuit.get(i));
            if ( i != 0 ) {
                System.out.print(" => ");
            }
        }
        System.out.println();
    }
	
}
