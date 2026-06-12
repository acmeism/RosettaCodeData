import java.util.LinkedList;
import java.util.List;

public final class DoublyLinkedListElementRemoval {

	public static void main(String[] args) {
		List<String> linkedList = new LinkedList<String>();
		linkedList.add("dog");
		linkedList.add("cat");
		linkedList.add("bear");
		
		System.out.println("Initial doubly-linked list: " + linkedList);
		linkedList.remove("cat");
		System.out.println("After removal of \"cat\":     " + linkedList);
		linkedList.remove("dog");
		System.out.println("After removal of \"dog\":     " + linkedList);
	}

}
