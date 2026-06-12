import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.Stack;
import java.util.function.BiFunction;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class ChristofidesAlgorithm {

	public static void main(String[] args) {
	    List<Pair> data = List.of(
	        new Pair(1380, 939), new Pair(2848, 96), new Pair(3510, 1671), new Pair(457, 334), new Pair(3888, 666),
	        new Pair(984, 965), new Pair(2721, 1482), new Pair(1286, 525), new Pair(2716, 1432), new Pair(738, 1325),
	        new Pair(1251, 1832), new Pair(2728, 1698), new Pair(3815, 169), new Pair(3683, 1533), new Pair(1247,1945),
	        new Pair(123, 862), new Pair(1234, 1946), new Pair(252, 1240), new Pair(611, 673), new Pair(2576, 1676),
	        new Pair(928, 1700), new Pair(53, 857), new Pair(1807, 1711), new Pair(274, 1420), new Pair(2574, 946),
	        new Pair(178, 24), new Pair(2678, 1825), new Pair(1795, 962), new Pair(3384, 1498), new Pair(3520, 1079),
	        new Pair(1256, 61), new Pair(1424, 1728), new Pair(3913, 192), new Pair(3085, 1528), new Pair(2573, 1969),
	        new Pair(463, 1670), new Pair(3875, 598), new Pair(298, 1513), new Pair(3479, 821), new Pair(2542, 236),
	        new Pair(3955, 1743), new Pair(1323, 280), new Pair(3447, 1830), new Pair(2936, 337), new Pair(1621, 1830),
	        new Pair(3373, 1646), new Pair(1393, 1368), new Pair(3874, 1318), new Pair(938, 955), new Pair(3022, 474),
	        new Pair(2482, 1183), new Pair(3854, 923), new Pair(376, 825), new Pair(2519, 135), new Pair(2945, 1622),
	        new Pair(953, 268), new Pair(2628, 1479), new Pair(2097, 981), new Pair(890, 1846), new Pair(2139, 1806),
	        new Pair(2421, 1007), new Pair(2290, 1810), new Pair(1115, 1052), new Pair(2588, 302), new Pair(327, 265),
	        new Pair(241, 341), new Pair(1917, 687), new Pair(2991, 792), new Pair(2573, 599), new Pair(19, 674),
	        new Pair(3911, 1673), new Pair(872, 1559), new Pair(2863, 558), new Pair(929, 1766), new Pair(839, 620),
	        new Pair(3893, 102), new Pair(2178, 1619), new Pair(3822, 899), new Pair(378, 1048), new Pair(1178, 100),
	        new Pair(2599, 901), new Pair(3416, 143), new Pair(2961, 1605), new Pair(611, 1384), new Pair(3113, 885),
	        new Pair(2597, 1830), new Pair(2586, 1286), new Pair(161, 906), new Pair(1429, 134), new Pair(742, 1025),
	        new Pair(1625, 1651), new Pair(1187, 706), new Pair(1787, 1009), new Pair(22, 987), new Pair(3640, 43),
	        new Pair(3756, 882), new Pair(776, 392), new Pair(1724, 1642), new Pair(198, 1810), new Pair(3950, 1558)
	    );
	
	    List<Point> points = IntStream.range(0, data.size()).mapToObj( i -> new Point(data.get(i), i) ).toList();

	    christofidesPath(points);
	}
	
	// Display and return an approximation to the optimum travelling salesman path using the Christofides algorithm
	private static Result christofidesPath(List<Point> points) {
		if ( points.isEmpty() ) {
	        return new Result(Collections.emptyList(), 0.0);
	    }
	    if ( points.size() == 1 ) {
	        return new Result(List.of(points.getFirst().id), 0.0);
	    }	

	    Graph graph = new Graph(points);
	    graph.display();

	    List<Edge> minimumSpanningTree = graph.minimumSpanningTree();
	    System.out.println("Minimum spanning tree: " + minimumSpanningTree + System.lineSeparator());

	    List<Integer> oddVertices = graph.oddVertices(minimumSpanningTree);
	    System.out.println("Odd vertices in minimum spanning tree: " + oddVertices + System.lineSeparator());

	    List<Edge> minimumWeightMatching = graph.minimumWeightMatching(minimumSpanningTree, oddVertices);
	    System.out.println("Minimum weight matching: " + minimumWeightMatching + System.lineSeparator());
	
	    List<Integer> eulerianCircuit = graph.eulerianCircuit(minimumWeightMatching);
		System.out.println("Eulerian circuit: " + eulerianCircuit + System.lineSeparator());
		
		if ( eulerianCircuit.isEmpty() ) {
			System.err.println("Error: Christofides path could not be found.");
	        return new Result(Collections.emptyList(), -1.0);
	    }
		
		Result result = graph.hamiltonianCircuit(eulerianCircuit);
	    System.out.println("Result path: " + result.path + System.lineSeparator());
	    System.out.println(String.format("%s%.2f", "Length of the result path: ", result.length));
	
	   return result;
	}		
	
	private record Pair(double x, double y) {}
	private record Point(Pair pair, int id) {}	
	private record Edge(int u, int v, double weight) {

		public String toString() {
			return String.format("%s%d%s%d%s%.2f%s", "(", u, ", ", v , ", ", weight, ")");
		}
		
	}
	
	private static final class Graph {
		
		public Graph(List<Point> points) {
			pointCount = points.size();
			distanceLists = IntStream.range(0, pointCount).boxed()
									 .map( i -> new ArrayList<Double>(Collections.nCopies(pointCount, 0.0)) )
									 .collect(Collectors.toList());
			
			BiFunction<Point, Point, Double> distance = (one, two) ->
				Math.hypot(one.pair.x - two.pair.x, one.pair.y - two.pair.y);
			
			IntStream.range(0, pointCount).forEach( i -> {
				IntStream.range(i + 1, pointCount).forEach( j -> {
					final double dist = distance.apply(points.get(i), points.get(j));
					distanceLists.get(i).set(j, dist);
					distanceLists.get(j).set(i, dist);
				} );
			} );
		}
		
		// Return the minimum spanning tree using Kruskal's algorithm
		public List<Edge> minimumSpanningTree() {
			List<Edge> edges = new ArrayList<Edge>();
		    if ( pointCount == 0 ) {
		    	return edges;
		    }
		
		    IntStream.range(0, pointCount).forEach( i -> {
				IntStream.range(i + 1, pointCount).forEach( j -> { // Avoids duplicates and self-loops
					edges.addLast( new Edge(i, j, distanceLists.get(i).get(j)) );
				} );
		    } );

		    // Sort edges by weight
		    Collections.sort(edges, (e1, e2) -> Double.compare(e1.weight, e2.weight));

		    List<Edge> minimumSpanningTree = new ArrayList<Edge>();
		    UnionFind unionFind = new UnionFind(pointCount);
		    int edgeCount = 0;
		
		    for ( Edge edge : edges ) {
		    	if ( unionFind.unite(edge.u, edge.v) ) {
		            minimumSpanningTree.addLast(edge);
		            edgeCount += 1;
		            if ( edgeCount == pointCount - 1 ) {
		                break; // An optimisation, since the minimum spanning tree has n - 1 edges
		            }
		        }		    	
		    }

		    return minimumSpanningTree;
		}
		
		// Return a list of vertices with odd degree in the minimum spanning tree
		public List<Integer> oddVertices(List<Edge> minimumSpanningTree) {
		    List<Integer> degrees = new ArrayList<Integer>(Collections.nCopies(pointCount, 0));
		    minimumSpanningTree.forEach( edge -> {
		        degrees.set(edge.u, degrees.get(edge.u) + 1);
		        degrees.set(edge.v, degrees.get(edge.v) + 1);
		    } );
		
		    return IntStream.range(0, pointCount).filter( i -> degrees.get(i) % 2 == 1 ).boxed().toList();
		}
		
		// Return a minimum weight matching using a greedy heuristic
		public List<Edge> minimumWeightMatching(List<Edge> minimumSpanningTree, List<Integer> oddVertices) {
			List<Edge> minimumWeightMatching = new ArrayList<Edge>();
			if ( oddVertices.isEmpty() ) {
				return minimumWeightMatching;
			}
			
			// All elements of 'minimumSpanningTree' are included
			minimumWeightMatching.addAll(minimumSpanningTree);
			
			// Create a copy to prevent mutation of the argument 'oddVertices'
		    List<Integer> currentOdd = new ArrayList<Integer>(oddVertices);
		
		    Collections.shuffle(currentOdd); // Shuffle for randomness
		   		
		    // Maintain a record of the visited indices in the shuffled 'currentOdd' list
		    Set<Integer> visited = new HashSet<Integer>();

		    for ( int i = 0; i < currentOdd.size(); i++ ) {
		        if ( visited.contains(i) ) { // Omit a vertex which has already been processed
		        	continue;
		        }
		
		        final int v = currentOdd.get(i);
		        double minimumDistance = Integer.MAX_VALUE;
		        Optional<Integer> closestUIndex = Optional.empty();

		        // Find the closest unmatched odd vertex occurring after 'v' in the shuffled 'currentOdd' list
		        for ( int j = i + 1; j < currentOdd.size(); j++ ) {	
		             if ( ! visited.contains(j) ) { // Check whether a vertex is available
		            	 final int u = currentOdd.get(j);
		                 if ( distanceLists.get(v).get(u) < minimumDistance ) {
		                     minimumDistance = distanceLists.get(v).get(u);
		                     closestUIndex = Optional.of(j);
		                 }
		             }
		        }	

		        if ( closestUIndex.isPresent() ) {
		        	final int j = closestUIndex.get();
		            final int u = currentOdd.get(j);
		            minimumWeightMatching.addLast( new Edge(v, u, minimumDistance) );

		            visited.add(i); // Mark both vertices as processed
		            visited.add(j);
		        } else {
		        	// This should not happen in the Christofides algorithm
		        	// as the number of odd vertices is always even.
		            // If it does, it might indicate an issue with the input data
		        	// or a graph where matching is not possible.
		            throw new AssertionError("Could not match an odd vertex in minimum weight matching: " + v);
		        }	
		    }
		
			return minimumWeightMatching;
		}
		
		// Return a list of vertices forming an Eulerian circuit using Hierholzer's algorithm
		public List<Integer> eulerianCircuit(List<Edge> minimumWeightMatching) {
			List<Integer> circuit = new ArrayList<Integer>();
		    if ( minimumWeightMatching.isEmpty() ) {
		    	return circuit;
		    }
		
		    record Twin(int halfEdge, int index) {}

		    // Create adjacency lists for the argument 'minimumWeightMatching'
		    List<List<Twin>> adjacencyLists = IntStream.range(0, minimumWeightMatching.size())
		    	.boxed().map( i -> new ArrayList<Twin>() ).collect(Collectors.toList());
		
		    IntStream.range(0, minimumWeightMatching.size()).forEach( index -> {
		    	Edge edge = minimumWeightMatching.get(index);
		    	adjacencyLists.get(edge.u).addLast( new Twin(edge.v, index) );
		    	adjacencyLists.get(edge.v).addLast( new Twin(edge.u, index) );
		    } );
		
		    Set<Integer> edgesUsed = new HashSet<Integer>();
		    		
		    Stack<Integer> stack = new Stack<Integer>();

		    // Start from any vertex having edges.
		    // A suitable vertex is guaranteed to exist if 'minimumSpanningTree' is not empty
		    int currentVertex = minimumWeightMatching.getFirst().u;
		    stack.push(currentVertex);

		    while ( ! stack.isEmpty() ) {
		    	currentVertex = stack.peek();
			    boolean foundEdge = false;
			    // Attempt to find an unused edge from the current vertex
		    	while ( ! adjacencyLists.get(currentVertex).isEmpty() ) {
		    		Twin twin = adjacencyLists.get(currentVertex).removeLast();
		    		if ( ! edgesUsed.contains(twin.index) ) {
		                edgesUsed.add(twin.index);
		                stack.push(twin.halfEdge);
		                foundEdge = true;
		                break; // Move to the next vertex which is 'twin.halfEdge'
		            }		    		
		    	}
		    	
		    	// If no unused edge was found from 'currentVertex',
		    	// either the adjacency list was empty or all its edges have been used
		        if ( ! foundEdge ) {
		            circuit.addLast(stack.pop()); // Backtrack
		        }		    	
		    }
		
		    Collections.reverse(circuit); // The circuit has been constructed in reverse order
		    return circuit;
		}
		
		public Result hamiltonianCircuit(List<Integer> eulerianCircuit) {
		    // Create a Hamiltonian circuit by removing any repeated visits to the same vertex
		    List<Integer> christofidesPath = new ArrayList<Integer>();
		    double length = 0.0;
		    Set<Integer> visited = new HashSet<Integer>();
		
		    int current = eulerianCircuit.getFirst();
		    christofidesPath.addLast(current);
		    visited.add(current);
		
		    for ( int vertex : eulerianCircuit ) {
		        if ( ! visited.contains(vertex) ) {
		            christofidesPath.addLast(vertex);
		            visited.add(vertex);
		            length += distanceLists.get(current).get(vertex); // Add distance from previous vertex in path
		            current = vertex; // Update current vertex in path	
		        }
		    }
		
		    // Add the edge returning to the start vertex
		    length += distanceLists.get(current).get(christofidesPath.getFirst());
		    christofidesPath.addLast(christofidesPath.getFirst()); // Complete the cycle			
			return new Result(christofidesPath, length);
		}
	
		public void display() {
		    System.out.println("Graph: {");
		    IntStream.range(0, pointCount).forEach( u -> {
		        System.out.print(String.format("%3d%s", u, ": {"));
		        IntStream.range(0, pointCount).forEach( v -> {
		            if ( u != v ) {
		                if ( ! ( u == 0 && v == 1 ) && v > 0 ) {
		                    System.out.print(", ");
		                }
		                System.out.print(String.format("%d%s%.2f", v, ": ", distanceLists.get(u).get(v)));
		            }
		        } );
		        System.out.println("}" + ( u == pointCount - 1 ? "" : "," ));
		    } );
		    System.out.println("}" + System.lineSeparator());
		}
		
		private static final class UnionFind {
			
			public UnionFind(int number) {
				parents = IntStream.range(0, number).boxed().collect(Collectors.toList());		
		        ranks = new ArrayList<Integer>(Collections.nCopies(number, 0));
			}
			
			public int find(int n) {				
		        if ( parents.get(n) == n ) {
		            return n;
		        }
		
		        // Path compression
		        parents.set(n, find(parents.get(n)));		
				return parents.get(n);
		    }
			
			public boolean unite(int i, int j) {
		        final int rootI = find(i);
		        final int rootJ = find(j);
		
		        if ( rootI != rootJ ) {
		        	switch ( Integer.compare(rootI, rootJ) ) {
		        		case -1 -> parents.set(rootI, rootJ);
		        		case +1 -> parents.set(rootJ, rootI);
		        		case  0 -> { parents.set(rootJ, rootI); ranks.set(rootI, ranks.get(rootI) + 1); }
		        	}		        	
		        	return true;
		        }		
		        return false;
		    }
			
			private List<Integer> parents;
			private List<Integer> ranks;
			
		}		
		
		private List<List<Double>> distanceLists;
		
		private final int pointCount;
		
	}
	
	private record Result(List<Integer> path, double length) {}
	
}
