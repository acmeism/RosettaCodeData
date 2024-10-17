import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Deque;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public final class DisplayAnOutlineAsANestedTable {

	public static void main(String[] args) {
		String outline = """				
			Display an outline as a nested table.
			    Parse the outline to a tree,
		        measuring the indent of each line,
		        translating the indentation to a nested structure,
		        and padding the tree to even depth.
		    count the leaves descending from each node,
		        defining the width of a leaf as 1,
		        and the width of a parent node as a sum.
		            (The sum of the widths of its children)
		            Propagating the sums upward as necessary.
		    and write out a table with 'colspan' values
		        either as a wiki table,
		        or as HTML.
		    Optionally add color to the nodes.
		    """;
		
		Node tree = parse(outline);
		colourTree(tree);
		
		String htmlCode = htmlTable(tree);
		System.out.println(htmlCode);
		
		String wikiCode = wikiTable(tree);
		System.out.println(wikiCode);
	}
	
	// Return the HTML code for the display of the given Node as a table.
	private static String htmlTable(Node tree) {
	    final int tableColumnCount = tree.colspan();

	    int rowColumn = 0;
	    StringBuilder builder = new StringBuilder("<table style='text-align: center;' >\n");

	    // Breadth first traversal of 'tree'.
	    Deque<Node> queue = new ArrayDeque<Node>();
		Set<Node> explored = new HashSet<Node>();
		queue.offer(tree);
		
	    while ( ! queue.isEmpty() ) {
	    	Node currentNode = queue.poll();
	    	
	    	if ( explored.contains(currentNode) ) {
				continue;
			}
	    	
	        if ( rowColumn == 0 ) {
	            builder.append("  <tr>\n");
	        }

	        builder.append(htmlTableData(currentNode));
	        rowColumn += currentNode.colspan();

	        if ( rowColumn == tableColumnCount ) {
	            builder.append("  </tr>\n");
	            rowColumn = 0;
	        }
	
	        for ( Node child : currentNode.children ) {
				queue.offer(child);
			}
	
			explored.add(currentNode);
	    }

	    builder.append("</table>\n");
	    return builder.toString();
	}
	
	// Return the code for the display of the given Node as a table in Wikipedia.
	private static String wikiTable(Node tree) {
	    final int tableColumnCount = tree.colspan();
	    int rowColumn = 0;

	    StringBuilder builder = new StringBuilder();
	    builder.append(
            "{| class=\"" + "wikitable" + "\"" + " style=\"" + "text-align: center;" + "\"" + "\n");

	    // Breadth first traversal of 'tree'.
	    Deque<Node> queue = new ArrayDeque<Node>();
		Set<Node> explored = new HashSet<Node>();
		queue.offer(tree);
		
	    while ( ! queue.isEmpty() ) {
	    	Node currentNode = queue.poll();
	    	
	    	if ( explored.contains(currentNode) ) {
				continue;
			}	
	    	
	        if ( rowColumn == 0 ) {
	            builder.append("|-\n");
	        }
	
	        builder.append(wikiTableData(currentNode));
	        rowColumn += currentNode.colspan();
	
	        if ( rowColumn == tableColumnCount ) {
	            rowColumn = 0;
	        }
	
	        for ( Node child : currentNode.children ) {
				queue.offer(child);
			}	
	
			explored.add(currentNode);
	    }

	    builder.append("|}\n");
	    return builder.toString();
	}
	
	// Return an HTML table data element for the given Node.
	private static String htmlTableData(Node node) {
	    String indent = "    ";	
	    String colspan = " colspan=\"" + node.colspan() + "\"";
	    String style = "style=\"" + "background-color: " + node.colour + "\"";
	    String attributes = colspan + " " + style;
	
	    return indent + "<td" + attributes + " >" + node.text + "</td>\n";
	}
	
	// Return a Wikipedia table data element for the given Node.
	private static String wikiTableData(Node node) {
	    if ( node.text.isBlank() ) {
	        return "|  |\n";
	    }

	    String style = "style=\"" + "background: " + node.colour + " \"";
	    String colspan = " colspan=" + node.colspan();	
	    String attributes = style + colspan;
	
	    return "| " + attributes + " | " + node.text + "\n";
	}
	
	// Return the given outline as a tree of Node.
	private static Node parse(String outline) {
		List<Token> tokens = tokenise(outline);
		Node temporaryTree = new Node("", -1, null);
		parse(tokens, 0, temporaryTree);
		Node tree = temporaryTree.children.getFirst();
		padTree(tree, tree.height());
		
		return tree;		
	}
	
	// Recursively build a tree of Node.
	private static void parse(List<Token> tokens, int index, Node node) {
		if ( index == tokens.size() ) {
	        return;
		}

	    Token token = tokens.get(index);
	
	    if ( token.indent == node.indent ) { // A sibling of node
	        Node current = new Node(token.text, token.indent, node.parent);
	        node.parent.children.addLast(current);
	        parse(tokens, index + 1, current);
	    } else if ( token.indent > node.indent ) { // A child of node
	        Node current = new Node(token.text, token.indent, node);
	        node.children.addLast(current);
	        parse(tokens, index + 1, current);
	    } else if ( token.indent < node.indent ) { // Try the node's parent until a sibling is found
	        parse(tokens, index, node.parent);
	    }
	}
	
	// Pad the tree with blank nodes so that all branches have the same depth.
	private static void padTree(Node node, int height) {	
	    if ( node.isLeaf() && node.depth() < height ) {
	        Node padNode = new Node("", node.indent + 1, node);
	        node.children.addLast(padNode);
	    }

	    for ( Node child : node.children ) {
	        padTree(child, height);
	    }
	}
	
	private static void colourTree(Node node) {
	    if ( node.text.isBlank() ) {
	        node.colour = Colour.blank();
	    } else if ( node.depth() <= 1 ) {
	        node.colour = Colour.next();
	    } else {
	        node.colour = node.parent.colour;
	    }

	    for ( Node child : node.children ) {
	        colourTree(child);
	    }
	}
	
	private static List<Token> tokenise(String outline) {
		List<Token> tokens = new ArrayList<Token>();
		
		for ( String line : outline.split("\n") ) {
			String lineTrimmed = line.trim();
			final int indent = line.length() - lineTrimmed.length();
			tokens.addLast( new Token(lineTrimmed, indent) );
		}

		return tokens;
	}
	
	private static final class Node {
		
		public Node (String aText, int aIndent, Node aParent) {
			text = aText;
			indent = aIndent;			
			parent = aParent;
			children = new ArrayList<Node>();
		}
	
	    public int depth() {
	    	return ( parent != null ) ? parent.depth() + 1 : -1;
	    }

	    public int height() {
	    	if ( isLeaf() ) {
	    		return 0;
	    	}
	    	
	    	return children.stream().map( child -> child.height() ).max(Comparator.naturalOrder()).get() + 1;
	    }

	    public int colspan() {
		    if ( isLeaf() ) {
		    	return 1;
		    }	

		    return children.stream().map( child -> child.colspan() ).mapToInt(Integer::intValue).sum();
	    }

	    public boolean isLeaf() {
	        return children.isEmpty();
	    }	
	    	
	    private String text;
	    private int indent;	
	    private Node parent;
	    private List<Node> children;
	    private String colour;
	
	}
	
	private static final class Colour {
		
		public static String next() {
			index = ( index + 1 ) % colours.size();
			return colours.get(index);
		}
		
		public static String blank() {
			return "#cccccc;";
		}
		
		private static int index = -1;
		
		private static final List<String> colours = List.of( "#ffff66;", "#ffcc66;", "#ccffcc;", "#ccccff;",
                                                             "#ffcccc;", "#00cccc;", "#cc9966;", "#ffccff;" );
		
	}

	private record Token(String text, int indent) { }	

}
