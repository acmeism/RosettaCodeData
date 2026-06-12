import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

public final class BronKerboschAlgorithm {

	public static void main(String[] args) {
		List<Edge> edges = List.of( new Edge("a", "b"), new Edge("b", "a"), new Edge("a", "c"), new Edge("c", "a"),
									new Edge("b", "c"), new Edge("c", "b"), new Edge("d", "e"), new Edge("e", "d"),
									new Edge("d", "f"), new Edge("f", "d"), new Edge("e", "f"), new Edge("f", "e") );
		
		// Build the graph as an adjacency list
	    Map<String, Set<String>> graph = new HashMap<String, Set<String>>();
	    edges.forEach( edge -> graph.computeIfAbsent(edge.start, v -> new HashSet<String>()).add(edge.end) );
	
	    // Initialize current clique, candidates and processed vertices
	    Set<String> currentClique = new TreeSet<String>();
	    Set<String> candidates = new HashSet<String>(graph.keySet());
	    Set<String> processedVertices = new HashSet<String>();

	    // Execute the Bron-Kerbosch algorithm to collect the cliques
	    bronKerbosch(currentClique, candidates, processedVertices, graph);
	
	    // Sort the cliques for consistent display
	    Collections.sort(cliques, listComparator);
	
	    // Display the cliques
	    System.out.println(cliques);
	}
	
	private static void bronKerbosch(Set<String> currentClique, Set<String> candidates,
			                         Set<String> processedVertices, Map<String, Set<String>> graph) {
		
	    if ( candidates.isEmpty() && processedVertices.isEmpty() ) {
	        if ( currentClique.size() > 2 ) {
	            List<String> clique = new ArrayList<String>(currentClique);
	            cliques.add(clique);
	        }
	        return;
	    }
	
	    // Select a pivot vertex from 'candidates' union 'processedVertices' with the maximum degree
	    Set<String> union = new HashSet<String>(candidates);
	    union.addAll(processedVertices);	
	    String pivot =
	    	union.stream().max( (s1, s2) -> Integer.compare(graph.get(s1).size(), graph.get(s2).size()) ).get();

	    // 'possibles' are vertices in 'candidates' that are not neighbours of the 'pivot'
	    Set<String> possibles = new HashSet<String>(candidates);
	    possibles.removeAll(graph.get(pivot));
	
	    for ( String vertex : possibles) {
	        // Create a new clique including 'vertex'
	        Set<String> newCliques = new TreeSet<String>(currentClique);
	        newCliques.add(vertex);

	        // 'newCandidates' are the members of 'candidates' that are neighbours of 'vertex'
	        Set<String> neighbours = graph.get(vertex);
	        Set<String> newCandidates = new HashSet<String>(candidates);
	        newCandidates.retainAll(neighbours);

	        // 'newProcessedVertices' are members of 'processedVertices' that are neighbours of 'vertex'
	        Set<String> newProcessedVertices = new HashSet<String>(processedVertices);
	        newProcessedVertices.retainAll(neighbours);

	        // Recursive call with the updated sets
	        bronKerbosch(newCliques, newCandidates, newProcessedVertices, graph);

	        // Move 'vertex' from 'candidates' to 'processedVertices'
	        candidates.remove(vertex);
	        processedVertices.add(vertex);
	    }	
	}
	
	private static Comparator<List<String>> listComparator = (list1, list2) -> {
        for ( int i = 0; i < Math.min(list1.size(), list2.size()); i++ ) {
            final int comparison = list1.get(i).compareTo(list2.get(i));
            if ( comparison != 0 ) {
                return comparison;
            }
        }
        return Integer.compare(list1.size(), list2.size());
	};
	
	private static List<List<String>> cliques = new ArrayList<List<String>>();
	
	private static record Edge(String start, String end) {}

}
