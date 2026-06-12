import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class HopcroftKarpAlgorithm {

	public static void main(String[] args) {		
		System.out.println("Running tests:");
	    int successCount = 0;

	    // Test Case 1
	    successCount = testValue(1, 3, 5, List.of( new Edge(1, 4) ), 1);
	
	    // Test Case 2
	    successCount += testValue(2, 6, 6, List.of( new Edge(1, 4), new Edge(1, 5), new Edge(5, 1) ), 2);
	
	    // Test Case 3: Complete Bipartite Graph K(3, 3)
	    List<Edge> edges = new ArrayList<Edge>();
	    for ( int i = 1; i <= 3; i++ ) {
	        for ( int j = 1; j <= 3; j++ ) {
	        	edges.addLast( new Edge(i, j) );
	        }
	    }
	    successCount += testValue(3, 3, 3, edges, 3);
	
	    // Test Case 4: No edges
	    successCount += testValue(4, 2, 2, List.of(), 0);
	
	    // Test Case 5
	    edges = List.of(
	    	new Edge(1, 1), new Edge(1, 3), new Edge(2, 3), new Edge(3, 4), new Edge(4, 3), new Edge(4, 2) );
	    successCount += testValue(5, 4, 4, edges, 4);

	    if ( successCount == 5 ) {
	    	System.out.println("All tests passed.");
	    }
	}	
	
	private static int testValue(int testNumber, int m, int n, List<Edge> edges, int expectedResult) {
		BipartiteGraph graph = new BipartiteGraph(m, n);
	    edges.forEach( edge -> graph.addEdge(edge.from, edge.to) );
	    final int result = graph.hopcroftKarpAlgorithm();
	    System.out.println("Test " + testNumber + ": Result = " + result + ", Expected = " + expectedResult);
	    if ( result == expectedResult ) {
	    	return 1;
	    }
	
	    System.out.println("Test " + testNumber + " failed.");	
	    return 0;
	}
	
	private record Edge(int from, int to) {}

}

/**
 * Representation of a bipartite graph.
 * Vertices in the left partition, U, are numbered from 1 to m,
 * and vertices in the right partition, V, are numbered 1 to n.
 */
final class BipartiteGraph {
	
	public BipartiteGraph(int aM, int aN) {
		m = aM;
		n = aN;
		
		adjacencyLists = IntStream.range(0, m + 1).boxed()
				                  .map( i -> new ArrayList<Integer>() ).collect(Collectors.toList());
		pairU = Stream.generate( () -> NIL ).limit(m + 1).collect(Collectors.toList());
		pairV = Stream.generate( () -> NIL ).limit(n + 1).collect(Collectors.toList());
		levels = Stream.generate( () -> INFINITY ).limit(m + 1).collect(Collectors.toList());
	}
	
	public void addEdge(int u, int v) {
        if ( 1 <= u && u <= m && 1 <= v && v <= n ) {
            adjacencyLists.get(u).addLast(v);
        } else {
            throw new AssertionError("Attempt to add an edge (" + u + ", " + v + ") which is out of bounds");
        }
    }
	
	/**
	 * Return the matching size of the bipartite graph.
	 */
    public int hopcroftKarpAlgorithm() {
        pairU = Stream.generate( () -> NIL ).limit(m + 1).collect(Collectors.toList());
		pairV = Stream.generate( () -> NIL ).limit(n + 1).collect(Collectors.toList());
        int matchingSize = 0;

        while ( breadthFirstSearch() ) {
            for ( int u = 1; u <= m; u++ ) {
                if ( pairU.get(u) == NIL && depthFirstSearch(u) ) { // vertex u is free and an augmenting path starting                	
                    matchingSize += 1;                              // from u has been found by the depth first search
                }
            }
        }
        return matchingSize;
    }
	
	/**
     * Determines whether there exists an augmenting path starting from a free vertex in U.
     *
     * Return true if an augmenting path could exist, otherwise false.
     */
    private boolean breadthFirstSearch() {
        Deque<Integer> queue = new ArrayDeque<Integer>();
        for ( int u = 1; u <= m; u++ ) { // Initialise 'levels' for the vertices in U
            if ( pairU.get(u) == NIL ) { // If u is a free vertex, its level is 0 add it is added to the queue
                levels.set(u, 0);
                queue.offerLast(u);
            } else { // Otherwise, set 'levels' to infinity
                levels.set(u, INFINITY);
            }
        }

        // The 'level' to the NIL node represents the length of the shortest augmenting path
        levels.set(NIL, INFINITY);

        while ( ! queue.isEmpty() ) {
            final int u = queue.pollFirst();
            if ( levels.get(u) < levels.get(NIL) ) { // The path through u could lead to a shorter augmenting path
                for ( int v : adjacencyLists.get(u) ) { // Explore the neighbours v of u in V
                    final int matchedU = pairV.get(v);
                    if ( levels.get(matchedU) == INFINITY ) { // The matched vertex has not been visited yet
                       levels.set(matchedU, levels.get(u) + 1);
                        queue.offerLast(matchedU); // Enqueue the matched vertex to explore it further
                    }
                }
            }
        }

        // An augmenting path from the initial free vertices was found if levels.get(NIL) is not INFINITY
        return levels.get(NIL) != INFINITY;
    }

    /**
     * Determine whether the shortest path from vertex u in U found by breadthFirstSearch() can be augmented.
     *
     * Return true if an augmenting path was found starting from u, otherwise false.
     */
    private boolean depthFirstSearch(int u) {
        if ( u != NIL ) {
            for ( int v : adjacencyLists.get(u) ) { // Explore neighbours v of u in V
                final int matchedU = pairV.get(v);
                // Check whether the edge (u, v) leads to a vertex matchedU
                // such that the path u -> v -> matchedU is part of a shortest augmenting path
                if ( levels.get(matchedU) == levels.get(u) + 1 ) {
                    if ( depthFirstSearch(matchedU) ) { // An augmenting path is found starting from 'matchedU'
                        pairV.set(v, u); // Match v with u,
                        pairU.set(u, v); // and u with v
                        return true;
                    }
                }
            }

            // No augmenting path was found starting from vertex u through any of its neighbours v,
            // so remove u from the depth first search phase of the algorithm
            levels.set(u, INFINITY);
            return false;
        }

        return true;
    }
	
	private List<List<Integer>> adjacencyLists; // adjacencyLists(u) stores a list of neighbours of u in V
	private List<Integer> pairU; // pairU(u) stores the vertex v in V matched with u in U, or NIL if unmatched
	private List<Integer> pairV; // pairV(v) stores the vertex u in U matched with v in V, or NIL if unmatched
	private List<Integer> levels; // levels(u) stores the level of vertex u in U during a breadth first search
	
	private final int m; // Index of the vertices in the left partition
	private final int n; // Index of the vertices in the right partition
	
	private static final int NIL = 0;
	private static final int INFINITY = Integer.MAX_VALUE;
	
}
