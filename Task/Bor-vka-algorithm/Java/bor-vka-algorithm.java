import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class BorůvkaAlgorithm {

	public static void main(String[] args) {
		Graph graph = new Graph(4);
	    graph.addEdge( new Edge(0, 1, 10.0) );
	    graph.addEdge( new Edge(0, 2,  6.0) );
	    graph.addEdge( new Edge(0, 3,  5.0) );
	    graph.addEdge( new Edge(1, 3, 15.0) );
	    graph.addEdge( new Edge(2, 3,  4.0) );

	    graph.borůvkaMinimumSpanningTree();
	}

}

final class Graph {
	
	public Graph(int aVertexCount) {
		vertexCount = aVertexCount;
		edges = new ArrayList<Edge>();
	}		
	
    public void addEdge(Edge edge) {
        edges.addLast(edge);
    }

    // Return the minimum spanning tree by using Boruvka's algorithm
    public void borůvkaMinimumSpanningTree() {
    	List<Integer> parent = IntStream.range(0, vertexCount).boxed().collect(Collectors.toList());
        List<Integer> rank = Stream.generate( () -> 0 ).limit(vertexCount).collect(Collectors.toList());

        // Store the indexes of the cheapest edge of each tree
        List<Edge> cheapest = IntStream.range(0, vertexCount)
            .mapToObj( i -> new Edge(-1, -1, -1.0) ).collect(Collectors.toList());

        // Initially there are 'vertexCount' different trees
        int treeCount = vertexCount;
        int minimumSpanningTreeWeight = 0;

        // Combine trees until all trees are combined into a single minimum spanning tree
        while ( treeCount > 1 ) {
        	// Traverse through all edges and update cheapest edge for every tree
            for ( Edge edge : edges ) {
                final int u = edge.getU();
                final int v = edge.getV();
                final double weight = edge.getWeight();

                final int index1 = find(parent, u);
                final int index2 = find(parent, v);

                // If the two vertices of the current edge belong to different trees,
                // check whether the current edge is cheaper than previous cheapest edges
                if ( index1 != index2 ) {
                	 if ( cheapest.get(index1).getWeight() == -1.0 || cheapest.get(index1).getWeight() > weight ) {
                         cheapest.set(index1, new Edge(u, v, weight));
                     }
                     if ( cheapest.get(index2).getWeight() == -1.0 || cheapest.get(index2).getWeight() > weight ) {
                         cheapest.set(index2, new Edge(u, v, weight));
                     }
                }
            }

		    // Add the cheapest edges to the minimum spanning tree
		    for ( int vertex = 0; vertex < vertexCount; vertex++ ) {
		        // Check whether the cheapest edge for current vertex exists
		        if ( cheapest.get(vertex).getWeight() != -1.0 ) {
		            final int u = cheapest.get(vertex).getU();
		            final int v = cheapest.get(vertex).getV();
		            final double weight = cheapest.get(vertex).getWeight();
		
		            final int index1 = find(parent, u);
		            final int index2 = find(parent, v);
		
		            if ( index1 != index2 ) {
		                minimumSpanningTreeWeight += weight;
		                unionSet(parent, rank, index1, index2);
		                System.out.println("Edge " + u + "--" + v + " with weight " + weight
		                		           + " is included in the minimum spanning tree");
		                treeCount -= 1;
		            }
		        }
		    }		
        }

		System.out.println(System.lineSeparator() + "Weight of minimum spanning tree is " + minimumSpanningTreeWeight);
    }

    // Return the index of the tree containing 'vertex', using a path compression technique
    private int find(List<Integer> parent, int vertex) {
        if ( parent.get(vertex) != vertex ) {
        	parent.set(vertex, find(parent, parent.get(vertex)));
        }

        return parent.get(vertex);
    }

    // Form the union by rank of the two trees indexed by u and v
    private void unionSet(List<Integer> parent, List<Integer> rank, int u, int v) {
        final int uRoot = find(parent, u);
        final int vRoot = find(parent, v);

        // Attach the smaller rank tree under root of the high rank tree
        switch ( Integer.compare(rank.get(uRoot), rank.get(vRoot)) ) {
        	case -1 -> parent.set(uRoot, vRoot);
        	case +1 -> parent.set(vRoot, uRoot);
        	// If ranks are the same, make one the root and increment its rank
        	case  0 -> { parent.set(vRoot, uRoot); rank.set(uRoot, rank.get(uRoot) + 1); }
        }
    }

    private List<Edge> edges;

    private final int vertexCount;

}

record Edge(int u, int v, double weight) {
	
	public int getU() { return u; }
	public int getV() { return v; }
	public double getWeight() { return weight; }
	
}
