import java.util.stream.IntStream;

public final class SinglyLinkedListElementRemoval {
	
	 public static void main(String[] args) {
	     SinglyLinkedList<Integer> singlyLinkedList = new SinglyLinkedList<Integer>();
	
	     IntStream.rangeClosed(1, 6).forEach( i -> {
	    	 singlyLinkedList.add(i);
	     } );
	     singlyLinkedList.display();
	
	     // Remove an element located at the head of the linked list
	     singlyLinkedList.remove(1);
	     singlyLinkedList.display();	
	     // Remove an element located other than at the head
	     singlyLinkedList.remove(4);
	     singlyLinkedList.display();
	     // Remove an element which is not present in the list
	     singlyLinkedList.remove(99);
	     singlyLinkedList.display();	
	 }
	
}

final class SinglyLinkedList<T> {
	
	public SinglyLinkedList() {
		head = null;
	}

	public void add(T data) {
		Node<T> newNode = new Node<T>(data);
		
		if ( head == null ) {
			head = newNode;
		} else {
			Node<T> current = head;
			while ( current.next != null ) {
				current = current.next;
			}		
			current.next = newNode;
		}
	}
	
	public void remove(T key) {
		Node<T> previous = null;
		Node<T> current = head;
	
		// CASE 1: The head node contains the key to be deleted	
		if ( current != null && current.data == key ) {
			head = current.next;
			return;
		}	
		
		// CASE 2: The the key is located other than at head
		while ( current != null && current.data != key ) {
			previous = current;
			current = current.next;
		}
	
		if ( current != null )  {
			previous.next = current.next;
		}
		
		// CASE 3: The key was not present in the list
	}
	
	public void reverse() {
		reverse(head);
	}
	
	public void display() {	
	    System.out.print("LinkedList: ");
	    Node<T> current = head;
	    while ( current != null ) {
	        System.out.print(current.data + " ");
	        current = current.next;
	    }
	    System.out.println();
	}
	
	private void reverse(Node<T> node) {
		Node<T> previous = null;
	    Node<T> current = node;
	    while ( current != null ) {
	        Node<T> next = current.next;
	        current.next = previous;
	        previous = current;
	        current = next;
	    }
	    head = previous;
	}

	private static final class Node<T> {
	
	    public Node(T aData) {
	        data = aData;
	        next = null;
	    }
	
	    private T data;
	    private Node<T> next;
	
	}	

	private Node<T> head;

}
