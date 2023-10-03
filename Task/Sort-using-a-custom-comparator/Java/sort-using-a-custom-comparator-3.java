import java.util.Comparator;
import java.util.List;

public final class SortUsingCustomComparator {

	public static void main(String[] args) {
		List<String> list = List.of( "Here", "are", "some", "sample", "strings", "to", "be", "sorted" );		
		
		Comparator<String> custom = Comparator.comparing(String::length, Comparator.reverseOrder())
											  .thenComparing(Comparator.naturalOrder());
		
		List<String> sortedList = list.stream().sorted(custom).toList();

		System.out.println(sortedList);
	}

}
