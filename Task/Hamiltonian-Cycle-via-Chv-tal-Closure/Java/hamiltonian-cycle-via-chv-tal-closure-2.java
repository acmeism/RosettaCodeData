import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.ArrayList;
import java.util.BitSet;
import java.util.HashSet;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class HamiltonianCycleViaChvátalClosure {

	public static void main(String[] args) {
		// Example: An almost complete graph with 5 vertices and missing the edge 0--1.
		// This graph satisfies Ore's condition, since degree(0) = 3, degree(1) = 3 and 3 + 3 >= 5.
		final int vertexCount = 5;
		Graph graph = new Graph(vertexCount);

		// Add all edges except 0--1
		IntStream.range(0, vertexCount).forEach( u -> {
			IntStream.range(u + 1, vertexCount).forEach( v -> {
		        if ( ! ( u == 0 && v == 1 ) ) {
		        	graph.addEdge(u, v);
		        }
			} );
		} );
		
		System.out.println("Original graph degrees:");
		IntStream.range(0, vertexCount).forEach( u -> {
		    System.out.println("    degree(" + u + ") = " + graph.degree(u));
		} );
		
		Graph closureGraph = new Graph(graph);
		closureGraph.closure();

		System.out.println("\nAfter Chvátal closure:");
		IntStream.range(0, vertexCount).forEach( u -> {
		    System.out.print("    " + u +  ": ");
		    IntStream.range(0, vertexCount).forEach( v -> {
		        if ( closureGraph.getAdjacencies().get(u).get(v) ) {
		        	System.out.print(v + " ");
		        }
		    } );
		    System.out.println();
		} );
		
		if ( closureGraph.isComplete() ) {
		    System.out.println("\nclosureGraph is complete => graph is Hamiltonian, by the Bondy-Chvátal theorem.");
		    List<Integer> cycle = graph.hamiltonianCycle();
		    if ( ! cycle.isEmpty() ) {
		        System.out.println("Found Hamiltonian cycle in the original graph:");
		        System.out.println(cycle);
			} else {
		        System.out.println("Unable to find a Hamiltonian cycle.");
			}
		} else {
		    System.out.println("\nClosure is not complete => no guarantee of Hamiltonian cycle.");
		}
	}

}

final class Graph {
	
	public Graph(int aVertexCount) {
		vertexCount = aVertexCount;
		adjacencies = IntStream.range(0, vertexCount).boxed()
			.map( i -> new BitSet(vertexCount) ).collect(Collectors.toList());
	}
	
	public Graph(Graph aGraph) {
		vertexCount = aGraph.vertexCount;
		adjacencies = aGraph.adjacencies.stream().map( b -> (BitSet) b.clone() ).collect(Collectors.toList());
	}
	
	// Add an undirected edge u--v
    public void addEdge(int u, int v) {
    	if ( u < 0 || u >= vertexCount || v < 0 || v >= vertexCount ) {
    		throw new IllegalArgumentException("An edge value is out of range: " + u + ", " + v);
    	}

        adjacencies.get(u).set(v, true);
        adjacencies.get(v).set(u, true);
    }

    public List<BitSet> getAdjacencies() {
    	return adjacencies;
    }

    // Return the degree of the given vertex
    public int degree(int u) {
    	if ( u < 0 || u >= vertexCount ) {
    		throw new IllegalArgumentException("Edge value is out of range: " + u);
    	}
    	    	
    	return adjacencies.get(u).cardinality();
    }

    // Compute the Chvátal closure in-place.
    //
    // Repeatedly adds an edge u--v until no more can be added,
    // provided that (u, v) does not form an edge and degree(u) + degree(v) >= 'vertexCount'
    public void closure() {
        boolean addedEdge = true;
        while ( addedEdge ) {        	
            addedEdge = false;
            for ( int u = 0; u < vertexCount && ! addedEdge; u++ ) {
                for ( int v = u + 1; v < vertexCount && ! addedEdge; v++ ) {
                    if ( ! adjacencies.get(u).get(v) ) {
                        if ( degree(u) + degree(v) >= vertexCount ) {
                            addEdge(u, v);
                            addedEdge = true;
                        }
                    }
                }
            }
        }
    }

    // Return whether the graph is complete
    public boolean isComplete() {
    	for ( int u = 0; u < vertexCount; u++ ) {
            for ( int v = u + 1; v < vertexCount; v++ ) {
                if ( ! adjacencies.get(u).get(v) ) {
                	return false;
                }
            }
    	}    	
        return true;
    }

    // Find a Hamiltonian cycle in the original graph by simple backtracking
    //
    // Return a list of vertices including the return to the start vertex
    public List<Integer> hamiltonianCycle() {
    	List<Integer> path = new ArrayList<Integer>(vertexCount);
    	Set<Integer> visited = new HashSet<Integer>(vertexCount);
	
	    // Set the starting vertex
	    path.addLast(0);
	    visited.add(0);
	
	    depthFirstSearch(path, visited, 0);
	    return path;
    }

    private Optional<List<Integer>> depthFirstSearch(List<Integer> path, Set<Integer> visited, int u) {
    	if ( path.size() == vertexCount ) {
            // Check whether the cycle can be closed
            if ( adjacencies.get(u).get(path.getFirst()) ) {
                List<Integer> cycle = new ArrayList<Integer>(path);
                cycle.addLast(path.getFirst());
                return Optional.of(cycle);
            } else {
                return Optional.empty();
            }
        }
    	
    	for ( int v = 0; v < vertexCount; v++ ) {
            if ( ! visited.contains(v) && adjacencies.get(u).get(v) ) {
                visited.add(v);
                path.addLast(v);
                Optional<List<Integer>> possible = depthFirstSearch(path, visited, v);
                if ( possible.isPresent() ) {
                    return Optional.of(possible.get());
                }

                // Backtrack
                path.removeLast();
                visited.remove(v);
            }
        }
    	
    	return Optional.empty();
    }
	
	private int vertexCount;
	private List<BitSet> adjacencies;

}
