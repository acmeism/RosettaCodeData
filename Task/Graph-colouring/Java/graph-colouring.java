import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

public final class GraphColoring {

	public static void main(String[] aArgs) {
		colourise("0-1 1-2 2-0 3");
	    colourise("1-6 1-7 1-8 2-5 2-7 2-8 3-5 3-6 3-8 4-5 4-6 4-7");
		colourise("1-4 1-6 1-8 3-2 3-6 3-8 5-2 5-4 5-8 7-2 7-4 7-6");
		colourise("1-6 7-1 8-1 5-2 2-7 2-8 3-5 6-3 3-8 4-5 4-6 4-7");
	}
	
	private static void colourise(String aGraphRepresentation) {			
		List<Node> graph = initialiseGraph(aGraphRepresentation);
		List<Node> nodes = new ArrayList<Node>(graph);
		while ( ! nodes.isEmpty() ) {
		    Node maxNode = nodes.stream().max( (one, two) -> Integer.compare(one.saturation, two.saturation) ).get();
		    maxNode.colour = minColour(maxNode);
		    updateSaturation(maxNode);
		    nodes.remove(maxNode);
		}
		
		System.out.println("Graph: " + aGraphRepresentation);
		display(graph);	
	}
	
	private static Colour minColour(Node aNode) {
		Set<Colour> coloursUsed = coloursUsed(aNode);		
		for ( Colour colour : Colour.values() ) {
			if ( ! coloursUsed.contains(colour) ) {
				return colour;
			}
		}
		return Colour.NO_COLOUR;
	}	
	
	private static Set<Colour> coloursUsed(Node aNode) {
		Set<Colour> coloursUsed = new HashSet<Colour>();
		for ( Node neighbour : aNode.neighbours ) {
			coloursUsed.add(neighbour.colour);
		}
		return coloursUsed;
	}
	
	private static void updateSaturation(Node aNode) {			
		for ( Node neighbour : aNode.neighbours ) {
			if ( neighbour.colour == Colour.NO_COLOUR ) {
				neighbour.saturation = coloursUsed(aNode).size();
			}
		}
	}
	
	private static void display(List<Node> aNodes) {
		Set<Colour> graphColours = new HashSet<Colour>();
		for ( Node node : aNodes ) {
			graphColours.add(node.colour);
			System.out.print("Node " + node.index + ":   colour = " + node.colour);
						
			if ( ! node.neighbours.isEmpty() ) {
				List<Integer> indexes = node.neighbours.stream().map( n -> n.index ).toList();
				System.out.print(" ".repeat(8 - String.valueOf(node.colour).length()) + "neighbours = " + indexes);					
			}
			System.out.println();
		}
		
		System.out.println("Number of colours used: " + graphColours.size());
		System.out.println();
	}
	
	private static List<Node> initialiseGraph(String aGraphRepresentation) {		
		Map<Integer, Node> map = new TreeMap<Integer, Node>();
		for ( String element : aGraphRepresentation.split(" ") ) {
			if ( element.contains("-") ) {
				final int index1 = Integer.valueOf(element.substring(0, 1));
				final int index2 = Integer.valueOf(element.substring(element.length() - 1));
				Node node1 = map.computeIfAbsent(index1, k -> new Node(index1, 0, Colour.NO_COLOUR) );	
			    Node node2 = map.computeIfAbsent(index2, k -> new Node(index2, 0, Colour.NO_COLOUR) );
			    node1.neighbours.add(node2);
			    node2.neighbours.add(node1);		    	
		    } else {
		    	final int index = Integer.valueOf(element);
		    	map.computeIfAbsent(index, k -> new Node(index, 0, Colour.NO_COLOUR));
		    }
		}

		List<Node> graph = new ArrayList<Node>(map.values());
	    return graph;
	}
	
	private enum Colour { BLUE, GREEN, RED, YELLOW, CYAN, ORANGE, NO_COLOUR }
	
	private static class Node {
		
		public Node(int aIndex, int aSaturation, Colour aColour) {
			index = aIndex; saturation = aSaturation;	 colour = aColour;
		}
		
		private int index, saturation;
		private Colour colour;
		private Set<Node> neighbours = new TreeSet<Node>( (one, two) -> Integer.compare(one.index, two.index) );
		
	}

}
