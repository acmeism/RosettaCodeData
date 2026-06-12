import java.util.ArrayList;
import java.util.List;
import java.util.Stack;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class GabowsAlgorithm {

	public static void main(String[] args) {		
		record Edge(int from, int to) {}

		List<Edge> edges = List.of( new Edge(4, 2), new Edge(2, 3), new Edge(3, 2), new Edge(6, 0), new Edge(0, 1),
			new Edge(2, 0), new Edge(11, 12), new Edge(12, 9), new Edge(9, 10), new Edge(9, 11), new Edge(8, 9),
			new Edge(10, 12), new Edge(0, 5), new Edge(5, 4), new Edge(3, 5), new Edge(6, 4), new Edge(6, 9),
			new Edge(7, 6), new Edge(7, 8), new Edge(8, 7), new Edge(5, 3), new Edge(0, 6) );
		
		Digraph digraph = new Digraph(13);
		
		edges.forEach( edge -> digraph.addEdge(edge.from, edge.to) );
		System.out.println("Constructed digraph:");
		System.out.println(digraph);
		
		GabowSCC gabowSCC = new GabowSCC(digraph);
		System.out.println("It has " + gabowSCC.stronglyConnectedComponentCount() + " strongly connected components.");
		
		List<List<Integer>> components = gabowSCC.components();
		System.out.println(System.lineSeparator() + "Components:");
		IntStream.range(0, components.size()).forEach( i -> {
			System.out.println("Component " + i + ": " +
				components.get(i).stream().map(String::valueOf).collect(Collectors.joining(" ")));
		} );
		
		// Example usage of the isStronglyConnected() and componentID() methods
		System.out.println(System.lineSeparator() + "Example connectivity checks:");
		System.out.println("Vertices 0 and 3 strongly connected? " + gabowSCC.isStronglyConnected(0, 3));
		System.out.println("Vertices 0 and 7 strongly connected? " + gabowSCC.isStronglyConnected(0, 7));
		System.out.println("Vertices 9 and 12 strongly connected? " + gabowSCC.isStronglyConnected(9, 12));
		System.out.println("Component ID of vertex 5: " + gabowSCC.componentID(5));
		System.out.println("Component ID of vertex 8: " + gabowSCC.componentID(8));
	}

}

/**
 * Determination of the strongly connected components (SCC's) of a directed graph using Gabow's algorithm.
 */
final class GabowSCC {
	
	public GabowSCC(Digraph digraph) {
	    visited = Stream.generate( () -> false ).limit(digraph.vertexCount()).collect(Collectors.toList());
	    componentIDs = IntStream.range(0, digraph.vertexCount()).boxed().map( i -> NONE ).collect(Collectors.toList());
	    preorders = IntStream.range(0, digraph.vertexCount()).boxed().map( i -> NONE ).collect(Collectors.toList());
	    preorderCount = 0;
	    sccCount = 0;
	    visitedVerticesStack = new Stack<Integer>();
	    auxiliaryStack = new Stack<Integer>();

	    IntStream.range(0, digraph.vertexCount()).forEach( vertex -> {
	    	if ( ! visited.get(vertex) ) {
	    		depthFirstSearch(digraph, vertex);
	    	}
	    } );
	}
	
	// Return, for each vertex, a list of its strongly connected vertices
	public List<List<Integer>> components() {
		List<List<Integer>> components = IntStream.range(0, sccCount).boxed()
												  .map( i -> new ArrayList<Integer>() ).collect(Collectors.toList());
		for ( int vertex = 0; vertex < visited.size(); vertex++ ) {
		    final int componentID =  componentID(vertex);
		    if ( componentID != NONE ) { // This would normally be true
		        components.get(componentID).addLast(vertex);
		    } else {
		        // Could be caused by the digraph edges being changed by the user
		        throw new AssertionError("Warning: Vertex " + vertex + " has no SCC ID assigned.");
		    }
		}
		return components;
	}
	
	// Return whether or not vertices 'v' and 'w' are in the same strongly connected component.
    public boolean isStronglyConnected(int v, int w) {
        validateVertex(v);
        validateVertex(w);
        // If either vertex was not visited, for example, due to it being in an unconnected graph component,
        // its id will be 'NONE', and they cannot be strongly connected unless
        // the graph is empty or has isolated vertices which is handled by the return condition below.
        return componentIDs.get(v) != NONE && componentIDs.get(v) == componentIDs.get(w);
    }
	
	// Return the component ID of the strong component containing 'vertex'.
    public int componentID(int vertex) {
        validateVertex(vertex);
        return componentIDs.get(vertex);
    }
	
	public int stronglyConnectedComponentCount() {
		return sccCount;
	}
	
	private void depthFirstSearch(Digraph digraph, int vertex) {
        visited.set(vertex, true);
        preorders.set(vertex, preorderCount);
        preorderCount += 1;
        visitedVerticesStack.push(vertex);
        auxiliaryStack.push(vertex);

        digraph.adjacencyList(vertex).forEach( w -> {
            if ( ! visited.get(w) ) {
                depthFirstSearch(digraph, w);
                // If 'w' is visited, but not yet assigned to a SCC,
                // then 'w' is on the current depth first path,
                // or in a SCC which has already been processed in this depth first path,
                // and this will be handled by the 'auxiliaryStack'.
            } else if ( componentIDs.get(w) == NONE ) {
                // Pop vertices from the 'auxiliaryStack' until the top vertex has a preorder <= preorder of 'w'.
                // This maintains the invariant that 'auxiliaryStack' contains a path of potential SCC roots.
                while ( ! auxiliaryStack.isEmpty() && preorders.get(auxiliaryStack.peek()) > preorders.get(w) ) {
                	auxiliaryStack.pop();
                }
            }
        } );

        // 'vertex' is the root of a SCC,
        // if it remains on top of the 'auxiliaryStack' after exploring all of its descendants and back-edges.
        if ( ! auxiliaryStack.isEmpty() && auxiliaryStack.peek() == vertex ) {
            auxiliaryStack.pop();
            // Pop vertices from the 'auxiliartStack' until 'vertex' is popped,
            // and assign these vertices the current strongly connected component id.
            while ( ! visitedVerticesStack.isEmpty() ) {
                final int w = visitedVerticesStack.pop();
                componentIDs.set(w, sccCount);
                if ( w == vertex ) {
                	break;
                }
            }
            sccCount += 1;
        }
	}
	
    private void validateVertex(int vertex) {
        final int visitedCount = visited.size();
        if ( vertex < 0 || vertex >= visitedCount ) {
        	throw new AssertionError("Vertex " + vertex + " is not between 0 and " + ( visitedCount - 1 ));
        }
    }
	
	private List<Boolean> visited; // stores the vertices that have been visited
	private List<Integer> componentIDs; // the unique id number of each strongly connected component
	private List<Integer> preorders; // stores the preorder of vertices
	private int preorderCount; // the number of preorders of vertices
	private int sccCount; // the number of strongly connected components
	private Stack<Integer> visitedVerticesStack; // stores vertices in the order of their visit
	private Stack<Integer> auxiliaryStack; // auxiliary stack for finding SCC roots
	
	private static final int NONE = -1;
	
}

/**
 * Representation of a directed graph, or digraph, using adjacency lists.
 * Vertices are identified by integers starting from zero.
 */
final class Digraph {
	
	 public Digraph(int aVertexCount) {
         if ( aVertexCount < 0 ) {
        	 throw new AssertionError("Number of vertices must be non-negative");
         }

         vertexCount = aVertexCount;
         edgeCount = 0;
         adjacencyLists = IntStream.range(0, vertexCount).boxed()
                                   .map( i -> new ArrayList<Integer>() ).collect(Collectors.toList());
    }
	
	 public void addEdge(int from, int to) {
        validateVertex(from);
        validateVertex(to);
        adjacencyLists.get(from).addLast(to);
        edgeCount += 1;
    }

    public String toString() {
        String result = "Digraph has " + vertexCount + " vertices and " + edgeCount + " edges"
        					+ System.lineSeparator() + "Adjacency lists:" + System.lineSeparator();
        for ( int vertex = 0; vertex < vertexCount; vertex++ ) {
            result += ( vertex < 10 ? " " : "" ) + vertex + ": "
                + adjacencyLists.get(vertex).stream().map(String::valueOf).sorted().collect(Collectors.joining(" "))
                + System.lineSeparator();
        }
        return result;
    }

    public int vertexCount() {
    	return vertexCount;
    }

    public int edgeCount() {
    	return edgeCount;
    }

    public List<Integer> adjacencyList(int vertex) {
        validateVertex(vertex);
        return adjacencyLists.get(vertex);
    }

    private void validateVertex(int vertex) {
        if ( vertex < 0 || vertex >= vertexCount ) {
        	throw new AssertionError("Vertex must be between 0 " + vertexCount + ": " + vertex);
        }
    }

    private int vertexCount;
    private int edgeCount;
    private List<List<Integer>> adjacencyLists;

}
