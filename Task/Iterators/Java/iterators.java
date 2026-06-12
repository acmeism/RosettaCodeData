import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.ListIterator;

public final class Iterators {

	public static void main(String[] args) {
		String[] daysOfWeek = new String[] {
			"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" }; // An array
		
		LinkedList<String> colours = new LinkedList<String>(List.of(
			"Red", "Orange", "Yellow", "Green", "Blue", "Purple" )); // A doubly-linked list
		
		// The syntax for creating a Java Iterator varies according to whether the source to be iterated
		// is an array or a list, as shown below.
		
		System.out.println("Print all elements:");
		printAll(Arrays.stream(daysOfWeek).iterator());
		printAll(colours.iterator());
		System.out.println();
		
		System.out.println("Print the first, fourth and fifth elements:");
		printFirstFourthFifth(Arrays.stream(daysOfWeek).iterator(), List.of( 1, 4, 5 ));
		printFirstFourthFifth(colours.iterator(), List.of( 1, 4, 5 ));
		System.out.println();
		
		// Java also has a ListIterator which can iterate in reverse order,
		// so avoiding the expensive operation of reversing a large list.
		
		System.out.println("Print the reversed first, fourth and fifth elements:");
		printReversedFirstFourthFifth(
			Arrays.stream(daysOfWeek).toList().listIterator(daysOfWeek.length), List.of( 1, 4, 5 ));
		printReversedFirstFourthFifth(colours.listIterator(colours.size()), List.of( 1, 4, 5 ));
	}
	
	private static void printAll(Iterator<String> iterator) {
		iterator.forEachRemaining( s -> System.out.print(s + " " ) );
		System.out.println();
	}
	
	private static void printFirstFourthFifth(Iterator<String> iterator, List<Integer> itemNumbers) {
		int itemCount = 1;
		while ( iterator.hasNext() ) {
			if ( itemNumbers.contains(itemCount++) ) {
				System.out.print(iterator.next() + " ");
			} else {
				iterator.next();
			}
		}
		System.out.println();
	}	
	
	private static void printReversedFirstFourthFifth(
			ListIterator<String> listIterator, List<Integer> itemNumbers) {
		int itemCount = 1;
		while ( listIterator.hasPrevious() ) {
			if ( itemNumbers.contains(itemCount++) ) {
				System.out.print(listIterator.previous() + " ");
			} else {
				listIterator.previous();
			}
		}
		System.out.println();
	}
	
}
