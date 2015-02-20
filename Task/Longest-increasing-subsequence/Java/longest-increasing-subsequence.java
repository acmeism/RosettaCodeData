import java.util.*;

public class LIS {
    public static <E extends Comparable<? super E>> List<E> lis(List<E> n) {
        List<Node<E>> pileTops = new ArrayList<Node<E>>();
        // sort into piles
        for (E x : n) {
	    Node<E> node = new Node<E>();
	    node.value = x;
            int i = Collections.binarySearch(pileTops, node);
            if (i < 0) i = ~i;
	    if (i != 0)
		node.pointer = pileTops.get(i-1);
            if (i != pileTops.size())
                pileTops.set(i, node);
            else
                pileTops.add(node);
        }
	// extract LIS from nodes
	List<E> result = new ArrayList<E>();
	for (Node<E> node = pileTops.size() == 0 ? null : pileTops.get(pileTops.size()-1);
                node != null; node = node.pointer)
	    result.add(node.value);
	Collections.reverse(result);
	return result;
    }

    private static class Node<E extends Comparable<? super E>> implements Comparable<Node<E>> {
	public E value;
	public Node<E> pointer;
        public int compareTo(Node<E> y) { return value.compareTo(y.value); }
    }

    public static void main(String[] args) {
	List<Integer> d = Arrays.asList(3,2,6,4,5,1);
	System.out.printf("an L.I.S. of %s is %s\n", d, lis(d));
        d = Arrays.asList(0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15);
	System.out.printf("an L.I.S. of %s is %s\n", d, lis(d));
    }
}
