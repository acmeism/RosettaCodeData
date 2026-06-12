import java.util.LinkedHashMap;

public final class FibonacciHeapTask {

	public static void main(String[] args) {
		System.out.println("MakeHeap:");
		FibonacciHeap<String> heap = FibonacciHeap.makeHeap();
		heap.visualise();

		System.out.println("\nInsert: \"cat\"");
		heap.insert("cat");
		heap.visualise();
		
		System.out.println("\nUnion:");
		FibonacciHeap<String> heap2 = FibonacciHeap.makeHeap();
		heap2.insert("rat");
		heap.union(heap2);
		heap.visualise();
		
		System.out.println("\nMinimum: " + heap.minimum());
		
		System.out.println("\nExtractMin:");
		// Add two more items to demonstrate the parent-child linking that occurs in the extractMin() method
		heap.insert("bat");
		// Save 'node' for use in the decreaseKey() and delete() methods
		FibonacciHeap.Node<String> node = heap.insert("meerkat");
		System.out.println("(extracted \"%s\")".formatted(heap.extractMin()));
		heap.visualise();
		
		System.out.println("\nDecreaseKey:");
		heap.decreaseKey(node, "gnat");
		heap.visualise();
		
		System.out.println("\nDelete:");
		// Add two more items
		heap.insert("bobcat");
		heap.insert("bat");
		System.out.println("(deleting \"gnat\")");
		heap.delete(node);
		heap.visualise();
	}

}

final class FibonacciHeap<T extends Comparable<T>> {
	
	public static <T extends Comparable<T>> FibonacciHeap<T> makeHeap() {
		return new FibonacciHeap<T>();
	}
	
	public Node<T> insert(T value) {
        Node<T> newNode = new Node<T>(value);
        if ( minNode == null ) {
            newNode.next = newNode;
            newNode.previous = newNode;
            minNode = newNode;
        } else {
            minNode.meldOne(newNode);
            if ( newNode.value.compareTo(minNode.value) < 0 ) {
            	minNode = newNode;
            }
        }
        return newNode;
    }
	
	public void union(FibonacciHeap<T> other) {
        if ( minNode == null ) {
            minNode = other.minNode;
        } else if ( other.minNode != null ) {
            minNode.meldTwo(other.minNode);
            if ( other.minNode.value.compareTo(minNode.value) < 0 ) {
            	minNode = other.minNode;
            }
        }
        other.minNode = null;
    }
	
	public T minimum() {
		return minNode.value;
	}
	
	public T extractMin() {
        if ( minNode == null ) {
        	return null;
        }

        final T min = minimum();
        LinkedHashMap<Integer, Node<T>> roots = new LinkedHashMap<Integer, Node<T>>();

        Node<T> minNodeNext = minNode.next;
        while ( minNodeNext != minNode ) {
            Node<T> node = minNodeNext.next;
            add(minNodeNext, roots);
            minNodeNext = node;
        }

        Node<T> minNodeChild = minNode.child;
        if ( minNodeChild != null ) {
            minNodeChild.parent = null;
            Node<T> minNodeChildNext = minNodeChild.next;
            add(minNodeChild, roots);
            while ( minNodeChildNext != minNodeChild ) {
                Node<T> node = minNodeChildNext.next;
                minNodeChildNext.parent = null;
                add(minNodeChildNext, roots);
                minNodeChildNext = node;
            }
        }

        if ( roots.isEmpty() ) {
            minNode = null;
            return min;
        }

        final int firstIndex = roots.sequencedKeySet().getFirst();
        Node<T> newMinNode = roots.get(firstIndex);
        roots.remove(firstIndex);
        newMinNode.next = newMinNode;
        newMinNode.previous = newMinNode;

        for ( Node<T> root : roots.values() ) {
            root.previous = newMinNode;
            root.next = newMinNode.next;
            newMinNode.next.previous = root;
            newMinNode.next = root;
            if ( root.value.compareTo(newMinNode.value) < 0 ) {
            	newMinNode = root;
            }
        }

        minNode = newMinNode;
        return min;
	}	
	
	public void decreaseKey(Node<T> node, T value) {
        if ( value.compareTo(node.value) >= 0 ) {
            throw new IllegalArgumentException("In 'decreaseKey' new value >= existing value.");
        }

        node.value = value;
        if ( node == minNode ) {
        	return;
        }
        Node<T> nodeParent = node.parent;
        if ( nodeParent == null ) {
            if ( value.compareTo(minNode.value) < 0 ) {
            	minNode = node;
            }
            return;
        }
        cutAndMeld(node);
    }	
	
	public void delete(Node<T> node) {
        Node<T> nodeParent = node.parent;
        if ( nodeParent == null ) {
            if ( node == minNode ) {
                extractMin();
                return;
            }
            if ( node.previous != null ) {
            	node.previous.next = node.next;
            }
            if ( node.next != null ) {
            	node.next.previous = node.previous;
            }
        } else {
            cut(node);
        }

        Node<T> nodeChild = node.child;
        if ( nodeChild == null ) {
        	return;
        }
        while ( true ) {
            nodeChild.parent = null;
            nodeChild = nodeChild.next;
            if ( nodeChild == node.child ) {
            	break;
            }
        }

        if ( minNode != null ) {
        	minNode.meldTwo(nodeChild);
        }
    }
	
	public void visualise() {
		if ( minNode == null ) {
            System.out.println("Empty heap");
            return;
        }
		
		visualise(minNode, "");
	}
	
	private void cutAndMeld(Node<T> node) {
        cut(node);
        node.parent = null;
        if ( minNode != null ) {
        	minNode.meldOne(node);
        }
    }
	
	private void cut(Node<T> node) {
        Node<T> nodeParent = node.parent;
        if ( nodeParent == null ) {
        	return;
        }

        nodeParent.degree -= 1;
        if ( nodeParent.degree == 0 ) {
            nodeParent.child = null;
        } else {
            nodeParent.child = node.next;
            if ( node.previous != null ) {
            	node.previous.next = node.next;
            }
            if ( node.next != null ) {
            	node.next.previous = node.previous;
            }
        }

        if ( nodeParent.parent == null ) {
        	return;
        }
        if ( ! nodeParent.marked ) {
            nodeParent.marked = true;
            return;
        }

        cutAndMeld(nodeParent);
    }
	
	private void add(Node<T> node, LinkedHashMap<Integer, Node<T>> roots) {
        node.previous = node;
        node.next = node;
        Node<T> nodeCopy = node;
        while ( true ) {
            Node<T> root = roots.get(nodeCopy.degree);
            if ( root == null ) {
            	break;
            }
            roots.remove(nodeCopy.degree);
            if ( root.value.compareTo(nodeCopy.value) < 0 ) {
                Node<T> temp = nodeCopy;
                nodeCopy = root;
                root = temp;
            }

            root.parent = nodeCopy;
            root.marked = false;
            if ( nodeCopy.child == null ) {
                root.next = root;
                root.previous = root;
                nodeCopy.child = root;
            } else {
                nodeCopy.child.meldOne(root);
            }
            nodeCopy.degree += 1;
        }

        roots.put(nodeCopy.degree, nodeCopy);
    }
	
	private void visualise(Node<T> node, String prefix) {
		String extraPrefix = "│ ";
        Node<T> nodeCopy = node;
        while ( true ) {
            if ( nodeCopy.next != node ) {
                System.out.print(prefix + "├─");
            } else {
                System.out.print(prefix + "└─");
                extraPrefix = "  ";
            }

            if ( nodeCopy.child == null ) {
                System.out.println("╴ " + nodeCopy.value);
            } else {
                System.out.println("┐ " + nodeCopy.value);
                visualise(nodeCopy.child, prefix + extraPrefix);
            }

            if ( nodeCopy.next == node ) {
            	break;
            }
            nodeCopy = nodeCopy.next;
        }
	}
		
	static final class Node<T> {
		
		public Node(T aValue) {
			value = aValue;
			degree = 0;
			marked = false;
		}	
		
		public void meldOne(Node<T> node) {
	        if ( previous != null ) {
	        	previous.next = node;
	        }
	
            node.previous = previous;
            node.next = this;
            previous = node;
        }
		
		public void meldTwo(Node<T> node) {			
	        if ( previous != null ) {
	        	previous.next = node;
	        }
	
	        if ( node.previous != null ) {
	        	node.previous.next = this;
	        }
	        Node<T> temp = previous;
	        previous = node.previous;
	        node.previous = temp;
	    }		
		
		private T value;
		private int degree;
		private boolean marked;
		private Node<T> previous;
		private Node<T> next;
		private Node<T> child;
		private Node<T> parent;
		
	}
	
	private Node<T> minNode;
	
}
