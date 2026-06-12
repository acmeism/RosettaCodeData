import java.util.AbstractQueue;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.PriorityQueue;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class JohnsonsAlgorithm {

	public static void main(String[] args) {
		// The element (i, j) is the weight of the edge from vertex i to vertex j.
		// INF, for infinity, means that there is no edge from vertex i to vertex j.
		List<List<Double>> graph = List.of(
				List.of( 0.0, -5.0, 2.0, 3.0 ),
			    List.of( INF,  0.0, 4.0, INF ),
			    List.of( INF,  INF, 0.0, 1.0 ),
			    List.of( INF,  INF, INF, 0.0 ) );

		Optional<List<List<Double>>> result = johnsonsAlgorithm(graph);
		
		if ( result.isPresent() ) {
		    System.out.println("All pairs shortest paths:");
		    System.out.println("The element (i, j) is the shortest path between vertex i and vertex j.");
		    for ( List<Double> row : result.get() ) {
		    	System.out.print("[");
		    	for ( double number : row ) {
		    		System.out.print(( number == INF ) ? "INF " : number + " ");
		    	}
		    	System.out.println("]");
		    }
		} else {
		    System.out.println("A negative cycle was detected in the graph.");
		}
	}
	
	/**
	 * Return the shortest path between all pairs of vertices in an edge weighted directed graph
	 * For a full description of the algorithm visit https://en.wikipedia.org/wiki/Johnson%27s_algorithm
	 */
	private static Optional<List<List<Double>>> johnsonsAlgorithm(List<List<Double>> graph) {
		final int vertexCount = graph.size();
	    List<Edge> originalEdges = new ArrayList<Edge>();

	    // Step 0: Build a list of edges for the original graph
	    IntStream.range(0, vertexCount).forEach( i -> {
	        IntStream.range(0, vertexCount).forEach( j -> {
	        	final double weight = graph.get(i).get(j);
	            if ( i == j ) {
	                if ( weight != 0.0 ) {
	                    System.out.println("Warning: graph[i][i] for i = " + i + " is " + weight
	                    		           + ", expected to be 0.0, resetting it to 0.0");
	                }
	            } else if ( weight != INF ) {
	                originalEdges.addLast( new Edge(i, j, weight) );
	            }
	        } );
	    } );
	
	    // Step 1: Form the augmented graph
	    // Add a new vertex with index 'vertexCount' and having 0-weight edges to all the original vertices
	    List<Edge> augmentedEdges = Stream.concat(originalEdges.stream(),
	    	Stream.iterate(0, i -> i + 1 ).limit(vertexCount).map( i -> new Edge(vertexCount, i, 0.0) )).toList();
	
	    // Step 2: Invoke the Bellman-Ford Algorithm starting from the new vertex
	    Optional<List<Double>> hValues = bellmanFordAlgorithm(vertexCount + 1, augmentedEdges, vertexCount);
	
	    if ( hValues.isEmpty() ) {	
	        return Optional.empty(); // A negative cycle was detected by the Bellman-Ford Algorithm
	    }
	
	    List<Double> values = hValues.get();
	    values.removeLast(); // Remove the value for the augmented vertex
	
	    // Step 3: Reweight the edges
	    Map<Integer, List<VertexAndWeight>> reweightedAdjacencies = IntStream.range(0, vertexCount).boxed()
	    	.collect(Collectors.toMap(Function.identity(), v -> new ArrayList<VertexAndWeight>() ));
	
	    originalEdges.stream().forEach( edge -> {
	        // Ensure the 'values' are valid before reweighting
	        if ( values.get(edge.u) == INF || values.get(edge.v) == INF ) {
	            // This can happen if the original graph was not strongly connected to the augmented vertex.
	        	// While not strictly an error for Johnson's Algorithm, because paths might still exist between
	        	// reachable nodes, it means the reweighting might involve INF.
	            // Computation can proceed since Dijkstra's Algorithm can handle INF.
	            System.out.println("Warning: invalid hValues detected by the Bellman-Ford Algorithm.");
	        }

	        final double reweight = edge.weight + values.get(edge.u) - values.get(edge.v);
	        reweightedAdjacencies.get(edge.u).addLast( new VertexAndWeight(edge.v, reweight) );	
	    } );
	
        // Step 4: Invoke Dijkstra's Algorithm starting from each vertex on the reweighted graph
	    List<List<Double>> allPairsShortestPaths = IntStream.range(0, vertexCount).boxed()
	    	.map( u -> dijkstraAlgorithm(vertexCount, reweightedAdjacencies, u, values) ).toList();
	
        // Step 5: Return the result matrix
        return Optional.of(allPairsShortestPaths);
	}
	
	/**
	 * Return a list of shortest distances from the source vertex to all other vertices,
	 * or an empty optional if a negative cycle is detected
	 */
	private static Optional<List<Double>> bellmanFordAlgorithm(
			int augmentedVertexCount, List<Edge> edges, int sourceVertex) {
	   	List<Double> distances = Stream.generate( () -> INF ).limit(augmentedVertexCount).collect(Collectors.toList());
	   	distances.set(sourceVertex, 0.0);
	   	
	    // Relax the edges (augmentedVertexCount - 1) times
	   	boolean updated = true;
	    for ( int i = 0; i < augmentedVertexCount - 1 && updated; i++ ) {
	        updated = false;
	        for ( int j = 0; j < edges.size(); j++ ) {
	        	Edge edge = edges.get(j);
	            if ( distances.get(edge.u) != INF && distances.get(edge.u) + edge.weight < distances.get(edge.v) ) {
	                distances.set(edge.v, distances.get(edge.u) + edge.weight);
	                updated = true;
	            }
	        }
	    }

	    // Check for negative cycles in the graph
	    for ( Edge edge : edges ) {
	        if ( distances.get(edge.u) != INF && distances.get(edge.u) + edge.weight < distances.get(edge.v) ) {
	            return Optional.empty(); // Indicates to the calling method that a negative cycle has been detected
	        }
	    }

	    return Optional.of(distances);
	}
	
	/**
	 * Return a list of shortest path distances from the source vertex in the original graph to all other vertices
	 */
	private static List<Double> dijkstraAlgorithm(int vertexCount,
			Map<Integer, List<VertexAndWeight>> reweightedAdjacencies, int sourceVertex, List<Double> values) {
		List<Double> distances = IntStream.range(0, vertexCount).boxed().map( i -> INF ).collect(Collectors.toList());
	    distances.set(sourceVertex, 0.0);
	
	    AbstractQueue<VertexAndWeight> priorityQueue =
	    	new PriorityQueue<VertexAndWeight>( (a, b) -> Double.compare(a.weight, b.weight) );
	    priorityQueue.add( new VertexAndWeight(sourceVertex, 0.0) );

	    List<Double> finalDistances = IntStream.range(0, vertexCount).boxed()
	    		                               .map( i -> INF ).collect(Collectors.toList());
	
	    while ( ! priorityQueue.isEmpty() ) {
	        VertexAndWeight vertexAndWeigth = priorityQueue.remove();
	        final int vertex = vertexAndWeigth.vertex;
	        if ( vertexAndWeigth.weight > distances.get(vertex) ) {
	            continue;
	        }
	
	        // Store the final shortest path distance, translated back to the distance in the original graph
	        // which prevents processing vertices disconnected from the source vertex
	        if ( finalDistances.get(vertex) == INF ) {
	             if ( distances.get(vertex) == INF ) { // This should not happen, but is included as a safety check
	                 finalDistances.set(vertex, INF);
	             } else {
	                 // Translate distance back to its original weight: d(u,v) = d'(u,v) - h[u] + h[v]
	                 finalDistances.set(vertex, distances.get(vertex) - values.get(sourceVertex) + values.get(vertex));
	             }
	        }

	        // Relax the edges outgoing from vertex
	        if ( reweightedAdjacencies.containsKey(vertex) ) {
	            for ( VertexAndWeight pair : reweightedAdjacencies.get(vertex) ) {
	                if ( distances.get(vertex) != INF
	                	&& distances.get(vertex) + pair.weight < distances.get(pair.vertex) ) {
	                    distances.set(pair.vertex, distances.get(vertex) + pair.weight);
	                    priorityQueue.add( new VertexAndWeight(pair.vertex, distances.get(pair.vertex)) );
	                }
	            }
	        }	
	    }
	
	    // Translate distance back to its original weight for any remaining reachable vertices
	    // This handles cases where a vertex was reachable, but was not the minimum vertex
	    // removed from the priority queue when its final distance was determined.
	    IntStream.range(0, vertexCount).forEach( i -> {
	         if ( finalDistances.get(i) == INF && distances.get(i) != INF ) {
	             finalDistances.set(i, distances.get(i) - values.get(sourceVertex) + values.get(i));
	         }
	    } );

	    return finalDistances;	
	}
	
	private record Edge(int u, int v, double weight) {}
	private record VertexAndWeight(int vertex, double weight) {}
	
	private static final double INF = Double.MAX_VALUE;

}
