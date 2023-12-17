import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

public final class UkkonenSuffixTree {

	public static void main(String[] aArgs) throws IOException {		
		List<Integer> limits = List.of( 1_000, 10_000, 100_000 );
		
		for ( int limit : limits ) {
			String contents = Files.readString(Path.of("piDigits.txt"));
			String piDigits = contents.substring(0, limit + 1);
			
			final long start = System.currentTimeMillis();			
			SuffixTree tree = new SuffixTree(piDigits);			
			Map<String, Set<Integer>> substrings = tree.getLongestRepeatedSubstrings();			
			final long finish = System.currentTimeMillis();
			
			System.out.println("First " + limit + " digits of pi has longest repeated characters:");
			for ( String substring : substrings.keySet() ) {
				System.out.print("    '" + substring + "' starting at index ");
				for ( Iterator<Integer> iterator = substrings.get(substring).iterator(); iterator.hasNext(); ) {
					System.out.print(iterator.next());
					if ( iterator.hasNext() ) {
						System.out.print(" and ");
					}
				}
				System.out.println();
			}
			
			System.out.println("Time taken: " + ( finish - start ) + " milliseconds." + System.lineSeparator());
		}
		
		System.out.println("The timings show that the implementation has approximately linear performance.");
	}

	private final static class SuffixTree {
		
		public SuffixTree(String aWord) {
			text = Arrays.copyOfRange(aWord.toCharArray(), 0, aWord.length() + 1);
			text[aWord.length()] = '\uF123'; // Terminal character
			
			nodes = new Node[2 * aWord.length() + 2];
	        root = newNode(UNDEFINED, UNDEFINED);
	        activeNode = root;
	
			for ( char character : text ) {
				extendSuffixTree(character);
			}				
		}
		
		public Map<String, Set<Integer>> getLongestRepeatedSubstrings() {
			List<Integer> indexes = doTraversal();
			String word = String.valueOf(text).substring(0, text.length - 1);
			Map<String, Set<Integer>> result = new HashMap<String, Set<Integer>>();
			
			if ( indexes.get(0) > 0 ) {
				for ( int i = 1; i < indexes.size(); i++ ) {
					String substring = word.substring(indexes.get(i), indexes.get(i) + indexes.get(0));			
					result.computeIfAbsent(substring, k -> new TreeSet<Integer>()).add(indexes.get(i));	
				}
			}
			
			return result;
		}	
	
		// PRIVATE //
		
		private void extendSuffixTree(char aCharacter) {
	        needParentLink = UNDEFINED;
	        remainder++;
	
	        while ( remainder > 0 ) {
	            if ( activeLength == 0 ) {
	            	activeEdge = textIndex;
	            }
	
	            if ( ! nodes[activeNode].children.containsKey(text[activeEdge]) ) {
	                final int leaf = newNode(textIndex, LEAF_NODE);
	                nodes[activeNode].children.put(text[activeEdge], leaf);
	                addSuffixLink(activeNode);
	            } else {
	                final int next = nodes[activeNode].children.get(text[activeEdge]);
	                if ( walkDown(next) ) {
	                	continue;
	                }
	
	                if ( text[nodes[next].start + activeLength] == aCharacter ) {
	                    activeLength++;
	                    addSuffixLink(activeNode);
	                    break;
	                }
	
	                final int split = newNode(nodes[next].start, nodes[next].start + activeLength);
	                nodes[activeNode].children.put(text[activeEdge], split);
	                final int leaf = newNode(textIndex, LEAF_NODE);
	                nodes[split].children.put(aCharacter, leaf);
	                nodes[next].start += activeLength;
	                nodes[split].children.put(text[nodes[next].start], next);
	                addSuffixLink(split);
	            }
	
	            remainder--;
	
	            if ( activeNode == root && activeLength > 0 ) {
	                activeLength--;
	                activeEdge = textIndex - remainder + 1;
	            } else {
	                activeNode = ( nodes[activeNode].parentLink > 0 ) ? nodes[activeNode].parentLink : root;
	            }
	        }
	
	        textIndex++;
	    }
		
		private boolean walkDown(int aNode) {
	        if ( activeLength >= nodes[aNode].edgeLength() ) {
	            activeEdge += nodes[aNode].edgeLength();
	            activeLength -= nodes[aNode].edgeLength();
	            activeNode = aNode;
	
	            return true;
	        }
	
	        return false;
	    }
		
		private void addSuffixLink(int aNode) {
	        if ( needParentLink != UNDEFINED ) {
	            nodes[needParentLink].parentLink = aNode;
	        }
	
	        needParentLink = aNode;
	    }
		
		private int newNode(int aStart, int aEnd) {
			Node node = new Node(aStart, aEnd);
			node.leafIndex = ( aEnd == LEAF_NODE ) ? leafIndexGenerator++ : UNDEFINED;
			nodes[currentNode] = node;
	
	        return currentNode++;
	    }
	
		private List<Integer> doTraversal() {
			List<Integer> indexes = new ArrayList<Integer>();
			indexes.add(UNDEFINED);		
	
			return traversal(indexes, nodes[root], 0);
		}		
		
		private List<Integer> traversal(List<Integer> aIndexes, Node aNode, int aHeight) {
			if ( aNode.leafIndex == UNDEFINED ) {
				for ( int index : aNode.children.values() ) {
			        Node child = nodes[index];
			        traversal(aIndexes, child, aHeight + child.edgeLength());
				}
			} else if ( aIndexes.get(0) < aHeight - aNode.edgeLength() ) {
				aIndexes.clear();
				aIndexes.add(aHeight - aNode.edgeLength());
				aIndexes.add(aNode.leafIndex);
			} else if ( aIndexes.get(0) == aHeight - aNode.edgeLength() ) {
			    aIndexes.add(aNode.leafIndex);
			}		
			
			return aIndexes;
		}
	
	    private final class Node {
	    	
	    	public Node(int aStart, int aEnd) {
	            start = aStart;
	            end = aEnd;
	        }
	    	
	    	public int edgeLength() {
	            return Math.min(end, textIndex + 1) - start;
	        }
	
	        private int start, end, parentLink, leafIndex;
	        private Map<Character, Integer> children = new HashMap<Character, Integer>();
	
	    }
	
	    private Node[] nodes;
	    private char[] text;
	    private int activeNode, activeLength, activeEdge;
	    private int root, textIndex, currentNode, needParentLink, remainder, leafIndexGenerator;
	
	    private static final int UNDEFINED = -1;
	    private static final int LEAF_NODE = Integer.MAX_VALUE;
	
	}

}
