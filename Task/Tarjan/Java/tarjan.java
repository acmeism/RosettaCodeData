import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Stack;

public final class TarjanSCC {
	
	public static void main(String[] aArgs) {
		Graph graph = new Graph(8);
		
		graph.addDirectedEdge(0, 1);
		graph.addDirectedEdge(1, 2); graph.addDirectedEdge(1, 7);
		graph.addDirectedEdge(2, 3); graph.addDirectedEdge(2, 6);
		graph.addDirectedEdge(3, 4);
		graph.addDirectedEdge(4, 2); graph.addDirectedEdge(4, 5);
		graph.addDirectedEdge(6, 3); graph.addDirectedEdge(6, 5);
		graph.addDirectedEdge(7, 0); graph.addDirectedEdge(7, 6);
		
		System.out.println("The strongly connected components are: ");
		for ( Set<Integer> component : graph.getSCC() ) {
			System.out.println(component);
		}		
	}
	
}

final class Graph {

	public Graph(int aSize) {		
		adjacencyLists = new ArrayList<Set<Integer>>(aSize);
		for ( int i = 0; i < aSize; i++ ) {
			vertices.add(i);
			adjacencyLists.add( new HashSet<Integer>() );
		}		
	}
	
	public void addDirectedEdge(int aFrom, int aTo) {
		adjacencyLists.get(aFrom).add(aTo);
	}
	
	public List<Set<Integer>> getSCC() {
		for ( int vertex : vertices ) {
			if ( ! numbers.keySet().contains(vertex) ) {
				stronglyConnect(vertex);
			}
		}
		
		return stronglyConnectedComponents;
	}
	
	private void stronglyConnect(int aVertex) {
		numbers.put(aVertex, index);
		lowlinks.put(aVertex, index);
		index += 1;
		stack.push(aVertex);
		
		for ( int adjacent : adjacencyLists.get(aVertex) ) {
			if ( ! numbers.keySet().contains(adjacent) ) {
				stronglyConnect(adjacent);				
				lowlinks.put(aVertex, Math.min(lowlinks.get(aVertex), lowlinks.get(adjacent)));
			} else if ( stack.contains(adjacent) ) {			
				lowlinks.put(aVertex, Math.min(lowlinks.get(aVertex), numbers.get(adjacent)));
			}
		}
		
		if ( lowlinks.get(aVertex) == numbers.get(aVertex) ) {
			Set<Integer> stonglyConnectedComponent = new HashSet<Integer>();
			int top;
			do {
				top = stack.pop();
				stonglyConnectedComponent.add(top);
			} while ( top != aVertex );
						
			stronglyConnectedComponents.add(stonglyConnectedComponent);
		}
	}		
	
	private List<Set<Integer>> adjacencyLists;
	private List<Integer> vertices = new ArrayList<Integer>();	
	private int index = 0;
	private Stack<Integer> stack = new Stack<Integer>();
	private Map<Integer, Integer> numbers = new HashMap<Integer, Integer>();
	private Map<Integer, Integer> lowlinks = new HashMap<Integer, Integer>();
	private List<Set<Integer>> stronglyConnectedComponents = new ArrayList<Set<Integer>>();

}
