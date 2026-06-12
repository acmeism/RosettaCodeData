import java.util.List;
import java.util.stream.Stream;

public final class CommonSortedList {

	public static void main(String[] args) {
		List<Integer> one = List.of( 5, 1, 3, 8, 9, 4, 8, 7 );
		List<Integer> two = List.of( 3, 5, 9, 8, 4 );
		List<Integer> three = List.of( 1, 3, 7, 9 );
		
		System.out.println(Stream.of(one, two, three).flatMap(List::stream).distinct().sorted().toList());
	}

}
