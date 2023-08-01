import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public final class Gotchas {

	public static void main(String[] aArgs) {
		// Gotcha 1: An integer argument to a Collection, such as a List, sets the capacity of the Collection,
		//           but does not fill the Collection with elements.
		List<Integer> numbers = new ArrayList<Integer>(100);
		// The above list has the capacity to hold 100 elements, but is currently empty.
		
		// Setting the element with index 3 to a value of 42 will create a runtime exception,
		// because the list has length 0, and this element does not yet exist.		
		numbers.set(3, 42);
		// The gotcha is only revealed when a runtime exception is thrown.
		System.out.println(numbers);
		// java.lang.IndexOutOfBoundsException: Index 3 out of bounds for length 0
		
		// Gotcha 2: Copying a Collection in a simple manner works,
		//           but means that changes to the original Collection are reflected in the copy,
		//           which is not normally the desired outcome.		
		Set<String> letters = new HashSet<String>();
		letters.add("a"); letters.add("b"); letters.add("c");
		
		// Create a copy of the set.
		Set<String> copy = letters;	
		// The two sets are identical.
		System.out.println(letters + " :: " + copy);
		
		// Add an element to the set 'letters'.
		letters.add("d");
		// The same letter has been added to the set 'copy'.
		// Both sets now contain the same 4 letters.
		System.out.println(letters + " :: " + copy);		
		// In a program this can cause mysterious results which can be difficult to debug.
		
		// The correct way to copy a Collection is to use a copy constructor as shown below.
		Set<String> correctCopy = new HashSet<String>(letters);
		letters.add("e");
		
		// The set 'correctCopy' only contains its original 4 letters.
		System.out.println(letters + " :: " + correctCopy);
	}

}
